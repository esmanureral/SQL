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

-----------------------------------------------------------------------------------------

--4.SORGU
/*þirketimizin planlama departmanýna yeni bir þef atamasý yapýldý maaþý belirlemek istiyoruz.
planlama departmaný için min,max,ort þef maaþý getiren sorgu (iþten çýkmýþlar dahil)*/

SELECT 
POS.DEPARTMENT,MIN(P.SALARY) AS MIN_SALARY,
MAX(P.SALARY) AS MAX_SALARY,
AVG(P.SALARY) AS AVG_SALARY
FROM POSITION POS
INNER JOIN PERSON P ON P.POSITIONID = POS.ID
WHERE POS.DEPARTMENT = 'PLANLAMA ÞEFÝ'
GROUP BY POS.DEPARTMENT


SELECT 
POS.DEPARTMENT,
(SELECT MIN(SALARY) FROM PERSON WHERE POSITIONID=POS.ID) AS MIN_SALARY,
(SELECT MAX(SALARY) FROM PERSON WHERE POSITIONID=POS.ID) AS MAX_SALARY,
(SELECT ROUND(AVG(SALARY),0) FROM PERSON WHERE POSITIONID=POS.ID) AS AVG_SALARY
FROM POSITION POS
WHERE POS.DEPARTMENT='PLANLAMA ÞEFÝ'


-----------------------------------------------------------------------------------------

--5.SORGU
/* Her bir pozisyonda mevcut halde çaliþanlar olarak kaç kiþi ve ortalama maaþlarýn
ne kadar oldugunu listelettir*/

SELECT POS.DEPARTMENT,
(SELECT COUNT(*) FROM PERSON WHERE POSITIONID=POS.ID)AS PERSONCOUNT,
(SELECT ROUND (AVG(SALARY),0) FROM PERSON WHERE POSITIONID=POS.ID)AS AVG_SALARY
FROM POSITION POS 
ORDER BY POS.DEPARTMENT

