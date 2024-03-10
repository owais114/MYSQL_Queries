DELIMITER 
CREATE PROCEDURE `sp_insertgender` (IN _gender VARCHAR(6))
BEGIN
	INSERT INTO `tbl_gender` (`gender`) VALUES(_gender);
END;
DELIMITER 
CREATE PROCEDURE `sp_insertcountry` (IN _country VARCHAR(10))
BEGIN
	INSERT INTO `tbl_country` (`country`) VALUES(_country);
END;
DELIMITER 
CREATE PROCEDURE `sp_insertdesignation` (IN _designation VARCHAR(50))
BEGIN
	INSERT INTO `tbl_designation` (`designation`) VALUES(_designation);
END;
DELIMITER 
CREATE PROCEDURE `sp_displayrecords` (IN _tablename VARCHAR(50))
BEGIN
    DECLARE errornumber INTEGER;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET CURRENT DIAGNOSTICS CONDITION 1 errornumber = MYSQL_errno;
        #SELECT errornumber AS error_number;
        IF(errornumber <> 0) THEN
			SELECT 'no table found' AS `WARNING`;
		END IF;
		ROLLBACK;
    END;
    
    START TRANSACTION;
    SET @tablename = _tablename;
    SET @query = CONCAT('SELECT * FROM ',@tablename);
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    COMMIT;
END;
#DELIMITER $$
#DROP PROCEDURE `sp_insertdesignation`;
#SET autocommit = 0;
DELIMITER 
CREATE PROCEDURE `sp_insertuser` (IN _firstname VARCHAR(50), IN _lastname VARCHAR(50), IN _email VARCHAR(50), IN _gender VARCHAR(50),
								  IN _designation VARCHAR(50), IN _country VARCHAR(50) )
BEGIN
	DECLARE errornumber INTEGER;
	DECLARE errorFound BOOLEAN DEFAULT false;
	DECLARE designationexist INTEGER;
    DECLARE countryexist INTEGER;
    DECLARE genderid INTEGER;
    DECLARE designationid INTEGER;
    DECLARE countryid INTEGER;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET CURRENT DIAGNOSTICS CONDITION 1 errornumber = MYSQL_ERRNO;
		IF(errornumber <> 0) THEN
			SELECT 'only unique email is allowed' AS ERROR;
        END IF;
		ROLLBACK;
    END;
    
    SELECT COUNT(id) INTO designationexist FROM `tbl_designation` WHERE designation = _designation;
    SELECT COUNT(id) INTO countryexist FROM `tbl_country` WHERE country = _country;
    
    IF(designationExist = 0) THEN
		CALL `sp_insertdesignation` (_designation);
    END IF;
    
    IF(countryexist  = 0) THEN
		CALL `sp_insertcountry` (_country);
    END IF;
    
    SELECT id INTO genderid FROM `tbl_gender` WHERE gender = _gender;
    SELECT id INTO designationid FROM `tbl_designation` WHERE designation = _designation;
    SELECT id INTO countryid FROM `tbl_country` WHERE country = _country;
    
    START TRANSACTION;
	INSERT INTO `tbl_users` (`firstname`,`lastname`,`email`,`gender`,`designation`,`country`) VALUES(_firstname, _lastname, _email, genderid, designationid,
							countryid);
	COMMIT;
END;	

#DELIMITER $$
#DROP PROCEDURE `sp_insertuser`;