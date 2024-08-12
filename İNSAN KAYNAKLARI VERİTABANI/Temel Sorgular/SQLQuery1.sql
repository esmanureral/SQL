--1.SORGU
/* �irketimizde halen �al��maya devam eden �al��anlar�n listesi*/

SELECT *FROM PERSON WHERE OUTDATE IS NULL

-----------------------------------------------------------------------------------------

--2.SORGU
/* �irketimizde departman bazl� halen �al��maya devam Kad�n ve Erkek say�lar�*/

SELECT D.DEPARTMENT,GENDER,COUNT(P.ID) AS PERSONCOUNT 
FROM PERSON P
INNER JOIN DEPARTMENT D ON D.ID=P.DEPARTMENTID
WHERE P.OUTDATE IS NULL
GROUP BY D.DEPARTMENT,GENDER
ORDER BY 1,2

--Bu sorguda cinsiyet K,E diye gelir.K�z Erkek yazs�n istiyorsak a�a��daki gibi:

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
/* �irketimizde departman bazl� halen �al��maya devam Kad�n ve Erkek say�lar�*/
--s�tun �eklinde !!!!
--Jo�n yapsak sat�r tekrar� olur


SELECT *,
(SELECT COUNT(*) FROM PERSON WHERE DEPARTMENTID = D.ID AND GENDER = 'E' AND OUTDATE IS NULL) AS MALE_PERSONCOUNT,
(SELECT COUNT(*) FROM PERSON WHERE DEPARTMENTID = D.ID AND GENDER = 'K' AND OUTDATE IS NULL) AS FEMALE_PERSONCOUNT
FROM DEPARTMENT D
ORDER BY D.DEPARTMENT

-----------------------------------------------------------------------------------------

--4.SORGU
/*�irketimizin planlama departman�na yeni bir �ef atamas� yap�ld� maa�� belirlemek istiyoruz.
planlama departman� i�in min,max,ort �ef maa�� getiren sorgu (i�ten ��km��lar dahil)*/

SELECT 
POS.DEPARTMENT,MIN(P.SALARY) AS MIN_SALARY,
MAX(P.SALARY) AS MAX_SALARY,
AVG(P.SALARY) AS AVG_SALARY
FROM POSITION POS
INNER JOIN PERSON P ON P.POSITIONID = POS.ID
WHERE POS.DEPARTMENT = 'PLANLAMA �EF�'
GROUP BY POS.DEPARTMENT


SELECT 
POS.DEPARTMENT,
(SELECT MIN(SALARY) FROM PERSON WHERE POSITIONID=POS.ID) AS MIN_SALARY,
(SELECT MAX(SALARY) FROM PERSON WHERE POSITIONID=POS.ID) AS MAX_SALARY,
(SELECT ROUND(AVG(SALARY),0) FROM PERSON WHERE POSITIONID=POS.ID) AS AVG_SALARY
FROM POSITION POS
WHERE POS.DEPARTMENT='PLANLAMA �EF�'


-----------------------------------------------------------------------------------------

--5.SORGU
/* Her bir pozisyonda mevcut halde �ali�anlar olarak ka� ki�i ve ortalama maa�lar�n
ne kadar oldugunu listelettir*/

SELECT POS.DEPARTMENT,
(SELECT COUNT(*) FROM PERSON WHERE POSITIONID=POS.ID)AS PERSONCOUNT,
(SELECT ROUND (AVG(SALARY),0) FROM PERSON WHERE POSITIONID=POS.ID)AS AVG_SALARY
FROM POSITION POS 
ORDER BY POS.DEPARTMENT

