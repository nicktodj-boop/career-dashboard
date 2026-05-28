-- ============================================================
-- 0001_init.sql ── 資料庫藍圖（建表）＋ 示範資料（先少量，打通後再補全）
-- 每個 CREATE TABLE 建一張表；每個欄位是一種屬性；INSERT 塞入一筆資料
-- ============================================================

-- 課程表
CREATE TABLE IF NOT EXISTS courses (
  id       INTEGER PRIMARY KEY,   -- 每門課的唯一編號
  name     TEXT    NOT NULL,      -- 中文課名
  en       TEXT,                  -- 英文/代碼
  credits  INTEGER NOT NULL,      -- 學分
  source   TEXT    NOT NULL,      -- major=資管必修 / minor=資工第二主修 / cross=加修 / gen=通識
  category TEXT,                  -- 分組：program/math/mgmt/minor/addon/general
  exam     INTEGER DEFAULT 0,     -- 是否考研考科（0/1）
  dup      INTEGER DEFAULT 0      -- 是否兩系重疊、不可抵免要重修（0/1）
);

-- 技能表
CREATE TABLE IF NOT EXISTS skills (
  id       INTEGER PRIMARY KEY,
  name     TEXT    NOT NULL,
  en       TEXT,
  layer    TEXT    NOT NULL,      -- 七類分層名
  source   TEXT    NOT NULL,      -- campus=校內 / selflearn=自補 / edge=差異化
  priority INTEGER DEFAULT 1      -- 優先級 1~3
);

-- 進度表：記錄你把哪個項目標成「已完成」
CREATE TABLE IF NOT EXISTS progress (
  item_type  TEXT    NOT NULL,    -- 'course' 或 'skill'
  item_id    INTEGER NOT NULL,
  done       INTEGER DEFAULT 0,
  updated_at TEXT,
  PRIMARY KEY (item_type, item_id) -- 同一項目只有一筆進度
);

-- 示範資料已抽到專案根的 seed.sql（schema 與資料分離，是業界常見做法）。
-- 本地灌資料： npx wrangler d1 execute career-dashboard-db --local --file=seed.sql
