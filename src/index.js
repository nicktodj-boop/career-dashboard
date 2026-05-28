// ============================================================
// Workers API ── 架構圖的 Application（廚房）層
// 每個進來的 HTTP 請求都會跑這個 fetch；我們只處理 /api/*，
// 其他路徑（首頁、靜態頁）由 Cloudflare 的 assets 自動回應。
// env.DB 就是 wrangler.toml 綁的那個 D1 資料庫。
// ============================================================

export default {
  async fetch(request, env) {
    const { pathname } = new URL(request.url);
    const method = request.method;

    try {
      // 課程清單
      if (pathname === "/api/courses" && method === "GET") {
        const { results } = await env.DB.prepare(`
          SELECT c.*, COALESCE(p.done, 0) AS done
          FROM courses c
          LEFT JOIN progress p ON p.item_type = 'course' AND p.item_id = c.id
          ORDER BY c.id
        `).all();
        return json(results);
      }

      // 技能清單
      if (pathname === "/api/skills" && method === "GET") {
        const { results } = await env.DB.prepare(`
          SELECT s.*, COALESCE(p.done, 0) AS done
          FROM skills s
          LEFT JOIN progress p ON p.item_type = 'skill' AND p.item_id = s.id
          ORDER BY s.id
        `).all();
        return json(results);
      }

      // 學分統計：各來源的總學分、已修學分（join 進度表）
      if (pathname === "/api/stats" && method === "GET") {
        const { results } = await env.DB.prepare(`
          SELECT c.source,
                 SUM(c.credits) AS total,
                 SUM(CASE WHEN p.done = 1 THEN c.credits ELSE 0 END) AS done
          FROM courses c
          LEFT JOIN progress p
            ON p.item_type = 'course' AND p.item_id = c.id
          GROUP BY c.source
        `).all();
        return json(results);
      }

      // 更新完成狀態：前端勾選「已修」時呼叫
      // body 範例：{ "item_type": "course", "item_id": 1, "done": true }
      if (pathname === "/api/progress" && method === "PATCH") {
        // 只有帶對 admin token 的請求能改進度（GET 讀取仍公開）
        const reqToken = request.headers.get("X-Admin-Token");
        if (!reqToken || reqToken !== env.ADMIN_TOKEN) {
          return json({ error: "unauthorized" }, 401);
        }
        const { item_type, item_id, done } = await request.json();
        await env.DB.prepare(`
          INSERT INTO progress (item_type, item_id, done, updated_at)
          VALUES (?1, ?2, ?3, datetime('now'))
          ON CONFLICT(item_type, item_id)
          DO UPDATE SET done = ?3, updated_at = datetime('now')
        `).bind(item_type, item_id, done ? 1 : 0).run();
        return json({ ok: true, item_type, item_id, done: !!done });
      }

      return json({ error: "not found", pathname }, 404);
    } catch (err) {
      return json({ error: String(err) }, 500);
    }
  },
};

// 小工具：把資料包成 JSON 回應
function json(data, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { "content-type": "application/json; charset=utf-8" },
  });
}
