# 開發記錄 · career-dashboard

從職涯規劃的「技能地圖＋修課總清單」延伸出來的做中學專案：把靜態規劃做成一個雲端三層全端 dashboard，邊做邊練資料工程。

## 開發歷程

### 階段 1 · 環境＋專案骨架
確認 node、wrangler；建 `career-dashboard` 專案（`src` / `public` / `migrations`）、`wrangler.toml`。

### 階段 2 · D1 資料庫
- schema：`courses` / `skills` / `progress` 三表，`progress` 用複合主鍵 `(item_type, item_id)`。
- seed：45 課＋37 技能（從修課總清單、技能地圖的資料生成）。
- schema 與 seed 分離（migration 建表、`seed.sql` 灌資料）。

### 階段 3 · Workers API
`GET /courses`、`/skills`、`/stats`；`PATCH /progress`。SQL 用 JOIN／聚合／upsert。

### 階段 4 · 前端
清單渲染、勾選 checkbox → `PATCH` → 進度即時更新。

### 階段 5 · 部署上線
建線上 D1、`wrangler.toml` 換真 id、apply migration＋seed 到 remote、`wrangler deploy`、註冊 workers.dev 子網域（nicktodj）、建 GitHub public repo。

### 階段 6 · 權限
寫入加 admin token 認證（公開唯讀、`PATCH` 要密碼）；`wrangler secret` ＋ `.dev.vars` ＋ localStorage 解鎖。

### 階段 7 · 進度條迭代
多維度（各來源／考研／技能）→ 百分比＋達標變色 → 黑框 handle 隨進度往右 → 軌道平常染色。

### 階段 8–10 · 總覽／篩選／備註
- 總覽：環形完成度圖＋總進度大條。
- 篩選：全部／未修／考研／重疊。
- 備註：`notes` 表＋`PUT /api/note`＋前端 `✎` 編輯。

## 踩過的坑（debug 記錄）

| 症狀 | 根因 | 解法 |
|---|---|---|
| `wrangler dev` 卡在下載 cloudflared、SHA mismatch | 誤用 `--remote`（要 tunnel）；本地不需要 | 改純本地 `wrangler dev` |
| 改 `database_id` 後本地 API 回 500「no such table」 | 本地 D1 state 綁 `database_id`，換 id ＝換成空庫 | 對新庫重 apply migration＋seed |
| 達標 100% 沒變綠 | `.fill.full` class 在無頭瀏覽器 cascade 沒套用 | 改 inline style（優先級最高） |
| 重複截圖看不到改動 | Chrome headless 快取同一個網址 | 換全新 `--user-data-dir` |
| 學分對照表 Total 對不上 | 專題製作標 5、官方是 4 | 改成 4，連帶修 HTML／seed |
| `wrangler deploy` fetch failed | 瞬時網路抖動 | 重試即過 |

**教訓**：每個「卡住」先讀錯誤、確認是不是真的壞了，很多是工具／環境問題、不是你的 code。
