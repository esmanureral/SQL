--1.SORGU
/* Þirketimizde halen çalýþmaya devam eden çalýþanlarýn listesi*/

SELECT *FROM PERSON WHERE OUTDATE IS NULL

-----------------------------------------------------------------------------------------

--2.SORGU
/* Þirketimizde departman bazlý halen çalýþmaya devam Kadýn ve Erkek sayýlarý*/

SELECT D.DEPARTMENT,GENDER,COUNT(P.ID) AS PERSONCOUNT 
FROM PERSON P
INNER JOIN DEPARTMENT D ON D.ID=P.DEPARTMENTID
WHERE P.OUTDATE IS NULL
GROUP BY D.DEPARTMENT,GENDER
ORDER BY 1,2

--Bu sorguda cinsiyet K,E diye gelir.Kýz Erkek yazsýn istiyorsak aþaðýdaki gibi:

SELECT D.DEPARTMENT,
CASE
  WHEN P.GENDER='E' THEN 'ERKEK'
  WHEN P.GENDER='K' THEN 'KIZ'
END AS GENDER,
COUNT(P.ID) AS PERSONCOUNT 
FROM PERSON P
INNER JOIN DEPARTMENT D ON D.ID=P.DEPARTMENTID
WHERE P.OUTDATE IS NULL
GROUP BY D.DEPARTMENT,GENDER
ORDER BY 1,2

-----------------------------------------------------------------------------------------
--3.SORGU
/* Þirketimizde departman bazlý halen çalýþmaya devam Kadýn ve Erkek sayýlarý*/
--sütun þeklinde !!!!
--Joýn yapsak satýr tekrarý olur


SELECT *,
(SELECT COUNT(*) FROM PERSON WHERE DEPARTMENTID = D.ID AND GENDER = 'E' AND OUTDATE IS NULL) AS MALE_PERSONCOUNT,
(SELECT COUNT(*) FROM PERSON WHERE DEPARTMENTID = D.ID AND GENDER = 'K' AND OUTDATE IS NULL) AS FEMALE_PERSONCOUNT
FROM DEPARTMENT D
ORDER BY D.DEPARTMENT
