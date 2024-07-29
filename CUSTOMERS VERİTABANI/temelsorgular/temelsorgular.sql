SELECT *FROM CUSTOMERS

--1.SORGU
--CUSTOMERS TABLOSUNDAN ADI 'A' HARFÝ ÝLE BAÞLAYAN KÝÞÝLERÝ ÇEKEN SORGU
SELECT *FROM CUSTOMERS WHERE CUSTOMERNAME LIKE 'A%' --A% BAÞ HARFÝ A OLAN,%A SON HARFÝ A OLAN
------------------------------------------------------------------------------------------------------------------------------------------------------------------


--2.SORGU
--CUSTOMERS TABLOSUNDAN ADI 'A' HARFÝ ÝLE BAÞLAYAN ERKEK MÜÞTERÝLERÝ ÇEKEN SORGU
SELECT *FROM CUSTOMERS WHERE CUSTOMERNAME LIKE 'A%' AND GENDER='E'


------------------------------------------------------------------------------------------------------------------------------------------------------------------

--3.SORGU
--1990 VE 1995 YILLARI ARASINDA DOÐAN MÜÞTERÝLERÝ ÇEKÝN. 1990 VE 1995 DAHÝL
SELECT *FROM CUSTOMERS WHERE BIRTHDATE>='1990-01-01' AND BIRTHDATE<='1995-12-31'
SELECT *FROM CUSTOMERS WHERE BIRTHDATE BETWEEN '1990-01-01' AND '1995-12-31'
SELECT *FROM CUSTOMERS WHERE YEAR(BIRTHDATE) BETWEEN 1990 AND 1995


------------------------------------------------------------------------------------------------------------------------------------------------------------------

--4.SORGU
--ÝSTANBULDA YAÞAYAN KÝÞÝLERÝ JOÝN KULLANARAK GETÝREN SORGU
--(customers ve cýtýes tablosu arasýnda baðlantý var)
SELECT *FROM CUSTOMERS C INNER JOIN CITIES CT ON C.CITYID=CT.ID WHERE CT.CITY='ÝSTANBUL'

--ÝSTANBULDA YAÞAYAN KÝÞÝLERÝ SUBQUERY KULLANARAK GETÝREN SORGU
SELECT( SELECT CITY FROM CITIES WHERE ID=C.CITYID), *FROM CUSTOMERS C WHERE (SELECT CITY FROM CITIES WHERE ID=CITYID)='ÝSTANBUL'


------------------------------------------------------------------------------------------------------------------------------------------------------------------

--5.SORGU
--HANGÝ ÞEHÝRDE KAÇ MÜÞTERÝ OLDUÐU BÝLGÝSÝNÝ GETÝREN SORGU
SELECT CT.CITY,COUNT(C.ID) AS CUSTOMERCOUNT FROM CUSTOMERS C INNER JOIN CITIES CT ON CT.ID=C.CITYID GROUP BY CT.CITY
SELECT *,(SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID=CT.ID) AS CUSTOMERCOUNT FROM CITIES CT
--(inner join dediði için her iki tabloda olan kayýtlarý gösterir)


------------------------------------------------------------------------------------------------------------------------------------------------------------------

--6.SORGU
--10'DAN FAZLA MÜÞTERÝMÝZ OLAN ÞEHÝRLERÝ MÜÞTERÝ SAYISI ÝLE BÝRLÝKTE FAZLADAN AZA DOÐRU SIRALA
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
--HANGÝ ÞEHÝRDE KAÇ ERKEK,KAÇ KADIN MÜÞTERÝSÝ VAR?
SELECT
CT.CITY,C.GENDER,COUNT(C.ID) AS CUSTOMERCOUNT
FROM CUSTOMERS C INNER JOIN CITIES CT ON CT.ID=C.CITYID
GROUP BY CT.CITY,C.GENDER
ORDER BY CT.CITY,C.GENDER --bu satýr KE-KE diye sýrayla birleþtiriyor.


------------------------------------------------------------------------------------------------------------------------------------------------------------------

--8.SORGU
--HANGÝ ÞEHÝRDE KAÇ ERKEK,KAÇ KADIN MÜÞTERÝSÝ VAR?(2 FARKLI SUTUN)

--joýn kullanamayýz 2 satýr gelsin deðil sütuna gitsin istoruz

SELECT CITY AS SEHIRADI,
(SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID=C.ID) AS MUSTERISAYISI,
(SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID=C.ID AND GENDER='E') AS ERKEKSAYISI,
(SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID=C.ID AND GENDER='K') AS KADINSAYISI,
*FROM  CITIES C


------------------------------------------------------------------------------------------------------------------------------------------------------------------

--9.SORGU/GÖREV
--CUSTOMERS TABLOSUNA YAÞ GRUBU ÝÇÝN BÝR ALAN(SÜTUN) EKLE SQL KOMUTU ÝLE YAP ALAN ADI=AGEGROUP

--ALTER:SQL DEÐÝÞTÝRME

ALTER TABLE CUSTOMERS ADD AGEGROUP VARCHAR(50)
SELECT *FROM CUSTOMERS



------------------------------------------------------------------------------------------------------------------------------------------------------------------

--10.SORGU/GÖREV
/**CUSTOMERS TABLOSUNA EKLEDÐÝMÝZ AGEGROUP ALANINI 20-35 YAÞ ARASI,
36-45,46-55,55-65 VE 65 YAÞ ÜSTÜ OLARAK GÜNCELLE

:yaþ almamýz gerekiyor bugunun yýlýndan doðum yýllarýný çýkartmamýz gerekiyor.
--DATEDIFF:iki tarih farký
**/
UPDATE CUSTOMERS SET AGEGROUP='65 YAÞ USTU'
WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE())>65

UPDATE CUSTOMERS SET AGEGROUP='36-45 YAÞ'
WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 36 AND 45

SELECT *,DATEDIFF(YEAR,BIRTHDATE,GETDATE()) FROM CUSTOMERS



------------------------------------------------------------------------------------------------------------------------------------------------------------------

--11.SORGU/GÖREV
--CUSTOMERS TABLOSUNDA MÜÞTERÝNÝN YAÞINA GÖRE HESAPLA:

SELECT AGEGROUP,COUNT(*)FROM CUSTOMERS
GROUP BY AGEGROUP

--AGEGROUP ALANI KULLANILMADAN:
SELECT AGEGROUP2,COUNT(TMP.ID)AS CUSTOMERCOUNT FROM
(
SELECT *,
CASE
WHEN DATEDIFF (YEAR,BIRTHDATE,GETDATE()) BETWEEN 20 AND 35 THEN '20-35 YAÞ ARASI'
WHEN DATEDIFF (YEAR,BIRTHDATE,GETDATE()) BETWEEN 36 AND 45 THEN '36-45 YAÞ ARASI'
WHEN DATEDIFF (YEAR,BIRTHDATE,GETDATE()) BETWEEN 46 AND 55 THEN '46-55 YAÞ ARASI'
WHEN DATEDIFF (YEAR,BIRTHDATE,GETDATE()) BETWEEN 56 AND 65 THEN '56-65 YAÞ ARASI'
WHEN DATEDIFF (YEAR,BIRTHDATE,GETDATE())>65 THEN '65 YAÞ ÜSTÜ'
END AGEGROUP2
FROM CUSTOMERS
)TMP
GROUP BY AGEGROUP2

------------------------------------------------------------------------------------------------------------------------------------------------------------------

--12.SORGU
--ÝSTANBULDA YAÞAYIP ÝLÇESÝ KADIKÖY DIÞINDA OLANLARI LÝSTELE
--1.YÖNTEM JOIN:
SELECT *FROM CUSTOMERS C 
INNER JOIN CITIES CT ON CT.ID=CITYID
INNER JOIN DISTRICTS D ON D.ID=C.DISTRICTID
WHERE CT.CITY='ÝSTANBUL' AND D.DISTRICT NOT IN('KADIKÖY')

--2.YONTEM
SELECT *FROM CUSTOMERS
WHERE CITYID IN(SELECT ID FROM CITIES WHERE CITY='ÝSTANBUL')
AND DISTRICTID NOT IN (SELECT ID FROM DISTRICTS WHERE DISTRICT='KADIKÖY')

------------------------------------------------------------------------------------------------------------------------------------------------------------------

--13.SORGU
/**CÝTÝES tablosundan "Ankara" kaydý sildiðimizi varsayalým
Ankara olan müþterilerin þehir alaný boþ gelecektir.Þehir alaný
boþ olan müþterileri listeleyen sorgu:**/

SELECT*FROM CITIES
SELECT *FROM CUSTOMERS WHERE CITYID=6

SELECT *FROM CUSTOMERS C INNER JOIN CITIES CT ON CT.ID=C.CITYID WHERE
CT.CITY='ANKARA'

DELETE FROM CITIES WHERE CITY='ANKARA'
SELECT*FROM CITIES

/** =NULL deðil is NULL kullanmalýyýz.**/

SELECT *FROM CUSTOMERS C LEFT JOIN CITIES CT ON CT.ID=C.CITYID WHERE CT.CITY IS NULL

SELECT *FROM CUSTOMERS C LEFT JOIN CITIES CT ON CT.ID=CITYID WHERE CT.CITY IS NULL

-- ÝSTANBULDAKÝNÝ DE SÝLELÝM :

DELETE FROM CITIES WHERE CITY='ÝSTANBUL'
SELECT *FROM CUSTOMERS C LEFT JOIN CITIES CT ON CT.ID=CITYID WHERE CT.CITY IS NULL


------------------------------------------------------------------------------------------------------------------------------------------------------------------

--14.SORGU
/** CITIES TABLOSUNDAN SÝLMÝÞ OLDUÐUMUZ ANKARA VE ÝSTANBUL KAYITLARINI AYNI IDLERÝ ALACAK
ÞEKÝLDE YENÝDEN TABLOYA INSERT EDÝNÝZ**/

SET IDENTITY_INSERT CITIES ON  --bunu yazmadan aðaþýdaki çalýþmýyor.

INSERT INTO CITIES(ID,CITY) 
VALUES (6,'ANKARA')

INSERT INTO CITIES(ID,CITY) 
VALUES (34,'iSTANBUL')

SELECT *FROM CUSTOMERS

------------------------------------------------------------------------------------------------------------------------------------------------------------------
--15.SORGU

/** Müþterilerimizin TELNR1 ve TELNR2 ÖPERATÖR (532),(505) bilgisini getirin

SUBSTRING KULLANIMI ***



SELECT *FROM CUSTOMERS**/

--1.yöntem
SELECT SUBSTRING('(542)5667453',1,5)
--2.yöntem
SELECT LEFT('(542)5667453',5)

--ASIL YÖNTEM
 SElECT *,
 SUBSTRING (TELNR1,1,5) AS OPERATOR1,
 SUBSTRING(TELNR2,1,5) AS OPERATOR2
 FROM CUSTOMERS

 ------------------------------------------------------------------------------------------------------------------------------------------------------------------

 --16.SORGU
 /** Her ilde en çok müþteriye sahip olduðumuz ilçeleri müþteri sayýsýna göre çoktan aza sýrala*//


 SELECT CT.CITY,D.DISTRICT,COUNT(C.ID) AS CUSTOMERCOUNT
 FROM CUSTOMERS C
 INNER JOIN CITIES CT ON CT.ID=C.CITYID
 INNER JOIN DISTRICTS D ON D.ID=C.DISTRICTID
 GROUP BY CT.CITY,D.DISTRICT
 --ORDER BY CT.CITY,COUNT(C.ID) DESC
 ORDER BY 1,3 DESC

 -----------------------------------------------------------------------------------------------------------------------------------------------------------------

 --17.SORGU
 /**Müþterilerin doðum gðnlerini haftanýn günü olarak getir**/
 
 -- DATENAME(MONTH,BIRTHDATE),BIRTHADATE, : ing olarak ay isimlerini getirir

 SET LANGUAGE Turkish --turkçe yazdýrýr.
 SELECT  CUSTOMERNAME,DATENAME (DW,BIRTHDATE)AS GUNÝSMÝ ,BIRTHDATE FROM CUSTOMERS

 ----------------------------------------------------------------------------------------------------------------------------------------------------------------
 --18.SORGU
 /**Doðum günü bugun olan müþteriler**/

 SELECT * FROM CUSTOMERS
 WHERE MONTH(BIRTHDATE)=MONTH(GETDATE())
 AND
 DAY(BIRTHDATE)=DAY(GETDATE())