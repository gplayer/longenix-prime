PRAGMA defer_foreign_keys=TRUE;
CREATE TABLE d1_migrations(
		id         INTEGER PRIMARY KEY AUTOINCREMENT,
		name       TEXT UNIQUE,
		applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);
INSERT INTO "d1_migrations" VALUES(1,'0001_initial_schema.sql','2025-11-23 16:08:28');
INSERT INTO "d1_migrations" VALUES(2,'0002_add_biological_age_table.sql','2025-11-23 16:08:29');
INSERT INTO "d1_migrations" VALUES(3,'0003_add_remaining_tables.sql','2025-11-23 16:08:29');
INSERT INTO "d1_migrations" VALUES(4,'0004_update_risk_calculations_table.sql','2025-11-23 16:08:29');
INSERT INTO "d1_migrations" VALUES(5,'0005_add_aging_assessments_table.sql','2025-11-23 16:08:29');
INSERT INTO "d1_migrations" VALUES(6,'0006_add_health_optimization_tables.sql','2025-11-23 16:08:30');
CREATE TABLE patients (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  full_name TEXT NOT NULL,
  date_of_birth DATE NOT NULL,
  gender TEXT NOT NULL,
  ethnicity TEXT DEFAULT 'not_specified',
  email TEXT UNIQUE NOT NULL,
  phone TEXT,
  country TEXT DEFAULT 'US',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO "patients" VALUES(141,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1756456694007@longenixhealth.com','+1 (555) 234-5678','US','2025-08-29 08:38:14','2025-08-29 08:38:14');
INSERT INTO "patients" VALUES(142,'503CLient','1980-01-01','male','mixed','503@email.com','','US','2025-08-29 09:09:45','2025-08-29 09:09:45');
INSERT INTO "patients" VALUES(143,'514Client','1947-01-01','male','mixed','514@mail.com','','US','2025-08-29 09:17:23','2025-08-29 09:17:23');
INSERT INTO "patients" VALUES(144,'514Client','1947-01-01','male','mixed','5141@mail.com','','US','2025-08-29 09:23:55','2025-08-29 09:23:55');
INSERT INTO "patients" VALUES(145,'525Client','1947-01-01','male','mixed','525person@email.com','','US','2025-08-29 09:27:47','2025-08-29 09:27:47');
INSERT INTO "patients" VALUES(146,'525Client','1947-01-01','male','mixed','525person525@email.com','','US','2025-08-29 09:30:22','2025-08-29 09:30:22');
INSERT INTO "patients" VALUES(147,'Claude 4 CLient','1947-01-01','male','mixed','525person525new@email.com','','US','2025-08-29 10:08:34','2025-08-29 10:08:34');
INSERT INTO "patients" VALUES(148,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1756477382865@longenixhealth.com','+1 (555) 234-5678','US','2025-08-29 14:23:03','2025-08-29 14:23:03');
INSERT INTO "patients" VALUES(149,'1024 Person ','1947-01-01','male','mixed','1024person1024@email.com','','US','2025-08-29 14:38:09','2025-08-29 14:38:09');
INSERT INTO "patients" VALUES(150,'1059client','1947-01-01','male','mixed','1059client1059@email.com','','US','2025-08-29 15:00:04','2025-08-29 15:00:04');
INSERT INTO "patients" VALUES(151,'Testuser Unique','1980-01-01','male','not_specified','testuser.unique.2025@gmail.com','','US','2025-08-30 05:06:38','2025-08-30 05:06:38');
INSERT INTO "patients" VALUES(152,'Critical Fix Test User','1990-01-01','male','not_specified','critical-fix-test-1756532346@example.com','','US','2025-08-30 05:39:07','2025-08-30 05:39:07');
INSERT INTO "patients" VALUES(153,'Production Test User','1990-01-01','male','not_specified','production-test-1756532359@example.com','','US','2025-08-30 05:39:19','2025-08-30 05:39:19');
INSERT INTO "patients" VALUES(154,'Complete Test User','1985-03-15','female','not_specified','complete-test-user-1756532365@example.com','','US','2025-08-30 05:39:25','2025-08-30 05:39:25');
INSERT INTO "patients" VALUES(155,'First User','1990-01-01','male','not_specified','duplicate-test-1756532373@example.com','','US','2025-08-30 05:39:33','2025-08-30 05:39:33');
INSERT INTO "patients" VALUES(156,'Unique Unique','1980-01-01','male','not_specified','unique123@email.com','','US','2025-08-30 05:43:27','2025-08-30 05:43:27');
INSERT INTO "patients" VALUES(157,'Jane Smith','1975-08-22','female','not_specified','jane.smith@gmail.com','','US','2025-08-30 05:47:32','2025-08-30 05:47:32');
INSERT INTO "patients" VALUES(158,'Jane Smith Different Person','1980-01-15','female','not_specified','assessment-1756532857973-mp3mxj-retry1@longenix.internal','','US','2025-08-30 05:47:37','2025-08-30 05:47:37');
INSERT INTO "patients" VALUES(159,'Unique 151','1980-01-01','male','not_specified','151person@testmail.com','','US','2025-08-30 05:52:05','2025-08-30 05:52:05');
INSERT INTO "patients" VALUES(160,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1756533168432@longenixhealth.com','+1 (555) 234-5678','US','2025-08-30 05:52:48','2025-08-30 05:52:48');
INSERT INTO "patients" VALUES(161,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1756533179425@longenixhealth.com','+1 (555) 234-5678','US','2025-08-30 05:52:59','2025-08-30 05:52:59');
INSERT INTO "patients" VALUES(162,'Phase 1 Test Client','1985-06-15','male','not_specified','phase1-test-1756533966-1756533966122@longenix.verified','','US','2025-08-30 06:06:06','2025-08-30 06:06:06');
INSERT INTO "patients" VALUES(163,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1756537462422@longenixhealth.com','+1 (555) 234-5678','US','2025-08-30 07:04:22','2025-08-30 07:04:22');
INSERT INTO "patients" VALUES(164,'Emma Thompson','1975-09-10','female','caucasian','demo-aus-balanced-1756537581682@longenixhealth.com','+61 2 9876 5432','Australia','2025-08-30 07:06:21','2025-08-30 07:06:21');
INSERT INTO "patients" VALUES(165,'307New CLient','1947-01-01','male','mixed','307mail307@newmail.com','','US','2025-08-30 07:23:11','2025-08-30 07:23:11');
INSERT INTO "patients" VALUES(166,'John TestUser','1978-08-15','male','not_specified','john.testuser@longenix.demo','','US','2025-08-30 08:54:55','2025-08-30 08:54:55');
INSERT INTO "patients" VALUES(167,'John TestUser Complete','1978-08-15','male','not_specified','john.complete@longenix.demo','','US','2025-08-30 09:01:12','2025-08-30 09:01:12');
INSERT INTO "patients" VALUES(168,'John TestUser Final','1978-08-15','male','not_specified','john.final@longenix.demo','','US','2025-08-30 09:05:01','2025-08-30 09:05:01');
INSERT INTO "patients" VALUES(169,'John TestUser Fixed','1978-08-15','male','not_specified','john.fixed@longenix.demo','','US','2025-08-30 09:12:17','2025-08-30 09:12:17');
INSERT INTO "patients" VALUES(170,'John TestUser Schema Fixed','1978-08-15','male','not_specified','john.testuser.fixed-1756545544648@longenix.verified','','US','2025-08-30 09:19:04','2025-08-30 09:19:04');
INSERT INTO "patients" VALUES(171,'John TestUser Data Mapping Fixed','1978-08-15','male','not_specified','john.testuser.mapping-1756545854913@longenix.verified','','US','2025-08-30 09:24:15','2025-08-30 09:24:15');
INSERT INTO "patients" VALUES(172,'Final Verification Test','1980-05-20','female','not_specified','final.verification-1756545999741@longenix.verified','','US','2025-08-30 09:26:39','2025-08-30 09:26:39');
INSERT INTO "patients" VALUES(173,'Backup Test User','1985-01-01','male','not_specified','backup-1756546280591@longenix.verified','','US','2025-08-30 09:31:20','2025-08-30 09:31:20');
INSERT INTO "patients" VALUES(174,'Enhanced Section 2 Test','1975-03-10','male','not_specified','section2.test@enhanced.com','','US','2025-08-30 09:44:30','2025-08-30 09:44:30');
INSERT INTO "patients" VALUES(175,'Enhanced Section 3 Demo','1970-06-15','female','not_specified','section3.demo@enhanced.com','','US','2025-08-30 10:29:21','2025-08-30 10:29:21');
INSERT INTO "patients" VALUES(176,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1756553304315@longenixhealth.com','+1 (555) 234-5678','US','2025-08-30 11:28:24','2025-08-30 11:28:24');
INSERT INTO "patients" VALUES(177,'John TestUser','1978-08-15','male','not_specified','assessment-1756555758007-4yfqy6-retry1@longenix.internal','','US','2025-08-30 12:09:18','2025-08-30 12:09:18');
INSERT INTO "patients" VALUES(178,'John TestUser','1978-08-15','male','not_specified','assessment-1756556009611-nwliv4-retry1@longenix.internal','','US','2025-08-30 12:13:29','2025-08-30 12:13:29');
INSERT INTO "patients" VALUES(179,'John TestUser','1978-08-15','male','not_specified','assessment-1756556981567-iayhzv-retry1@longenix.internal','','US','2025-08-30 12:29:41','2025-08-30 12:29:41');
INSERT INTO "patients" VALUES(180,'John TestUser','1978-08-15','male','not_specified','assessment-1756557093005-sa9ak6-retry1@longenix.internal','','US','2025-08-30 12:31:33','2025-08-30 12:31:33');
INSERT INTO "patients" VALUES(181,'John TestUser','1978-08-15','male','not_specified','assessment-1756557153927-xmqnlf-retry1@longenix.internal','','US','2025-08-30 12:32:33','2025-08-30 12:32:33');
INSERT INTO "patients" VALUES(182,'John TestUser','1978-08-15','male','not_specified','assessment-1756557167974-obysrx-retry1@longenix.internal','','US','2025-08-30 12:32:47','2025-08-30 12:32:47');
INSERT INTO "patients" VALUES(183,'John TestUser','1978-08-15','male','not_specified','assessment-1756557806499-3ieguc-retry1@longenix.internal','','US','2025-08-30 12:43:26','2025-08-30 12:43:26');
INSERT INTO "patients" VALUES(184,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1756559584005@longenixhealth.com','+1 (555) 234-5678','US','2025-08-30 13:13:04','2025-08-30 13:13:04');
INSERT INTO "patients" VALUES(185,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1756561125116@longenixhealth.com','+1 (555) 234-5678','US','2025-08-30 13:38:45','2025-08-30 13:38:45');
INSERT INTO "patients" VALUES(186,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1756637596888@longenixhealth.com','+1 (555) 234-5678','US','2025-08-31 10:53:17','2025-08-31 10:53:17');
INSERT INTO "patients" VALUES(187,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1756637949307@longenixhealth.com','+1 (555) 234-5678','US','2025-08-31 10:59:09','2025-08-31 10:59:09');
INSERT INTO "patients" VALUES(188,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1756640982114@longenixhealth.com','+1 (555) 234-5678','US','2025-08-31 11:49:42','2025-08-31 11:49:42');
INSERT INTO "patients" VALUES(189,'1001Client1001','1947-01-01','male','mixed','1001client1001@email.com','','US','2025-08-31 14:02:42','2025-08-31 14:02:42');
INSERT INTO "patients" VALUES(190,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1756650957517@longenixhealth.com','+1 (555) 234-5678','US','2025-08-31 14:35:57','2025-08-31 14:35:57');
INSERT INTO "patients" VALUES(191,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1756650964492@longenixhealth.com','+1 (555) 234-5678','US','2025-08-31 14:36:04','2025-08-31 14:36:04');
INSERT INTO "patients" VALUES(192,'1036Person','1947-01-01','male','not_specified','1036Person@gmail.com','','US','2025-08-31 14:37:18','2025-08-31 14:37:18');
INSERT INTO "patients" VALUES(193,'Production Test User','1980-01-01','male','not_specified','production-test-1756654907083@longenix.verified','','US','2025-08-31 15:41:47','2025-08-31 15:41:47');
INSERT INTO "patients" VALUES(194,'Sarah Johnson','1978-05-15','female','caucasian','demo-usa-optimal-1756654918923@longenixhealth.com','+1 (555) 123-4567','US','2025-08-31 15:41:58','2025-08-31 15:41:58');
INSERT INTO "patients" VALUES(195,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1756655095093@longenixhealth.com','+1 (555) 234-5678','US','2025-08-31 15:44:55','2025-08-31 15:44:55');
INSERT INTO "patients" VALUES(196,'1145New','1947-01-01','male','not_specified','1145New@mail.com','','US','2025-08-31 15:46:42','2025-08-31 15:46:42');
INSERT INTO "patients" VALUES(197,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1756655870150@longenixhealth.com','+1 (555) 234-5678','US','2025-08-31 15:57:50','2025-08-31 15:57:50');
INSERT INTO "patients" VALUES(198,'1158New','1947-01-01','male','not_specified','1158New@mail.com','','US','2025-08-31 15:59:35','2025-08-31 15:59:35');
INSERT INTO "patients" VALUES(199,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1756701453447@longenixhealth.com','+1 (555) 234-5678','US','2025-09-01 04:37:33','2025-09-01 04:37:33');
INSERT INTO "patients" VALUES(200,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1756709790964@longenixhealth.com','+1 (555) 234-5678','US','2025-09-01 06:56:31','2025-09-01 06:56:31');
INSERT INTO "patients" VALUES(201,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1756711282688@longenixhealth.com','+1 (555) 234-5678','US','2025-09-01 07:21:22','2025-09-01 07:21:22');
INSERT INTO "patients" VALUES(202,'Emma Thompson','1975-09-10','female','caucasian','demo-aus-balanced-1756711387745@longenixhealth.com','+61 2 9876 5432','Australia','2025-09-01 07:23:07','2025-09-01 07:23:07');
INSERT INTO "patients" VALUES(203,'324Client','1947-01-01','male','not_specified','324CLient@client.com','','US','2025-09-01 07:25:42','2025-09-01 07:25:42');
INSERT INTO "patients" VALUES(204,'324Client','1947-01-01','male','not_specified','assessment-1756711749274-z5em5v-retry1@longenix.internal','','US','2025-09-01 07:29:09','2025-09-01 07:29:09');
INSERT INTO "patients" VALUES(205,'Sarah Johnson','1978-05-15','female','caucasian','demo-usa-optimal-1756711836656@longenixhealth.com','+1 (555) 123-4567','US','2025-09-01 07:30:36','2025-09-01 07:30:36');
INSERT INTO "patients" VALUES(206,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1756787296867@longenixhealth.com','+1 (555) 234-5678','US','2025-09-02 04:28:17','2025-09-02 04:28:17');
INSERT INTO "patients" VALUES(207,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1756882807879@longenixhealth.com','+1 (555) 234-5678','US','2025-09-03 07:00:08','2025-09-03 07:00:08');
INSERT INTO "patients" VALUES(208,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1756882814308@longenixhealth.com','+1 (555) 234-5678','US','2025-09-03 07:00:14','2025-09-03 07:00:14');
INSERT INTO "patients" VALUES(209,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1757041562292@longenixhealth.com','+1 (555) 234-5678','US','2025-09-05 03:06:02','2025-09-05 03:06:02');
INSERT INTO "patients" VALUES(210,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1757222292062@longenixhealth.com','+1 (555) 234-5678','US','2025-09-07 05:18:12','2025-09-07 05:18:12');
INSERT INTO "patients" VALUES(211,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1757222300996@longenixhealth.com','+1 (555) 234-5678','US','2025-09-07 05:18:21','2025-09-07 05:18:21');
INSERT INTO "patients" VALUES(212,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1757774787338@longenixhealth.com','+1 (555) 234-5678','US','2025-09-13 14:46:28','2025-09-13 14:46:28');
INSERT INTO "patients" VALUES(213,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1757774798133@longenixhealth.com','+1 (555) 234-5678','US','2025-09-13 14:46:38','2025-09-13 14:46:38');
INSERT INTO "patients" VALUES(214,'Emma Thompson','1975-09-10','female','caucasian','demo-aus-balanced-1757774841302@longenixhealth.com','+61 2 9876 5432','Australia','2025-09-13 14:47:21','2025-09-13 14:47:21');
INSERT INTO "patients" VALUES(215,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1757921580445@longenixhealth.com','+1 (555) 234-5678','US','2025-09-15 07:33:01','2025-09-15 07:33:01');
INSERT INTO "patients" VALUES(216,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1758009723481@longenixhealth.com','+1 (555) 234-5678','US','2025-09-16 08:02:04','2025-09-16 08:02:04');
INSERT INTO "patients" VALUES(217,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1758009731411@longenixhealth.com','+1 (555) 234-5678','US','2025-09-16 08:02:11','2025-09-16 08:02:11');
INSERT INTO "patients" VALUES(218,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1758023874950@longenixhealth.com','+1 (555) 234-5678','US','2025-09-16 11:57:55','2025-09-16 11:57:55');
INSERT INTO "patients" VALUES(219,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1758023879775@longenixhealth.com','+1 (555) 234-5678','US','2025-09-16 11:57:59','2025-09-16 11:57:59');
INSERT INTO "patients" VALUES(220,'Emma Thompson','1975-09-10','female','caucasian','demo-aus-balanced-1758025816208@longenixhealth.com','+61 2 9876 5432','Australia','2025-09-16 12:30:16','2025-09-16 12:30:16');
INSERT INTO "patients" VALUES(221,'Emma Thompson','1975-09-10','female','caucasian','demo-aus-balanced-1758025822510@longenixhealth.com','+61 2 9876 5432','Australia','2025-09-16 12:30:22','2025-09-16 12:30:22');
INSERT INTO "patients" VALUES(222,'Sarah Johnson','1978-05-15','female','caucasian','demo-usa-optimal-1758025842345@longenixhealth.com','+1 (555) 123-4567','US','2025-09-16 12:30:42','2025-09-16 12:30:42');
INSERT INTO "patients" VALUES(223,'Sarah Johnson','1978-05-15','female','caucasian','demo-usa-optimal-1758025847897@longenixhealth.com','+1 (555) 123-4567','US','2025-09-16 12:30:47','2025-09-16 12:30:47');
INSERT INTO "patients" VALUES(224,'Sarah Johnson','1978-05-15','female','caucasian','demo-usa-optimal-1758343966922@longenixhealth.com','+1 (555) 123-4567','US','2025-09-20 04:52:47','2025-09-20 04:52:47');
INSERT INTO "patients" VALUES(225,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1758505325303@longenixhealth.com','+1 (555) 234-5678','US','2025-09-22 01:42:05','2025-09-22 01:42:05');
INSERT INTO "patients" VALUES(226,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1758505330507@longenixhealth.com','+1 (555) 234-5678','US','2025-09-22 01:42:10','2025-09-22 01:42:10');
INSERT INTO "patients" VALUES(227,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1758505333581@longenixhealth.com','+1 (555) 234-5678','US','2025-09-22 01:42:13','2025-09-22 01:42:13');
INSERT INTO "patients" VALUES(228,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1758594447170@longenixhealth.com','+1 (555) 234-5678','US','2025-09-23 02:27:27','2025-09-23 02:27:27');
INSERT INTO "patients" VALUES(229,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1758594453892@longenixhealth.com','+1 (555) 234-5678','US','2025-09-23 02:27:34','2025-09-23 02:27:34');
INSERT INTO "patients" VALUES(230,'Dentist Client','1966-01-01','male','asian','dentistclient@noemail.com','','US','2025-09-25 05:44:49','2025-09-25 05:44:49');
INSERT INTO "patients" VALUES(231,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1759397886348@longenixhealth.com','+1 (555) 234-5678','US','2025-10-02 09:38:07','2025-10-02 09:38:07');
INSERT INTO "patients" VALUES(232,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1759410974651@longenixhealth.com','+1 (555) 234-5678','US','2025-10-02 13:16:15','2025-10-02 13:16:15');
INSERT INTO "patients" VALUES(233,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1759410979789@longenixhealth.com','+1 (555) 234-5678','US','2025-10-02 13:16:19','2025-10-02 13:16:19');
INSERT INTO "patients" VALUES(234,'Sarah Johnson','1978-05-15','female','caucasian','demo-usa-optimal-1759479489667@longenixhealth.com','+1 (555) 123-4567','US','2025-10-03 08:18:10','2025-10-03 08:18:10');
INSERT INTO "patients" VALUES(235,'Sarah Johnson','1978-05-15','female','caucasian','demo-usa-optimal-1759479500154@longenixhealth.com','+1 (555) 123-4567','US','2025-10-03 08:18:20','2025-10-03 08:18:20');
INSERT INTO "patients" VALUES(236,'Emma Thompson','1975-09-10','female','caucasian','demo-aus-balanced-1759569496917@longenixhealth.com','+61 2 9876 5432','Australia','2025-10-04 09:18:17','2025-10-04 09:18:17');
INSERT INTO "patients" VALUES(237,'Emma Thompson','1975-09-10','female','caucasian','demo-aus-balanced-1759569506417@longenixhealth.com','+61 2 9876 5432','Australia','2025-10-04 09:18:26','2025-10-04 09:18:26');
INSERT INTO "patients" VALUES(238,'Maria Santos','1985-12-03','female','asian','demo-ph-young-1759569534532@longenixhealth.com','+63 2 8765 4321','Philippines','2025-10-04 09:18:54','2025-10-04 09:18:54');
INSERT INTO "patients" VALUES(239,'Maria Santos','1985-12-03','female','asian','demo-ph-young-1759569538676@longenixhealth.com','+63 2 8765 4321','Philippines','2025-10-04 09:18:58','2025-10-04 09:18:58');
INSERT INTO "patients" VALUES(240,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1759569574437@longenixhealth.com','+1 (555) 234-5678','US','2025-10-04 09:19:34','2025-10-04 09:19:34');
INSERT INTO "patients" VALUES(241,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1761461942419@longenixhealth.com','+1 (555) 234-5678','US','2025-10-26 06:59:03','2025-10-26 06:59:03');
INSERT INTO "patients" VALUES(242,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1761461952192@longenixhealth.com','+1 (555) 234-5678','US','2025-10-26 06:59:12','2025-10-26 06:59:12');
INSERT INTO "patients" VALUES(243,'Sarah Johnson','1978-05-15','female','caucasian','demo-usa-optimal-1762814032950@longenixhealth.com','+1 (555) 123-4567','US','2025-11-10 22:33:53','2025-11-10 22:33:53');
INSERT INTO "patients" VALUES(244,'Sarah Johnson','1978-05-15','female','caucasian','demo-usa-optimal-1762814038302@longenixhealth.com','+1 (555) 123-4567','US','2025-11-10 22:33:58','2025-11-10 22:33:58');
INSERT INTO "patients" VALUES(245,'Sarah Johnson','1978-05-15','female','caucasian','demo-usa-optimal-1762814041994@longenixhealth.com','+1 (555) 123-4567','US','2025-11-10 22:34:02','2025-11-10 22:34:02');
INSERT INTO "patients" VALUES(246,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1762814414748@longenixhealth.com','+1 (555) 234-5678','US','2025-11-10 22:40:15','2025-11-10 22:40:15');
INSERT INTO "patients" VALUES(247,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1762814423827@longenixhealth.com','+1 (555) 234-5678','US','2025-11-10 22:40:23','2025-11-10 22:40:23');
INSERT INTO "patients" VALUES(248,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1762816280433@longenixhealth.com','+1 (555) 234-5678','US','2025-11-10 23:11:20','2025-11-10 23:11:20');
INSERT INTO "patients" VALUES(249,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1762816283358@longenixhealth.com','+1 (555) 234-5678','US','2025-11-10 23:11:23','2025-11-10 23:11:23');
INSERT INTO "patients" VALUES(250,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1762816289365@longenixhealth.com','+1 (555) 234-5678','US','2025-11-10 23:11:29','2025-11-10 23:11:29');
INSERT INTO "patients" VALUES(251,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1763956875022@longenixhealth.com','+1 (555) 234-5678','US','2025-11-24 04:01:15','2025-11-24 04:01:15');
INSERT INTO "patients" VALUES(252,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1763956887744@longenixhealth.com','+1 (555) 234-5678','US','2025-11-24 04:01:27','2025-11-24 04:01:27');
INSERT INTO "patients" VALUES(253,'Sarah Johnson','1978-05-15','female','caucasian','demo-usa-optimal-1763956925329@longenixhealth.com','+1 (555) 123-4567','US','2025-11-24 04:02:05','2025-11-24 04:02:05');
INSERT INTO "patients" VALUES(254,'Sarah Johnson','1978-05-15','female','caucasian','demo-usa-optimal-1763956934426@longenixhealth.com','+1 (555) 123-4567','US','2025-11-24 04:02:14','2025-11-24 04:02:14');
INSERT INTO "patients" VALUES(255,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1763957051996@longenixhealth.com','+1 (555) 234-5678','US','2025-11-24 04:04:12','2025-11-24 04:04:12');
INSERT INTO "patients" VALUES(256,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1763957053278@longenixhealth.com','+1 (555) 234-5678','US','2025-11-24 04:04:13','2025-11-24 04:04:13');
INSERT INTO "patients" VALUES(257,'Robert Martinez','1968-03-22','male','hispanic','demo-usa-risk-1763957057484@longenixhealth.com','+1 (555) 234-5678','US','2025-11-24 04:04:17','2025-11-24 04:04:17');
CREATE TABLE assessment_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  patient_id INTEGER NOT NULL,
  session_type TEXT NOT NULL DEFAULT 'standard',
  status TEXT NOT NULL DEFAULT 'pending',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE
);
INSERT INTO "assessment_sessions" VALUES(140,141,'demo','completed','2025-08-29 08:38:14','2025-08-29 08:38:14');
INSERT INTO "assessment_sessions" VALUES(141,142,'comprehensive','completed','2025-08-29 09:09:45','2025-08-29 09:09:45');
INSERT INTO "assessment_sessions" VALUES(142,143,'comprehensive','completed','2025-08-29 09:17:24','2025-08-29 09:17:24');
INSERT INTO "assessment_sessions" VALUES(143,144,'comprehensive','completed','2025-08-29 09:23:56','2025-08-29 09:23:56');
INSERT INTO "assessment_sessions" VALUES(144,145,'comprehensive','completed','2025-08-29 09:27:48','2025-08-29 09:27:48');
INSERT INTO "assessment_sessions" VALUES(145,146,'comprehensive','completed','2025-08-29 09:30:23','2025-08-29 09:30:23');
INSERT INTO "assessment_sessions" VALUES(146,147,'comprehensive','completed','2025-08-29 10:08:35','2025-08-29 10:08:35');
INSERT INTO "assessment_sessions" VALUES(147,148,'demo','completed','2025-08-29 14:23:05','2025-08-29 14:23:05');
INSERT INTO "assessment_sessions" VALUES(148,149,'comprehensive','completed','2025-08-29 14:38:09','2025-08-29 14:38:09');
INSERT INTO "assessment_sessions" VALUES(149,150,'comprehensive','completed','2025-08-29 15:00:05','2025-08-29 15:00:05');
INSERT INTO "assessment_sessions" VALUES(150,151,'comprehensive','completed','2025-08-30 05:06:39','2025-08-30 05:06:39');
INSERT INTO "assessment_sessions" VALUES(151,152,'comprehensive','completed','2025-08-30 05:39:07','2025-08-30 05:39:07');
INSERT INTO "assessment_sessions" VALUES(152,153,'comprehensive','completed','2025-08-30 05:39:19','2025-08-30 05:39:19');
INSERT INTO "assessment_sessions" VALUES(153,154,'comprehensive','completed','2025-08-30 05:39:25','2025-08-30 05:39:25');
INSERT INTO "assessment_sessions" VALUES(154,155,'comprehensive','completed','2025-08-30 05:39:33','2025-08-30 05:39:33');
INSERT INTO "assessment_sessions" VALUES(155,156,'comprehensive','completed','2025-08-30 05:43:27','2025-08-30 05:43:27');
INSERT INTO "assessment_sessions" VALUES(156,157,'comprehensive','completed','2025-08-30 05:47:33','2025-08-30 05:47:33');
INSERT INTO "assessment_sessions" VALUES(157,158,'comprehensive','completed','2025-08-30 05:47:38','2025-08-30 05:47:38');
INSERT INTO "assessment_sessions" VALUES(158,159,'comprehensive','completed','2025-08-30 05:52:06','2025-08-30 05:52:06');
INSERT INTO "assessment_sessions" VALUES(159,160,'demo','completed','2025-08-30 05:52:48','2025-08-30 05:52:48');
INSERT INTO "assessment_sessions" VALUES(160,161,'demo','completed','2025-08-30 05:52:59','2025-08-30 05:52:59');
INSERT INTO "assessment_sessions" VALUES(161,162,'comprehensive','completed','2025-08-30 06:06:06','2025-08-30 06:06:06');
INSERT INTO "assessment_sessions" VALUES(162,163,'demo','completed','2025-08-30 07:04:23','2025-08-30 07:04:23');
INSERT INTO "assessment_sessions" VALUES(163,164,'demo','completed','2025-08-30 07:06:22','2025-08-30 07:06:22');
INSERT INTO "assessment_sessions" VALUES(164,165,'comprehensive','completed','2025-08-30 07:23:12','2025-08-30 07:23:12');
INSERT INTO "assessment_sessions" VALUES(165,166,'comprehensive','completed','2025-08-30 08:54:55','2025-08-30 08:54:55');
INSERT INTO "assessment_sessions" VALUES(166,167,'comprehensive','completed','2025-08-30 09:01:12','2025-08-30 09:01:12');
INSERT INTO "assessment_sessions" VALUES(167,168,'comprehensive','completed','2025-08-30 09:05:01','2025-08-30 09:05:01');
INSERT INTO "assessment_sessions" VALUES(168,169,'comprehensive','completed','2025-08-30 09:12:17','2025-08-30 09:12:17');
INSERT INTO "assessment_sessions" VALUES(169,170,'comprehensive','completed','2025-08-30 09:19:04','2025-08-30 09:19:04');
INSERT INTO "assessment_sessions" VALUES(170,171,'comprehensive','completed','2025-08-30 09:24:15','2025-08-30 09:24:15');
INSERT INTO "assessment_sessions" VALUES(171,172,'comprehensive','completed','2025-08-30 09:26:39','2025-08-30 09:26:39');
INSERT INTO "assessment_sessions" VALUES(172,173,'comprehensive','completed','2025-08-30 09:31:20','2025-08-30 09:31:20');
INSERT INTO "assessment_sessions" VALUES(173,174,'comprehensive','completed','2025-08-30 09:44:30','2025-08-30 09:44:30');
INSERT INTO "assessment_sessions" VALUES(174,175,'comprehensive','completed','2025-08-30 10:29:21','2025-08-30 10:29:21');
INSERT INTO "assessment_sessions" VALUES(175,176,'demo','completed','2025-08-30 11:28:25','2025-08-30 11:28:25');
INSERT INTO "assessment_sessions" VALUES(176,177,'comprehensive','completed','2025-08-30 12:09:18','2025-08-30 12:09:18');
INSERT INTO "assessment_sessions" VALUES(177,178,'comprehensive','completed','2025-08-30 12:13:29','2025-08-30 12:13:29');
INSERT INTO "assessment_sessions" VALUES(178,179,'comprehensive','completed','2025-08-30 12:29:41','2025-08-30 12:29:41');
INSERT INTO "assessment_sessions" VALUES(179,180,'comprehensive','completed','2025-08-30 12:31:33','2025-08-30 12:31:33');
INSERT INTO "assessment_sessions" VALUES(180,181,'comprehensive','completed','2025-08-30 12:32:33','2025-08-30 12:32:33');
INSERT INTO "assessment_sessions" VALUES(181,182,'comprehensive','completed','2025-08-30 12:32:48','2025-08-30 12:32:48');
INSERT INTO "assessment_sessions" VALUES(182,183,'comprehensive','completed','2025-08-30 12:43:26','2025-08-30 12:43:26');
INSERT INTO "assessment_sessions" VALUES(183,184,'demo','completed','2025-08-30 13:13:04','2025-08-30 13:13:04');
INSERT INTO "assessment_sessions" VALUES(184,185,'demo','completed','2025-08-30 13:38:45','2025-08-30 13:38:45');
INSERT INTO "assessment_sessions" VALUES(185,186,'demo','completed','2025-08-31 10:53:17','2025-08-31 10:53:17');
INSERT INTO "assessment_sessions" VALUES(186,187,'demo','completed','2025-08-31 10:59:10','2025-08-31 10:59:10');
INSERT INTO "assessment_sessions" VALUES(187,188,'demo','completed','2025-08-31 11:49:42','2025-08-31 11:49:42');
INSERT INTO "assessment_sessions" VALUES(188,189,'comprehensive','completed','2025-08-31 14:02:42','2025-08-31 14:02:42');
INSERT INTO "assessment_sessions" VALUES(189,190,'demo','completed','2025-08-31 14:35:58','2025-08-31 14:35:58');
INSERT INTO "assessment_sessions" VALUES(190,191,'demo','completed','2025-08-31 14:36:04','2025-08-31 14:36:04');
INSERT INTO "assessment_sessions" VALUES(191,192,'comprehensive','completed','2025-08-31 14:37:18','2025-08-31 14:37:18');
INSERT INTO "assessment_sessions" VALUES(192,193,'comprehensive','completed','2025-08-31 15:41:47','2025-08-31 15:41:47');
INSERT INTO "assessment_sessions" VALUES(193,194,'demo','completed','2025-08-31 15:41:58','2025-08-31 15:41:58');
INSERT INTO "assessment_sessions" VALUES(194,195,'demo','completed','2025-08-31 15:44:55','2025-08-31 15:44:55');
INSERT INTO "assessment_sessions" VALUES(195,196,'comprehensive','completed','2025-08-31 15:46:42','2025-08-31 15:46:42');
INSERT INTO "assessment_sessions" VALUES(196,197,'demo','completed','2025-08-31 15:57:50','2025-08-31 15:57:50');
INSERT INTO "assessment_sessions" VALUES(197,198,'comprehensive','completed','2025-08-31 15:59:36','2025-08-31 15:59:36');
INSERT INTO "assessment_sessions" VALUES(198,199,'demo','completed','2025-09-01 04:37:34','2025-09-01 04:37:34');
INSERT INTO "assessment_sessions" VALUES(199,200,'demo','completed','2025-09-01 06:56:31','2025-09-01 06:56:31');
INSERT INTO "assessment_sessions" VALUES(200,201,'demo','completed','2025-09-01 07:21:23','2025-09-01 07:21:23');
INSERT INTO "assessment_sessions" VALUES(201,202,'demo','completed','2025-09-01 07:23:08','2025-09-01 07:23:08');
INSERT INTO "assessment_sessions" VALUES(202,203,'comprehensive','completed','2025-09-01 07:25:43','2025-09-01 07:25:43');
INSERT INTO "assessment_sessions" VALUES(203,204,'comprehensive','completed','2025-09-01 07:29:09','2025-09-01 07:29:09');
INSERT INTO "assessment_sessions" VALUES(204,205,'demo','completed','2025-09-01 07:30:37','2025-09-01 07:30:37');
INSERT INTO "assessment_sessions" VALUES(205,206,'demo','completed','2025-09-02 04:28:18','2025-09-02 04:28:18');
INSERT INTO "assessment_sessions" VALUES(206,207,'demo','completed','2025-09-03 07:00:09','2025-09-03 07:00:09');
INSERT INTO "assessment_sessions" VALUES(207,208,'demo','completed','2025-09-03 07:00:14','2025-09-03 07:00:14');
INSERT INTO "assessment_sessions" VALUES(208,209,'demo','completed','2025-09-05 03:06:03','2025-09-05 03:06:03');
INSERT INTO "assessment_sessions" VALUES(209,210,'demo','completed','2025-09-07 05:18:12','2025-09-07 05:18:12');
INSERT INTO "assessment_sessions" VALUES(210,211,'demo','completed','2025-09-07 05:18:21','2025-09-07 05:18:21');
INSERT INTO "assessment_sessions" VALUES(211,212,'demo','completed','2025-09-13 14:46:28','2025-09-13 14:46:28');
INSERT INTO "assessment_sessions" VALUES(212,213,'demo','completed','2025-09-13 14:46:38','2025-09-13 14:46:38');
INSERT INTO "assessment_sessions" VALUES(213,214,'demo','completed','2025-09-13 14:47:21','2025-09-13 14:47:21');
INSERT INTO "assessment_sessions" VALUES(214,215,'demo','completed','2025-09-15 07:33:01','2025-09-15 07:33:01');
INSERT INTO "assessment_sessions" VALUES(215,216,'demo','completed','2025-09-16 08:02:04','2025-09-16 08:02:04');
INSERT INTO "assessment_sessions" VALUES(216,217,'demo','completed','2025-09-16 08:02:11','2025-09-16 08:02:11');
INSERT INTO "assessment_sessions" VALUES(217,218,'demo','completed','2025-09-16 11:57:55','2025-09-16 11:57:55');
INSERT INTO "assessment_sessions" VALUES(218,219,'demo','completed','2025-09-16 11:58:00','2025-09-16 11:58:00');
INSERT INTO "assessment_sessions" VALUES(219,220,'demo','completed','2025-09-16 12:30:16','2025-09-16 12:30:16');
INSERT INTO "assessment_sessions" VALUES(220,221,'demo','completed','2025-09-16 12:30:22','2025-09-16 12:30:22');
INSERT INTO "assessment_sessions" VALUES(221,222,'demo','completed','2025-09-16 12:30:42','2025-09-16 12:30:42');
INSERT INTO "assessment_sessions" VALUES(222,223,'demo','completed','2025-09-16 12:30:48','2025-09-16 12:30:48');
INSERT INTO "assessment_sessions" VALUES(223,224,'demo','completed','2025-09-20 04:52:47','2025-09-20 04:52:47');
INSERT INTO "assessment_sessions" VALUES(224,225,'demo','completed','2025-09-22 01:42:06','2025-09-22 01:42:06');
INSERT INTO "assessment_sessions" VALUES(225,226,'demo','completed','2025-09-22 01:42:10','2025-09-22 01:42:10');
INSERT INTO "assessment_sessions" VALUES(226,227,'demo','completed','2025-09-22 01:42:13','2025-09-22 01:42:13');
INSERT INTO "assessment_sessions" VALUES(227,228,'demo','completed','2025-09-23 02:27:28','2025-09-23 02:27:28');
INSERT INTO "assessment_sessions" VALUES(228,229,'demo','completed','2025-09-23 02:27:34','2025-09-23 02:27:34');
INSERT INTO "assessment_sessions" VALUES(229,230,'comprehensive','completed','2025-09-25 05:44:49','2025-09-25 05:44:49');
INSERT INTO "assessment_sessions" VALUES(230,231,'demo','completed','2025-10-02 09:38:07','2025-10-02 09:38:07');
INSERT INTO "assessment_sessions" VALUES(231,232,'demo','completed','2025-10-02 13:16:16','2025-10-02 13:16:16');
INSERT INTO "assessment_sessions" VALUES(232,233,'demo','completed','2025-10-02 13:16:20','2025-10-02 13:16:20');
INSERT INTO "assessment_sessions" VALUES(233,234,'demo','completed','2025-10-03 08:18:10','2025-10-03 08:18:10');
INSERT INTO "assessment_sessions" VALUES(234,235,'demo','completed','2025-10-03 08:18:20','2025-10-03 08:18:20');
INSERT INTO "assessment_sessions" VALUES(235,236,'demo','completed','2025-10-04 09:18:18','2025-10-04 09:18:18');
INSERT INTO "assessment_sessions" VALUES(236,237,'demo','completed','2025-10-04 09:18:26','2025-10-04 09:18:26');
INSERT INTO "assessment_sessions" VALUES(237,238,'demo','completed','2025-10-04 09:18:54','2025-10-04 09:18:54');
INSERT INTO "assessment_sessions" VALUES(238,239,'demo','completed','2025-10-04 09:18:59','2025-10-04 09:18:59');
INSERT INTO "assessment_sessions" VALUES(239,240,'demo','completed','2025-10-04 09:19:34','2025-10-04 09:19:34');
INSERT INTO "assessment_sessions" VALUES(240,241,'demo','completed','2025-10-26 06:59:03','2025-10-26 06:59:03');
INSERT INTO "assessment_sessions" VALUES(241,242,'demo','completed','2025-10-26 06:59:12','2025-10-26 06:59:12');
INSERT INTO "assessment_sessions" VALUES(242,243,'demo','completed','2025-11-10 22:33:54','2025-11-10 22:33:54');
INSERT INTO "assessment_sessions" VALUES(243,244,'demo','completed','2025-11-10 22:33:58','2025-11-10 22:33:58');
INSERT INTO "assessment_sessions" VALUES(244,245,'demo','completed','2025-11-10 22:34:02','2025-11-10 22:34:02');
INSERT INTO "assessment_sessions" VALUES(245,246,'demo','completed','2025-11-10 22:40:15','2025-11-10 22:40:15');
INSERT INTO "assessment_sessions" VALUES(246,247,'demo','completed','2025-11-10 22:40:24','2025-11-10 22:40:24');
INSERT INTO "assessment_sessions" VALUES(247,248,'demo','completed','2025-11-10 23:11:21','2025-11-10 23:11:21');
INSERT INTO "assessment_sessions" VALUES(248,249,'demo','completed','2025-11-10 23:11:23','2025-11-10 23:11:23');
INSERT INTO "assessment_sessions" VALUES(249,250,'demo','completed','2025-11-10 23:11:29','2025-11-10 23:11:29');
INSERT INTO "assessment_sessions" VALUES(250,251,'demo','completed','2025-11-24 04:01:15','2025-11-24 04:01:15');
INSERT INTO "assessment_sessions" VALUES(251,252,'demo','completed','2025-11-24 04:01:28','2025-11-24 04:01:28');
INSERT INTO "assessment_sessions" VALUES(252,253,'demo','completed','2025-11-24 04:02:05','2025-11-24 04:02:05');
INSERT INTO "assessment_sessions" VALUES(253,254,'demo','completed','2025-11-24 04:02:14','2025-11-24 04:02:14');
INSERT INTO "assessment_sessions" VALUES(254,255,'demo','completed','2025-11-24 04:04:12','2025-11-24 04:04:12');
INSERT INTO "assessment_sessions" VALUES(255,256,'demo','completed','2025-11-24 04:04:13','2025-11-24 04:04:13');
INSERT INTO "assessment_sessions" VALUES(256,257,'demo','completed','2025-11-24 04:04:17','2025-11-24 04:04:17');
CREATE TABLE clinical_assessments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  height_cm REAL,
  weight_kg REAL,
  systolic_bp INTEGER,
  diastolic_bp INTEGER,
  heart_rate INTEGER,
  temperature REAL,
  bmi REAL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE
);
CREATE TABLE biomarkers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  biomarker_name TEXT NOT NULL,
  value REAL NOT NULL,
  unit TEXT,
  reference_range TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE
);
CREATE TABLE lifestyle_assessments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  assessment_type TEXT NOT NULL,
  question_key TEXT NOT NULL,
  response TEXT NOT NULL,
  score INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE
);
CREATE TABLE assessment_reports (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  report_data TEXT NOT NULL,
  chronological_age REAL,
  biological_age REAL,
  phenotypic_age REAL,
  kd_biological_age REAL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE
);
CREATE TABLE comprehensive_assessments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  assessment_data TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE
);
CREATE TABLE biological_age (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  chronological_age REAL NOT NULL,
  phenotypic_age REAL,
  klemera_doubal_age REAL,
  metabolic_age REAL,
  telomere_age REAL,
  average_biological_age REAL NOT NULL,
  age_advantage REAL NOT NULL,
  calculation_method TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE
);
INSERT INTO "biological_age" VALUES(137,140,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-08-29 08:38:15');
INSERT INTO "biological_age" VALUES(138,147,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-08-29 14:23:06');
INSERT INTO "biological_age" VALUES(139,159,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-08-30 05:52:49');
INSERT INTO "biological_age" VALUES(140,160,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-08-30 05:53:00');
INSERT INTO "biological_age" VALUES(141,162,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-08-30 07:04:23');
INSERT INTO "biological_age" VALUES(142,163,50,50,49.65707434052758,51,NULL,50.21902478017586,-0.21902478017585736,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-08-30 07:06:22');
INSERT INTO "biological_age" VALUES(143,165,47,NULL,47.64532019704433,47,NULL,47.322660098522164,-0.3226600985221637,'Phenotypic Age + KDM + Metabolic Age','2025-08-30 09:01:01');
INSERT INTO "biological_age" VALUES(144,166,47,NULL,47.64532019704433,47,NULL,47.322660098522164,-0.3226600985221637,'Phenotypic Age + KDM + Metabolic Age','2025-08-30 09:04:51');
INSERT INTO "biological_age" VALUES(145,169,47,47,47,47,47,47,0,'KLEMERA_DOUBAL','2025-08-30 09:19:04');
INSERT INTO "biological_age" VALUES(146,170,47,NULL,47.07913669064747,47,NULL,47.03956834532374,-0.039568345323736764,'KLEMERA_DOUBAL','2025-08-30 09:24:15');
INSERT INTO "biological_age" VALUES(147,171,45,NULL,44.54916067146283,45,NULL,44.774580335731414,0.2254196642685855,'KLEMERA_DOUBAL','2025-08-30 09:26:39');
INSERT INTO "biological_age" VALUES(148,172,40,40,40,40,NULL,40,0,'KLEMERA_DOUBAL','2025-08-30 09:31:20');
INSERT INTO "biological_age" VALUES(149,173,50,51,53.1345029239766,58,NULL,54.0448343079922,-4.044834307992197,'KLEMERA_DOUBAL','2025-08-30 09:44:30');
INSERT INTO "biological_age" VALUES(150,174,55,NULL,52.79616306954435,51,NULL,51.898081534772174,3.1019184652278255,'KLEMERA_DOUBAL','2025-08-30 10:29:21');
INSERT INTO "biological_age" VALUES(151,175,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-08-30 11:28:25');
INSERT INTO "biological_age" VALUES(152,176,47,NULL,47.035971223021576,47,NULL,47.01798561151079,-0.017985611510788146,'KLEMERA_DOUBAL','2025-08-30 12:09:18');
INSERT INTO "biological_age" VALUES(153,177,47,NULL,47.035971223021576,47,NULL,47.01798561151079,-0.017985611510788146,'KLEMERA_DOUBAL','2025-08-30 12:13:29');
INSERT INTO "biological_age" VALUES(154,178,47,NULL,47.035971223021576,47,NULL,47.01798561151079,-0.017985611510788146,'KLEMERA_DOUBAL','2025-08-30 12:29:41');
INSERT INTO "biological_age" VALUES(155,179,47,NULL,47.035971223021576,47,NULL,47.01798561151079,-0.017985611510788146,'KLEMERA_DOUBAL','2025-08-30 12:31:33');
INSERT INTO "biological_age" VALUES(156,180,47,NULL,47.035971223021576,47,NULL,47.01798561151079,-0.017985611510788146,'KLEMERA_DOUBAL','2025-08-30 12:32:34');
INSERT INTO "biological_age" VALUES(157,181,47,NULL,47.035971223021576,47,NULL,47.01798561151079,-0.017985611510788146,'KLEMERA_DOUBAL','2025-08-30 12:32:48');
INSERT INTO "biological_age" VALUES(158,182,47,NULL,47.035971223021576,47,NULL,47.01798561151079,-0.017985611510788146,'KLEMERA_DOUBAL','2025-08-30 12:43:26');
INSERT INTO "biological_age" VALUES(159,183,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-08-30 13:13:05');
INSERT INTO "biological_age" VALUES(160,184,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-08-30 13:38:46');
INSERT INTO "biological_age" VALUES(161,185,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-08-31 10:53:17');
INSERT INTO "biological_age" VALUES(162,186,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-08-31 10:59:10');
INSERT INTO "biological_age" VALUES(163,187,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-08-31 11:49:43');
INSERT INTO "biological_age" VALUES(164,188,78,78,78,78,NULL,78,0,'KLEMERA_DOUBAL','2025-08-31 14:02:43');
INSERT INTO "biological_age" VALUES(165,189,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-08-31 14:35:58');
INSERT INTO "biological_age" VALUES(166,190,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-08-31 14:36:05');
INSERT INTO "biological_age" VALUES(167,191,78,78,78,78,NULL,78,0,'KLEMERA_DOUBAL','2025-08-31 14:37:18');
INSERT INTO "biological_age" VALUES(168,192,45,45,45,45,NULL,45,0,'KLEMERA_DOUBAL','2025-08-31 15:41:47');
INSERT INTO "biological_age" VALUES(169,193,47,47,44.918465227817734,43,NULL,44.97282174260591,2.027178257394091,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-08-31 15:41:59');
INSERT INTO "biological_age" VALUES(170,194,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-08-31 15:44:56');
INSERT INTO "biological_age" VALUES(171,195,78,78,78,78,NULL,78,0,'KLEMERA_DOUBAL','2025-08-31 15:46:42');
INSERT INTO "biological_age" VALUES(172,196,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-08-31 15:57:51');
INSERT INTO "biological_age" VALUES(173,197,78,78,78,78,NULL,78,0,'KLEMERA_DOUBAL','2025-08-31 15:59:36');
INSERT INTO "biological_age" VALUES(174,198,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-01 04:37:34');
INSERT INTO "biological_age" VALUES(175,199,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-01 06:56:32');
INSERT INTO "biological_age" VALUES(176,200,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-01 07:21:23');
INSERT INTO "biological_age" VALUES(177,201,50,50,49.65707434052758,51,NULL,50.21902478017586,-0.21902478017585736,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-01 07:23:08');
INSERT INTO "biological_age" VALUES(178,202,78,78,78,78,NULL,78,0,'KLEMERA_DOUBAL','2025-09-01 07:25:43');
INSERT INTO "biological_age" VALUES(179,203,78,78,78.2857142857143,78,NULL,78.0952380952381,-0.095238095238102,'KLEMERA_DOUBAL','2025-09-01 07:29:09');
INSERT INTO "biological_age" VALUES(180,204,47,47,44.918465227817734,43,NULL,44.97282174260591,2.027178257394091,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-01 07:30:37');
INSERT INTO "biological_age" VALUES(181,205,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-02 04:28:18');
INSERT INTO "biological_age" VALUES(182,206,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-03 07:00:09');
INSERT INTO "biological_age" VALUES(183,207,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-03 07:00:14');
INSERT INTO "biological_age" VALUES(184,208,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-05 03:06:03');
INSERT INTO "biological_age" VALUES(185,209,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-07 05:18:13');
INSERT INTO "biological_age" VALUES(186,211,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-13 14:46:28');
INSERT INTO "biological_age" VALUES(187,212,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-13 14:46:38');
INSERT INTO "biological_age" VALUES(188,213,50,50,49.65707434052758,51,NULL,50.21902478017586,-0.21902478017585736,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-13 14:47:21');
INSERT INTO "biological_age" VALUES(189,214,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-15 07:33:01');
INSERT INTO "biological_age" VALUES(190,215,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-16 08:02:04');
INSERT INTO "biological_age" VALUES(191,216,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-16 08:02:11');
INSERT INTO "biological_age" VALUES(192,217,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-16 11:57:55');
INSERT INTO "biological_age" VALUES(193,218,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-16 11:58:00');
INSERT INTO "biological_age" VALUES(194,219,50,50,49.65707434052758,51,NULL,50.21902478017586,-0.21902478017585736,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-16 12:30:17');
INSERT INTO "biological_age" VALUES(195,220,50,50,49.65707434052758,51,NULL,50.21902478017586,-0.21902478017585736,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-16 12:30:23');
INSERT INTO "biological_age" VALUES(196,221,47,47,44.918465227817734,43,NULL,44.97282174260591,2.027178257394091,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-16 12:30:42');
INSERT INTO "biological_age" VALUES(197,222,47,47,44.918465227817734,43,NULL,44.97282174260591,2.027178257394091,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-16 12:30:48');
INSERT INTO "biological_age" VALUES(198,223,47,47,44.918465227817734,43,NULL,44.97282174260591,2.027178257394091,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-20 04:52:48');
INSERT INTO "biological_age" VALUES(199,224,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-22 01:42:06');
INSERT INTO "biological_age" VALUES(200,225,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-22 01:42:11');
INSERT INTO "biological_age" VALUES(201,226,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-22 01:42:14');
INSERT INTO "biological_age" VALUES(202,227,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-23 02:27:28');
INSERT INTO "biological_age" VALUES(203,228,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-09-23 02:27:34');
INSERT INTO "biological_age" VALUES(204,229,59,NULL,58.75438596491227,62,NULL,60.37719298245614,-1.3771929824561369,'KLEMERA_DOUBAL','2025-09-25 05:44:49');
INSERT INTO "biological_age" VALUES(205,230,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-10-02 09:38:07');
INSERT INTO "biological_age" VALUES(206,231,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-10-02 13:16:16');
INSERT INTO "biological_age" VALUES(207,232,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-10-02 13:16:20');
INSERT INTO "biological_age" VALUES(208,233,47,47,44.918465227817734,43,NULL,44.97282174260591,2.027178257394091,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-10-03 08:18:11');
INSERT INTO "biological_age" VALUES(209,234,47,47,44.918465227817734,43,NULL,44.97282174260591,2.027178257394091,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-10-03 08:18:20');
INSERT INTO "biological_age" VALUES(210,235,50,50,49.65707434052758,51,NULL,50.21902478017586,-0.21902478017585736,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-10-04 09:18:18');
INSERT INTO "biological_age" VALUES(211,236,50,50,49.65707434052758,51,NULL,50.21902478017586,-0.21902478017585736,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-10-04 09:18:27');
INSERT INTO "biological_age" VALUES(212,237,40,40,36.9640287769784,36,NULL,37.6546762589928,2.345323741007199,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-10-04 09:18:55');
INSERT INTO "biological_age" VALUES(213,238,40,40,36.9640287769784,36,NULL,37.6546762589928,2.345323741007199,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-10-04 09:18:59');
INSERT INTO "biological_age" VALUES(214,239,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-10-04 09:19:35');
INSERT INTO "biological_age" VALUES(215,240,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-10-26 06:59:04');
INSERT INTO "biological_age" VALUES(216,241,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-10-26 06:59:12');
INSERT INTO "biological_age" VALUES(217,242,47,47,44.918465227817734,43,NULL,44.97282174260591,2.027178257394091,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-11-10 22:33:54');
INSERT INTO "biological_age" VALUES(218,243,47,47,44.918465227817734,43,NULL,44.97282174260591,2.027178257394091,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-11-10 22:33:58');
INSERT INTO "biological_age" VALUES(219,244,47,47,44.918465227817734,43,NULL,44.97282174260591,2.027178257394091,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-11-10 22:34:02');
INSERT INTO "biological_age" VALUES(220,245,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-11-10 22:40:15');
INSERT INTO "biological_age" VALUES(221,247,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-11-10 23:11:21');
INSERT INTO "biological_age" VALUES(222,248,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-11-10 23:11:24');
INSERT INTO "biological_age" VALUES(223,249,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-11-10 23:11:30');
INSERT INTO "biological_age" VALUES(224,250,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-11-24 04:01:16');
INSERT INTO "biological_age" VALUES(225,251,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-11-24 04:01:28');
INSERT INTO "biological_age" VALUES(226,252,47,47,44.918465227817734,43,NULL,44.97282174260591,2.027178257394091,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-11-24 04:02:05');
INSERT INTO "biological_age" VALUES(227,253,47,47,44.918465227817734,43,NULL,44.97282174260591,2.027178257394091,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-11-24 04:02:15');
INSERT INTO "biological_age" VALUES(228,254,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-11-24 04:04:12');
INSERT INTO "biological_age" VALUES(229,255,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-11-24 04:04:13');
INSERT INTO "biological_age" VALUES(230,256,57,60,60.55395683453237,65,NULL,61.85131894484412,-4.851318944844117,'Demo: Phenotypic Age + KDM + Metabolic Age','2025-11-24 04:04:18');
CREATE TABLE risk_calculations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  risk_category TEXT NOT NULL,
  risk_score REAL NOT NULL,
  risk_level TEXT NOT NULL,
  recommendations TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP, ten_year_risk REAL, algorithm_used TEXT,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE
);
INSERT INTO "risk_calculations" VALUES(920,140,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-08-29 08:38:15',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(921,140,'diabetes',18,'very_high',NULL,'2025-08-29 08:38:15',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(922,140,'kidney_disease',3,'low',NULL,'2025-08-29 08:38:15',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(923,140,'cancer_risk',7,'moderate',NULL,'2025-08-29 08:38:16',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(924,140,'cognitive_decline',8,'moderate',NULL,'2025-08-29 08:38:16',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(925,140,'metabolic_syndrome',14,'very_high',NULL,'2025-08-29 08:38:16',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(926,140,'stroke_risk',8,'moderate',NULL,'2025-08-29 08:38:16',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(927,147,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-08-29 14:23:06',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(928,147,'diabetes',18,'very_high',NULL,'2025-08-29 14:23:06',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(929,147,'kidney_disease',3,'low',NULL,'2025-08-29 14:23:06',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(930,147,'cancer_risk',7,'moderate',NULL,'2025-08-29 14:23:07',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(931,147,'cognitive_decline',8,'moderate',NULL,'2025-08-29 14:23:07',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(932,147,'metabolic_syndrome',14,'very_high',NULL,'2025-08-29 14:23:07',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(933,147,'stroke_risk',8,'moderate',NULL,'2025-08-29 14:23:08',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(934,159,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-08-30 05:52:49',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(935,159,'diabetes',18,'very_high',NULL,'2025-08-30 05:52:49',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(936,159,'kidney_disease',3,'low',NULL,'2025-08-30 05:52:49',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(937,159,'cancer_risk',7,'moderate',NULL,'2025-08-30 05:52:50',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(938,159,'cognitive_decline',8,'moderate',NULL,'2025-08-30 05:52:50',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(939,159,'metabolic_syndrome',14,'very_high',NULL,'2025-08-30 05:52:50',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(940,159,'stroke_risk',8,'moderate',NULL,'2025-08-30 05:52:50',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(941,160,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-08-30 05:53:00',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(942,160,'diabetes',18,'very_high',NULL,'2025-08-30 05:53:00',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(943,160,'kidney_disease',3,'low',NULL,'2025-08-30 05:53:00',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(944,160,'cancer_risk',7,'moderate',NULL,'2025-08-30 05:53:01',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(945,160,'cognitive_decline',8,'moderate',NULL,'2025-08-30 05:53:01',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(946,160,'metabolic_syndrome',14,'very_high',NULL,'2025-08-30 05:53:01',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(947,160,'stroke_risk',8,'moderate',NULL,'2025-08-30 05:53:01',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(948,162,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-08-30 07:04:23',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(949,162,'diabetes',18,'very_high',NULL,'2025-08-30 07:04:24',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(950,162,'kidney_disease',3,'low',NULL,'2025-08-30 07:04:24',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(951,162,'cancer_risk',7,'moderate',NULL,'2025-08-30 07:04:24',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(952,162,'cognitive_decline',8,'moderate',NULL,'2025-08-30 07:04:24',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(953,162,'metabolic_syndrome',14,'very_high',NULL,'2025-08-30 07:04:25',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(954,162,'stroke_risk',8,'moderate',NULL,'2025-08-30 07:04:25',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(955,163,'cardiovascular',76.81067115026642,'low',NULL,'2025-08-30 07:06:22',0.00018907234561327257,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(956,163,'diabetes',5,'low',NULL,'2025-08-30 07:06:22',1,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(957,163,'kidney_disease',3,'low',NULL,'2025-08-30 07:06:23',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(958,163,'cancer_risk',6,'moderate',NULL,'2025-08-30 07:06:23',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(959,163,'cognitive_decline',1,'low',NULL,'2025-08-30 07:06:23',1,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(960,163,'metabolic_syndrome',1,'low',NULL,'2025-08-30 07:06:23',5,'ATP III Criteria (0/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(961,163,'stroke_risk',0,'low',NULL,'2025-08-30 07:06:24',1,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(962,165,'cardiovascular',89.69456071832406,'very_high',NULL,'2025-08-30 09:01:01',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(963,165,'diabetes',4,'low',NULL,'2025-08-30 09:01:01',1,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(964,165,'kidney_disease',3,'low',NULL,'2025-08-30 09:01:01',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(965,165,'cancer_risk',3,'low',NULL,'2025-08-30 09:01:01',2,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(966,165,'cognitive_decline',2,'low',NULL,'2025-08-30 09:01:01',1,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(967,165,'metabolic_syndrome',7,'high',NULL,'2025-08-30 09:01:01',35,'ATP III Criteria (2/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(968,165,'stroke_risk',1,'low',NULL,'2025-08-30 09:01:01',0,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(969,166,'cardiovascular',89.69456071832406,'very_high',NULL,'2025-08-30 09:04:51',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(970,166,'diabetes',4,'low',NULL,'2025-08-30 09:04:51',1,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(971,166,'kidney_disease',3,'low',NULL,'2025-08-30 09:04:51',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(972,166,'cancer_risk',3,'low',NULL,'2025-08-30 09:04:51',2,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(973,166,'cognitive_decline',2,'low',NULL,'2025-08-30 09:04:51',1,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(974,166,'metabolic_syndrome',7,'high',NULL,'2025-08-30 09:04:51',35,'ATP III Criteria (2/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(975,166,'stroke_risk',1,'low',NULL,'2025-08-30 09:04:51',0,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(976,169,'ASCVD_10_YEAR',0,'low',NULL,'2025-08-30 09:19:04',0,'POOLED_COHORT_EQUATIONS');
INSERT INTO "risk_calculations" VALUES(977,169,'DIABETES_TYPE2',0,'low',NULL,'2025-08-30 09:19:04',0,'FRAMINGHAM_DIABETES');
INSERT INTO "risk_calculations" VALUES(978,170,'ASCVD_10_YEAR',89.69456071832406,'very_high',NULL,'2025-08-30 09:24:15',100,'POOLED_COHORT_EQUATIONS');
INSERT INTO "risk_calculations" VALUES(979,170,'DIABETES_TYPE2',4,'low',NULL,'2025-08-30 09:24:15',1,'FRAMINGHAM_DIABETES');
INSERT INTO "risk_calculations" VALUES(980,171,'ASCVD_10_YEAR',74.96957989112992,'low',NULL,'2025-08-30 09:26:39',0.000029995256700665607,'POOLED_COHORT_EQUATIONS');
INSERT INTO "risk_calculations" VALUES(981,171,'DIABETES_TYPE2',4,'low',NULL,'2025-08-30 09:26:39',1,'FRAMINGHAM_DIABETES');
INSERT INTO "risk_calculations" VALUES(982,172,'ASCVD_10_YEAR',85.52455534817294,'very_high',NULL,'2025-08-30 09:31:20',100,'POOLED_COHORT_EQUATIONS');
INSERT INTO "risk_calculations" VALUES(983,172,'DIABETES_TYPE2',2,'low',NULL,'2025-08-30 09:31:20',1,'FRAMINGHAM_DIABETES');
INSERT INTO "risk_calculations" VALUES(984,173,'ASCVD_10_YEAR',95.73497706917361,'very_high',NULL,'2025-08-30 09:44:30',100,'POOLED_COHORT_EQUATIONS');
INSERT INTO "risk_calculations" VALUES(985,173,'DIABETES_TYPE2',17,'very_high',NULL,'2025-08-30 09:44:30',33,'FRAMINGHAM_DIABETES');
INSERT INTO "risk_calculations" VALUES(986,174,'ASCVD_10_YEAR',78.7595973681294,'low',NULL,'2025-08-30 10:29:21',0.001327496675174178,'POOLED_COHORT_EQUATIONS');
INSERT INTO "risk_calculations" VALUES(987,174,'DIABETES_TYPE2',5,'low',NULL,'2025-08-30 10:29:21',1,'FRAMINGHAM_DIABETES');
INSERT INTO "risk_calculations" VALUES(988,175,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-08-30 11:28:25',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(989,175,'diabetes',18,'very_high',NULL,'2025-08-30 11:28:25',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(990,175,'kidney_disease',3,'low',NULL,'2025-08-30 11:28:26',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(991,175,'cancer_risk',7,'moderate',NULL,'2025-08-30 11:28:26',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(992,175,'cognitive_decline',8,'moderate',NULL,'2025-08-30 11:28:26',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(993,175,'metabolic_syndrome',14,'very_high',NULL,'2025-08-30 11:28:26',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(994,175,'stroke_risk',8,'moderate',NULL,'2025-08-30 11:28:27',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(995,176,'ASCVD_10_YEAR',89.69456071832406,'very_high',NULL,'2025-08-30 12:09:18',100,'POOLED_COHORT_EQUATIONS');
INSERT INTO "risk_calculations" VALUES(996,176,'DIABETES_TYPE2',4,'low',NULL,'2025-08-30 12:09:18',1,'FRAMINGHAM_DIABETES');
INSERT INTO "risk_calculations" VALUES(997,177,'ASCVD_10_YEAR',89.69456071832406,'very_high',NULL,'2025-08-30 12:13:29',100,'POOLED_COHORT_EQUATIONS');
INSERT INTO "risk_calculations" VALUES(998,177,'DIABETES_TYPE2',4,'low',NULL,'2025-08-30 12:13:29',1,'FRAMINGHAM_DIABETES');
INSERT INTO "risk_calculations" VALUES(999,178,'ASCVD_10_YEAR',89.69456071832406,'very_high',NULL,'2025-08-30 12:29:41',100,'POOLED_COHORT_EQUATIONS');
INSERT INTO "risk_calculations" VALUES(1000,178,'DIABETES_TYPE2',4,'low',NULL,'2025-08-30 12:29:41',1,'FRAMINGHAM_DIABETES');
INSERT INTO "risk_calculations" VALUES(1001,179,'ASCVD_10_YEAR',89.69456071832406,'very_high',NULL,'2025-08-30 12:31:33',100,'POOLED_COHORT_EQUATIONS');
INSERT INTO "risk_calculations" VALUES(1002,179,'DIABETES_TYPE2',4,'low',NULL,'2025-08-30 12:31:33',1,'FRAMINGHAM_DIABETES');
INSERT INTO "risk_calculations" VALUES(1003,180,'ASCVD_10_YEAR',89.69456071832406,'very_high',NULL,'2025-08-30 12:32:34',100,'POOLED_COHORT_EQUATIONS');
INSERT INTO "risk_calculations" VALUES(1004,180,'DIABETES_TYPE2',4,'low',NULL,'2025-08-30 12:32:34',1,'FRAMINGHAM_DIABETES');
INSERT INTO "risk_calculations" VALUES(1005,181,'ASCVD_10_YEAR',89.69456071832406,'very_high',NULL,'2025-08-30 12:32:48',100,'POOLED_COHORT_EQUATIONS');
INSERT INTO "risk_calculations" VALUES(1006,181,'DIABETES_TYPE2',4,'low',NULL,'2025-08-30 12:32:48',1,'FRAMINGHAM_DIABETES');
INSERT INTO "risk_calculations" VALUES(1007,182,'ASCVD_10_YEAR',89.69456071832406,'very_high',NULL,'2025-08-30 12:43:26',100,'POOLED_COHORT_EQUATIONS');
INSERT INTO "risk_calculations" VALUES(1008,182,'DIABETES_TYPE2',4,'low',NULL,'2025-08-30 12:43:26',1,'FRAMINGHAM_DIABETES');
INSERT INTO "risk_calculations" VALUES(1009,183,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-08-30 13:13:05',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1010,183,'diabetes',18,'very_high',NULL,'2025-08-30 13:13:05',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1011,183,'kidney_disease',3,'low',NULL,'2025-08-30 13:13:05',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1012,183,'cancer_risk',7,'moderate',NULL,'2025-08-30 13:13:06',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1013,183,'cognitive_decline',8,'moderate',NULL,'2025-08-30 13:13:06',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1014,183,'metabolic_syndrome',14,'very_high',NULL,'2025-08-30 13:13:06',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1015,183,'stroke_risk',8,'moderate',NULL,'2025-08-30 13:13:07',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1016,184,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-08-30 13:38:46',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1017,184,'diabetes',18,'very_high',NULL,'2025-08-30 13:38:46',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1018,184,'kidney_disease',3,'low',NULL,'2025-08-30 13:38:46',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1019,184,'cancer_risk',7,'moderate',NULL,'2025-08-30 13:38:47',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1020,184,'cognitive_decline',8,'moderate',NULL,'2025-08-30 13:38:47',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1021,184,'metabolic_syndrome',14,'very_high',NULL,'2025-08-30 13:38:47',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1022,184,'stroke_risk',8,'moderate',NULL,'2025-08-30 13:38:48',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1023,185,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-08-31 10:53:18',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1024,185,'diabetes',18,'very_high',NULL,'2025-08-31 10:53:18',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1025,185,'kidney_disease',3,'low',NULL,'2025-08-31 10:53:18',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1026,185,'cancer_risk',7,'moderate',NULL,'2025-08-31 10:53:19',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1027,185,'cognitive_decline',8,'moderate',NULL,'2025-08-31 10:53:19',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1028,185,'metabolic_syndrome',14,'very_high',NULL,'2025-08-31 10:53:19',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1029,185,'stroke_risk',8,'moderate',NULL,'2025-08-31 10:53:19',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1030,186,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-08-31 10:59:10',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1031,186,'diabetes',18,'very_high',NULL,'2025-08-31 10:59:10',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1032,186,'kidney_disease',3,'low',NULL,'2025-08-31 10:59:11',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1033,186,'cancer_risk',7,'moderate',NULL,'2025-08-31 10:59:11',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1034,186,'cognitive_decline',8,'moderate',NULL,'2025-08-31 10:59:11',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1035,186,'metabolic_syndrome',14,'very_high',NULL,'2025-08-31 10:59:11',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1036,186,'stroke_risk',8,'moderate',NULL,'2025-08-31 10:59:12',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1037,187,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-08-31 11:49:43',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1038,187,'diabetes',18,'very_high',NULL,'2025-08-31 11:49:43',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1039,187,'kidney_disease',3,'low',NULL,'2025-08-31 11:49:43',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1040,187,'cancer_risk',7,'moderate',NULL,'2025-08-31 11:49:44',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1041,187,'cognitive_decline',8,'moderate',NULL,'2025-08-31 11:49:44',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1042,187,'metabolic_syndrome',14,'very_high',NULL,'2025-08-31 11:49:44',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1043,187,'stroke_risk',8,'moderate',NULL,'2025-08-31 11:49:45',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1044,188,'ASCVD_10_YEAR',93.76824112324684,'very_high',NULL,'2025-08-31 14:02:43',100,'POOLED_COHORT_EQUATIONS');
INSERT INTO "risk_calculations" VALUES(1045,188,'DIABETES_TYPE2',6,'low',NULL,'2025-08-31 14:02:43',1,'FRAMINGHAM_DIABETES');
INSERT INTO "risk_calculations" VALUES(1046,189,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-08-31 14:35:58',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1047,189,'diabetes',18,'very_high',NULL,'2025-08-31 14:35:59',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1048,189,'kidney_disease',3,'low',NULL,'2025-08-31 14:35:59',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1049,189,'cancer_risk',7,'moderate',NULL,'2025-08-31 14:35:59',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1050,189,'cognitive_decline',8,'moderate',NULL,'2025-08-31 14:35:59',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1051,189,'metabolic_syndrome',14,'very_high',NULL,'2025-08-31 14:36:00',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1052,189,'stroke_risk',8,'moderate',NULL,'2025-08-31 14:36:00',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1053,190,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-08-31 14:36:05',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1054,190,'diabetes',18,'very_high',NULL,'2025-08-31 14:36:05',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1055,190,'kidney_disease',3,'low',NULL,'2025-08-31 14:36:05',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1056,190,'cancer_risk',7,'moderate',NULL,'2025-08-31 14:36:06',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1057,190,'cognitive_decline',8,'moderate',NULL,'2025-08-31 14:36:06',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1058,190,'metabolic_syndrome',14,'very_high',NULL,'2025-08-31 14:36:06',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1059,190,'stroke_risk',8,'moderate',NULL,'2025-08-31 14:36:06',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1060,191,'ASCVD_10_YEAR',93.76824112324684,'very_high',NULL,'2025-08-31 14:37:18',100,'POOLED_COHORT_EQUATIONS');
INSERT INTO "risk_calculations" VALUES(1061,191,'DIABETES_TYPE2',6,'low',NULL,'2025-08-31 14:37:19',1,'FRAMINGHAM_DIABETES');
INSERT INTO "risk_calculations" VALUES(1062,192,'cardiovascular',86.97846914031533,'very_high',NULL,'2025-08-31 15:41:47',100,'POOLED_COHORT_EQUATIONS');
INSERT INTO "risk_calculations" VALUES(1063,192,'diabetes',4,'low',NULL,'2025-08-31 15:41:47',1,'FRAMINGHAM_DIABETES');
INSERT INTO "risk_calculations" VALUES(1064,192,'kidney_disease',2,'low',NULL,'2025-08-31 15:41:47',10,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1065,192,'cancer_risk',2,'low',NULL,'2025-08-31 15:41:47',2,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1066,192,'cognitive_decline',0,'low',NULL,'2025-08-31 15:41:47',1,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1067,192,'metabolic_syndrome',1,'low',NULL,'2025-08-31 15:41:47',5,'ATP III Criteria (0/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1068,192,'stroke_risk',1,'low',NULL,'2025-08-31 15:41:48',0,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1069,193,'cardiovascular',76.02729514715377,'low',NULL,'2025-08-31 15:41:59',0.00008637983290871176,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1070,193,'diabetes',4,'low',NULL,'2025-08-31 15:41:59',1,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1071,193,'kidney_disease',2,'low',NULL,'2025-08-31 15:41:59',10,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1072,193,'cancer_risk',2,'low',NULL,'2025-08-31 15:41:59',2,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1073,193,'cognitive_decline',0,'low',NULL,'2025-08-31 15:41:59',1,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1074,193,'metabolic_syndrome',1,'low',NULL,'2025-08-31 15:41:59',5,'ATP III Criteria (0/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1075,193,'stroke_risk',-1,'low',NULL,'2025-08-31 15:41:59',1,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1076,194,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-08-31 15:44:56',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1077,194,'diabetes',18,'very_high',NULL,'2025-08-31 15:44:56',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1078,194,'kidney_disease',3,'low',NULL,'2025-08-31 15:44:56',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1079,194,'cancer_risk',7,'moderate',NULL,'2025-08-31 15:44:57',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1080,194,'cognitive_decline',8,'moderate',NULL,'2025-08-31 15:44:57',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1081,194,'metabolic_syndrome',14,'very_high',NULL,'2025-08-31 15:44:57',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1082,194,'stroke_risk',8,'moderate',NULL,'2025-08-31 15:44:57',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1083,195,'cardiovascular',93.76824112324684,'very_high',NULL,'2025-08-31 15:46:43',100,'POOLED_COHORT_EQUATIONS');
INSERT INTO "risk_calculations" VALUES(1084,195,'diabetes',6,'low',NULL,'2025-08-31 15:46:43',1,'FRAMINGHAM_DIABETES');
INSERT INTO "risk_calculations" VALUES(1085,195,'kidney_disease',3,'low',NULL,'2025-08-31 15:46:43',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1086,195,'cancer_risk',8,'moderate',NULL,'2025-08-31 15:46:43',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1087,195,'cognitive_decline',7,'moderate',NULL,'2025-08-31 15:46:44',5,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1088,195,'metabolic_syndrome',3,'low',NULL,'2025-08-31 15:46:44',5,'ATP III Criteria (0/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1089,195,'stroke_risk',6,'low',NULL,'2025-08-31 15:46:44',3,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1090,196,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-08-31 15:57:51',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1091,196,'diabetes',18,'very_high',NULL,'2025-08-31 15:57:51',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1092,196,'kidney_disease',3,'low',NULL,'2025-08-31 15:57:51',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1093,196,'cancer_risk',7,'moderate',NULL,'2025-08-31 15:57:52',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1094,196,'cognitive_decline',8,'moderate',NULL,'2025-08-31 15:57:52',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1095,196,'metabolic_syndrome',14,'very_high',NULL,'2025-08-31 15:57:52',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1096,196,'stroke_risk',8,'moderate',NULL,'2025-08-31 15:57:52',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1097,197,'cardiovascular',93.76824112324684,'very_high',NULL,'2025-08-31 15:59:36',100,'POOLED_COHORT_EQUATIONS');
INSERT INTO "risk_calculations" VALUES(1098,197,'diabetes',6,'low',NULL,'2025-08-31 15:59:36',1,'FRAMINGHAM_DIABETES');
INSERT INTO "risk_calculations" VALUES(1099,197,'kidney_disease',3,'low',NULL,'2025-08-31 15:59:37',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1100,197,'cancer_risk',8,'moderate',NULL,'2025-08-31 15:59:37',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1101,197,'cognitive_decline',7,'moderate',NULL,'2025-08-31 15:59:37',5,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1102,197,'metabolic_syndrome',3,'low',NULL,'2025-08-31 15:59:38',5,'ATP III Criteria (0/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1103,197,'stroke_risk',6,'low',NULL,'2025-08-31 15:59:38',3,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1104,198,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-09-01 04:37:34',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1105,198,'diabetes',18,'very_high',NULL,'2025-09-01 04:37:35',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1106,198,'kidney_disease',3,'low',NULL,'2025-09-01 04:37:35',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1107,198,'cancer_risk',7,'moderate',NULL,'2025-09-01 04:37:35',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1108,198,'cognitive_decline',8,'moderate',NULL,'2025-09-01 04:37:35',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1109,198,'metabolic_syndrome',14,'very_high',NULL,'2025-09-01 04:37:36',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1110,198,'stroke_risk',8,'moderate',NULL,'2025-09-01 04:37:36',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1111,199,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-09-01 06:56:32',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1112,199,'diabetes',18,'very_high',NULL,'2025-09-01 06:56:32',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1113,199,'kidney_disease',3,'low',NULL,'2025-09-01 06:56:32',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1114,199,'cancer_risk',7,'moderate',NULL,'2025-09-01 06:56:33',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1115,199,'cognitive_decline',8,'moderate',NULL,'2025-09-01 06:56:33',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1116,199,'metabolic_syndrome',14,'very_high',NULL,'2025-09-01 06:56:33',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1117,199,'stroke_risk',8,'moderate',NULL,'2025-09-01 06:56:34',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1118,200,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-09-01 07:21:24',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1119,200,'diabetes',18,'very_high',NULL,'2025-09-01 07:21:24',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1120,200,'kidney_disease',3,'low',NULL,'2025-09-01 07:21:24',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1121,200,'cancer_risk',7,'moderate',NULL,'2025-09-01 07:21:24',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1122,200,'cognitive_decline',8,'moderate',NULL,'2025-09-01 07:21:25',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1123,200,'metabolic_syndrome',14,'very_high',NULL,'2025-09-01 07:21:25',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1124,200,'stroke_risk',8,'moderate',NULL,'2025-09-01 07:21:25',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1125,201,'cardiovascular',76.81067115026642,'low',NULL,'2025-09-01 07:23:08',0.00018907234561327257,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1126,201,'diabetes',5,'low',NULL,'2025-09-01 07:23:08',1,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1127,201,'kidney_disease',3,'low',NULL,'2025-09-01 07:23:09',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1128,201,'cancer_risk',6,'moderate',NULL,'2025-09-01 07:23:09',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1129,201,'cognitive_decline',1,'low',NULL,'2025-09-01 07:23:09',1,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1130,201,'metabolic_syndrome',1,'low',NULL,'2025-09-01 07:23:10',5,'ATP III Criteria (0/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1131,201,'stroke_risk',0,'low',NULL,'2025-09-01 07:23:10',1,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1132,202,'cardiovascular',93.76824112324684,'very_high',NULL,'2025-09-01 07:25:43',100,'POOLED_COHORT_EQUATIONS');
INSERT INTO "risk_calculations" VALUES(1133,202,'diabetes',6,'low',NULL,'2025-09-01 07:25:44',1,'FRAMINGHAM_DIABETES');
INSERT INTO "risk_calculations" VALUES(1134,202,'kidney_disease',3,'low',NULL,'2025-09-01 07:25:44',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1135,202,'cancer_risk',8,'moderate',NULL,'2025-09-01 07:25:44',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1136,202,'cognitive_decline',7,'moderate',NULL,'2025-09-01 07:25:44',5,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1137,202,'metabolic_syndrome',3,'low',NULL,'2025-09-01 07:25:45',5,'ATP III Criteria (0/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1138,202,'stroke_risk',6,'low',NULL,'2025-09-01 07:25:45',3,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1139,203,'cardiovascular',93.76824112324684,'very_high',NULL,'2025-09-01 07:29:10',100,'POOLED_COHORT_EQUATIONS');
INSERT INTO "risk_calculations" VALUES(1140,203,'diabetes',6,'low',NULL,'2025-09-01 07:29:10',1,'FRAMINGHAM_DIABETES');
INSERT INTO "risk_calculations" VALUES(1141,203,'kidney_disease',3,'low',NULL,'2025-09-01 07:29:10',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1142,203,'cancer_risk',8,'moderate',NULL,'2025-09-01 07:29:11',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1143,203,'cognitive_decline',7,'moderate',NULL,'2025-09-01 07:29:11',5,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1144,203,'metabolic_syndrome',6,'moderate',NULL,'2025-09-01 07:29:11',15,'ATP III Criteria (1/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1145,203,'stroke_risk',6,'low',NULL,'2025-09-01 07:29:11',3,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1146,204,'cardiovascular',76.02729514715377,'low',NULL,'2025-09-01 07:30:37',0.00008637983290871176,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1147,204,'diabetes',4,'low',NULL,'2025-09-01 07:30:37',1,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1148,204,'kidney_disease',2,'low',NULL,'2025-09-01 07:30:38',10,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1149,204,'cancer_risk',2,'low',NULL,'2025-09-01 07:30:38',2,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1150,204,'cognitive_decline',0,'low',NULL,'2025-09-01 07:30:38',1,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1151,204,'metabolic_syndrome',1,'low',NULL,'2025-09-01 07:30:38',5,'ATP III Criteria (0/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1152,204,'stroke_risk',-1,'low',NULL,'2025-09-01 07:30:39',1,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1153,205,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-09-02 04:28:18',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1154,205,'diabetes',18,'very_high',NULL,'2025-09-02 04:28:18',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1155,205,'kidney_disease',3,'low',NULL,'2025-09-02 04:28:19',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1156,205,'cancer_risk',7,'moderate',NULL,'2025-09-02 04:28:19',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1157,205,'cognitive_decline',8,'moderate',NULL,'2025-09-02 04:28:19',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1158,205,'metabolic_syndrome',14,'very_high',NULL,'2025-09-02 04:28:19',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1159,205,'stroke_risk',8,'moderate',NULL,'2025-09-02 04:28:20',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1160,206,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-09-03 07:00:09',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1161,206,'diabetes',18,'very_high',NULL,'2025-09-03 07:00:09',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1162,206,'kidney_disease',3,'low',NULL,'2025-09-03 07:00:10',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1163,206,'cancer_risk',7,'moderate',NULL,'2025-09-03 07:00:10',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1164,206,'cognitive_decline',8,'moderate',NULL,'2025-09-03 07:00:10',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1165,206,'metabolic_syndrome',14,'very_high',NULL,'2025-09-03 07:00:10',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1166,206,'stroke_risk',8,'moderate',NULL,'2025-09-03 07:00:11',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1167,207,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-09-03 07:00:15',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1168,207,'diabetes',18,'very_high',NULL,'2025-09-03 07:00:15',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1169,207,'kidney_disease',3,'low',NULL,'2025-09-03 07:00:15',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1170,207,'cancer_risk',7,'moderate',NULL,'2025-09-03 07:00:16',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1171,207,'cognitive_decline',8,'moderate',NULL,'2025-09-03 07:00:16',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1172,207,'metabolic_syndrome',14,'very_high',NULL,'2025-09-03 07:00:17',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1173,207,'stroke_risk',8,'moderate',NULL,'2025-09-03 07:00:17',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1174,208,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-09-05 03:06:03',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1175,208,'diabetes',18,'very_high',NULL,'2025-09-05 03:06:03',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1176,208,'kidney_disease',3,'low',NULL,'2025-09-05 03:06:03',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1177,208,'cancer_risk',7,'moderate',NULL,'2025-09-05 03:06:04',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1178,208,'cognitive_decline',8,'moderate',NULL,'2025-09-05 03:06:04',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1179,208,'metabolic_syndrome',14,'very_high',NULL,'2025-09-05 03:06:04',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1180,208,'stroke_risk',8,'moderate',NULL,'2025-09-05 03:06:04',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1181,209,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-09-07 05:18:13',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1182,209,'diabetes',18,'very_high',NULL,'2025-09-07 05:18:13',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1183,209,'kidney_disease',3,'low',NULL,'2025-09-07 05:18:13',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1184,209,'cancer_risk',7,'moderate',NULL,'2025-09-07 05:18:14',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1185,209,'cognitive_decline',8,'moderate',NULL,'2025-09-07 05:18:14',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1186,209,'metabolic_syndrome',14,'very_high',NULL,'2025-09-07 05:18:14',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1187,209,'stroke_risk',8,'moderate',NULL,'2025-09-07 05:18:14',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1188,211,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-09-13 14:46:29',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1189,211,'diabetes',18,'very_high',NULL,'2025-09-13 14:46:29',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1190,211,'kidney_disease',3,'low',NULL,'2025-09-13 14:46:29',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1191,211,'cancer_risk',7,'moderate',NULL,'2025-09-13 14:46:29',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1192,211,'cognitive_decline',8,'moderate',NULL,'2025-09-13 14:46:30',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1193,211,'metabolic_syndrome',14,'very_high',NULL,'2025-09-13 14:46:30',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1194,211,'stroke_risk',8,'moderate',NULL,'2025-09-13 14:46:30',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1195,212,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-09-13 14:46:39',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1196,212,'diabetes',18,'very_high',NULL,'2025-09-13 14:46:39',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1197,212,'kidney_disease',3,'low',NULL,'2025-09-13 14:46:39',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1198,212,'cancer_risk',7,'moderate',NULL,'2025-09-13 14:46:39',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1199,212,'cognitive_decline',8,'moderate',NULL,'2025-09-13 14:46:40',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1200,212,'metabolic_syndrome',14,'very_high',NULL,'2025-09-13 14:46:40',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1201,212,'stroke_risk',8,'moderate',NULL,'2025-09-13 14:46:40',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1202,213,'cardiovascular',76.81067115026642,'low',NULL,'2025-09-13 14:47:22',0.00018907234561327257,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1203,213,'diabetes',5,'low',NULL,'2025-09-13 14:47:22',1,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1204,213,'kidney_disease',3,'low',NULL,'2025-09-13 14:47:22',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1205,213,'cancer_risk',6,'moderate',NULL,'2025-09-13 14:47:22',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1206,213,'cognitive_decline',1,'low',NULL,'2025-09-13 14:47:23',1,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1207,213,'metabolic_syndrome',1,'low',NULL,'2025-09-13 14:47:24',5,'ATP III Criteria (0/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1208,213,'stroke_risk',0,'low',NULL,'2025-09-13 14:47:24',1,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1209,214,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-09-15 07:33:02',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1210,214,'diabetes',18,'very_high',NULL,'2025-09-15 07:33:02',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1211,214,'kidney_disease',3,'low',NULL,'2025-09-15 07:33:02',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1212,214,'cancer_risk',7,'moderate',NULL,'2025-09-15 07:33:02',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1213,214,'cognitive_decline',8,'moderate',NULL,'2025-09-15 07:33:03',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1214,214,'metabolic_syndrome',14,'very_high',NULL,'2025-09-15 07:33:03',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1215,214,'stroke_risk',8,'moderate',NULL,'2025-09-15 07:33:03',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1216,215,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-09-16 08:02:04',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1217,215,'diabetes',18,'very_high',NULL,'2025-09-16 08:02:05',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1218,215,'kidney_disease',3,'low',NULL,'2025-09-16 08:02:05',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1219,215,'cancer_risk',7,'moderate',NULL,'2025-09-16 08:02:05',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1220,215,'cognitive_decline',8,'moderate',NULL,'2025-09-16 08:02:05',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1221,215,'metabolic_syndrome',14,'very_high',NULL,'2025-09-16 08:02:05',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1222,215,'stroke_risk',8,'moderate',NULL,'2025-09-16 08:02:06',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1223,216,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-09-16 08:02:12',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1224,216,'diabetes',18,'very_high',NULL,'2025-09-16 08:02:12',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1225,216,'kidney_disease',3,'low',NULL,'2025-09-16 08:02:12',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1226,216,'cancer_risk',7,'moderate',NULL,'2025-09-16 08:02:12',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1227,216,'cognitive_decline',8,'moderate',NULL,'2025-09-16 08:02:13',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1228,216,'metabolic_syndrome',14,'very_high',NULL,'2025-09-16 08:02:13',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1229,216,'stroke_risk',8,'moderate',NULL,'2025-09-16 08:02:13',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1230,217,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-09-16 11:57:55',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1231,217,'diabetes',18,'very_high',NULL,'2025-09-16 11:57:56',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1232,217,'kidney_disease',3,'low',NULL,'2025-09-16 11:57:56',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1233,217,'cancer_risk',7,'moderate',NULL,'2025-09-16 11:57:56',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1234,217,'cognitive_decline',8,'moderate',NULL,'2025-09-16 11:57:56',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1235,217,'metabolic_syndrome',14,'very_high',NULL,'2025-09-16 11:57:56',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1236,217,'stroke_risk',8,'moderate',NULL,'2025-09-16 11:57:57',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1237,218,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-09-16 11:58:00',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1238,218,'diabetes',18,'very_high',NULL,'2025-09-16 11:58:00',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1239,218,'kidney_disease',3,'low',NULL,'2025-09-16 11:58:00',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1240,218,'cancer_risk',7,'moderate',NULL,'2025-09-16 11:58:00',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1241,218,'cognitive_decline',8,'moderate',NULL,'2025-09-16 11:58:01',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1242,218,'metabolic_syndrome',14,'very_high',NULL,'2025-09-16 11:58:01',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1243,218,'stroke_risk',8,'moderate',NULL,'2025-09-16 11:58:01',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1244,219,'cardiovascular',76.81067115026642,'low',NULL,'2025-09-16 12:30:17',0.00018907234561327257,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1245,219,'diabetes',5,'low',NULL,'2025-09-16 12:30:17',1,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1246,219,'kidney_disease',3,'low',NULL,'2025-09-16 12:30:17',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1247,219,'cancer_risk',6,'moderate',NULL,'2025-09-16 12:30:17',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1248,219,'cognitive_decline',1,'low',NULL,'2025-09-16 12:30:18',1,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1249,219,'metabolic_syndrome',1,'low',NULL,'2025-09-16 12:30:18',5,'ATP III Criteria (0/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1250,219,'stroke_risk',0,'low',NULL,'2025-09-16 12:30:18',1,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1251,220,'cardiovascular',76.81067115026642,'low',NULL,'2025-09-16 12:30:23',0.00018907234561327257,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1252,221,'cardiovascular',76.02729514715377,'low',NULL,'2025-09-16 12:30:42',0.00008637983290871176,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1253,221,'diabetes',4,'low',NULL,'2025-09-16 12:30:43',1,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1254,221,'kidney_disease',2,'low',NULL,'2025-09-16 12:30:43',10,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1255,221,'cancer_risk',2,'low',NULL,'2025-09-16 12:30:43',2,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1256,221,'cognitive_decline',0,'low',NULL,'2025-09-16 12:30:43',1,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1257,221,'metabolic_syndrome',1,'low',NULL,'2025-09-16 12:30:43',5,'ATP III Criteria (0/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1258,221,'stroke_risk',-1,'low',NULL,'2025-09-16 12:30:44',1,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1259,222,'cardiovascular',76.02729514715377,'low',NULL,'2025-09-16 12:30:48',0.00008637983290871176,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1260,222,'diabetes',4,'low',NULL,'2025-09-16 12:30:48',1,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1261,222,'kidney_disease',2,'low',NULL,'2025-09-16 12:30:48',10,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1262,222,'cancer_risk',2,'low',NULL,'2025-09-16 12:30:49',2,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1263,222,'cognitive_decline',0,'low',NULL,'2025-09-16 12:30:49',1,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1264,222,'metabolic_syndrome',1,'low',NULL,'2025-09-16 12:30:49',5,'ATP III Criteria (0/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1265,223,'cardiovascular',76.02729514715377,'low',NULL,'2025-09-20 04:52:48',0.00008637983290871176,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1266,223,'diabetes',4,'low',NULL,'2025-09-20 04:52:48',1,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1267,223,'kidney_disease',2,'low',NULL,'2025-09-20 04:52:48',10,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1268,223,'cancer_risk',2,'low',NULL,'2025-09-20 04:52:48',2,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1269,223,'cognitive_decline',0,'low',NULL,'2025-09-20 04:52:49',1,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1270,223,'metabolic_syndrome',1,'low',NULL,'2025-09-20 04:52:49',5,'ATP III Criteria (0/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1271,223,'stroke_risk',-1,'low',NULL,'2025-09-20 04:52:49',1,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1272,224,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-09-22 01:42:06',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1273,224,'diabetes',18,'very_high',NULL,'2025-09-22 01:42:06',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1274,224,'kidney_disease',3,'low',NULL,'2025-09-22 01:42:07',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1275,224,'cancer_risk',7,'moderate',NULL,'2025-09-22 01:42:07',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1276,224,'cognitive_decline',8,'moderate',NULL,'2025-09-22 01:42:07',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1277,224,'metabolic_syndrome',14,'very_high',NULL,'2025-09-22 01:42:07',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1278,224,'stroke_risk',8,'moderate',NULL,'2025-09-22 01:42:08',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1279,225,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-09-22 01:42:11',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1280,225,'diabetes',18,'very_high',NULL,'2025-09-22 01:42:11',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1281,225,'kidney_disease',3,'low',NULL,'2025-09-22 01:42:11',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1282,225,'cancer_risk',7,'moderate',NULL,'2025-09-22 01:42:12',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1283,225,'cognitive_decline',8,'moderate',NULL,'2025-09-22 01:42:12',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1284,225,'metabolic_syndrome',14,'very_high',NULL,'2025-09-22 01:42:12',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1285,225,'stroke_risk',8,'moderate',NULL,'2025-09-22 01:42:12',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1286,226,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-09-22 01:42:14',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1287,226,'diabetes',18,'very_high',NULL,'2025-09-22 01:42:14',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1288,226,'kidney_disease',3,'low',NULL,'2025-09-22 01:42:14',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1289,226,'cancer_risk',7,'moderate',NULL,'2025-09-22 01:42:15',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1290,226,'cognitive_decline',8,'moderate',NULL,'2025-09-22 01:42:15',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1291,226,'metabolic_syndrome',14,'very_high',NULL,'2025-09-22 01:42:15',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1292,226,'stroke_risk',8,'moderate',NULL,'2025-09-22 01:42:15',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1293,227,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-09-23 02:27:28',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1294,227,'diabetes',18,'very_high',NULL,'2025-09-23 02:27:28',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1295,227,'kidney_disease',3,'low',NULL,'2025-09-23 02:27:28',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1296,227,'cancer_risk',7,'moderate',NULL,'2025-09-23 02:27:29',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1297,227,'cognitive_decline',8,'moderate',NULL,'2025-09-23 02:27:29',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1298,227,'metabolic_syndrome',14,'very_high',NULL,'2025-09-23 02:27:29',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1299,227,'stroke_risk',8,'moderate',NULL,'2025-09-23 02:27:29',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1300,229,'cardiovascular',87.06381742900285,'very_high',NULL,'2025-09-25 05:44:50',100,'POOLED_COHORT_EQUATIONS');
INSERT INTO "risk_calculations" VALUES(1301,229,'diabetes',11,'moderate',NULL,'2025-09-25 05:44:50',4,'FRAMINGHAM_DIABETES');
INSERT INTO "risk_calculations" VALUES(1302,229,'kidney_disease',2,'low',NULL,'2025-09-25 05:44:50',10,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1303,229,'cancer_risk',6,'moderate',NULL,'2025-09-25 05:44:50',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1304,229,'cognitive_decline',3,'low',NULL,'2025-09-25 05:44:50',1,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1305,229,'metabolic_syndrome',4,'moderate',NULL,'2025-09-25 05:44:51',15,'ATP III Criteria (1/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1306,229,'stroke_risk',3,'low',NULL,'2025-09-25 05:44:51',0,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1307,230,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-10-02 09:38:08',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1308,230,'diabetes',18,'very_high',NULL,'2025-10-02 09:38:08',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1309,230,'kidney_disease',3,'low',NULL,'2025-10-02 09:38:08',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1310,230,'cancer_risk',7,'moderate',NULL,'2025-10-02 09:38:08',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1311,230,'cognitive_decline',8,'moderate',NULL,'2025-10-02 09:38:08',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1312,230,'metabolic_syndrome',14,'very_high',NULL,'2025-10-02 09:38:08',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1313,230,'stroke_risk',8,'moderate',NULL,'2025-10-02 09:38:09',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1314,231,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-10-02 13:16:16',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1315,231,'diabetes',18,'very_high',NULL,'2025-10-02 13:16:16',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1316,231,'kidney_disease',3,'low',NULL,'2025-10-02 13:16:17',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1317,231,'cancer_risk',7,'moderate',NULL,'2025-10-02 13:16:17',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1318,231,'cognitive_decline',8,'moderate',NULL,'2025-10-02 13:16:17',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1319,231,'metabolic_syndrome',14,'very_high',NULL,'2025-10-02 13:16:17',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1320,231,'stroke_risk',8,'moderate',NULL,'2025-10-02 13:16:18',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1321,232,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-10-02 13:16:20',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1322,232,'diabetes',18,'very_high',NULL,'2025-10-02 13:16:20',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1323,232,'kidney_disease',3,'low',NULL,'2025-10-02 13:16:21',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1324,232,'cancer_risk',7,'moderate',NULL,'2025-10-02 13:16:21',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1325,232,'cognitive_decline',8,'moderate',NULL,'2025-10-02 13:16:21',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1326,232,'metabolic_syndrome',14,'very_high',NULL,'2025-10-02 13:16:21',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1327,232,'stroke_risk',8,'moderate',NULL,'2025-10-02 13:16:21',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1328,233,'cardiovascular',76.02729514715377,'low',NULL,'2025-10-03 08:18:11',0.00008637983290871176,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1329,233,'diabetes',4,'low',NULL,'2025-10-03 08:18:11',1,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1330,233,'kidney_disease',2,'low',NULL,'2025-10-03 08:18:12',10,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1331,233,'cancer_risk',2,'low',NULL,'2025-10-03 08:18:12',2,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1332,233,'cognitive_decline',0,'low',NULL,'2025-10-03 08:18:12',1,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1333,233,'metabolic_syndrome',1,'low',NULL,'2025-10-03 08:18:12',5,'ATP III Criteria (0/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1334,233,'stroke_risk',-1,'low',NULL,'2025-10-03 08:18:13',1,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1335,234,'cardiovascular',76.02729514715377,'low',NULL,'2025-10-03 08:18:21',0.00008637983290871176,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1336,234,'diabetes',4,'low',NULL,'2025-10-03 08:18:21',1,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1337,234,'kidney_disease',2,'low',NULL,'2025-10-03 08:18:21',10,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1338,234,'cancer_risk',2,'low',NULL,'2025-10-03 08:18:21',2,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1339,234,'cognitive_decline',0,'low',NULL,'2025-10-03 08:18:22',1,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1340,234,'metabolic_syndrome',1,'low',NULL,'2025-10-03 08:18:22',5,'ATP III Criteria (0/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1341,234,'stroke_risk',-1,'low',NULL,'2025-10-03 08:18:22',1,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1342,235,'cardiovascular',76.81067115026642,'low',NULL,'2025-10-04 09:18:18',0.00018907234561327257,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1343,235,'diabetes',5,'low',NULL,'2025-10-04 09:18:18',1,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1344,235,'kidney_disease',3,'low',NULL,'2025-10-04 09:18:19',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1345,235,'cancer_risk',6,'moderate',NULL,'2025-10-04 09:18:19',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1346,235,'cognitive_decline',1,'low',NULL,'2025-10-04 09:18:19',1,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1347,235,'metabolic_syndrome',1,'low',NULL,'2025-10-04 09:18:19',5,'ATP III Criteria (0/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1348,235,'stroke_risk',0,'low',NULL,'2025-10-04 09:18:20',1,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1349,236,'cardiovascular',76.81067115026642,'low',NULL,'2025-10-04 09:18:27',0.00018907234561327257,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1350,236,'diabetes',5,'low',NULL,'2025-10-04 09:18:27',1,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1351,236,'kidney_disease',3,'low',NULL,'2025-10-04 09:18:27',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1352,236,'cancer_risk',6,'moderate',NULL,'2025-10-04 09:18:28',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1353,236,'cognitive_decline',1,'low',NULL,'2025-10-04 09:18:28',1,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1354,236,'metabolic_syndrome',1,'low',NULL,'2025-10-04 09:18:28',5,'ATP III Criteria (0/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1355,236,'stroke_risk',0,'low',NULL,'2025-10-04 09:18:28',1,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1356,237,'cardiovascular',73.50659345894678,'low',NULL,'2025-10-04 09:18:55',0.000006945215058618004,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1357,237,'diabetes',2,'low',NULL,'2025-10-04 09:18:55',1,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1358,237,'kidney_disease',2,'low',NULL,'2025-10-04 09:18:55',10,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1359,237,'cancer_risk',2,'low',NULL,'2025-10-04 09:18:56',2,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1360,237,'cognitive_decline',0,'low',NULL,'2025-10-04 09:18:56',1,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1361,237,'metabolic_syndrome',0,'low',NULL,'2025-10-04 09:18:56',5,'ATP III Criteria (0/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1362,237,'stroke_risk',-1,'low',NULL,'2025-10-04 09:18:56',1,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1363,238,'cardiovascular',73.50659345894678,'low',NULL,'2025-10-04 09:18:59',0.000006945215058618004,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1364,238,'diabetes',2,'low',NULL,'2025-10-04 09:18:59',1,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1365,238,'kidney_disease',2,'low',NULL,'2025-10-04 09:19:00',10,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1366,238,'cancer_risk',2,'low',NULL,'2025-10-04 09:19:00',2,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1367,238,'cognitive_decline',0,'low',NULL,'2025-10-04 09:19:00',1,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1368,238,'metabolic_syndrome',0,'low',NULL,'2025-10-04 09:19:00',5,'ATP III Criteria (0/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1369,238,'stroke_risk',-1,'low',NULL,'2025-10-04 09:19:01',1,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1370,239,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-10-04 09:19:35',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1371,239,'diabetes',18,'very_high',NULL,'2025-10-04 09:19:35',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1372,239,'kidney_disease',3,'low',NULL,'2025-10-04 09:19:35',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1373,239,'cancer_risk',7,'moderate',NULL,'2025-10-04 09:19:36',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1374,239,'cognitive_decline',8,'moderate',NULL,'2025-10-04 09:19:36',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1375,239,'metabolic_syndrome',14,'very_high',NULL,'2025-10-04 09:19:36',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1376,239,'stroke_risk',8,'moderate',NULL,'2025-10-04 09:19:36',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1377,240,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-10-26 06:59:04',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1378,240,'diabetes',18,'very_high',NULL,'2025-10-26 06:59:04',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1379,240,'kidney_disease',3,'low',NULL,'2025-10-26 06:59:04',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1380,240,'cancer_risk',7,'moderate',NULL,'2025-10-26 06:59:05',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1381,240,'cognitive_decline',8,'moderate',NULL,'2025-10-26 06:59:05',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1382,240,'metabolic_syndrome',14,'very_high',NULL,'2025-10-26 06:59:05',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1383,240,'stroke_risk',8,'moderate',NULL,'2025-10-26 06:59:06',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1384,241,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-10-26 06:59:13',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1385,241,'diabetes',18,'very_high',NULL,'2025-10-26 06:59:13',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1386,241,'kidney_disease',3,'low',NULL,'2025-10-26 06:59:13',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1387,242,'cardiovascular',76.02729514715377,'low',NULL,'2025-11-10 22:33:54',0.00008637983290871176,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1388,242,'diabetes',4,'low',NULL,'2025-11-10 22:33:55',1,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1389,242,'kidney_disease',2,'low',NULL,'2025-11-10 22:33:55',10,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1390,242,'cancer_risk',2,'low',NULL,'2025-11-10 22:33:55',2,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1391,242,'cognitive_decline',0,'low',NULL,'2025-11-10 22:33:55',1,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1392,242,'metabolic_syndrome',1,'low',NULL,'2025-11-10 22:33:56',5,'ATP III Criteria (0/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1393,242,'stroke_risk',-1,'low',NULL,'2025-11-10 22:33:56',1,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1394,243,'cardiovascular',76.02729514715377,'low',NULL,'2025-11-10 22:33:59',0.00008637983290871176,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1395,243,'diabetes',4,'low',NULL,'2025-11-10 22:33:59',1,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1396,243,'kidney_disease',2,'low',NULL,'2025-11-10 22:33:59',10,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1397,243,'cancer_risk',2,'low',NULL,'2025-11-10 22:33:59',2,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1398,243,'cognitive_decline',0,'low',NULL,'2025-11-10 22:34:00',1,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1399,243,'metabolic_syndrome',1,'low',NULL,'2025-11-10 22:34:00',5,'ATP III Criteria (0/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1400,243,'stroke_risk',-1,'low',NULL,'2025-11-10 22:34:00',1,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1401,245,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-11-10 22:40:16',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1402,245,'diabetes',18,'very_high',NULL,'2025-11-10 22:40:16',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1403,245,'kidney_disease',3,'low',NULL,'2025-11-10 22:40:16',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1404,245,'cancer_risk',7,'moderate',NULL,'2025-11-10 22:40:16',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1405,245,'cognitive_decline',8,'moderate',NULL,'2025-11-10 22:40:17',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1406,245,'metabolic_syndrome',14,'very_high',NULL,'2025-11-10 22:40:17',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1407,245,'stroke_risk',8,'moderate',NULL,'2025-11-10 22:40:17',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1408,247,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-11-10 23:11:21',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1409,247,'diabetes',18,'very_high',NULL,'2025-11-10 23:11:22',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1410,247,'kidney_disease',3,'low',NULL,'2025-11-10 23:11:22',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1411,247,'cancer_risk',7,'moderate',NULL,'2025-11-10 23:11:22',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1412,247,'cognitive_decline',8,'moderate',NULL,'2025-11-10 23:11:23',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1413,247,'metabolic_syndrome',14,'very_high',NULL,'2025-11-10 23:11:23',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1414,247,'stroke_risk',8,'moderate',NULL,'2025-11-10 23:11:23',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1415,248,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-11-10 23:11:24',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1416,248,'diabetes',18,'very_high',NULL,'2025-11-10 23:11:24',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1417,248,'kidney_disease',3,'low',NULL,'2025-11-10 23:11:24',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1418,248,'cancer_risk',7,'moderate',NULL,'2025-11-10 23:11:25',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1419,248,'cognitive_decline',8,'moderate',NULL,'2025-11-10 23:11:26',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1420,248,'metabolic_syndrome',14,'very_high',NULL,'2025-11-10 23:11:26',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1421,248,'stroke_risk',8,'moderate',NULL,'2025-11-10 23:11:27',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1422,249,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-11-10 23:11:30',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1423,249,'diabetes',18,'very_high',NULL,'2025-11-10 23:11:30',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1424,249,'kidney_disease',3,'low',NULL,'2025-11-10 23:11:30',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1425,250,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-11-24 04:01:16',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1426,250,'diabetes',18,'very_high',NULL,'2025-11-24 04:01:16',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1427,250,'kidney_disease',3,'low',NULL,'2025-11-24 04:01:17',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1428,250,'cancer_risk',7,'moderate',NULL,'2025-11-24 04:01:17',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1429,250,'cognitive_decline',8,'moderate',NULL,'2025-11-24 04:01:17',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1430,250,'metabolic_syndrome',14,'very_high',NULL,'2025-11-24 04:01:17',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1431,250,'stroke_risk',8,'moderate',NULL,'2025-11-24 04:01:18',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1432,251,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-11-24 04:01:28',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1433,251,'diabetes',18,'very_high',NULL,'2025-11-24 04:01:28',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1434,251,'kidney_disease',3,'low',NULL,'2025-11-24 04:01:29',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1435,251,'cancer_risk',7,'moderate',NULL,'2025-11-24 04:01:29',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1436,251,'cognitive_decline',8,'moderate',NULL,'2025-11-24 04:01:29',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1437,251,'metabolic_syndrome',14,'very_high',NULL,'2025-11-24 04:01:30',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1438,251,'stroke_risk',8,'moderate',NULL,'2025-11-24 04:01:30',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1439,252,'cardiovascular',76.02729514715377,'low',NULL,'2025-11-24 04:02:06',0.00008637983290871176,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1440,252,'diabetes',4,'low',NULL,'2025-11-24 04:02:07',1,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1441,252,'kidney_disease',2,'low',NULL,'2025-11-24 04:02:08',10,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1442,252,'cancer_risk',2,'low',NULL,'2025-11-24 04:02:08',2,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1443,252,'cognitive_decline',0,'low',NULL,'2025-11-24 04:02:08',1,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1444,252,'metabolic_syndrome',1,'low',NULL,'2025-11-24 04:02:08',5,'ATP III Criteria (0/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1445,252,'stroke_risk',-1,'low',NULL,'2025-11-24 04:02:09',1,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1446,253,'cardiovascular',76.02729514715377,'low',NULL,'2025-11-24 04:02:15',0.00008637983290871176,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1447,253,'diabetes',4,'low',NULL,'2025-11-24 04:02:15',1,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1448,254,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-11-24 04:04:12',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1449,254,'diabetes',18,'very_high',NULL,'2025-11-24 04:04:13',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1450,254,'kidney_disease',3,'low',NULL,'2025-11-24 04:04:13',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1451,254,'cancer_risk',7,'moderate',NULL,'2025-11-24 04:04:13',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1452,254,'cognitive_decline',8,'moderate',NULL,'2025-11-24 04:04:13',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1453,255,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-11-24 04:04:14',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1454,254,'metabolic_syndrome',14,'very_high',NULL,'2025-11-24 04:04:14',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1455,255,'diabetes',18,'very_high',NULL,'2025-11-24 04:04:14',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1456,255,'kidney_disease',3,'low',NULL,'2025-11-24 04:04:14',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1457,254,'stroke_risk',8,'moderate',NULL,'2025-11-24 04:04:14',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1458,255,'cancer_risk',7,'moderate',NULL,'2025-11-24 04:04:14',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1459,255,'cognitive_decline',8,'moderate',NULL,'2025-11-24 04:04:15',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1460,255,'metabolic_syndrome',14,'very_high',NULL,'2025-11-24 04:04:15',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1461,255,'stroke_risk',8,'moderate',NULL,'2025-11-24 04:04:15',7,'Modified Framingham Stroke Risk Profile');
INSERT INTO "risk_calculations" VALUES(1462,256,'cardiovascular',94.99271553865229,'very_high',NULL,'2025-11-24 04:04:18',100,'ASCVD Risk Estimator Plus (AHA/ACC 2018)');
INSERT INTO "risk_calculations" VALUES(1463,256,'diabetes',18,'very_high',NULL,'2025-11-24 04:04:19',33,'FINDRISC (Finnish Diabetes Risk Score)');
INSERT INTO "risk_calculations" VALUES(1464,256,'kidney_disease',3,'low',NULL,'2025-11-24 04:04:19',15,'KDIGO CKD Risk Classification');
INSERT INTO "risk_calculations" VALUES(1465,256,'cancer_risk',7,'moderate',NULL,'2025-11-24 04:04:19',8,'Comprehensive Cancer Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1466,256,'cognitive_decline',8,'moderate',NULL,'2025-11-24 04:04:19',3,'Comprehensive Cognitive Risk Assessment');
INSERT INTO "risk_calculations" VALUES(1467,256,'metabolic_syndrome',14,'very_high',NULL,'2025-11-24 04:04:20',88,'ATP III Criteria (4/5 criteria met)');
INSERT INTO "risk_calculations" VALUES(1468,256,'stroke_risk',8,'moderate',NULL,'2025-11-24 04:04:20',7,'Modified Framingham Stroke Risk Profile');
CREATE TABLE assessment_data (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  data_type TEXT NOT NULL,
  json_data TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE
);
INSERT INTO "assessment_data" VALUES(1,250,'comprehensive_lifestyle','{"fullName":"Robert Martinez","dateOfBirth":"1968-03-22","gender":"male","occupation":"Executive","country":"US","phq9_q1":"2","phq9_q2":"2","phq9_q3":"3","phq9_q4":"3","phq9_q5":"1","phq9_q6":"2","phq9_q7":"2","phq9_q8":"1","phq9_q9":"0","gad7_q1":"3","gad7_q2":"3","gad7_q3":"3","gad7_q4":"2","gad7_q5":"2","gad7_q6":"2","gad7_q7":"1","memory_recall":"2","memory_learning":"2","attention_focus":"2","attention_multitask":"1","processing_speed":"2","processing_decisions":"2","executive_planning":"3","executive_problem_solving":"2","stress_management":"1","emotional_regulation":"2","resilience_bounce_back":"2","adaptability":"2","coping_strategies":"1","social_support_quality":"2","social_network_size":"2","mental_stimulation":"3","creative_activities":"1","exercise_mental_health":"1","assimilation_q1":"often","assimilation_q2":"no","assimilation_q3":"poor","assimilation_q4":"yes","assimilation_q5":"often","assimilation_q6":"questionable","exerciseFrequency":"rarely","exerciseTypes":["none"],"sleepHours":"5-6","sleepQuality":"poor","stressLevel":"high","smokingStatus":"former","alcoholConsumption":"heavy","takingMedications":"yes","currentMedications":"Lisinopril 10mg, Metformin 500mg, Atorvastatin 20mg","takingSupplements":"no","familyHistory":["family_heart_disease","family_diabetes"],"familyHistoryDetails":"Multiple family members with heart disease and diabetes","antecedentsDescription":["Strong family history of cardiovascular disease, diabetes, and hypertension creating genetic predisposition","Chronic work-related stress over 15+ years in high-pressure corporate environment","Sedentary lifestyle during 20s and 30s with minimal regular exercise","Poor sleep hygiene patterns established in early career leading to chronic sleep debt","Standard American Diet (SAD) consumption during formative adult years"],"antecedentsDate":["birth","01/05","06/88","01/00","09/86"],"antecedentsSeverity":["High","Moderate-High","Moderate","Moderate","Moderate"],"triggersDescription":["Major work promotion with increased responsibility and 60+ hour work weeks","Death of parent causing significant emotional stress and grief","COVID-19 pandemic disrupting exercise routines and increasing sedentary behavior"],"triggersDate":["01/18","03/20","03/20"],"triggersImpact":["High - initiated chronic stress response and poor work-life balance","High - triggered emotional eating and disrupted sleep patterns","Moderate-High - eliminated gym routine and increased home-based sedentary time"],"mediatorsDescription":["Chronic stress with elevated cortisol patterns affecting multiple systems","Suboptimal sleep quality (5-6 hours/night) preventing adequate recovery","Irregular meal timing and frequent business meals high in processed foods","Limited social support system due to work demands and geographic isolation","Minimal mind-body stress management practices or relaxation techniques"],"mediatorsDate":["01/18","01/15","01/17","01/19","birth"],"mediatorsFrequency":["Daily","Nightly","5-6 days per week","Ongoing","Continuous"],"geneticPredispositions":"Strong familial clustering of metabolic syndrome components including cardiovascular disease, type 2 diabetes, and essential hypertension suggesting polygenic predisposition to cardiometabolic dysfunction","earlyStress":"moderate","symptomOnset":"Gradual onset of fatigue, digestive discomfort, and mood variability beginning around age 35-37, coinciding with increased work stress and lifestyle changes. Initial subtle symptoms progressed to more noticeable functional medicine system dysfunction over 5-7 year period.","height":"178","weight":"95","systolicBP":"145","diastolicBP":"92","glucose":"118","hba1c":"6.2","totalCholesterol":"245","hdlCholesterol":"38","ldlCholesterol":"155","triglycerides":"185","creatinine":"1.3","egfr":"68","albumin":"3.8","albuminCreatinineRatio":"25","cReactiveProtein":"4.2","whiteBoodCells":"9.5","hemoglobin":"13.8","vitaminD":"22","vitaminB12":"280","folate":"8.5","ferritin":"280","tsh":"3.8","t3Free":"2.8","t4Free":"1.1","apoA1":"115","apoB":"135","lipoproteinA":"45","homocysteine":"14.2","insulin":"18.5","cortisol":"24.8","dheas":"155","testosterone":"320","magnesium":"1.8","zinc":"75","selenium":"95","alt":"42","ast":"38","alkalinePhosphatase":"95","bilirubin":"1.2"}','2025-11-24 04:01:24');
INSERT INTO "assessment_data" VALUES(2,251,'comprehensive_lifestyle','{"fullName":"Robert Martinez","dateOfBirth":"1968-03-22","gender":"male","occupation":"Executive","country":"US","phq9_q1":"2","phq9_q2":"2","phq9_q3":"3","phq9_q4":"3","phq9_q5":"1","phq9_q6":"2","phq9_q7":"2","phq9_q8":"1","phq9_q9":"0","gad7_q1":"3","gad7_q2":"3","gad7_q3":"3","gad7_q4":"2","gad7_q5":"2","gad7_q6":"2","gad7_q7":"1","memory_recall":"2","memory_learning":"2","attention_focus":"2","attention_multitask":"1","processing_speed":"2","processing_decisions":"2","executive_planning":"3","executive_problem_solving":"2","stress_management":"1","emotional_regulation":"2","resilience_bounce_back":"2","adaptability":"2","coping_strategies":"1","social_support_quality":"2","social_network_size":"2","mental_stimulation":"3","creative_activities":"1","exercise_mental_health":"1","assimilation_q1":"often","assimilation_q2":"no","assimilation_q3":"poor","assimilation_q4":"yes","assimilation_q5":"often","assimilation_q6":"questionable","exerciseFrequency":"rarely","exerciseTypes":["none"],"sleepHours":"5-6","sleepQuality":"poor","stressLevel":"high","smokingStatus":"former","alcoholConsumption":"heavy","takingMedications":"yes","currentMedications":"Lisinopril 10mg, Metformin 500mg, Atorvastatin 20mg","takingSupplements":"no","familyHistory":["family_heart_disease","family_diabetes"],"familyHistoryDetails":"Multiple family members with heart disease and diabetes","antecedentsDescription":["Strong family history of cardiovascular disease, diabetes, and hypertension creating genetic predisposition","Chronic work-related stress over 15+ years in high-pressure corporate environment","Sedentary lifestyle during 20s and 30s with minimal regular exercise","Poor sleep hygiene patterns established in early career leading to chronic sleep debt","Standard American Diet (SAD) consumption during formative adult years"],"antecedentsDate":["birth","01/05","06/88","01/00","09/86"],"antecedentsSeverity":["High","Moderate-High","Moderate","Moderate","Moderate"],"triggersDescription":["Major work promotion with increased responsibility and 60+ hour work weeks","Death of parent causing significant emotional stress and grief","COVID-19 pandemic disrupting exercise routines and increasing sedentary behavior"],"triggersDate":["01/18","03/20","03/20"],"triggersImpact":["High - initiated chronic stress response and poor work-life balance","High - triggered emotional eating and disrupted sleep patterns","Moderate-High - eliminated gym routine and increased home-based sedentary time"],"mediatorsDescription":["Chronic stress with elevated cortisol patterns affecting multiple systems","Suboptimal sleep quality (5-6 hours/night) preventing adequate recovery","Irregular meal timing and frequent business meals high in processed foods","Limited social support system due to work demands and geographic isolation","Minimal mind-body stress management practices or relaxation techniques"],"mediatorsDate":["01/18","01/15","01/17","01/19","birth"],"mediatorsFrequency":["Daily","Nightly","5-6 days per week","Ongoing","Continuous"],"geneticPredispositions":"Strong familial clustering of metabolic syndrome components including cardiovascular disease, type 2 diabetes, and essential hypertension suggesting polygenic predisposition to cardiometabolic dysfunction","earlyStress":"moderate","symptomOnset":"Gradual onset of fatigue, digestive discomfort, and mood variability beginning around age 35-37, coinciding with increased work stress and lifestyle changes. Initial subtle symptoms progressed to more noticeable functional medicine system dysfunction over 5-7 year period.","height":"178","weight":"95","systolicBP":"145","diastolicBP":"92","glucose":"118","hba1c":"6.2","totalCholesterol":"245","hdlCholesterol":"38","ldlCholesterol":"155","triglycerides":"185","creatinine":"1.3","egfr":"68","albumin":"3.8","albuminCreatinineRatio":"25","cReactiveProtein":"4.2","whiteBoodCells":"9.5","hemoglobin":"13.8","vitaminD":"22","vitaminB12":"280","folate":"8.5","ferritin":"280","tsh":"3.8","t3Free":"2.8","t4Free":"1.1","apoA1":"115","apoB":"135","lipoproteinA":"45","homocysteine":"14.2","insulin":"18.5","cortisol":"24.8","dheas":"155","testosterone":"320","magnesium":"1.8","zinc":"75","selenium":"95","alt":"42","ast":"38","alkalinePhosphatase":"95","bilirubin":"1.2"}','2025-11-24 04:01:36');
INSERT INTO "assessment_data" VALUES(3,252,'comprehensive_lifestyle','{"fullName":"Sarah Johnson","dateOfBirth":"1978-05-15","gender":"female","occupation":"Marketing Manager","country":"US","assimilation_q1":"rarely","assimilation_q2":"yes","assimilation_q3":"excellent","assimilation_q4":"no","assimilation_q5":"rarely","assimilation_q6":"yes","biotransformation_q1":"good","biotransformation_q2":"rarely","biotransformation_q3":"no","biotransformation_q4":"sometimes","biotransformation_q5":"yes","biotransformation_q6":"rarely","defense_q1":"rarely","defense_q2":"good","defense_q3":"no","defense_q4":"rarely","defense_q5":"good","defense_q6":"no","energy_q1":"good","energy_q2":"rarely","energy_q3":"good","energy_q4":"no","energy_q5":"good","energy_q6":"rarely","transport_q1":"no","transport_q2":"good","transport_q3":"rarely","transport_q4":"good","transport_q5":"no","transport_q6":"good","communication_q1":"good","communication_q2":"rarely","communication_q3":"no","communication_q4":"good","communication_q5":"rarely","communication_q6":"good","structural_q1":"rarely","structural_q2":"good","structural_q3":"no","structural_q4":"good","structural_q5":"rarely","structural_q6":"good","phq9_q1":"1","phq9_q2":"0","phq9_q3":"1","phq9_q4":"0","phq9_q5":"1","phq9_q6":"0","phq9_q7":"0","phq9_q8":"1","phq9_q9":"0","gad7_q1":"1","gad7_q2":"0","gad7_q3":"1","gad7_q4":"0","gad7_q5":"1","gad7_q6":"0","gad7_q7":"1","hasCurrentConditions":"no","exerciseFrequency":"daily","exerciseTypes":["cardio","strength"],"sleepHours":"7-8","sleepQuality":"excellent","stressLevel":"low","smokingStatus":"never","alcoholConsumption":"moderate","takingMedications":"no","takingSupplements":"yes","currentSupplements":"Vitamin D3, Omega-3, Magnesium","familyHistory":["family_heart_disease"],"familyHistoryDetails":"Father had heart attack at age 65","regularCycles":"yes","pregnancies":"2","liveBirths":"2"}','2025-11-24 04:02:15');
INSERT INTO "assessment_data" VALUES(4,254,'comprehensive_lifestyle','{"fullName":"Robert Martinez","dateOfBirth":"1968-03-22","gender":"male","occupation":"Executive","country":"US","phq9_q1":"2","phq9_q2":"2","phq9_q3":"3","phq9_q4":"3","phq9_q5":"1","phq9_q6":"2","phq9_q7":"2","phq9_q8":"1","phq9_q9":"0","gad7_q1":"3","gad7_q2":"3","gad7_q3":"3","gad7_q4":"2","gad7_q5":"2","gad7_q6":"2","gad7_q7":"1","memory_recall":"2","memory_learning":"2","attention_focus":"2","attention_multitask":"1","processing_speed":"2","processing_decisions":"2","executive_planning":"3","executive_problem_solving":"2","stress_management":"1","emotional_regulation":"2","resilience_bounce_back":"2","adaptability":"2","coping_strategies":"1","social_support_quality":"2","social_network_size":"2","mental_stimulation":"3","creative_activities":"1","exercise_mental_health":"1","assimilation_q1":"often","assimilation_q2":"no","assimilation_q3":"poor","assimilation_q4":"yes","assimilation_q5":"often","assimilation_q6":"questionable","exerciseFrequency":"rarely","exerciseTypes":["none"],"sleepHours":"5-6","sleepQuality":"poor","stressLevel":"high","smokingStatus":"former","alcoholConsumption":"heavy","takingMedications":"yes","currentMedications":"Lisinopril 10mg, Metformin 500mg, Atorvastatin 20mg","takingSupplements":"no","familyHistory":["family_heart_disease","family_diabetes"],"familyHistoryDetails":"Multiple family members with heart disease and diabetes","antecedentsDescription":["Strong family history of cardiovascular disease, diabetes, and hypertension creating genetic predisposition","Chronic work-related stress over 15+ years in high-pressure corporate environment","Sedentary lifestyle during 20s and 30s with minimal regular exercise","Poor sleep hygiene patterns established in early career leading to chronic sleep debt","Standard American Diet (SAD) consumption during formative adult years"],"antecedentsDate":["birth","01/05","06/88","01/00","09/86"],"antecedentsSeverity":["High","Moderate-High","Moderate","Moderate","Moderate"],"triggersDescription":["Major work promotion with increased responsibility and 60+ hour work weeks","Death of parent causing significant emotional stress and grief","COVID-19 pandemic disrupting exercise routines and increasing sedentary behavior"],"triggersDate":["01/18","03/20","03/20"],"triggersImpact":["High - initiated chronic stress response and poor work-life balance","High - triggered emotional eating and disrupted sleep patterns","Moderate-High - eliminated gym routine and increased home-based sedentary time"],"mediatorsDescription":["Chronic stress with elevated cortisol patterns affecting multiple systems","Suboptimal sleep quality (5-6 hours/night) preventing adequate recovery","Irregular meal timing and frequent business meals high in processed foods","Limited social support system due to work demands and geographic isolation","Minimal mind-body stress management practices or relaxation techniques"],"mediatorsDate":["01/18","01/15","01/17","01/19","birth"],"mediatorsFrequency":["Daily","Nightly","5-6 days per week","Ongoing","Continuous"],"geneticPredispositions":"Strong familial clustering of metabolic syndrome components including cardiovascular disease, type 2 diabetes, and essential hypertension suggesting polygenic predisposition to cardiometabolic dysfunction","earlyStress":"moderate","symptomOnset":"Gradual onset of fatigue, digestive discomfort, and mood variability beginning around age 35-37, coinciding with increased work stress and lifestyle changes. Initial subtle symptoms progressed to more noticeable functional medicine system dysfunction over 5-7 year period.","height":"178","weight":"95","systolicBP":"145","diastolicBP":"92","glucose":"118","hba1c":"6.2","totalCholesterol":"245","hdlCholesterol":"38","ldlCholesterol":"155","triglycerides":"185","creatinine":"1.3","egfr":"68","albumin":"3.8","albuminCreatinineRatio":"25","cReactiveProtein":"4.2","whiteBoodCells":"9.5","hemoglobin":"13.8","vitaminD":"22","vitaminB12":"280","folate":"8.5","ferritin":"280","tsh":"3.8","t3Free":"2.8","t4Free":"1.1","apoA1":"115","apoB":"135","lipoproteinA":"45","homocysteine":"14.2","insulin":"18.5","cortisol":"24.8","dheas":"155","testosterone":"320","magnesium":"1.8","zinc":"75","selenium":"95","alt":"42","ast":"38","alkalinePhosphatase":"95","bilirubin":"1.2"}','2025-11-24 04:04:21');
CREATE TABLE aging_assessments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  overall_aging_score REAL NOT NULL,
  biological_age_acceleration REAL NOT NULL,
  primary_concerns TEXT NOT NULL,
  confidence_level TEXT NOT NULL,
  calculation_date TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE
);
INSERT INTO "aging_assessments" VALUES(1,250,80.925,6.185000000000002,'["Telomere Attrition","Epigenetic Alterations","Loss of Proteostasis","Deregulated Nutrient Sensing","Cellular Senescence","Stem Cell Exhaustion","Altered Intercellular Communication","Chronic Inflammation","Dysbiosis","Altered Mechanical Properties"]','low','2025-11-24','2025-11-24 04:01:18');
INSERT INTO "aging_assessments" VALUES(2,251,80.925,6.185000000000002,'["Telomere Attrition","Epigenetic Alterations","Loss of Proteostasis","Deregulated Nutrient Sensing","Cellular Senescence","Stem Cell Exhaustion","Altered Intercellular Communication","Chronic Inflammation","Dysbiosis","Altered Mechanical Properties"]','low','2025-11-24','2025-11-24 04:01:30');
INSERT INTO "aging_assessments" VALUES(3,252,2.0833333333333335,-9.583333333333336,'[]','low','2025-11-24','2025-11-24 04:02:09');
INSERT INTO "aging_assessments" VALUES(4,254,80.925,6.185000000000002,'["Telomere Attrition","Epigenetic Alterations","Loss of Proteostasis","Deregulated Nutrient Sensing","Cellular Senescence","Stem Cell Exhaustion","Altered Intercellular Communication","Chronic Inflammation","Dysbiosis","Altered Mechanical Properties"]','low','2025-11-24','2025-11-24 04:04:15');
INSERT INTO "aging_assessments" VALUES(5,255,80.925,6.185000000000002,'["Telomere Attrition","Epigenetic Alterations","Loss of Proteostasis","Deregulated Nutrient Sensing","Cellular Senescence","Stem Cell Exhaustion","Altered Intercellular Communication","Chronic Inflammation","Dysbiosis","Altered Mechanical Properties"]','low','2025-11-24','2025-11-24 04:04:16');
INSERT INTO "aging_assessments" VALUES(6,256,80.925,6.185000000000002,'["Telomere Attrition","Epigenetic Alterations","Loss of Proteostasis","Deregulated Nutrient Sensing","Cellular Senescence","Stem Cell Exhaustion","Altered Intercellular Communication","Chronic Inflammation","Dysbiosis","Altered Mechanical Properties"]','low','2025-11-24','2025-11-24 04:04:20');
CREATE TABLE aging_hallmarks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  aging_assessment_id INTEGER NOT NULL,
  hallmark_name TEXT NOT NULL,
  impact_percentage REAL NOT NULL,
  confidence_level TEXT NOT NULL,
  markers_available TEXT NOT NULL,
  markers_missing TEXT NOT NULL,
  risk_level TEXT NOT NULL,
  description TEXT NOT NULL,
  algorithm_used TEXT NOT NULL,
  reference TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (aging_assessment_id) REFERENCES aging_assessments(id) ON DELETE CASCADE
);
INSERT INTO "aging_hallmarks" VALUES(1,1,'Genomic Instability',40,'high','["Smoking Status","Alcohol Consumption","Stress Level"]','["CRP","Homocysteine"]','moderate','Genomic instability score of 40% based on oxidative stress markers, inflammatory indicators, and lifestyle factors affecting DNA repair mechanisms.','Multi-biomarker oxidative stress and inflammation assessment','López-Otín et al. Cell 2013; Nature Reviews 2023','2025-11-24 04:01:18');
INSERT INTO "aging_hallmarks" VALUES(2,1,'Telomere Attrition',85,'medium','["Chronological Age","Physical Activity Level","Smoking Status","Chronic Stress Level","Sleep Quality","BMI"]','["Telomere Length Test"]','severe','Telomere attrition risk of 85% estimated from age-adjusted lifestyle factors known to influence telomere length.','Age-adjusted lifestyle telomere risk estimation','Blackburn et al. Nature 2015; Verhulst et al. Ageing Research Reviews 2016','2025-11-24 04:01:19');
INSERT INTO "aging_hallmarks" VALUES(3,1,'Epigenetic Alterations',81.5,'medium','["Chronological Age","HbA1c","Fasting Glucose","Diet Quality","Physical Activity","Smoking Status"]','["DNA Methylation Clock","Histone Modifications"]','severe','Epigenetic alteration risk of 81.5% based on metabolic markers and lifestyle factors that influence DNA methylation patterns.','Metabolic-lifestyle epigenetic risk assessment','Pal & Tyler JCI Insight 2016; Xia et al. Genome Medicine 2021','2025-11-24 04:01:19');
INSERT INTO "aging_hallmarks" VALUES(4,1,'Loss of Proteostasis',68,'medium','["Age","Glucose","Albumin","Exercise","Stress Level"]','["Heat Shock Proteins","Autophagy Markers","Protein Aggregates"]','high','Proteostasis impairment risk of 68% based on age-related protein quality decline and metabolic stress indicators.','Age-adjusted protein stress and inflammatory assessment','Balch et al. Science 2008; Klaips et al. Cell 2018','2025-11-24 04:01:19');
INSERT INTO "aging_hallmarks" VALUES(5,1,'Deregulated Nutrient Sensing',98,'high','["Fasting Glucose","HbA1c","Triglycerides","BMI","Diet Quality","Physical Activity"]','["IGF-1","mTOR Activity","AMPK Activity","Insulin"]','severe','Nutrient sensing dysfunction of 98% based on glucose metabolism markers, insulin sensitivity, and lifestyle factors.','Comprehensive metabolic pathway assessment','Johnson et al. Cell Metabolism 2013; Fontana & Partridge Cell 2015','2025-11-24 04:01:19');
INSERT INTO "aging_hallmarks" VALUES(6,1,'Mitochondrial Dysfunction',58,'medium','["Age","Glucose","Creatinine","Exercise Level","Smoking Status","Diet Quality"]','["Lactate","CoQ10","Mitochondrial DNA","VO2 Max"]','moderate','Mitochondrial dysfunction risk of 58% based on age-related decline, metabolic markers, and lifestyle factors affecting cellular energy production.','Age-adjusted mitochondrial health assessment','Picard et al. Cell Metabolism 2018; Kauppila et al. Cell Metabolism 2017','2025-11-24 04:01:20');
INSERT INTO "aging_hallmarks" VALUES(7,1,'Cellular Senescence',66,'medium','["Chronological Age","Glucose","Physical Activity","Smoking Status","Chronic Stress"]','["p16","p21","SASP Markers","Senescent Cell Count","IL-6"]','high','Cellular senescence burden of 66% estimated from age-related accumulation and inflammatory markers indicating senescent cell activity.','Age-adjusted senescence and inflammatory assessment','Campisi & d''Adda di Fagagna Nature Reviews 2007; Tchkonia et al. Aging Cell 2013','2025-11-24 04:01:20');
INSERT INTO "aging_hallmarks" VALUES(8,1,'Stem Cell Exhaustion',85,'medium','["Age","Hemoglobin","White Blood Cells","Albumin","Exercise","Diet Quality"]','["Stem Cell Markers","Regenerative Capacity","Growth Factors","Vitamin D"]','severe','Stem cell exhaustion risk of 85% based on age-related decline, hematopoietic markers, and factors affecting regenerative capacity.','Age-adjusted regenerative capacity assessment','Rossi et al. Cell 2008; Ermolaeva et al. Nature 2018','2025-11-24 04:01:20');
INSERT INTO "aging_hallmarks" VALUES(9,1,'Altered Intercellular Communication',90,'medium','["Age","Glucose","Cholesterol Ratio","Social Connections","Stress Level","Physical Activity"]','["Cytokine Panel","Neurohormones","Cell Adhesion Molecules","IL-6","TSH"]','severe','Intercellular communication disruption of 90% based on inflammatory markers, hormonal balance, and factors affecting cellular signaling.','Multi-system communication assessment','Franceschi & Campisi Nature Reviews 2014; Fulop et al. Frontiers Immunology 2018','2025-11-24 04:01:20');
INSERT INTO "aging_hallmarks" VALUES(10,1,'Chronic Inflammation',100,'medium','["Chronological Age","C-Reactive Protein","White Blood Cell Count","Smoking Status","Physical Activity","Chronic Stress Level","Fasting Glucose","BMI (Adipose Inflammation)","Sleep Quality"]','["IL-6","TNF-α","IL-1β","NLRP3"]','severe','Chronic inflammation (inflammaging) score of 100% based on inflammatory markers, lifestyle factors, and age-related immune system changes.','Multi-biomarker inflammaging assessment','Franceschi et al. Nature Reviews Immunology 2018; Ferrucci & Fabbri Nature Reviews Cardiology 2018','2025-11-24 04:01:21');
INSERT INTO "aging_hallmarks" VALUES(11,1,'Dysbiosis',99.6,'low','["Chronological Age","Diet Quality","High Stress (Dysbiosis Risk)","Physical Activity","Sleep Quality","Systemic Inflammation","Glucose Metabolism","Smoking Status","Alcohol Consumption"]','["Microbiome Analysis","SCFA Levels","Zonulin","Calprotectin","Akkermansia","Bifidobacterium"]','severe','Gut microbiome dysbiosis risk of 99.6% estimated from lifestyle factors and indirect biomarkers affecting microbial diversity and gut barrier function.','Lifestyle-based dysbiosis risk assessment','O''Toole & Jeffery Nature Reviews Gastroenterology 2015; Ghosh et al. Nature Reviews Gastroenterology 2020','2025-11-24 04:01:21');
INSERT INTO "aging_hallmarks" VALUES(12,1,'Altered Mechanical Properties',100,'medium','["Chronological Age","Blood Pressure (Arterial Stiffness)","Physical Activity Level","Smoking Status (Collagen Impact)","Gender (Hormonal Effects)","BMI (Mechanical Load)","Albumin (Protein Synthesis)","Chronic Stress Level","Sleep Quality (Tissue Repair)"]','["Skin Elasticity","Arterial Stiffness (PWV)","Bone Density","Muscle Fiber Composition","Collagen Crosslinking","ECM Remodeling","Vitamin D"]','severe','Mechanical aging score of 100% based on factors affecting tissue elasticity, arterial stiffness, bone density, and extracellular matrix remodeling.','Multi-system mechanical aging assessment','López-Otín et al. Cell 2023; Phillip et al. Nature Reviews Materials 2021','2025-11-24 04:01:21');
INSERT INTO "aging_hallmarks" VALUES(13,2,'Genomic Instability',40,'high','["Smoking Status","Alcohol Consumption","Stress Level"]','["CRP","Homocysteine"]','moderate','Genomic instability score of 40% based on oxidative stress markers, inflammatory indicators, and lifestyle factors affecting DNA repair mechanisms.','Multi-biomarker oxidative stress and inflammation assessment','López-Otín et al. Cell 2013; Nature Reviews 2023','2025-11-24 04:01:31');
INSERT INTO "aging_hallmarks" VALUES(14,2,'Telomere Attrition',85,'medium','["Chronological Age","Physical Activity Level","Smoking Status","Chronic Stress Level","Sleep Quality","BMI"]','["Telomere Length Test"]','severe','Telomere attrition risk of 85% estimated from age-adjusted lifestyle factors known to influence telomere length.','Age-adjusted lifestyle telomere risk estimation','Blackburn et al. Nature 2015; Verhulst et al. Ageing Research Reviews 2016','2025-11-24 04:01:31');
INSERT INTO "aging_hallmarks" VALUES(15,2,'Epigenetic Alterations',81.5,'medium','["Chronological Age","HbA1c","Fasting Glucose","Diet Quality","Physical Activity","Smoking Status"]','["DNA Methylation Clock","Histone Modifications"]','severe','Epigenetic alteration risk of 81.5% based on metabolic markers and lifestyle factors that influence DNA methylation patterns.','Metabolic-lifestyle epigenetic risk assessment','Pal & Tyler JCI Insight 2016; Xia et al. Genome Medicine 2021','2025-11-24 04:01:31');
INSERT INTO "aging_hallmarks" VALUES(16,2,'Loss of Proteostasis',68,'medium','["Age","Glucose","Albumin","Exercise","Stress Level"]','["Heat Shock Proteins","Autophagy Markers","Protein Aggregates"]','high','Proteostasis impairment risk of 68% based on age-related protein quality decline and metabolic stress indicators.','Age-adjusted protein stress and inflammatory assessment','Balch et al. Science 2008; Klaips et al. Cell 2018','2025-11-24 04:01:31');
INSERT INTO "aging_hallmarks" VALUES(17,2,'Deregulated Nutrient Sensing',98,'high','["Fasting Glucose","HbA1c","Triglycerides","BMI","Diet Quality","Physical Activity"]','["IGF-1","mTOR Activity","AMPK Activity","Insulin"]','severe','Nutrient sensing dysfunction of 98% based on glucose metabolism markers, insulin sensitivity, and lifestyle factors.','Comprehensive metabolic pathway assessment','Johnson et al. Cell Metabolism 2013; Fontana & Partridge Cell 2015','2025-11-24 04:01:32');
INSERT INTO "aging_hallmarks" VALUES(18,2,'Mitochondrial Dysfunction',58,'medium','["Age","Glucose","Creatinine","Exercise Level","Smoking Status","Diet Quality"]','["Lactate","CoQ10","Mitochondrial DNA","VO2 Max"]','moderate','Mitochondrial dysfunction risk of 58% based on age-related decline, metabolic markers, and lifestyle factors affecting cellular energy production.','Age-adjusted mitochondrial health assessment','Picard et al. Cell Metabolism 2018; Kauppila et al. Cell Metabolism 2017','2025-11-24 04:01:32');
INSERT INTO "aging_hallmarks" VALUES(19,2,'Cellular Senescence',66,'medium','["Chronological Age","Glucose","Physical Activity","Smoking Status","Chronic Stress"]','["p16","p21","SASP Markers","Senescent Cell Count","IL-6"]','high','Cellular senescence burden of 66% estimated from age-related accumulation and inflammatory markers indicating senescent cell activity.','Age-adjusted senescence and inflammatory assessment','Campisi & d''Adda di Fagagna Nature Reviews 2007; Tchkonia et al. Aging Cell 2013','2025-11-24 04:01:32');
INSERT INTO "aging_hallmarks" VALUES(20,2,'Stem Cell Exhaustion',85,'medium','["Age","Hemoglobin","White Blood Cells","Albumin","Exercise","Diet Quality"]','["Stem Cell Markers","Regenerative Capacity","Growth Factors","Vitamin D"]','severe','Stem cell exhaustion risk of 85% based on age-related decline, hematopoietic markers, and factors affecting regenerative capacity.','Age-adjusted regenerative capacity assessment','Rossi et al. Cell 2008; Ermolaeva et al. Nature 2018','2025-11-24 04:01:32');
INSERT INTO "aging_hallmarks" VALUES(21,2,'Altered Intercellular Communication',90,'medium','["Age","Glucose","Cholesterol Ratio","Social Connections","Stress Level","Physical Activity"]','["Cytokine Panel","Neurohormones","Cell Adhesion Molecules","IL-6","TSH"]','severe','Intercellular communication disruption of 90% based on inflammatory markers, hormonal balance, and factors affecting cellular signaling.','Multi-system communication assessment','Franceschi & Campisi Nature Reviews 2014; Fulop et al. Frontiers Immunology 2018','2025-11-24 04:01:33');
INSERT INTO "aging_hallmarks" VALUES(22,2,'Chronic Inflammation',100,'medium','["Chronological Age","C-Reactive Protein","White Blood Cell Count","Smoking Status","Physical Activity","Chronic Stress Level","Fasting Glucose","BMI (Adipose Inflammation)","Sleep Quality"]','["IL-6","TNF-α","IL-1β","NLRP3"]','severe','Chronic inflammation (inflammaging) score of 100% based on inflammatory markers, lifestyle factors, and age-related immune system changes.','Multi-biomarker inflammaging assessment','Franceschi et al. Nature Reviews Immunology 2018; Ferrucci & Fabbri Nature Reviews Cardiology 2018','2025-11-24 04:01:33');
INSERT INTO "aging_hallmarks" VALUES(23,2,'Dysbiosis',99.6,'low','["Chronological Age","Diet Quality","High Stress (Dysbiosis Risk)","Physical Activity","Sleep Quality","Systemic Inflammation","Glucose Metabolism","Smoking Status","Alcohol Consumption"]','["Microbiome Analysis","SCFA Levels","Zonulin","Calprotectin","Akkermansia","Bifidobacterium"]','severe','Gut microbiome dysbiosis risk of 99.6% estimated from lifestyle factors and indirect biomarkers affecting microbial diversity and gut barrier function.','Lifestyle-based dysbiosis risk assessment','O''Toole & Jeffery Nature Reviews Gastroenterology 2015; Ghosh et al. Nature Reviews Gastroenterology 2020','2025-11-24 04:01:33');
INSERT INTO "aging_hallmarks" VALUES(24,2,'Altered Mechanical Properties',100,'medium','["Chronological Age","Blood Pressure (Arterial Stiffness)","Physical Activity Level","Smoking Status (Collagen Impact)","Gender (Hormonal Effects)","BMI (Mechanical Load)","Albumin (Protein Synthesis)","Chronic Stress Level","Sleep Quality (Tissue Repair)"]','["Skin Elasticity","Arterial Stiffness (PWV)","Bone Density","Muscle Fiber Composition","Collagen Crosslinking","ECM Remodeling","Vitamin D"]','severe','Mechanical aging score of 100% based on factors affecting tissue elasticity, arterial stiffness, bone density, and extracellular matrix remodeling.','Multi-system mechanical aging assessment','López-Otín et al. Cell 2023; Phillip et al. Nature Reviews Materials 2021','2025-11-24 04:01:34');
INSERT INTO "aging_hallmarks" VALUES(25,3,'Genomic Instability',5,'high','["Smoking Status","Alcohol Consumption","Stress Level"]','["CRP","Homocysteine"]','optimal','Genomic instability score of 5% based on oxidative stress markers, inflammatory indicators, and lifestyle factors affecting DNA repair mechanisms.','Multi-biomarker oxidative stress and inflammation assessment','López-Otín et al. Cell 2013; Nature Reviews 2023','2025-11-24 04:02:09');
INSERT INTO "aging_hallmarks" VALUES(26,3,'Telomere Attrition',0,'medium','["Chronological Age","Physical Activity Level","Smoking Status","Chronic Stress Level","Sleep Quality","BMI"]','["Telomere Length Test"]','optimal','Telomere attrition risk of 0% estimated from age-adjusted lifestyle factors known to influence telomere length.','Age-adjusted lifestyle telomere risk estimation','Blackburn et al. Nature 2015; Verhulst et al. Ageing Research Reviews 2016','2025-11-24 04:02:10');
INSERT INTO "aging_hallmarks" VALUES(27,3,'Epigenetic Alterations',10.5,'medium','["Chronological Age","HbA1c","Fasting Glucose","Diet Quality","Physical Activity","Smoking Status"]','["DNA Methylation Clock","Histone Modifications"]','optimal','Epigenetic alteration risk of 10.5% based on metabolic markers and lifestyle factors that influence DNA methylation patterns.','Metabolic-lifestyle epigenetic risk assessment','Pal & Tyler JCI Insight 2016; Xia et al. Genome Medicine 2021','2025-11-24 04:02:10');
INSERT INTO "aging_hallmarks" VALUES(28,3,'Loss of Proteostasis',0,'medium','["Age","Glucose","Albumin","Exercise","Stress Level"]','["Heat Shock Proteins","Autophagy Markers","Protein Aggregates"]','optimal','Proteostasis impairment risk of 0% based on age-related protein quality decline and metabolic stress indicators.','Age-adjusted protein stress and inflammatory assessment','Balch et al. Science 2008; Klaips et al. Cell 2018','2025-11-24 04:02:10');
INSERT INTO "aging_hallmarks" VALUES(29,3,'Deregulated Nutrient Sensing',0,'high','["Fasting Glucose","HbA1c","Triglycerides","BMI","Diet Quality","Physical Activity"]','["IGF-1","mTOR Activity","AMPK Activity","Insulin"]','optimal','Nutrient sensing dysfunction of 0% based on glucose metabolism markers, insulin sensitivity, and lifestyle factors.','Comprehensive metabolic pathway assessment','Johnson et al. Cell Metabolism 2013; Fontana & Partridge Cell 2015','2025-11-24 04:02:10');
INSERT INTO "aging_hallmarks" VALUES(30,3,'Mitochondrial Dysfunction',0,'medium','["Age","Glucose","Creatinine","Exercise Level","Smoking Status","Diet Quality"]','["Lactate","CoQ10","Mitochondrial DNA","VO2 Max"]','optimal','Mitochondrial dysfunction risk of 0% based on age-related decline, metabolic markers, and lifestyle factors affecting cellular energy production.','Age-adjusted mitochondrial health assessment','Picard et al. Cell Metabolism 2018; Kauppila et al. Cell Metabolism 2017','2025-11-24 04:02:11');
INSERT INTO "aging_hallmarks" VALUES(31,3,'Cellular Senescence',0,'medium','["Chronological Age","Glucose","Physical Activity","Smoking Status","Chronic Stress"]','["p16","p21","SASP Markers","Senescent Cell Count","IL-6"]','optimal','Cellular senescence burden of 0% estimated from age-related accumulation and inflammatory markers indicating senescent cell activity.','Age-adjusted senescence and inflammatory assessment','Campisi & d''Adda di Fagagna Nature Reviews 2007; Tchkonia et al. Aging Cell 2013','2025-11-24 04:02:11');
INSERT INTO "aging_hallmarks" VALUES(32,3,'Stem Cell Exhaustion',7,'medium','["Age","Hemoglobin","White Blood Cells","Albumin","Exercise","Diet Quality"]','["Stem Cell Markers","Regenerative Capacity","Growth Factors","Vitamin D"]','optimal','Stem cell exhaustion risk of 7% based on age-related decline, hematopoietic markers, and factors affecting regenerative capacity.','Age-adjusted regenerative capacity assessment','Rossi et al. Cell 2008; Ermolaeva et al. Nature 2018','2025-11-24 04:02:11');
INSERT INTO "aging_hallmarks" VALUES(33,3,'Altered Intercellular Communication',0,'medium','["Age","Glucose","Cholesterol Ratio","Social Connections","Stress Level","Physical Activity"]','["Cytokine Panel","Neurohormones","Cell Adhesion Molecules","IL-6","TSH"]','optimal','Intercellular communication disruption of 0% based on inflammatory markers, hormonal balance, and factors affecting cellular signaling.','Multi-system communication assessment','Franceschi & Campisi Nature Reviews 2014; Fulop et al. Frontiers Immunology 2018','2025-11-24 04:02:11');
INSERT INTO "aging_hallmarks" VALUES(34,3,'Chronic Inflammation',0,'medium','["Chronological Age","C-Reactive Protein","White Blood Cell Count","Smoking Status","Physical Activity","Chronic Stress Level","Fasting Glucose","BMI (Adipose Inflammation)","Sleep Quality"]','["IL-6","TNF-α","IL-1β","NLRP3"]','optimal','Chronic inflammation (inflammaging) score of 0% based on inflammatory markers, lifestyle factors, and age-related immune system changes.','Multi-biomarker inflammaging assessment','Franceschi et al. Nature Reviews Immunology 2018; Ferrucci & Fabbri Nature Reviews Cardiology 2018','2025-11-24 04:02:12');
INSERT INTO "aging_hallmarks" VALUES(35,3,'Dysbiosis',0,'low','["Chronological Age","Diet Quality","Physical Activity","Sleep Quality","Systemic Inflammation","Glucose Metabolism","Smoking Status","Alcohol Consumption"]','["Microbiome Analysis","SCFA Levels","Zonulin","Calprotectin","Akkermansia","Bifidobacterium"]','optimal','Gut microbiome dysbiosis risk of 0% estimated from lifestyle factors and indirect biomarkers affecting microbial diversity and gut barrier function.','Lifestyle-based dysbiosis risk assessment','O''Toole & Jeffery Nature Reviews Gastroenterology 2015; Ghosh et al. Nature Reviews Gastroenterology 2020','2025-11-24 04:02:12');
INSERT INTO "aging_hallmarks" VALUES(36,3,'Altered Mechanical Properties',2.5,'medium','["Chronological Age","Blood Pressure (Arterial Stiffness)","Physical Activity Level","Smoking Status (Collagen Impact)","Gender (Hormonal Effects)","BMI (Mechanical Load)","Albumin (Protein Synthesis)","Chronic Stress Level","Sleep Quality (Tissue Repair)"]','["Skin Elasticity","Arterial Stiffness (PWV)","Bone Density","Muscle Fiber Composition","Collagen Crosslinking","ECM Remodeling","Vitamin D"]','optimal','Mechanical aging score of 2.5% based on factors affecting tissue elasticity, arterial stiffness, bone density, and extracellular matrix remodeling.','Multi-system mechanical aging assessment','López-Otín et al. Cell 2023; Phillip et al. Nature Reviews Materials 2021','2025-11-24 04:02:12');
INSERT INTO "aging_hallmarks" VALUES(37,4,'Genomic Instability',40,'high','["Smoking Status","Alcohol Consumption","Stress Level"]','["CRP","Homocysteine"]','moderate','Genomic instability score of 40% based on oxidative stress markers, inflammatory indicators, and lifestyle factors affecting DNA repair mechanisms.','Multi-biomarker oxidative stress and inflammation assessment','López-Otín et al. Cell 2013; Nature Reviews 2023','2025-11-24 04:04:15');
INSERT INTO "aging_hallmarks" VALUES(38,4,'Telomere Attrition',85,'medium','["Chronological Age","Physical Activity Level","Smoking Status","Chronic Stress Level","Sleep Quality","BMI"]','["Telomere Length Test"]','severe','Telomere attrition risk of 85% estimated from age-adjusted lifestyle factors known to influence telomere length.','Age-adjusted lifestyle telomere risk estimation','Blackburn et al. Nature 2015; Verhulst et al. Ageing Research Reviews 2016','2025-11-24 04:04:15');
INSERT INTO "aging_hallmarks" VALUES(39,4,'Epigenetic Alterations',81.5,'medium','["Chronological Age","HbA1c","Fasting Glucose","Diet Quality","Physical Activity","Smoking Status"]','["DNA Methylation Clock","Histone Modifications"]','severe','Epigenetic alteration risk of 81.5% based on metabolic markers and lifestyle factors that influence DNA methylation patterns.','Metabolic-lifestyle epigenetic risk assessment','Pal & Tyler JCI Insight 2016; Xia et al. Genome Medicine 2021','2025-11-24 04:04:15');
INSERT INTO "aging_hallmarks" VALUES(40,4,'Loss of Proteostasis',68,'medium','["Age","Glucose","Albumin","Exercise","Stress Level"]','["Heat Shock Proteins","Autophagy Markers","Protein Aggregates"]','high','Proteostasis impairment risk of 68% based on age-related protein quality decline and metabolic stress indicators.','Age-adjusted protein stress and inflammatory assessment','Balch et al. Science 2008; Klaips et al. Cell 2018','2025-11-24 04:04:16');
INSERT INTO "aging_hallmarks" VALUES(41,4,'Deregulated Nutrient Sensing',98,'high','["Fasting Glucose","HbA1c","Triglycerides","BMI","Diet Quality","Physical Activity"]','["IGF-1","mTOR Activity","AMPK Activity","Insulin"]','severe','Nutrient sensing dysfunction of 98% based on glucose metabolism markers, insulin sensitivity, and lifestyle factors.','Comprehensive metabolic pathway assessment','Johnson et al. Cell Metabolism 2013; Fontana & Partridge Cell 2015','2025-11-24 04:04:16');
INSERT INTO "aging_hallmarks" VALUES(42,5,'Genomic Instability',40,'high','["Smoking Status","Alcohol Consumption","Stress Level"]','["CRP","Homocysteine"]','moderate','Genomic instability score of 40% based on oxidative stress markers, inflammatory indicators, and lifestyle factors affecting DNA repair mechanisms.','Multi-biomarker oxidative stress and inflammation assessment','López-Otín et al. Cell 2013; Nature Reviews 2023','2025-11-24 04:04:16');
INSERT INTO "aging_hallmarks" VALUES(43,4,'Mitochondrial Dysfunction',58,'medium','["Age","Glucose","Creatinine","Exercise Level","Smoking Status","Diet Quality"]','["Lactate","CoQ10","Mitochondrial DNA","VO2 Max"]','moderate','Mitochondrial dysfunction risk of 58% based on age-related decline, metabolic markers, and lifestyle factors affecting cellular energy production.','Age-adjusted mitochondrial health assessment','Picard et al. Cell Metabolism 2018; Kauppila et al. Cell Metabolism 2017','2025-11-24 04:04:16');
INSERT INTO "aging_hallmarks" VALUES(44,5,'Telomere Attrition',85,'medium','["Chronological Age","Physical Activity Level","Smoking Status","Chronic Stress Level","Sleep Quality","BMI"]','["Telomere Length Test"]','severe','Telomere attrition risk of 85% estimated from age-adjusted lifestyle factors known to influence telomere length.','Age-adjusted lifestyle telomere risk estimation','Blackburn et al. Nature 2015; Verhulst et al. Ageing Research Reviews 2016','2025-11-24 04:04:16');
INSERT INTO "aging_hallmarks" VALUES(45,4,'Cellular Senescence',66,'medium','["Chronological Age","Glucose","Physical Activity","Smoking Status","Chronic Stress"]','["p16","p21","SASP Markers","Senescent Cell Count","IL-6"]','high','Cellular senescence burden of 66% estimated from age-related accumulation and inflammatory markers indicating senescent cell activity.','Age-adjusted senescence and inflammatory assessment','Campisi & d''Adda di Fagagna Nature Reviews 2007; Tchkonia et al. Aging Cell 2013','2025-11-24 04:04:16');
INSERT INTO "aging_hallmarks" VALUES(46,5,'Epigenetic Alterations',81.5,'medium','["Chronological Age","HbA1c","Fasting Glucose","Diet Quality","Physical Activity","Smoking Status"]','["DNA Methylation Clock","Histone Modifications"]','severe','Epigenetic alteration risk of 81.5% based on metabolic markers and lifestyle factors that influence DNA methylation patterns.','Metabolic-lifestyle epigenetic risk assessment','Pal & Tyler JCI Insight 2016; Xia et al. Genome Medicine 2021','2025-11-24 04:04:16');
INSERT INTO "aging_hallmarks" VALUES(47,4,'Stem Cell Exhaustion',85,'medium','["Age","Hemoglobin","White Blood Cells","Albumin","Exercise","Diet Quality"]','["Stem Cell Markers","Regenerative Capacity","Growth Factors","Vitamin D"]','severe','Stem cell exhaustion risk of 85% based on age-related decline, hematopoietic markers, and factors affecting regenerative capacity.','Age-adjusted regenerative capacity assessment','Rossi et al. Cell 2008; Ermolaeva et al. Nature 2018','2025-11-24 04:04:17');
INSERT INTO "aging_hallmarks" VALUES(48,5,'Loss of Proteostasis',68,'medium','["Age","Glucose","Albumin","Exercise","Stress Level"]','["Heat Shock Proteins","Autophagy Markers","Protein Aggregates"]','high','Proteostasis impairment risk of 68% based on age-related protein quality decline and metabolic stress indicators.','Age-adjusted protein stress and inflammatory assessment','Balch et al. Science 2008; Klaips et al. Cell 2018','2025-11-24 04:04:17');
INSERT INTO "aging_hallmarks" VALUES(49,4,'Altered Intercellular Communication',90,'medium','["Age","Glucose","Cholesterol Ratio","Social Connections","Stress Level","Physical Activity"]','["Cytokine Panel","Neurohormones","Cell Adhesion Molecules","IL-6","TSH"]','severe','Intercellular communication disruption of 90% based on inflammatory markers, hormonal balance, and factors affecting cellular signaling.','Multi-system communication assessment','Franceschi & Campisi Nature Reviews 2014; Fulop et al. Frontiers Immunology 2018','2025-11-24 04:04:17');
INSERT INTO "aging_hallmarks" VALUES(50,5,'Deregulated Nutrient Sensing',98,'high','["Fasting Glucose","HbA1c","Triglycerides","BMI","Diet Quality","Physical Activity"]','["IGF-1","mTOR Activity","AMPK Activity","Insulin"]','severe','Nutrient sensing dysfunction of 98% based on glucose metabolism markers, insulin sensitivity, and lifestyle factors.','Comprehensive metabolic pathway assessment','Johnson et al. Cell Metabolism 2013; Fontana & Partridge Cell 2015','2025-11-24 04:04:17');
INSERT INTO "aging_hallmarks" VALUES(51,4,'Chronic Inflammation',100,'medium','["Chronological Age","C-Reactive Protein","White Blood Cell Count","Smoking Status","Physical Activity","Chronic Stress Level","Fasting Glucose","BMI (Adipose Inflammation)","Sleep Quality"]','["IL-6","TNF-α","IL-1β","NLRP3"]','severe','Chronic inflammation (inflammaging) score of 100% based on inflammatory markers, lifestyle factors, and age-related immune system changes.','Multi-biomarker inflammaging assessment','Franceschi et al. Nature Reviews Immunology 2018; Ferrucci & Fabbri Nature Reviews Cardiology 2018','2025-11-24 04:04:17');
INSERT INTO "aging_hallmarks" VALUES(52,5,'Mitochondrial Dysfunction',58,'medium','["Age","Glucose","Creatinine","Exercise Level","Smoking Status","Diet Quality"]','["Lactate","CoQ10","Mitochondrial DNA","VO2 Max"]','moderate','Mitochondrial dysfunction risk of 58% based on age-related decline, metabolic markers, and lifestyle factors affecting cellular energy production.','Age-adjusted mitochondrial health assessment','Picard et al. Cell Metabolism 2018; Kauppila et al. Cell Metabolism 2017','2025-11-24 04:04:17');
INSERT INTO "aging_hallmarks" VALUES(53,4,'Dysbiosis',99.6,'low','["Chronological Age","Diet Quality","High Stress (Dysbiosis Risk)","Physical Activity","Sleep Quality","Systemic Inflammation","Glucose Metabolism","Smoking Status","Alcohol Consumption"]','["Microbiome Analysis","SCFA Levels","Zonulin","Calprotectin","Akkermansia","Bifidobacterium"]','severe','Gut microbiome dysbiosis risk of 99.6% estimated from lifestyle factors and indirect biomarkers affecting microbial diversity and gut barrier function.','Lifestyle-based dysbiosis risk assessment','O''Toole & Jeffery Nature Reviews Gastroenterology 2015; Ghosh et al. Nature Reviews Gastroenterology 2020','2025-11-24 04:04:17');
INSERT INTO "aging_hallmarks" VALUES(54,5,'Cellular Senescence',66,'medium','["Chronological Age","Glucose","Physical Activity","Smoking Status","Chronic Stress"]','["p16","p21","SASP Markers","Senescent Cell Count","IL-6"]','high','Cellular senescence burden of 66% estimated from age-related accumulation and inflammatory markers indicating senescent cell activity.','Age-adjusted senescence and inflammatory assessment','Campisi & d''Adda di Fagagna Nature Reviews 2007; Tchkonia et al. Aging Cell 2013','2025-11-24 04:04:18');
INSERT INTO "aging_hallmarks" VALUES(55,4,'Altered Mechanical Properties',100,'medium','["Chronological Age","Blood Pressure (Arterial Stiffness)","Physical Activity Level","Smoking Status (Collagen Impact)","Gender (Hormonal Effects)","BMI (Mechanical Load)","Albumin (Protein Synthesis)","Chronic Stress Level","Sleep Quality (Tissue Repair)"]','["Skin Elasticity","Arterial Stiffness (PWV)","Bone Density","Muscle Fiber Composition","Collagen Crosslinking","ECM Remodeling","Vitamin D"]','severe','Mechanical aging score of 100% based on factors affecting tissue elasticity, arterial stiffness, bone density, and extracellular matrix remodeling.','Multi-system mechanical aging assessment','López-Otín et al. Cell 2023; Phillip et al. Nature Reviews Materials 2021','2025-11-24 04:04:18');
INSERT INTO "aging_hallmarks" VALUES(56,5,'Stem Cell Exhaustion',85,'medium','["Age","Hemoglobin","White Blood Cells","Albumin","Exercise","Diet Quality"]','["Stem Cell Markers","Regenerative Capacity","Growth Factors","Vitamin D"]','severe','Stem cell exhaustion risk of 85% based on age-related decline, hematopoietic markers, and factors affecting regenerative capacity.','Age-adjusted regenerative capacity assessment','Rossi et al. Cell 2008; Ermolaeva et al. Nature 2018','2025-11-24 04:04:18');
INSERT INTO "aging_hallmarks" VALUES(57,5,'Altered Intercellular Communication',90,'medium','["Age","Glucose","Cholesterol Ratio","Social Connections","Stress Level","Physical Activity"]','["Cytokine Panel","Neurohormones","Cell Adhesion Molecules","IL-6","TSH"]','severe','Intercellular communication disruption of 90% based on inflammatory markers, hormonal balance, and factors affecting cellular signaling.','Multi-system communication assessment','Franceschi & Campisi Nature Reviews 2014; Fulop et al. Frontiers Immunology 2018','2025-11-24 04:04:18');
INSERT INTO "aging_hallmarks" VALUES(58,5,'Chronic Inflammation',100,'medium','["Chronological Age","C-Reactive Protein","White Blood Cell Count","Smoking Status","Physical Activity","Chronic Stress Level","Fasting Glucose","BMI (Adipose Inflammation)","Sleep Quality"]','["IL-6","TNF-α","IL-1β","NLRP3"]','severe','Chronic inflammation (inflammaging) score of 100% based on inflammatory markers, lifestyle factors, and age-related immune system changes.','Multi-biomarker inflammaging assessment','Franceschi et al. Nature Reviews Immunology 2018; Ferrucci & Fabbri Nature Reviews Cardiology 2018','2025-11-24 04:04:19');
INSERT INTO "aging_hallmarks" VALUES(59,5,'Dysbiosis',99.6,'low','["Chronological Age","Diet Quality","High Stress (Dysbiosis Risk)","Physical Activity","Sleep Quality","Systemic Inflammation","Glucose Metabolism","Smoking Status","Alcohol Consumption"]','["Microbiome Analysis","SCFA Levels","Zonulin","Calprotectin","Akkermansia","Bifidobacterium"]','severe','Gut microbiome dysbiosis risk of 99.6% estimated from lifestyle factors and indirect biomarkers affecting microbial diversity and gut barrier function.','Lifestyle-based dysbiosis risk assessment','O''Toole & Jeffery Nature Reviews Gastroenterology 2015; Ghosh et al. Nature Reviews Gastroenterology 2020','2025-11-24 04:04:19');
INSERT INTO "aging_hallmarks" VALUES(60,5,'Altered Mechanical Properties',100,'medium','["Chronological Age","Blood Pressure (Arterial Stiffness)","Physical Activity Level","Smoking Status (Collagen Impact)","Gender (Hormonal Effects)","BMI (Mechanical Load)","Albumin (Protein Synthesis)","Chronic Stress Level","Sleep Quality (Tissue Repair)"]','["Skin Elasticity","Arterial Stiffness (PWV)","Bone Density","Muscle Fiber Composition","Collagen Crosslinking","ECM Remodeling","Vitamin D"]','severe','Mechanical aging score of 100% based on factors affecting tissue elasticity, arterial stiffness, bone density, and extracellular matrix remodeling.','Multi-system mechanical aging assessment','López-Otín et al. Cell 2023; Phillip et al. Nature Reviews Materials 2021','2025-11-24 04:04:19');
INSERT INTO "aging_hallmarks" VALUES(61,6,'Genomic Instability',40,'high','["Smoking Status","Alcohol Consumption","Stress Level"]','["CRP","Homocysteine"]','moderate','Genomic instability score of 40% based on oxidative stress markers, inflammatory indicators, and lifestyle factors affecting DNA repair mechanisms.','Multi-biomarker oxidative stress and inflammation assessment','López-Otín et al. Cell 2013; Nature Reviews 2023','2025-11-24 04:04:20');
INSERT INTO "aging_hallmarks" VALUES(62,6,'Telomere Attrition',85,'medium','["Chronological Age","Physical Activity Level","Smoking Status","Chronic Stress Level","Sleep Quality","BMI"]','["Telomere Length Test"]','severe','Telomere attrition risk of 85% estimated from age-adjusted lifestyle factors known to influence telomere length.','Age-adjusted lifestyle telomere risk estimation','Blackburn et al. Nature 2015; Verhulst et al. Ageing Research Reviews 2016','2025-11-24 04:04:21');
INSERT INTO "aging_hallmarks" VALUES(63,6,'Epigenetic Alterations',81.5,'medium','["Chronological Age","HbA1c","Fasting Glucose","Diet Quality","Physical Activity","Smoking Status"]','["DNA Methylation Clock","Histone Modifications"]','severe','Epigenetic alteration risk of 81.5% based on metabolic markers and lifestyle factors that influence DNA methylation patterns.','Metabolic-lifestyle epigenetic risk assessment','Pal & Tyler JCI Insight 2016; Xia et al. Genome Medicine 2021','2025-11-24 04:04:21');
CREATE TABLE health_optimization_assessments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL,
  overall_health_score REAL NOT NULL,
  health_span_projection REAL NOT NULL,
  primary_strengths TEXT NOT NULL,
  optimization_opportunities TEXT NOT NULL,
  confidence_level TEXT NOT NULL,
  calculation_date TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (session_id) REFERENCES assessment_sessions(id) ON DELETE CASCADE
);
INSERT INTO "health_optimization_assessments" VALUES(1,250,0.625,4.1875,'[]','["Metabolic Health","Cardiovascular Fitness","Cognitive Reserve","Immune Resilience","Physical Performance","Sleep Quality","Stress Resilience","Nutritional Status"]','medium','2025-11-24','2025-11-24 04:01:21');
INSERT INTO "health_optimization_assessments" VALUES(2,251,0.625,4.1875,'[]','["Metabolic Health","Cardiovascular Fitness","Cognitive Reserve","Immune Resilience","Physical Performance","Sleep Quality","Stress Resilience","Nutritional Status"]','medium','2025-11-24','2025-11-24 04:01:34');
INSERT INTO "health_optimization_assessments" VALUES(3,252,100,49,'["Metabolic Health","Cardiovascular Fitness","Cognitive Reserve","Immune Resilience","Physical Performance","Sleep Quality","Stress Resilience","Nutritional Status"]','[]','medium','2025-11-24','2025-11-24 04:02:12');
INSERT INTO "health_optimization_assessments" VALUES(4,254,0.625,4.1875,'[]','["Metabolic Health","Cardiovascular Fitness","Cognitive Reserve","Immune Resilience","Physical Performance","Sleep Quality","Stress Resilience","Nutritional Status"]','medium','2025-11-24','2025-11-24 04:04:18');
INSERT INTO "health_optimization_assessments" VALUES(5,255,0.625,4.1875,'[]','["Metabolic Health","Cardiovascular Fitness","Cognitive Reserve","Immune Resilience","Physical Performance","Sleep Quality","Stress Resilience","Nutritional Status"]','medium','2025-11-24','2025-11-24 04:04:19');
CREATE TABLE health_domains (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  health_optimization_assessment_id INTEGER NOT NULL,
  domain_name TEXT NOT NULL,
  score_percentage REAL NOT NULL,
  confidence_level TEXT NOT NULL,
  markers_available TEXT NOT NULL,
  markers_missing TEXT NOT NULL,
  optimization_level TEXT NOT NULL,
  recommendations TEXT NOT NULL,
  description TEXT NOT NULL,
  algorithm_used TEXT NOT NULL,
  reference TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (health_optimization_assessment_id) REFERENCES health_optimization_assessments(id) ON DELETE CASCADE
);
INSERT INTO "health_domains" VALUES(1,1,'Metabolic Health',0,'high','["HbA1c","Fasting Glucose","HDL/Triglyceride Ratio","BMI","Diet Quality","Physical Activity"]','["Insulin Levels","HOMA-IR","Advanced Lipid Panel","Adiponectin"]','poor','["Consider glucose monitoring and dietary carbohydrate optimization","Weight optimization through balanced nutrition and exercise","Increase physical activity to 150+ minutes per week"]','Metabolic health score of 0% based on glucose metabolism, lipid optimization, and metabolic flexibility indicators.','Comprehensive metabolic health assessment','American Diabetes Association 2023; ESC/EAS Lipid Guidelines 2019','2025-11-24 04:01:22');
INSERT INTO "health_domains" VALUES(2,1,'Cardiovascular Fitness',5,'high','["Blood Pressure","LDL Cholesterol","HDL Cholesterol","Physical Activity Level","Age-Adjusted Assessment","Smoking Status","Inflammatory Markers"]','["VO2 Max","HRV","Echocardiogram","Stress Test"]','poor','["Consider blood pressure optimization through lifestyle and medical management","Increase cardiovascular exercise to 150+ minutes per week"]','Cardiovascular fitness score of 5% based on blood pressure, lipid profile, physical activity, and cardiovascular risk factors.','Multi-factor cardiovascular health assessment','AHA/ACC Primary Prevention Guidelines 2019; ESC Cardiovascular Prevention Guidelines 2021','2025-11-24 04:01:22');
INSERT INTO "health_domains" VALUES(3,1,'Cognitive Reserve',0,'medium','["Chronological Age","Social Engagement","Physical Activity (Neuroprotective)","Sleep Quality","Glucose Metabolism (Brain Health)","Blood Pressure (Cerebral Perfusion)","Inflammatory Status","Stress Management","Smoking Status (Cognitive Risk)"]','["Cognitive Testing","APOE Status","Neuroimaging","Amyloid Beta"]','poor','["Increase physical activity - excellent for brain health and neuroplasticity","Optimize sleep quality - critical for memory consolidation and brain detox","Implement stress management techniques to protect cognitive function","Enhance social engagement - strong predictor of cognitive resilience"]','Cognitive reserve score of 0% based on lifestyle factors that support brain health, neuroplasticity, and cognitive resilience.','Lifestyle-based cognitive reserve assessment','Stern et al. Nature Reviews Neurology 2020; Livingston et al. Lancet 2020','2025-11-24 04:01:22');
INSERT INTO "health_domains" VALUES(4,1,'Immune Resilience',0,'medium','["White Blood Cell Count","Inflammatory Balance","Age-Adjusted Immune Function","Sleep Quality (Immune Support)","Physical Activity (Immune Modulation)","Stress Management","Nutritional Status","Smoking Status","Social Support (Psychoneuroimmunology)"]','["Lymphocyte Subsets","NK Cell Function","Antibody Titers","Cytokine Profile"]','poor','["Prioritize sleep optimization - critical for immune function and recovery","Implement stress reduction techniques to support immune resilience","Optimize nutrition with immune-supporting foods and adequate micronutrients","Increase moderate physical activity to boost immune function"]','Immune resilience score of 0% based on inflammatory control, lifestyle factors supporting immune function, and age-adjusted immune health indicators.','Multi-factor immune health assessment','Pawelec et al. Nature Reviews Immunology 2018; Nieman & Wentz Journal of Sport and Health Science 2019','2025-11-24 04:01:23');
INSERT INTO "health_domains" VALUES(5,1,'Physical Performance',0,'medium','["Age-Adjusted Assessment","Body Composition (BMI)","Physical Activity Level","Cardiovascular Fitness","Metabolic Fitness","Oxygen Transport Capacity","Recovery Status (Inflammation)","Sleep Quality (Recovery)","Smoking Status"]','["Muscle Mass (DEXA)","Grip Strength","VO2 Max","Flexibility Tests","Balance Tests"]','poor','["Increase physical activity - combine cardiovascular and strength training","Optimize body composition through strength training and nutrition","Improve sleep quality for better recovery and performance"]','Physical performance score of 0% based on age-adjusted fitness indicators, body composition, activity level, and physiological markers supporting physical function.','Age-adjusted physical performance assessment','ACSM Position Stand on Exercise and Physical Activity 2018; WHO Physical Activity Guidelines 2020','2025-11-24 04:01:23');
INSERT INTO "health_domains" VALUES(6,1,'Sleep Quality',0,'medium','["Self-Reported Sleep Quality","Age-Adjusted Sleep Assessment","Stress Level (Sleep Impact)","Physical Activity (Sleep Benefit)","Glucose Control (Sleep Quality)","BMI (Sleep Apnea Risk)","Smoking Status (Sleep Disruption)","Alcohol Consumption (Sleep Impact)","Inflammatory Status"]','["Sleep Study","HRV During Sleep","Melatonin Levels","Sleep Efficiency Tracking"]','poor','["Focus on sleep hygiene optimization - consistent schedule, cool dark room, no screens before bed","Implement evening stress reduction techniques - meditation, gentle stretching, or reading","Regular daytime exercise improves sleep quality - avoid intense exercise 3hrs before bed"]','Sleep quality score of 0% based on self-reported sleep quality, lifestyle factors affecting sleep, and physiological markers related to circadian health.','Multi-factor sleep quality assessment','American Academy of Sleep Medicine Clinical Practice Guidelines 2017; Walker "Why We Sleep" 2017','2025-11-24 04:01:23');
INSERT INTO "health_domains" VALUES(7,1,'Stress Resilience',0,'medium','["Self-Reported Stress Level","Social Support (Stress Buffer)","Physical Activity (Stress Relief)","Sleep Quality (Stress Recovery)","Inflammatory Status (Chronic Stress)","Blood Pressure (Stress Impact)","Glucose Control (Stress Impact)","Smoking Status (Stress Coping)","Age-Related Stress Resilience"]','["Cortisol Rhythm","HRV","Stress Hormones","Neurotransmitter Levels"]','poor','["Implement daily stress management techniques - mindfulness, deep breathing, or meditation","Strengthen social connections - key protective factor against stress impact","Increase physical activity - excellent natural stress reliever and resilience builder","Prioritize sleep optimization for better stress recovery and emotional regulation"]','Stress resilience score of 0% based on stress levels, social support, coping mechanisms, and physiological indicators of chronic stress adaptation.','Multi-factor stress resilience assessment','McEwen Stress and Health 2017; Cohen et al. Psychological Science 2012','2025-11-24 04:01:23');
INSERT INTO "health_domains" VALUES(8,1,'Nutritional Status',0,'medium','["Diet Quality Assessment","Protein Status (Albumin)","Iron Status (Hemoglobin)","Nutritional Balance (BMI)","Metabolic Nutrition Impact","Dietary Fat Quality","Anti-Inflammatory Nutrition","Age-Adjusted Nutritional Needs","Alcohol Impact on Nutrition"]','["Vitamin D","B12","Folate","Iron Studies","Micronutrient Panel","Omega-3 Index"]','poor','["Focus on whole foods nutrition - vegetables, fruits, lean proteins, and healthy fats","Consider portion control and nutrient-dense food choices for weight optimization"]','Nutritional status score of 0% based on diet quality, nutritional biomarkers, metabolic indicators, and age-adjusted nutritional adequacy.','Comprehensive nutritional status assessment','Academy of Nutrition and Dietetics Evidence-Based Guidelines 2020; WHO Nutritional Indicators 2021','2025-11-24 04:01:24');
INSERT INTO "health_domains" VALUES(9,2,'Metabolic Health',0,'high','["HbA1c","Fasting Glucose","HDL/Triglyceride Ratio","BMI","Diet Quality","Physical Activity"]','["Insulin Levels","HOMA-IR","Advanced Lipid Panel","Adiponectin"]','poor','["Consider glucose monitoring and dietary carbohydrate optimization","Weight optimization through balanced nutrition and exercise","Increase physical activity to 150+ minutes per week"]','Metabolic health score of 0% based on glucose metabolism, lipid optimization, and metabolic flexibility indicators.','Comprehensive metabolic health assessment','American Diabetes Association 2023; ESC/EAS Lipid Guidelines 2019','2025-11-24 04:01:34');
INSERT INTO "health_domains" VALUES(10,2,'Cardiovascular Fitness',5,'high','["Blood Pressure","LDL Cholesterol","HDL Cholesterol","Physical Activity Level","Age-Adjusted Assessment","Smoking Status","Inflammatory Markers"]','["VO2 Max","HRV","Echocardiogram","Stress Test"]','poor','["Consider blood pressure optimization through lifestyle and medical management","Increase cardiovascular exercise to 150+ minutes per week"]','Cardiovascular fitness score of 5% based on blood pressure, lipid profile, physical activity, and cardiovascular risk factors.','Multi-factor cardiovascular health assessment','AHA/ACC Primary Prevention Guidelines 2019; ESC Cardiovascular Prevention Guidelines 2021','2025-11-24 04:01:34');
INSERT INTO "health_domains" VALUES(11,2,'Cognitive Reserve',0,'medium','["Chronological Age","Social Engagement","Physical Activity (Neuroprotective)","Sleep Quality","Glucose Metabolism (Brain Health)","Blood Pressure (Cerebral Perfusion)","Inflammatory Status","Stress Management","Smoking Status (Cognitive Risk)"]','["Cognitive Testing","APOE Status","Neuroimaging","Amyloid Beta"]','poor','["Increase physical activity - excellent for brain health and neuroplasticity","Optimize sleep quality - critical for memory consolidation and brain detox","Implement stress management techniques to protect cognitive function","Enhance social engagement - strong predictor of cognitive resilience"]','Cognitive reserve score of 0% based on lifestyle factors that support brain health, neuroplasticity, and cognitive resilience.','Lifestyle-based cognitive reserve assessment','Stern et al. Nature Reviews Neurology 2020; Livingston et al. Lancet 2020','2025-11-24 04:01:35');
INSERT INTO "health_domains" VALUES(12,2,'Immune Resilience',0,'medium','["White Blood Cell Count","Inflammatory Balance","Age-Adjusted Immune Function","Sleep Quality (Immune Support)","Physical Activity (Immune Modulation)","Stress Management","Nutritional Status","Smoking Status","Social Support (Psychoneuroimmunology)"]','["Lymphocyte Subsets","NK Cell Function","Antibody Titers","Cytokine Profile"]','poor','["Prioritize sleep optimization - critical for immune function and recovery","Implement stress reduction techniques to support immune resilience","Optimize nutrition with immune-supporting foods and adequate micronutrients","Increase moderate physical activity to boost immune function"]','Immune resilience score of 0% based on inflammatory control, lifestyle factors supporting immune function, and age-adjusted immune health indicators.','Multi-factor immune health assessment','Pawelec et al. Nature Reviews Immunology 2018; Nieman & Wentz Journal of Sport and Health Science 2019','2025-11-24 04:01:35');
INSERT INTO "health_domains" VALUES(13,2,'Physical Performance',0,'medium','["Age-Adjusted Assessment","Body Composition (BMI)","Physical Activity Level","Cardiovascular Fitness","Metabolic Fitness","Oxygen Transport Capacity","Recovery Status (Inflammation)","Sleep Quality (Recovery)","Smoking Status"]','["Muscle Mass (DEXA)","Grip Strength","VO2 Max","Flexibility Tests","Balance Tests"]','poor','["Increase physical activity - combine cardiovascular and strength training","Optimize body composition through strength training and nutrition","Improve sleep quality for better recovery and performance"]','Physical performance score of 0% based on age-adjusted fitness indicators, body composition, activity level, and physiological markers supporting physical function.','Age-adjusted physical performance assessment','ACSM Position Stand on Exercise and Physical Activity 2018; WHO Physical Activity Guidelines 2020','2025-11-24 04:01:35');
INSERT INTO "health_domains" VALUES(14,2,'Sleep Quality',0,'medium','["Self-Reported Sleep Quality","Age-Adjusted Sleep Assessment","Stress Level (Sleep Impact)","Physical Activity (Sleep Benefit)","Glucose Control (Sleep Quality)","BMI (Sleep Apnea Risk)","Smoking Status (Sleep Disruption)","Alcohol Consumption (Sleep Impact)","Inflammatory Status"]','["Sleep Study","HRV During Sleep","Melatonin Levels","Sleep Efficiency Tracking"]','poor','["Focus on sleep hygiene optimization - consistent schedule, cool dark room, no screens before bed","Implement evening stress reduction techniques - meditation, gentle stretching, or reading","Regular daytime exercise improves sleep quality - avoid intense exercise 3hrs before bed"]','Sleep quality score of 0% based on self-reported sleep quality, lifestyle factors affecting sleep, and physiological markers related to circadian health.','Multi-factor sleep quality assessment','American Academy of Sleep Medicine Clinical Practice Guidelines 2017; Walker "Why We Sleep" 2017','2025-11-24 04:01:35');
INSERT INTO "health_domains" VALUES(15,2,'Stress Resilience',0,'medium','["Self-Reported Stress Level","Social Support (Stress Buffer)","Physical Activity (Stress Relief)","Sleep Quality (Stress Recovery)","Inflammatory Status (Chronic Stress)","Blood Pressure (Stress Impact)","Glucose Control (Stress Impact)","Smoking Status (Stress Coping)","Age-Related Stress Resilience"]','["Cortisol Rhythm","HRV","Stress Hormones","Neurotransmitter Levels"]','poor','["Implement daily stress management techniques - mindfulness, deep breathing, or meditation","Strengthen social connections - key protective factor against stress impact","Increase physical activity - excellent natural stress reliever and resilience builder","Prioritize sleep optimization for better stress recovery and emotional regulation"]','Stress resilience score of 0% based on stress levels, social support, coping mechanisms, and physiological indicators of chronic stress adaptation.','Multi-factor stress resilience assessment','McEwen Stress and Health 2017; Cohen et al. Psychological Science 2012','2025-11-24 04:01:36');
INSERT INTO "health_domains" VALUES(16,2,'Nutritional Status',0,'medium','["Diet Quality Assessment","Protein Status (Albumin)","Iron Status (Hemoglobin)","Nutritional Balance (BMI)","Metabolic Nutrition Impact","Dietary Fat Quality","Anti-Inflammatory Nutrition","Age-Adjusted Nutritional Needs","Alcohol Impact on Nutrition"]','["Vitamin D","B12","Folate","Iron Studies","Micronutrient Panel","Omega-3 Index"]','poor','["Focus on whole foods nutrition - vegetables, fruits, lean proteins, and healthy fats","Consider portion control and nutrient-dense food choices for weight optimization"]','Nutritional status score of 0% based on diet quality, nutritional biomarkers, metabolic indicators, and age-adjusted nutritional adequacy.','Comprehensive nutritional status assessment','Academy of Nutrition and Dietetics Evidence-Based Guidelines 2020; WHO Nutritional Indicators 2021','2025-11-24 04:01:36');
INSERT INTO "health_domains" VALUES(17,3,'Metabolic Health',100,'high','["HbA1c","Fasting Glucose","HDL/Triglyceride Ratio","BMI","Diet Quality","Physical Activity"]','["Insulin Levels","HOMA-IR","Advanced Lipid Panel","Adiponectin"]','optimal','["Maintain current excellent metabolic health practices"]','Metabolic health score of 100% based on glucose metabolism, lipid optimization, and metabolic flexibility indicators.','Comprehensive metabolic health assessment','American Diabetes Association 2023; ESC/EAS Lipid Guidelines 2019','2025-11-24 04:02:13');
INSERT INTO "health_domains" VALUES(18,3,'Cardiovascular Fitness',100,'high','["Blood Pressure","LDL Cholesterol","HDL Cholesterol","Physical Activity Level","Age-Adjusted Assessment","Smoking Status","Inflammatory Markers"]','["VO2 Max","HRV","Echocardiogram","Stress Test"]','optimal','["Maintain excellent cardiovascular fitness practices"]','Cardiovascular fitness score of 100% based on blood pressure, lipid profile, physical activity, and cardiovascular risk factors.','Multi-factor cardiovascular health assessment','AHA/ACC Primary Prevention Guidelines 2019; ESC Cardiovascular Prevention Guidelines 2021','2025-11-24 04:02:13');
INSERT INTO "health_domains" VALUES(19,3,'Cognitive Reserve',100,'medium','["Chronological Age","Social Engagement","Physical Activity (Neuroprotective)","Sleep Quality","Glucose Metabolism (Brain Health)","Blood Pressure (Cerebral Perfusion)","Inflammatory Status","Stress Management","Smoking Status (Cognitive Risk)"]','["Cognitive Testing","APOE Status","Neuroimaging","Amyloid Beta"]','optimal','["Continue brain-healthy lifestyle practices and consider cognitive challenges"]','Cognitive reserve score of 100% based on lifestyle factors that support brain health, neuroplasticity, and cognitive resilience.','Lifestyle-based cognitive reserve assessment','Stern et al. Nature Reviews Neurology 2020; Livingston et al. Lancet 2020','2025-11-24 04:02:13');
INSERT INTO "health_domains" VALUES(20,3,'Immune Resilience',100,'medium','["White Blood Cell Count","Inflammatory Balance","Age-Adjusted Immune Function","Sleep Quality (Immune Support)","Physical Activity (Immune Modulation)","Stress Management","Nutritional Status","Smoking Status","Social Support (Psychoneuroimmunology)"]','["Lymphocyte Subsets","NK Cell Function","Antibody Titers","Cytokine Profile"]','optimal','["Maintain excellent immune-supporting lifestyle practices"]','Immune resilience score of 100% based on inflammatory control, lifestyle factors supporting immune function, and age-adjusted immune health indicators.','Multi-factor immune health assessment','Pawelec et al. Nature Reviews Immunology 2018; Nieman & Wentz Journal of Sport and Health Science 2019','2025-11-24 04:02:14');
INSERT INTO "health_domains" VALUES(21,3,'Physical Performance',100,'medium','["Age-Adjusted Assessment","Body Composition (BMI)","Physical Activity Level","Cardiovascular Fitness","Metabolic Fitness","Oxygen Transport Capacity","Recovery Status (Inflammation)","Sleep Quality (Recovery)","Smoking Status"]','["Muscle Mass (DEXA)","Grip Strength","VO2 Max","Flexibility Tests","Balance Tests"]','optimal','["Maintain excellent physical conditioning and consider performance optimization"]','Physical performance score of 100% based on age-adjusted fitness indicators, body composition, activity level, and physiological markers supporting physical function.','Age-adjusted physical performance assessment','ACSM Position Stand on Exercise and Physical Activity 2018; WHO Physical Activity Guidelines 2020','2025-11-24 04:02:14');
INSERT INTO "health_domains" VALUES(22,3,'Sleep Quality',100,'medium','["Self-Reported Sleep Quality","Age-Adjusted Sleep Assessment","Stress Level (Sleep Impact)","Physical Activity (Sleep Benefit)","Glucose Control (Sleep Quality)","BMI (Sleep Apnea Risk)","Smoking Status (Sleep Disruption)","Alcohol Consumption (Sleep Impact)","Inflammatory Status"]','["Sleep Study","HRV During Sleep","Melatonin Levels","Sleep Efficiency Tracking"]','optimal','["Maintain excellent sleep practices and consider sleep tracking for optimization"]','Sleep quality score of 100% based on self-reported sleep quality, lifestyle factors affecting sleep, and physiological markers related to circadian health.','Multi-factor sleep quality assessment','American Academy of Sleep Medicine Clinical Practice Guidelines 2017; Walker "Why We Sleep" 2017','2025-11-24 04:02:14');
INSERT INTO "health_domains" VALUES(23,3,'Stress Resilience',100,'medium','["Self-Reported Stress Level","Social Support (Stress Buffer)","Physical Activity (Stress Relief)","Sleep Quality (Stress Recovery)","Inflammatory Status (Chronic Stress)","Blood Pressure (Stress Impact)","Glucose Control (Stress Impact)","Smoking Status (Stress Coping)","Age-Related Stress Resilience"]','["Cortisol Rhythm","HRV","Stress Hormones","Neurotransmitter Levels"]','optimal','["Maintain excellent stress resilience practices and consider advanced stress management techniques"]','Stress resilience score of 100% based on stress levels, social support, coping mechanisms, and physiological indicators of chronic stress adaptation.','Multi-factor stress resilience assessment','McEwen Stress and Health 2017; Cohen et al. Psychological Science 2012','2025-11-24 04:02:14');
INSERT INTO "health_domains" VALUES(24,3,'Nutritional Status',100,'medium','["Diet Quality Assessment","Protein Status (Albumin)","Iron Status (Hemoglobin)","Nutritional Balance (BMI)","Metabolic Nutrition Impact","Dietary Fat Quality","Anti-Inflammatory Nutrition","Age-Adjusted Nutritional Needs","Alcohol Impact on Nutrition"]','["Vitamin D","B12","Folate","Iron Studies","Micronutrient Panel","Omega-3 Index"]','optimal','["Maintain excellent nutritional practices and consider micronutrient optimization"]','Nutritional status score of 100% based on diet quality, nutritional biomarkers, metabolic indicators, and age-adjusted nutritional adequacy.','Comprehensive nutritional status assessment','Academy of Nutrition and Dietetics Evidence-Based Guidelines 2020; WHO Nutritional Indicators 2021','2025-11-24 04:02:15');
INSERT INTO "health_domains" VALUES(25,4,'Metabolic Health',0,'high','["HbA1c","Fasting Glucose","HDL/Triglyceride Ratio","BMI","Diet Quality","Physical Activity"]','["Insulin Levels","HOMA-IR","Advanced Lipid Panel","Adiponectin"]','poor','["Consider glucose monitoring and dietary carbohydrate optimization","Weight optimization through balanced nutrition and exercise","Increase physical activity to 150+ minutes per week"]','Metabolic health score of 0% based on glucose metabolism, lipid optimization, and metabolic flexibility indicators.','Comprehensive metabolic health assessment','American Diabetes Association 2023; ESC/EAS Lipid Guidelines 2019','2025-11-24 04:04:19');
INSERT INTO "health_domains" VALUES(26,4,'Cardiovascular Fitness',5,'high','["Blood Pressure","LDL Cholesterol","HDL Cholesterol","Physical Activity Level","Age-Adjusted Assessment","Smoking Status","Inflammatory Markers"]','["VO2 Max","HRV","Echocardiogram","Stress Test"]','poor','["Consider blood pressure optimization through lifestyle and medical management","Increase cardiovascular exercise to 150+ minutes per week"]','Cardiovascular fitness score of 5% based on blood pressure, lipid profile, physical activity, and cardiovascular risk factors.','Multi-factor cardiovascular health assessment','AHA/ACC Primary Prevention Guidelines 2019; ESC Cardiovascular Prevention Guidelines 2021','2025-11-24 04:04:19');
INSERT INTO "health_domains" VALUES(27,4,'Cognitive Reserve',0,'medium','["Chronological Age","Social Engagement","Physical Activity (Neuroprotective)","Sleep Quality","Glucose Metabolism (Brain Health)","Blood Pressure (Cerebral Perfusion)","Inflammatory Status","Stress Management","Smoking Status (Cognitive Risk)"]','["Cognitive Testing","APOE Status","Neuroimaging","Amyloid Beta"]','poor','["Increase physical activity - excellent for brain health and neuroplasticity","Optimize sleep quality - critical for memory consolidation and brain detox","Implement stress management techniques to protect cognitive function","Enhance social engagement - strong predictor of cognitive resilience"]','Cognitive reserve score of 0% based on lifestyle factors that support brain health, neuroplasticity, and cognitive resilience.','Lifestyle-based cognitive reserve assessment','Stern et al. Nature Reviews Neurology 2020; Livingston et al. Lancet 2020','2025-11-24 04:04:19');
INSERT INTO "health_domains" VALUES(28,4,'Immune Resilience',0,'medium','["White Blood Cell Count","Inflammatory Balance","Age-Adjusted Immune Function","Sleep Quality (Immune Support)","Physical Activity (Immune Modulation)","Stress Management","Nutritional Status","Smoking Status","Social Support (Psychoneuroimmunology)"]','["Lymphocyte Subsets","NK Cell Function","Antibody Titers","Cytokine Profile"]','poor','["Prioritize sleep optimization - critical for immune function and recovery","Implement stress reduction techniques to support immune resilience","Optimize nutrition with immune-supporting foods and adequate micronutrients","Increase moderate physical activity to boost immune function"]','Immune resilience score of 0% based on inflammatory control, lifestyle factors supporting immune function, and age-adjusted immune health indicators.','Multi-factor immune health assessment','Pawelec et al. Nature Reviews Immunology 2018; Nieman & Wentz Journal of Sport and Health Science 2019','2025-11-24 04:04:19');
INSERT INTO "health_domains" VALUES(29,4,'Physical Performance',0,'medium','["Age-Adjusted Assessment","Body Composition (BMI)","Physical Activity Level","Cardiovascular Fitness","Metabolic Fitness","Oxygen Transport Capacity","Recovery Status (Inflammation)","Sleep Quality (Recovery)","Smoking Status"]','["Muscle Mass (DEXA)","Grip Strength","VO2 Max","Flexibility Tests","Balance Tests"]','poor','["Increase physical activity - combine cardiovascular and strength training","Optimize body composition through strength training and nutrition","Improve sleep quality for better recovery and performance"]','Physical performance score of 0% based on age-adjusted fitness indicators, body composition, activity level, and physiological markers supporting physical function.','Age-adjusted physical performance assessment','ACSM Position Stand on Exercise and Physical Activity 2018; WHO Physical Activity Guidelines 2020','2025-11-24 04:04:20');
INSERT INTO "health_domains" VALUES(30,5,'Metabolic Health',0,'high','["HbA1c","Fasting Glucose","HDL/Triglyceride Ratio","BMI","Diet Quality","Physical Activity"]','["Insulin Levels","HOMA-IR","Advanced Lipid Panel","Adiponectin"]','poor','["Consider glucose monitoring and dietary carbohydrate optimization","Weight optimization through balanced nutrition and exercise","Increase physical activity to 150+ minutes per week"]','Metabolic health score of 0% based on glucose metabolism, lipid optimization, and metabolic flexibility indicators.','Comprehensive metabolic health assessment','American Diabetes Association 2023; ESC/EAS Lipid Guidelines 2019','2025-11-24 04:04:20');
INSERT INTO "health_domains" VALUES(31,4,'Sleep Quality',0,'medium','["Self-Reported Sleep Quality","Age-Adjusted Sleep Assessment","Stress Level (Sleep Impact)","Physical Activity (Sleep Benefit)","Glucose Control (Sleep Quality)","BMI (Sleep Apnea Risk)","Smoking Status (Sleep Disruption)","Alcohol Consumption (Sleep Impact)","Inflammatory Status"]','["Sleep Study","HRV During Sleep","Melatonin Levels","Sleep Efficiency Tracking"]','poor','["Focus on sleep hygiene optimization - consistent schedule, cool dark room, no screens before bed","Implement evening stress reduction techniques - meditation, gentle stretching, or reading","Regular daytime exercise improves sleep quality - avoid intense exercise 3hrs before bed"]','Sleep quality score of 0% based on self-reported sleep quality, lifestyle factors affecting sleep, and physiological markers related to circadian health.','Multi-factor sleep quality assessment','American Academy of Sleep Medicine Clinical Practice Guidelines 2017; Walker "Why We Sleep" 2017','2025-11-24 04:04:20');
INSERT INTO "health_domains" VALUES(32,5,'Cardiovascular Fitness',5,'high','["Blood Pressure","LDL Cholesterol","HDL Cholesterol","Physical Activity Level","Age-Adjusted Assessment","Smoking Status","Inflammatory Markers"]','["VO2 Max","HRV","Echocardiogram","Stress Test"]','poor','["Consider blood pressure optimization through lifestyle and medical management","Increase cardiovascular exercise to 150+ minutes per week"]','Cardiovascular fitness score of 5% based on blood pressure, lipid profile, physical activity, and cardiovascular risk factors.','Multi-factor cardiovascular health assessment','AHA/ACC Primary Prevention Guidelines 2019; ESC Cardiovascular Prevention Guidelines 2021','2025-11-24 04:04:20');
INSERT INTO "health_domains" VALUES(33,4,'Stress Resilience',0,'medium','["Self-Reported Stress Level","Social Support (Stress Buffer)","Physical Activity (Stress Relief)","Sleep Quality (Stress Recovery)","Inflammatory Status (Chronic Stress)","Blood Pressure (Stress Impact)","Glucose Control (Stress Impact)","Smoking Status (Stress Coping)","Age-Related Stress Resilience"]','["Cortisol Rhythm","HRV","Stress Hormones","Neurotransmitter Levels"]','poor','["Implement daily stress management techniques - mindfulness, deep breathing, or meditation","Strengthen social connections - key protective factor against stress impact","Increase physical activity - excellent natural stress reliever and resilience builder","Prioritize sleep optimization for better stress recovery and emotional regulation"]','Stress resilience score of 0% based on stress levels, social support, coping mechanisms, and physiological indicators of chronic stress adaptation.','Multi-factor stress resilience assessment','McEwen Stress and Health 2017; Cohen et al. Psychological Science 2012','2025-11-24 04:04:20');
INSERT INTO "health_domains" VALUES(34,5,'Cognitive Reserve',0,'medium','["Chronological Age","Social Engagement","Physical Activity (Neuroprotective)","Sleep Quality","Glucose Metabolism (Brain Health)","Blood Pressure (Cerebral Perfusion)","Inflammatory Status","Stress Management","Smoking Status (Cognitive Risk)"]','["Cognitive Testing","APOE Status","Neuroimaging","Amyloid Beta"]','poor','["Increase physical activity - excellent for brain health and neuroplasticity","Optimize sleep quality - critical for memory consolidation and brain detox","Implement stress management techniques to protect cognitive function","Enhance social engagement - strong predictor of cognitive resilience"]','Cognitive reserve score of 0% based on lifestyle factors that support brain health, neuroplasticity, and cognitive resilience.','Lifestyle-based cognitive reserve assessment','Stern et al. Nature Reviews Neurology 2020; Livingston et al. Lancet 2020','2025-11-24 04:04:20');
INSERT INTO "health_domains" VALUES(35,4,'Nutritional Status',0,'medium','["Diet Quality Assessment","Protein Status (Albumin)","Iron Status (Hemoglobin)","Nutritional Balance (BMI)","Metabolic Nutrition Impact","Dietary Fat Quality","Anti-Inflammatory Nutrition","Age-Adjusted Nutritional Needs","Alcohol Impact on Nutrition"]','["Vitamin D","B12","Folate","Iron Studies","Micronutrient Panel","Omega-3 Index"]','poor','["Focus on whole foods nutrition - vegetables, fruits, lean proteins, and healthy fats","Consider portion control and nutrient-dense food choices for weight optimization"]','Nutritional status score of 0% based on diet quality, nutritional biomarkers, metabolic indicators, and age-adjusted nutritional adequacy.','Comprehensive nutritional status assessment','Academy of Nutrition and Dietetics Evidence-Based Guidelines 2020; WHO Nutritional Indicators 2021','2025-11-24 04:04:20');
INSERT INTO "health_domains" VALUES(36,5,'Immune Resilience',0,'medium','["White Blood Cell Count","Inflammatory Balance","Age-Adjusted Immune Function","Sleep Quality (Immune Support)","Physical Activity (Immune Modulation)","Stress Management","Nutritional Status","Smoking Status","Social Support (Psychoneuroimmunology)"]','["Lymphocyte Subsets","NK Cell Function","Antibody Titers","Cytokine Profile"]','poor','["Prioritize sleep optimization - critical for immune function and recovery","Implement stress reduction techniques to support immune resilience","Optimize nutrition with immune-supporting foods and adequate micronutrients","Increase moderate physical activity to boost immune function"]','Immune resilience score of 0% based on inflammatory control, lifestyle factors supporting immune function, and age-adjusted immune health indicators.','Multi-factor immune health assessment','Pawelec et al. Nature Reviews Immunology 2018; Nieman & Wentz Journal of Sport and Health Science 2019','2025-11-24 04:04:21');
INSERT INTO "health_domains" VALUES(37,5,'Physical Performance',0,'medium','["Age-Adjusted Assessment","Body Composition (BMI)","Physical Activity Level","Cardiovascular Fitness","Metabolic Fitness","Oxygen Transport Capacity","Recovery Status (Inflammation)","Sleep Quality (Recovery)","Smoking Status"]','["Muscle Mass (DEXA)","Grip Strength","VO2 Max","Flexibility Tests","Balance Tests"]','poor','["Increase physical activity - combine cardiovascular and strength training","Optimize body composition through strength training and nutrition","Improve sleep quality for better recovery and performance"]','Physical performance score of 0% based on age-adjusted fitness indicators, body composition, activity level, and physiological markers supporting physical function.','Age-adjusted physical performance assessment','ACSM Position Stand on Exercise and Physical Activity 2018; WHO Physical Activity Guidelines 2020','2025-11-24 04:04:21');
DELETE FROM sqlite_sequence;
INSERT INTO "sqlite_sequence" VALUES('d1_migrations',6);
INSERT INTO "sqlite_sequence" VALUES('patients',257);
INSERT INTO "sqlite_sequence" VALUES('assessment_sessions',256);
INSERT INTO "sqlite_sequence" VALUES('biological_age',230);
INSERT INTO "sqlite_sequence" VALUES('risk_calculations',1468);
INSERT INTO "sqlite_sequence" VALUES('aging_assessments',6);
INSERT INTO "sqlite_sequence" VALUES('aging_hallmarks',63);
INSERT INTO "sqlite_sequence" VALUES('health_optimization_assessments',5);
INSERT INTO "sqlite_sequence" VALUES('health_domains',37);
INSERT INTO "sqlite_sequence" VALUES('assessment_data',4);
CREATE INDEX idx_patients_email ON patients(email);
CREATE INDEX idx_sessions_patient_id ON assessment_sessions(patient_id);
CREATE INDEX idx_clinical_session_id ON clinical_assessments(session_id);
CREATE INDEX idx_biomarkers_session_id ON biomarkers(session_id);
CREATE INDEX idx_biomarkers_name ON biomarkers(biomarker_name);
CREATE INDEX idx_lifestyle_session_id ON lifestyle_assessments(session_id);
CREATE INDEX idx_lifestyle_type ON lifestyle_assessments(assessment_type);
CREATE INDEX idx_reports_session_id ON assessment_reports(session_id);
CREATE INDEX idx_comprehensive_session_id ON comprehensive_assessments(session_id);
CREATE INDEX idx_biological_age_session_id ON biological_age(session_id);
CREATE INDEX idx_risk_calculations_session_id ON risk_calculations(session_id);
CREATE INDEX idx_risk_calculations_category ON risk_calculations(risk_category);
CREATE INDEX idx_assessment_data_session_id ON assessment_data(session_id);
CREATE INDEX idx_assessment_data_type ON assessment_data(data_type);
CREATE INDEX idx_aging_assessments_session_id ON aging_assessments(session_id);
CREATE INDEX idx_aging_hallmarks_assessment_id ON aging_hallmarks(aging_assessment_id);
CREATE INDEX idx_aging_hallmarks_name ON aging_hallmarks(hallmark_name);
CREATE INDEX idx_health_optimization_assessments_session_id ON health_optimization_assessments(session_id);
CREATE INDEX idx_health_domains_assessment_id ON health_domains(health_optimization_assessment_id);
CREATE INDEX idx_health_domains_name ON health_domains(domain_name);
