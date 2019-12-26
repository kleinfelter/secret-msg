drop database if exists shhh;
create database shhh;
CREATE OR REPLACE USER shhh@localhost IDENTIFIED BY 'shhh123';
GRANT ALL PRIVILEGES ON shhh.* TO 'shhh'@'localhost';
FLUSH PRIVILEGES;

use shhh;

CREATE TABLE IF NOT EXISTS `links` (
  `slug_link` text,
  `passphrase` text,
  `encrypted_text` text,
  `date_created` datetime DEFAULT NULL,
  `date_expires` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET GLOBAL event_scheduler = ON;

CREATE EVENT IF NOT EXISTS AutoDeleteExpiredRecords
ON SCHEDULE
EVERY 2 HOUR
DO
  DELETE FROM `links` WHERE `date_expires` <= now();
