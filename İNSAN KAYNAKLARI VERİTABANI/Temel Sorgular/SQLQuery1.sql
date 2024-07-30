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
