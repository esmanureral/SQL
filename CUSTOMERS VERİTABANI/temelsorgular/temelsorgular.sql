SELECT *FROM CUSTOMERS

--1.SORGU
--CUSTOMERS TABLOSUNDAN ADI 'A' HARF� �LE BA�LAYAN K���LER� �EKEN SORGU
SELECT *FROM CUSTOMERS WHERE CUSTOMERNAME LIKE 'A%' --A% BA� HARF� A OLAN,%A SON HARF� A OLAN
------------------------------------------------------------------------------------------------------------------------------------------------------------------


--2.SORGU
--CUSTOMERS TABLOSUNDAN ADI 'A' HARF� �LE BA�LAYAN ERKEK M��TER�LER� �EKEN SORGU
SELECT *FROM CUSTOMERS WHERE CUSTOMERNAME LIKE 'A%' AND GENDER='E'


------------------------------------------------------------------------------------------------------------------------------------------------------------------

--3.SORGU
--1990 VE 1995 YILLARI ARASINDA DO�AN M��TER�LER� �EK�N. 1990 VE 1995 DAH�L
SELECT *FROM CUSTOMERS WHERE BIRTHDATE>='1990-01-01' AND BIRTHDATE<='1995-12-31'
SELECT *FROM CUSTOMERS WHERE BIRTHDATE BETWEEN '1990-01-01' AND '1995-12-31'
SELECT *FROM CUSTOMERS WHERE YEAR(BIRTHDATE) BETWEEN 1990 AND 1995


------------------------------------------------------------------------------------------------------------------------------------------------------------------

--4.SORGU
--�STANBULDA YA�AYAN K���LER� JO�N KULLANARAK GET�REN SORGU
--(customers ve c�t�es tablosu aras�nda ba�lant� var)
SELECT *FROM CUSTOMERS C INNER JOIN CITIES CT ON C.CITYID=CT.ID WHERE CT.CITY='�STANBUL'

--�STANBULDA YA�AYAN K���LER� SUBQUERY KULLANARAK GET�REN SORGU
SELECT( SELECT CITY FROM CITIES WHERE ID=C.CITYID), *FROM CUSTOMERS C WHERE (SELECT CITY FROM CITIES WHERE ID=CITYID)='�STANBUL'


------------------------------------------------------------------------------------------------------------------------------------------------------------------

--5.SORGU
--HANG� �EH�RDE KA� M��TER� OLDU�U B�LG�S�N� GET�REN SORGU
SELECT CT.CITY,COUNT(C.ID) AS CUSTOMERCOUNT FROM CUSTOMERS C INNER JOIN CITIES CT ON CT.ID=C.CITYID GROUP BY CT.CITY
SELECT *,(SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID=CT.ID) AS CUSTOMERCOUNT FROM CITIES CT
--(inner join dedi�i i�in her iki tabloda olan kay�tlar� g�sterir)


------------------------------------------------------------------------------------------------------------------------------------------------------------------

--6.SORGU
--10'DAN FAZLA M��TER�M�Z OLAN �EH�RLER� M��TER� SAYISI �LE B�RL�KTE FAZLADAN AZA DO�RU SIRALA
--(1.YOL JOIN):
SELECT CT.CITY,COUNT(C.ID)AS CUSTOMERCOUNT FROM CUSTOMERS C 
INNER JOIN CITIES CT ON CT.ID=C.CITYID
GROUP BY CT.CITY
HAVING COUNT(C.ID)>10
ORDER BY COUNT(C.ID) DESC

--(2.YOL SUBQUERY):
SELECT *,
(SELECT COUNT(*)FROM CUSTOMERS WHERE CITYID=C.ID) FROM CITIES C
WHERE
(SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID=C.ID)>10


------------------------------------------------------------------------------------------------------------------------------------------------------------------

--7.SORGU
--HANG� �EH�RDE KA� ERKEK,KA� KADIN M��TER�S� VAR?
SELECT
CT.CITY,C.GENDER,COUNT(C.ID) AS CUSTOMERCOUNT
FROM CUSTOMERS C INNER JOIN CITIES CT ON CT.ID=C.CITYID
GROUP BY CT.CITY,C.GENDER
ORDER BY CT.CITY,C.GENDER --bu sat�r KE-KE diye s�rayla birle�tiriyor.


------------------------------------------------------------------------------------------------------------------------------------------------------------------

--8.SORGU
--HANG� �EH�RDE KA� ERKEK,KA� KADIN M��TER�S� VAR?(2 FARKLI SUTUN)

--jo�n kullanamay�z 2 sat�r gelsin de�il s�tuna gitsin istoruz

SELECT CITY AS SEHIRADI,
(SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID=C.ID) AS MUSTERISAYISI,
(SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID=C.ID AND GENDER='E') AS ERKEKSAYISI,
(SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID=C.ID AND GENDER='K') AS KADINSAYISI,
*FROM  CITIES C


------------------------------------------------------------------------------------------------------------------------------------------------------------------

--9.SORGU/G�REV
--CUSTOMERS TABLOSUNA YA� GRUBU ���N B�R ALAN(S�TUN) EKLE SQL KOMUTU �LE YAP ALAN ADI=AGEGROUP

--ALTER:SQL DE���T�RME

ALTER TABLE CUSTOMERS ADD AGEGROUP VARCHAR(50)
SELECT *FROM CUSTOMERS



------------------------------------------------------------------------------------------------------------------------------------------------------------------

--10.SORGU/G�REV
/**CUSTOMERS TABLOSUNA EKLED��M�Z AGEGROUP ALANINI 20-35 YA� ARASI,
36-45,46-55,55-65 VE 65 YA� �ST� OLARAK G�NCELLE

:ya� almam�z gerekiyor bugunun y�l�ndan do�um y�llar�n� ��kartmam�z gerekiyor.
--DATEDIFF:iki tarih fark�
**/
UPDATE CUSTOMERS SET AGEGROUP='65 YA� USTU'
WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE())>65

UPDATE CUSTOMERS SET AGEGROUP='36-45 YA�'
WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 36 AND 45

SELECT *,DATEDIFF(YEAR,BIRTHDATE,GETDATE()) FROM CUSTOMERS



------------------------------------------------------------------------------------------------------------------------------------------------------------------

--11.SORGU/G�REV
--CUSTOMERS TABLOSUNDA M��TER�N�N YA�INA G�RE HESAPLA:

SELECT AGEGROUP,COUNT(*)FROM CUSTOMERS
GROUP BY AGEGROUP

--AGEGROUP ALANI KULLANILMADAN:
SELECT AGEGROUP2,COUNT(TMP.ID)AS CUSTOMERCOUNT FROM
(
SELECT *,
CASE
WHEN DATEDIFF (YEAR,BIRTHDATE,GETDATE()) BETWEEN 20 AND 35 THEN '20-35 YA� ARASI'
WHEN DATEDIFF (YEAR,BIRTHDATE,GETDATE()) BETWEEN 36 AND 45 THEN '36-45 YA� ARASI'
WHEN DATEDIFF (YEAR,BIRTHDATE,GETDATE()) BETWEEN 46 AND 55 THEN '46-55 YA� ARASI'
WHEN DATEDIFF (YEAR,BIRTHDATE,GETDATE()) BETWEEN 56 AND 65 THEN '56-65 YA� ARASI'
WHEN DATEDIFF (YEAR,BIRTHDATE,GETDATE())>65 THEN '65 YA� �ST�'
END AGEGROUP2
FROM CUSTOMERS
)TMP
GROUP BY AGEGROUP2

------------------------------------------------------------------------------------------------------------------------------------------------------------------

--12.SORGU
--�STANBULDA YA�AYIP �L�ES� KADIK�Y DI�INDA OLANLARI L�STELE
--1.Y�NTEM JOIN:
SELECT *FROM CUSTOMERS C 
INNER JOIN CITIES CT ON CT.ID=CITYID
INNER JOIN DISTRICTS D ON D.ID=C.DISTRICTID
WHERE CT.CITY='�STANBUL' AND D.DISTRICT NOT IN('KADIK�Y')

--2.YONTEM
SELECT *FROM CUSTOMERS
WHERE CITYID IN(SELECT ID FROM CITIES WHERE CITY='�STANBUL')
AND DISTRICTID NOT IN (SELECT ID FROM DISTRICTS WHERE DISTRICT='KADIK�Y')

------------------------------------------------------------------------------------------------------------------------------------------------------------------

--13.SORGU
/**C�T�ES tablosundan "Ankara" kayd� sildi�imizi varsayal�m
Ankara olan m��terilerin �ehir alan� bo� gelecektir.�ehir alan�
bo� olan m��terileri listeleyen sorgu:**/

SELECT*FROM CITIES
SELECT *FROM CUSTOMERS WHERE CITYID=6

SELECT *FROM CUSTOMERS C INNER JOIN CITIES CT ON CT.ID=C.CITYID WHERE
CT.CITY='ANKARA'

DELETE FROM CITIES WHERE CITY='ANKARA'
SELECT*FROM CITIES

/** =NULL de�il is NULL kullanmal�y�z.**/

SELECT *FROM CUSTOMERS C LEFT JOIN CITIES CT ON CT.ID=C.CITYID WHERE CT.CITY IS NULL

SELECT *FROM CUSTOMERS C LEFT JOIN CITIES CT ON CT.ID=CITYID WHERE CT.CITY IS NULL

-- �STANBULDAK�N� DE S�LEL�M :

DELETE FROM CITIES WHERE CITY='�STANBUL'
SELECT *FROM CUSTOMERS C LEFT JOIN CITIES CT ON CT.ID=CITYID WHERE CT.CITY IS NULL


------------------------------------------------------------------------------------------------------------------------------------------------------------------

--14.SORGU
/** CITIES TABLOSUNDAN S�LM�� OLDU�UMUZ ANKARA VE �STANBUL KAYITLARINI AYNI IDLER� ALACAK
�EK�LDE YEN�DEN TABLOYA INSERT ED�N�Z**/

SET IDENTITY_INSERT CITIES ON  --bunu yazmadan a�a��daki �al��m�yor.

INSERT INTO CITIES(ID,CITY) 
VALUES (6,'ANKARA')

INSERT INTO CITIES(ID,CITY) 
VALUES (34,'iSTANBUL')

SELECT *FROM CUSTOMERS

------------------------------------------------------------------------------------------------------------------------------------------------------------------
--15.SORGU

/** M��terilerimizin TELNR1 ve TELNR2 �PERAT�R (532),(505) bilgisini getirin

SUBSTRING KULLANIMI ***



SELECT *FROM CUSTOMERS**/

--1.y�ntem
SELECT SUBSTRING('(542)5667453',1,5)
--2.y�ntem
SELECT LEFT('(542)5667453',5)

--ASIL Y�NTEM
 SElECT *,
 SUBSTRING (TELNR1,1,5) AS OPERATOR1,
 SUBSTRING(TELNR2,1,5) AS OPERATOR2
 FROM CUSTOMERS

 ------------------------------------------------------------------------------------------------------------------------------------------------------------------

 --16.SORGU
 /** Her ilde en �ok m��teriye sahip oldu�umuz il�eleri m��teri say�s�na g�re �oktan aza s�rala*//


 SELECT CT.CITY,D.DISTRICT,COUNT(C.ID) AS CUSTOMERCOUNT
 FROM CUSTOMERS C
 INNER JOIN CITIES CT ON CT.ID=C.CITYID
 INNER JOIN DISTRICTS D ON D.ID=C.DISTRICTID
 GROUP BY CT.CITY,D.DISTRICT
 --ORDER BY CT.CITY,COUNT(C.ID) DESC
 ORDER BY 1,3 DESC

 -----------------------------------------------------------------------------------------------------------------------------------------------------------------

 --17.SORGU
 /**M��terilerin do�um g�nlerini haftan�n g�n� olarak getir**/
 
 -- DATENAME(MONTH,BIRTHDATE),BIRTHADATE, : ing olarak ay isimlerini getirir

 SET LANGUAGE Turkish --turk�e yazd�r�r.
 SELECT  CUSTOMERNAME,DATENAME (DW,BIRTHDATE)AS GUN�SM� ,BIRTHDATE FROM CUSTOMERS

 ----------------------------------------------------------------------------------------------------------------------------------------------------------------
 --18.SORGU
 /**Do�um g�n� bugun olan m��teriler**/

 SELECT * FROM CUSTOMERS
 WHERE MONTH(BIRTHDATE)=MONTH(GETDATE())
 AND
 DAY(BIRTHDATE)=DAY(GETDATE())