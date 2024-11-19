/* LAB 2: 11/11/2024
   Create a database 'hr' and the following tables:
   - country(country_id(PK), country_name, region_id(FK - Future))
   - department(department_id(PK), department_name, manager_id, location_id(FK))
   - employee(employee_id(PK), first_name, last_name, email, phone_number, hire_date, job_id(FK), salary, commission_pct, manager_id(FK), department_id(FK))
   - job_history(employee_id(PK, FK), start_date(PK), end_date(PK), job_id(FK), department_id(FK))
   - job(job_id(PK), job_title, min_salary, max_salary)
   - location(location_id(PK), street_address, postal_code, city, state_province, country_id(FK))
   - job_grade(grade_level(PK), lowest_sal, highest_sal) [Wil be dropped in LAB3]
*/


/* 1st step: create a database 'hr' */
CREATE DATABASE IF NOT EXISTS HR;

/*tell which database you will use*/
USE HR;

CREATE TABLE IF NOT EXISTS `country` (
  `COUNTRY_ID` varchar(2) NOT NULL,
  `COUNTRY_NAME` varchar(40) DEFAULT NULL,
  `REGION_ID` TINYINT DEFAULT NULL,
  PRIMARY KEY (`COUNTRY_ID`)
);


CREATE TABLE IF NOT EXISTS `department` (
  `DEPARTMENT_ID` INTEGER NOT NULL DEFAULT 0,
  `DEPARTMENT_NAME` varchar(30) NOT NULL,
  `MANAGER_ID` INTEGER DEFAULT NULL,
  `LOCATION_ID` INTEGER DEFAULT NULL,
  PRIMARY KEY (`DEPARTMENT_ID`)
) ;


CREATE TABLE IF NOT EXISTS `employee` (
  `EMPLOYEE_ID` INTEGER NOT NULL DEFAULT 0,
  `FIRST_NAME` varchar(20) DEFAULT NULL,
  `LAST_NAME` varchar(25) NOT NULL,
  `EMAIL` varchar(25) NOT NULL,
  `PHONE_NUMBER` varchar(20) DEFAULT NULL,
  `HIRE_DATE` date NOT NULL,
  `JOB_ID` varchar(10) NOT NULL,
  `SALARY` decimal(8,2) DEFAULT NULL,
  `COMMISSION_PCT` decimal(2,2) DEFAULT NULL,
  `MANAGER_ID` INTEGER DEFAULT NULL,
  `DEPARTMENT_ID` INTEGER DEFAULT NULL,
  PRIMARY KEY (`EMPLOYEE_ID`)
) ;

CREATE TABLE IF NOT EXISTS `job_history` (
  `EMPLOYEE_ID` INTEGER NOT NULL,
  `START_DATE` date NOT NULL,
  `END_DATE` date NOT NULL,
  `JOB_ID` VARCHAR(15) NOT NULL,
  `DEPARTMENT_ID` INTEGER DEFAULT NULL,
  PRIMARY KEY (`EMPLOYEE_ID`,`START_DATE`)
) ;

CREATE TABLE IF NOT EXISTS `job` (
  `JOB_ID` VARCHAR(15) NOT NULL,
  `JOB_TITLE` varchar(35) NOT NULL,
  `MIN_SALARY` decimal(6,0) DEFAULT NULL,
  `MAX_SALARY` decimal(6,0) DEFAULT NULL,
  PRIMARY KEY (`JOB_ID`)
) ;


CREATE TABLE IF NOT EXISTS `location` (
  `LOCATION_ID` INTEGER NOT NULL DEFAULT '0',
  `STREET_ADDRESS` varchar(40) DEFAULT NULL,
  `POSTAL_CODE` varchar(12) DEFAULT NULL,
  `CITY` varchar(30) NOT NULL,
  `STATE_PROVINCE` varchar(25) DEFAULT NULL,
  `COUNTRY_ID` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`LOCATION_ID`)
) ;


CREATE TABLE IF NOT EXISTS `job_grade` (
  `GRADE_LEVEL` varchar(20) NOT NULL,
  `LOWEST_SAL` decimal(6,0) DEFAULT NULL,
  `HIGHEST_SAL` decimal(6,0) DEFAULT NULL,
  PRIMARY KEY (`GRADE_LEVEL`)
) ;
