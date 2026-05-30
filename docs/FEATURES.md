# career-dashboard 功能文檔

生涯規劃進度儀表板：追蹤大學修課與技能養成進度，可勾選「已修」、即時看完成度。
用 Cloudflare 全家桶做的三層全端小專案（做中學練資料工程）。

- **線上**：https://career-dashboard.nicktodj.workers.dev
- **原始碼**：https://github.com/nicktodj-boop/career-dashboard

---

## 架構（三層）

| 層 | 用什麼 | 檔案 |
|---|---|---|
| Presentation（前端） | Cloudflare Pages | `public/index.html` |
| Application（API） | Cloudflare Workers | `src/index.js` |
| Data（資料庫） | Cloudflare D1 (SQLite) | `migrations/0001_init.sql` · `seed.sql` |

資料流：前端 `fetch` → Workers API → 查／寫 D1 → 回 JSON → 前端渲染。
勾選已修 → `PATCH` → 寫 D1 → 重算進度。

---

## 功能

### 1. 修課／技能清單
- 45 門課（資管必修 68／資工第二主修 40／加修 5／通識 19 學分）＋ 37 項技能（七類）。
- 每列顯示：學分、來源標籤（資管／資工／加修／通識）、★考研考科、△兩系重疊。

### 2. 進度追蹤（勾選已修）
- 勾核取方塊 → `PATCH /api/progress` → 寫進 D1 → 進度條即時更新。
- 進度持久化（存 D1，重開還在）。

### 3. 學分進度條（多維度）
六條：四個來源學分 ＋ 考研考科學分 ＋ 技能完成數。視覺：
- 百分比數字 ＋ 已修／總量。
- 軌道平常就染該維度的淡色（0% 也不單調）。
- **黑框 handle** 隨進度往右滑、標示「走到哪」。
- 達標 100% 填充轉綠。

### 4. 總覽
- **環形完成度圖**：總完成度 %（SVG 圓環）。
- **總進度大條**：已修／全部課程學分。

### 5. 篩選
- 修課清單可切換：全部／未修／★考研／△重疊（純前端依列的狀態顯示／隱藏）。

### 6. 每課備註
- 解鎖後，每門課右邊的 `✎` 可寫一筆備註（`PUT /api/note`，需密碼），備註顯示在課名下方。

### 7. 權限控制（公開唯讀，只有我能改）
- **讀取**（GET）公開：任何人能看 dashboard。
- **寫入**（PATCH 勾選）需 admin token：請求要帶 `X-Admin-Token`，等於 `wrangler secret` 存的 `ADMIN_TOKEN` 才放行，否則回 `401`。
- 前端「🔒 解鎖編輯」輸入密碼（存 `localStorage`），訪客的核取方塊是唯讀（灰）。

---

## API

| Endpoint | 說明 | 認證 |
|---|---|---|
| `GET /api/courses` | 課程清單（含完成狀態） | 公開 |
| `GET /api/skills` | 技能清單 | 公開 |
| `GET /api/stats` | 各來源學分統計 | 公開 |
| `PATCH /api/progress` | 更新完成狀態 | 需 `X-Admin-Token` |
| `PUT /api/note` | 寫課程備註 | 需 `X-Admin-Token` |

## 資料結構（D1）

```sql
courses(id, name, en, credits, source, category, exam, dup)
skills(id, name, en, layer, source, priority)
progress(item_type, item_id, done, updated_at)   -- PRIMARY KEY (item_type, item_id)
notes(item_type, item_id, note, updated_at)      -- PRIMARY KEY (item_type, item_id)
```
`progress` 的複合主鍵讓「同一項目只有一筆進度」，並支援 `PATCH` 的 `ON CONFLICT ... DO UPDATE`（upsert）。

## 技術棧
Cloudflare Pages / Workers / D1 · 原生 JavaScript · SQL · wrangler

---

## 本地開發

```bash
npm install
npx wrangler d1 migrations apply career-dashboard-db --local   # 建表
npx wrangler d1 execute career-dashboard-db --local --file=seed.sql  # 灌資料
npx wrangler dev          # http://localhost:8787（純本地，不要加 --remote）
```
本地寫入用 `.dev.vars` 裡的 `ADMIN_TOKEN`（此檔被 `.gitignore` 擋、不進 repo）。

## 部署

```bash
npx wrangler d1 migrations apply career-dashboard-db --remote
npx wrangler d1 execute career-dashboard-db --remote --file=seed.sql
npx wrangler secret put ADMIN_TOKEN     # 設線上寫入密碼
npx wrangler deploy
```
`git push` 後 Cloudflare 會自動部署前端。

---

## 實作筆記（踩過的坑）

- **本地 `wrangler dev` 不要加 `--remote`**：`--remote` 會去抓 `cloudflared` 建通道，撞到版本指紋不符就卡死；純本地開發用不到它。
- **本地 D1 的 state 綁 `database_id`**：改了 `wrangler.toml` 的 `database_id` 後，本地會換成新的空庫，要重新 `migrations apply --local` ＋ 灌 seed。
- **達標變綠用 inline style**：`.fill.full` 的 class 寫法在無頭瀏覽器環境的 cascade 沒如預期套用，改用行內樣式（優先級最高）確保生效。
- **schema 與 seed 分離**：建表放 migration、資料放獨立 `seed.sql` 用 `d1 execute` 灌，是常見做法（部署時遠端也同一招）。
