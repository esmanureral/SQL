
--CUSTOMERS �S�ML� B�R VER�TABANI OLU�TUR
--VER�TABANI ��ER�S�NDEK� TABLOLARI SQL KODU YAZARAK OLU�TUR.


CREATE DATABASE CUSTOMERS

CREATE TABLE CITIES(
ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
CITY VARCHAR(50)
)

CREATE TABLE DISTRICTS(
ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
CITYID INT,
DISTRICT VARCHAR(50)
)
CREATE TABLE CUSTOMERS(
ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
CUSTOMERNAME VARCHAR(100),
TCNUMBER VARCHAR(11),
GENDER VARCHAR(1),
EMAIL VARCHAR(100),
BIRTHDATE DATE,
CITYID INT,
DISTRICTID INT,
TELNR1 VARCHAR(15),
TELNR2 VARCHAR(15)
)