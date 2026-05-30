# 學到的技能 · career-dashboard

這個做中學專案實際碰到、練到的技能，對照職涯主線（資料工程）與技能地圖。

## 雲端 / 後端（資料工程硬技能）
- **Cloudflare 三層**：Pages（前端託管）、Workers（serverless API）、D1（雲端 SQLite）。
- **SQL 實戰**：建表、`INSERT`、`LEFT JOIN`、聚合（`SUM` / `GROUP BY` / `CASE`）、upsert（`ON CONFLICT DO UPDATE`）、複合主鍵。
- **API 設計**：REST endpoints、HTTP 方法（`GET` / `PATCH` / `PUT`）、JSON 回應、token 認證（`401`）。
- **wrangler CLI**：`dev`（local vs remote）、`d1 create` / `migrations` / `execute`、`secret`、`deploy`。

## 工程基本功
- **git／GitHub**：`init`、`commit`、`push`、`.gitignore`、`gh repo create`、不把 secret 推上去。
- **部署流程**：migration apply、seed、本地 vs 線上、workers.dev 子網域。
- **系統性除錯**：讀錯誤訊息、重現、區分「工具／環境問題」vs「code 問題」、找根因再修。
- **權限／安全**：公開唯讀＋寫入認證、secret 管理（不進 repo）。

## 前端
fetch API、DOM 操作、localStorage、SVG（環形進度圖）、CSS（OKLCH、進度條、響應式）。

## 架構觀念
**分層架構**：presentation／application／data 三層分離、各司其職、資料流（前端 → API → DB → JSON → 渲染）。

## 對照技能地圖
- **命中「資料工程硬技能」區**：SQL、雲端、API、Git、部署。學校不教、本來要自學的，這個專案一次摸到。
- **工程基本功**（git、debug、認證）也補了一輪。
- **還沒碰、可往下練**：CI/CD、自動化測試、Cron／ETL pipeline、時間序列分析（差異化武器 SPC／時序／異常偵測）。

## 一句話
從「只會寫單機跑一次的程式」，到「資料存哪、前後端怎麼通、怎麼上線、壞了怎麼查」第一次走完整一圈。
