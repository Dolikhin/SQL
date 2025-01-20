DROP DATABASE IF EXISTS telegram;
CREATE SCHEMA telegram;
use telegram;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  firstname VARCHAR(100),
  lastname VARCHAR(100),
  login VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  password_hash VARCHAR(256),
  phone BIGINT UNSIGNED UNIQUE,
  
  INDEX(firstname, lastname)
);


DROP TABLE IF EXISTS user_settings;
CREATE TABLE user_settings (
   user_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
   is_premium_account BIT,
   is_night_mode_enabled BIT,
   color_scheme ENUM('classic', 'day', 'tinted', 'pink'),
   app_language ENUM('english', 'french', 'russian', 'spanish', 'german') NOT NULL,
   notification_and_sounds JSON,
   created_at DATETIME DEFAULT NOW()

);

ALTER TABLE user_settings ADD CONSTRAINT fk_user_settings_user_id
FOREIGN KEY (user_id) REFERENCES users(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE users ADD COLUMN birthday DATETIME;

ALTER TABLE users MODIFY COLUMN birthday DATE;

ALTER TABLE users RENAME COLUMN birthday to date_of_birth;

ALTER TABLE users DROP COLUMN date_of_birth;

DROP TABLE IF EXISTS private_messages;
CREATE TABLE private_messages (
   id SERIAL,
   sender_id BIGINT UNSIGNED NOT NULL,
   receiver_id BIGINT UNSIGNED NOT NULL,
   reply_to_id BIGINT UNSIGNED NULL,
   media_type ENUM('text', 'image', 'audio', 'video') NOT NULL,
   -- media_type_id BIGINT UNSIGNED NOT NULL,
   body TEXT,
   file_name VARCHAR(200),
    created_at DATETIME DEFAULT NOW(),
    
    FOREIGN KEY (sender_id) REFERENCES users(id),
    FOREIGN KEY (receiver_id) REFERENCES users(id),
    FOREIGN KEY (reply_to_id) REFERENCES private_messages(id)
    
   );
   
DROP TABLE IF EXISTS `groups`;
CREATE TABLE `groups` (
   id SERIAL,
   title VARCHAR(45),
   icon VARCHAR(45),
   invite_link VARCHAR(100),
   settings JSON,
   owner_user_id BIGINT UNSIGNED NOT NULL,
   is_private BIT,
   created_at DATETIME DEFAULT NOW(),
   
   FOREIGN KEY (owner_user_id) REFERENCES users (id)
   );

DROP TABLE IF EXISTS `group_members`;
CREATE TABLE `group_members` (
   id SERIAL,
   `group_id` BIGINT UNSIGNED NOT NULL,
   `user_id` BIGINT UNSIGNED NOT NULL,
   created_at DATETIME DEFAULT NOW(),
   
   FOREIGN KEY (user_id) REFERENCES users (id),
   FOREIGN KEY (`group_id`) REFERENCES `groups` (id)
   );
   
DROP TABLE IF EXISTS `group_messages`;
CREATE TABLE `group_messages` (
   id SERIAL,
   group_id BIGINT UNSIGNED NOT NULL,
   sender_id BIGINT UNSIGNED NOT NULL,
   reply_to_id BIGINT UNSIGNED NULL,
   media_type ENUM('text', 'image', 'audio', 'video') NOT NULL,
   body TEXT,
   file_name VARCHAR(200) NULL,
   created_at DATETIME DEFAULT NOW(),
   
   FOREIGN KEY (group_id) REFERENCES `groups` (id),
   FOREIGN KEY (sender_id) REFERENCES users (id),
   FOREIGN KEY (reply_to_id) REFERENCES `group_messages` (id)
   );
   
DROP TABLE IF EXISTS channels;
CREATE TABLE channels (
   id SERIAL,
   title VARCHAR(45),
   icon VARCHAR(45),
   invite_link VARCHAR(100),
   settings JSON,
   owner_user_id BIGINT UNSIGNED NOT NULL,
   is_private BIT,
   created_at DATETIME DEFAULT NOW(),
   
   FOREIGN KEY (owner_user_id) REFERENCES users (id)
   );
   
DROP TABLE IF EXISTS channel_subscribers;
CREATE TABLE channel_subscribers (
  channel_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  status ENUM('requested', 'joined', 'left'),
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
  
  PRIMARY KEY (user_id, channel_id),
  FOREIGN KEY (channel_id) REFERENCES channels (id),
  FOREIGN KEY (user_id) REFERENCES users (id)
);

DROP TABLE IF EXISTS channel_messages;
CREATE TABLE channel_messages (
   id SERIAL,
   channel_id BIGINT UNSIGNED NOT NULL,
   sender_id BIGINT UNSIGNED NOT NULL,
   media_type ENUM('text', 'image', 'audio', 'video') NOT NULL,
   body TEXT,
   file_name VARCHAR(200) NULL,
   created_at DATETIME DEFAULT NOW(),
   
   FOREIGN KEY (channel_id) REFERENCES channels (id),
   FOREIGN KEY (sender_id) REFERENCES users (id)
   );
   
DROP TABLE IF EXISTS saved_messages;
CREATE TABLE saved_messages (
   id SERIAL,
   user_id BIGINT UNSIGNED NOT NULL,
   body TEXT,
   created_at DATETIME DEFAULT NOW(),
   
   FOREIGN KEY (user_id) REFERENCES users (id)
   );
   
DROP TABLE IF EXISTS reactions_list;
CREATE TABLE reactions_list (
   id SERIAL,
   code VARCHAR(1)
   ) DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;
   
DROP TABLE IF EXISTS private_message_reactions;
CREATE TABLE private_message_reactions (
   reaction_id BIGINT UNSIGNED NOT NULL,
   message_id BIGINT UNSIGNED NOT NULL,
   user_id BIGINT UNSIGNED NOT NULL,
   
   FOREIGN KEY (reaction_id) REFERENCES reactions_list (id),
   FOREIGN KEY (message_id) REFERENCES private_messages (id),
   FOREIGN KEY (user_id) REFERENCES users (id)
   );
   
DROP TABLE IF EXISTS channel_message_reactions;
CREATE TABLE channel_message_reactions (
   reaction_id BIGINT UNSIGNED NOT NULL,
   message_id BIGINT UNSIGNED NOT NULL,
   user_id BIGINT UNSIGNED NOT NULL,
   
   FOREIGN KEY (reaction_id) REFERENCES reactions_list (id),
   FOREIGN KEY (message_id) REFERENCES channel_messages (id),
   FOREIGN KEY (user_id) REFERENCES users (id)
   );
   
DROP TABLE IF EXISTS group_message_reactions;
CREATE TABLE group_message_reactions (
   reaction_id BIGINT UNSIGNED NOT NULL,
   message_id BIGINT UNSIGNED NOT NULL,
   user_id BIGINT UNSIGNED NOT NULL,
   
   FOREIGN KEY (reaction_id) REFERENCES reactions_list (id),
   FOREIGN KEY (message_id) REFERENCES group_messages (id),
   FOREIGN KEY (user_id) REFERENCES users (id)
   );
   
DROP TABLE IF EXISTS stories;
CREATE TABLE stories (
   id SERIAL,
   user_id BIGINT UNSIGNED NOT NULL,
   captions VARCHAR(140),
   filename VARCHAR(100),
   views_count INT UNSIGNED,
   created_at DATETIME DEFAULT NOW(),
   
   FOREIGN KEY (user_id) REFERENCES users (id)
   );
   
DROP TABLE IF EXISTS stories_likes;
CREATE TABLE stories_likes (
   id SERIAL,
   stories_id BIGINT UNSIGNED NOT NULL,
   user_id BIGINT UNSIGNED NOT NULL,
   created_at DATETIME DEFAULT NOW(),
   
   
   FOREIGN KEY (stories_id) REFERENCES stories (id),
   FOREIGN KEY (user_id) REFERENCES users (id)
   );
   