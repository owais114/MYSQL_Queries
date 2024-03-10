#CREATE DATABASE `users`;
#DROP DATABASE `users`;
CREATE DATABASE `db_users`;
USE `db_users`;
CREATE TABLE `tbl_users`
(
	id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
    firstname VARCHAR(15) NOT NULL,
    middlename VARCHAR(50),
    lastname VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    designation INTEGER NOT NULL,
    gender INTEGER NOT NULL
);
ALTER TABLE `tbl_users` RENAME TO `tbl_user`;
ALTER TABLE `tbl_user` RENAME TO `tbl_users`;
ALTER TABLE `tbl_users` ADD COLUMN `country` INTEGER NOT NULL;
DESCRIBE `tbl_users`;

ALTER TABLE `tbl_users` AUTO_INCREMENT = 1;
SET @@auto_increment_increment = 1;

CREATE TABLE `tbl_gender`
(
	id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
    gender VARCHAR(50) NOT NULL
);

CREATE TABLE `tbl_country`(
	id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
	country VARCHAR(50) NOT NULL
);

CREATE TABLE `tbl_designation`
(
	id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
    designation VARCHAR(50) NOT NULL
);
SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'db_users'; 
ALTER TABLE `tbl_users` ADD CONSTRAINT fk_users_gender FOREIGN KEY (`gender`) REFERENCES `tbl_gender` (`id`);
ALTER TABLE `tbl_users` ADD CONSTRAINT fk_users_country FOREIGN KEY (`country`) REFERENCES `tbl_country` (`id`);
ALTER TABLE `tbl_users` ADD CONSTRAINT fk_users_designation FOREIGN KEY (`designation`) REFERENCES `tbl_designation` (`id`);

DESCRIBE `tbl_users`;

SELECT TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME, REFERENCED_COLUMN_NAME, REFERENCED_TABLE_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_NAME = 'tbl_users';

ALTER TABLE `tbl_users` ADD CONSTRAINT `uk_users_email` UNIQUE (`email`);
ALTER TABLE `tbl_users` DROP CONSTRAINT `email`;

CALL `sp_insertgender` ('Male');
CALL `sp_insertgender` ('Female');

CALL `sp_displayrecords` ('tbl_designation');
CALL `sp_insertdesignation` ('Software Engineer');

INSERT INTO `tbl_country` (`country`) VALUES('Afghanistan'), ('Algeria'), ('Bahamas'), ('Armenia');

CALL `sp_insertuser` ('saad','jawed','saadjawed@gmail.com','Male','Software Engineer','UK');

SELECT * FROM `tbl_users`;
SELECT * FROM `tbl_country`;

DELETE FROM `tbl_country` WHERE id = 8;

DELIMITER 
SET @query = 'SELECT * FROM tbl_users WHERE firstname = ?';
SET @firstname = 'faizan';
PREPARE preparedstmt FROM @query;
EXECUTE preparedstmt USING @firstname;
