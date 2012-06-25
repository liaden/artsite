CREATE TABLE "Users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "username" varchar(255), "email" varchar(255), "crypted_password" varchar(255), "password_salt" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "persistence_token" varchar(255), "privilege" integer);
CREATE TABLE "artwork_media" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "medium_id" integer, "artwork_id" integer);
CREATE TABLE "artwork_tags" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "artwork_id" integer, "tag_id" integer);
CREATE TABLE "artworks" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "description" varchar(255), "image_file_name" varchar(255), "image_content_type" varchar(255), "image_file_size" varchar(255));
CREATE TABLE "auto_tumbles" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "tumble_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "auto_tweets" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "tweet_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "lesson_orders" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "lesson_id" integer, "order_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "lessons" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "date" datetime, "free_spots" integer, "description" text, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "media" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "orders" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "print_orders" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "print_id" integer, "order_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "prints" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "is_sold_out" boolean, "is_on_show" boolean, "price" integer, "artwork_id" integer, "size_name" varchar(255), "material" varchar(255), "dimensions" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "shows" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "date" datetime, "building" varchar(255), "address" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "show_type" varchar(255));
CREATE TABLE "tags" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20120414191829');

INSERT INTO schema_migrations (version) VALUES ('20120414220510');

INSERT INTO schema_migrations (version) VALUES ('20120414220617');

INSERT INTO schema_migrations (version) VALUES ('20120414223244');

INSERT INTO schema_migrations (version) VALUES ('20120414225322');

INSERT INTO schema_migrations (version) VALUES ('20120422222152');

INSERT INTO schema_migrations (version) VALUES ('20120503184519');

INSERT INTO schema_migrations (version) VALUES ('20120503184755');

INSERT INTO schema_migrations (version) VALUES ('20120506160803');

INSERT INTO schema_migrations (version) VALUES ('20120507230551');

INSERT INTO schema_migrations (version) VALUES ('20120507230724');

INSERT INTO schema_migrations (version) VALUES ('20120508001436');

INSERT INTO schema_migrations (version) VALUES ('20120508214908');

INSERT INTO schema_migrations (version) VALUES ('20120508214920');

INSERT INTO schema_migrations (version) VALUES ('20120508230121');

INSERT INTO schema_migrations (version) VALUES ('20120513152207');

INSERT INTO schema_migrations (version) VALUES ('20120513153251');

INSERT INTO schema_migrations (version) VALUES ('20120514162135');

INSERT INTO schema_migrations (version) VALUES ('20120515195555');

INSERT INTO schema_migrations (version) VALUES ('20120515195808');

INSERT INTO schema_migrations (version) VALUES ('20120516180933');

INSERT INTO schema_migrations (version) VALUES ('20120516184428');

INSERT INTO schema_migrations (version) VALUES ('20120517031841');

INSERT INTO schema_migrations (version) VALUES ('20120517032522');

INSERT INTO schema_migrations (version) VALUES ('20120518142507');

INSERT INTO schema_migrations (version) VALUES ('20120520185229');