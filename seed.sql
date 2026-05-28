-- ============================================================
-- seed.sql ── 完整示範資料（schema 在 migrations/0001_init.sql）
-- 重灌指令：
--   本地： npx wrangler d1 execute career-dashboard-db --local  --file=seed.sql
--   線上： npx wrangler d1 execute career-dashboard-db --remote --file=seed.sql
-- 開頭先清空三張表，所以可以重複灌、不會累積重複資料。
-- ============================================================

DELETE FROM progress;
DELETE FROM courses;
DELETE FROM skills;

-- 課程（45 門）── source: major=資管必修 / minor=資工第二主修 / cross=加修 / gen=通識
INSERT INTO courses (id,name,en,credits,source,category,exam,dup) VALUES
 (1 ,'基礎程式設計','Java',4,'major','program',0,1),
 (2 ,'程式設計與資料結構','prog + DS',6,'major','program',1,1),
 (3 ,'進階程式設計','adv prog',4,'major','program',0,0),
 (4 ,'作業系統','OS',2,'major','program',1,1),
 (5 ,'作業系統實務','OS lab',2,'major','program',0,0),
 (6 ,'資料庫設計','database',3,'major','program',0,1),
 (7 ,'網路與通訊','networking',2,'major','program',0,1),
 (8 ,'網路程式設計','net prog',3,'major','program',0,0),
 (9 ,'系統分析與設計','SA&D',3,'major','program',0,0),
 (10,'數位科技與 AI 應用','digital tech',4,'major','program',0,0),
 (11,'微積分','calculus',4,'major','math',1,0),
 (12,'統計學','statistics',4,'major','math',1,1),
 (13,'管理學','management',3,'major','mgmt',0,0),
 (14,'會計學','accounting',4,'major','mgmt',0,0),
 (15,'經濟學','economics',4,'major','mgmt',0,0),
 (16,'財務管理','finance',3,'major','mgmt',0,0),
 (17,'行銷管理','marketing',3,'major','mgmt',0,0),
 (18,'商事法','business law',2,'major','mgmt',0,0),
 (19,'企業倫理','ethics',2,'major','mgmt',0,0),
 (20,'資訊管理導論','intro MIS',2,'major','mgmt',0,0),
 (21,'專題製作','capstone',4,'major','program',0,0),
 (22,'程式語言（一）','prog lang I',4,'minor','minor',0,1),
 (23,'程式語言（二）','prog lang II',4,'minor','minor',0,1),
 (24,'計算機概論','intro CS',3,'minor','minor',0,0),
 (25,'計算機實驗','CS lab',1,'minor','minor',0,0),
 (26,'機率統計','prob & stats',3,'minor','minor',1,1),
 (27,'離散數學','discrete math',3,'minor','minor',1,0),
 (28,'線性代數','linear algebra',3,'minor','minor',1,0),
 (29,'資料結構','data structures',3,'minor','minor',1,1),
 (30,'演算法','algorithms',3,'minor','minor',1,0),
 (31,'資料庫','database',3,'minor','minor',0,1),
 (32,'統計學習','stat learning',2,'minor','minor',0,0),
 (33,'機器學習數學','ML math',3,'minor','minor',0,0),
 (34,'開源軟體實務','open source',2,'minor','minor',0,0),
 (35,'網路概論','networking',3,'minor','minor',0,1),
 (36,'計算機組織','comp org',3,'cross','addon',1,0),
 (37,'人工智慧','AI',2,'cross','addon',0,0),
 (38,'外國語文','foreign lang',8,'gen','general',0,0),
 (39,'中國語文能力表達','Chinese',2,'gen','general',0,0),
 (40,'校園與社區服務學習','service',2,'gen','general',0,0),
 (41,'大學學習','univ learning',1,'gen','general',0,0),
 (42,'社團學習與實作','club',1,'gen','general',0,0),
 (43,'探索永續','sustainability',1,'gen','general',0,0),
 (44,'體育','PE',4,'gen','general',0,0),
 (45,'國防教育軍訓','defense',0,'gen','general',0,0);

-- 技能（37 項）── source: campus=校內 / selflearn=自補 / edge=差異化
INSERT INTO skills (id,name,en,layer,source,priority) VALUES
 (1 ,'C 語言','C','程式與軟體基礎','campus',1),
 (2 ,'Java','Java','程式與軟體基礎','campus',1),
 (3 ,'Python（資料生態）','pandas/numpy','程式與軟體基礎','campus',2),
 (4 ,'程式語言（一）（二）','prog lang','程式與軟體基礎','campus',1),
 (5 ,'計算機概論','intro CS','程式與軟體基礎','campus',1),
 (6 ,'資料結構','data structures','CS 理論核心','campus',3),
 (7 ,'演算法','algorithms','CS 理論核心','campus',3),
 (8 ,'作業系統','OS','CS 理論核心','campus',3),
 (9 ,'計算機組織','comp org','CS 理論核心','campus',3),
 (10,'離散數學','discrete math','CS 理論核心','campus',2),
 (11,'線性代數','linear algebra','CS 理論核心','campus',2),
 (12,'機率統計','prob & stats','CS 理論核心','campus',2),
 (13,'微積分','calculus','CS 理論核心','campus',1),
 (14,'SQL 實戰','SQL','資料工程硬技能','selflearn',2),
 (15,'雲端平台','AWS / GCP','資料工程硬技能','selflearn',2),
 (16,'大數據框架','Spark','資料工程硬技能','selflearn',2),
 (17,'ETL / 資料管線','Airflow · dbt','資料工程硬技能','selflearn',2),
 (18,'資料倉儲','BigQuery','資料工程硬技能','selflearn',1),
 (19,'Linux / Shell','unix','資料工程硬技能','selflearn',2),
 (20,'版本控制','Git · GitHub','資料工程硬技能','selflearn',2),
 (21,'容器化','Docker','資料工程硬技能','selflearn',1),
 (22,'統計學習','stat learning','資料科學 / ML','campus',1),
 (23,'機器學習數學','ML math','資料科學 / ML','campus',1),
 (24,'人工智慧','AI','資料科學 / ML','campus',1),
 (25,'資料視覺化','visualization','資料科學 / ML','selflearn',1),
 (26,'SPC 統計製程管制','SPC','A∩B 差異化','edge',3),
 (27,'時間序列分析','time series','A∩B 差異化','edge',3),
 (28,'異常偵測 / 預測維護','anomaly · PdM','A∩B 差異化','edge',3),
 (29,'半導體製造 domain','製程 · 良率','A∩B 差異化','edge',2),
 (30,'英文','TOEIC 860+','軟實力與加分','selflearn',2),
 (31,'實習 ×2','internship','軟實力與加分','selflearn',3),
 (32,'作品集','GitHub portfolio','軟實力與加分','selflearn',2),
 (33,'雲端證照','AWS/GCP cert','軟實力與加分','selflearn',1),
 (34,'競賽','Kaggle','軟實力與加分','selflearn',1),
 (35,'考研考古題','past papers','升學專項','selflearn',2),
 (36,'台灣資工所筆試','written exam','升學專項','selflearn',2),
 (37,'LeetCode','LeetCode','升學專項','selflearn',1);
