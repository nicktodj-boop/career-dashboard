-- 0002_notes.sql ── 每個項目（課程／技能）可以寫一筆備註
CREATE TABLE IF NOT EXISTS notes (
  item_type  TEXT    NOT NULL,    -- 'course' 或 'skill'
  item_id    INTEGER NOT NULL,
  note       TEXT,
  updated_at TEXT,
  PRIMARY KEY (item_type, item_id) -- 同一項目只有一筆備註
);
