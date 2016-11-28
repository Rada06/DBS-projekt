-- 2.1 Vytvoreni databaze a tabulek
CREATE DATABASE Znamky
GO

USE Znamky
GO

CREATE TABLE Student
(
  id_student int identity(1, 1),
  jmeno varchar(50),
  prijmeni varchar (50),
  CONSTRAINT PK_Tabulka_Student PRIMARY KEY (id_student)
)
GO

CREATE TABLE Predmet
(
  id_predmet int identity(1, 1),
  nazev varchar(50),
  CONSTRAINT PK_Tabulka_Predmet PRIMARY KEY (id_predmet)
)
GO

CREATE TABLE Ucitel
(
  id_ucitel int identity(1, 1),
  jmeno varchar(50),
  prijmeni varchar (50),
  CONSTRAINT PK_Tabulka_Ucitel PRIMARY KEY (id_ucitel)
)
GO

CREATE TABLE Vyucujici
(
  id_ucitel int,
  id_predmet int,
  CONSTRAINT PK_Tabulka_Vyucujici PRIMARY KEY (id_ucitel, id_predmet),
  CONSTRAINT FK_Vyucujici_Ucitel FOREIGN KEY (id_ucitel)
  REFERENCES Ucitel (id_ucitel),
  CONSTRAINT FK_Vyucujici_Predmet FOREIGN KEY (id_predmet)
  REFERENCES Predmet (id_predmet)
 )
GO

CREATE TABLE Znamka
(
  id_student int, 
  id_predmet int,
  id_ucitel int,
  body int,
  CONSTRAINT PK_Tabulka_Znamka PRIMARY KEY (id_student, id_ucitel, id_predmet),
  CONSTRAINT PK_Znamka_Student FOREIGN KEY (id_student)
  REFERENCES Student (id_student),
  CONSTRAINT FK_Znamka_Predmet FOREIGN KEY (id_predmet)
  REFERENCES Predmet (id_predmet),
  CONSTRAINT FK_Znamka_Ucitel FOREIGN KEY (id_ucitel)
  REFERENCES Ucitel(id_ucitel)
)
GO

-- 2.1 Naplneni tabulek daty
--	vlo�en� student�
INSERT INTO student (jmeno, prijmeni) 
VALUES ('Franta', 'Nov�k')
INSERT INTO student (jmeno, prijmeni) 
VALUES ('Pepa', 'Jan�')
INSERT INTO student (jmeno, prijmeni) 
VALUES ('Jarda', 'Po��zek')
INSERT INTO student (jmeno, prijmeni) 
VALUES ('Ferda', 'Petr�ela')
INSERT INTO student (jmeno, prijmeni) 
VALUES ('Roman', 'Kol��')
GO

--	vlo�en� u�itel�

INSERT INTO ucitel (jmeno, prijmeni)
VALUES ('Vlastimil', 'Dvo��k')
INSERT INTO ucitel (jmeno, prijmeni)
VALUES ('Jarom�r', 'Novotn�')
INSERT INTO ucitel (jmeno, prijmeni) 
VALUES ('Tom�', 'Marn�')
GO

--	vlo�en� p�edm�t�
INSERT INTO predmet (nazev)
VALUES ('matematika')
INSERT INTO predmet (nazev)
VALUES ('chemie')
INSERT INTO predmet (nazev)
VALUES ('d�jepis')
INSERT INTO predmet (nazev)
VALUES ('�e�tina')
GO

--	vlo�en� vyu�uj�c�ch (u�itel�, kte�� vyu�uj� p�edm�ty)
INSERT INTO vyucujici (id_predmet, id_ucitel)
VALUES (3, 1)
INSERT INTO vyucujici (id_predmet, id_ucitel)
VALUES (3, 2)
INSERT INTO vyucujici (id_predmet, id_ucitel)
VALUES (1, 2)
GO

--	vlo�en� zn�mek 
INSERT INTO znamka (id_student, id_predmet, id_ucitel, body)
VALUES (1, 1, 3, 65)
INSERT INTO znamka (id_student, id_predmet, id_ucitel, body)
VALUES (2, 1, 3, 45)
INSERT INTO znamka (id_student, id_predmet, id_ucitel, body)
VALUES (3, 1, 3, 100)
INSERT INTO znamka (id_student, id_predmet, id_ucitel, body)
VALUES (4, 1, 3, 50)
INSERT INTO znamka (id_student, id_predmet, id_ucitel, body)
VALUES (1, 2, 3, 20)
INSERT INTO znamka (id_student, id_predmet, id_ucitel, body)
VALUES (2, 2, 3, 50)
INSERT INTO znamka (id_student, id_predmet, id_ucitel, body)
VALUES (3, 2, 3, 80)
INSERT INTO znamka (id_student, id_predmet, id_ucitel, body)
VALUES (4, 2, 3, 60)
GO

-- 3. ZOBRAZEN� DAT Z VYTVO�EN�CH TABULEK
-- 3.1 vypi�te u�itele, kte�� vyu�uj� p�edmety spolu 
-- s n�zvy vyu�ovan�ho p�edmetu (jm�no, p��jmen�, n�zev)
SELECT u.jmeno, u.prijmeni, p.nazev
FROM ucitel u 
INNER JOIN vyucujici v 
 ON u.id_ucitel=v.id_ucitel
INNER JOIN predmet p
 ON v.id_predmet=p.id_predmet
GO

SELECT u.jmeno, u.prijmeni, p.nazev
FROM ucitel u, vyucujici v, predmet p
WHERE u.id_ucitel=v.id_ucitel
AND v.id_predmet=p.id_predmet
GO

-- 3.2 Vypi�te u�itele, kte�� nevyu�uj� �adn� p�edm�t (jm�no, p��jmen�)
-- (ve sb�rce)
SELECT u.jmeno, u.prijmeni
FROM ucitel u 
WHERE NOT EXISTS 
  (
    SELECT * FROM vyucujici v 
    WHERE v.id_ucitel=u.id_ucitel
  )
GO

SELECT u.jmeno, u.prijmeni
FROM ucitel u 
LEFT JOIN vyucujici v 
 ON u.id_ucitel=v.id_ucitel
WHERE v.id_ucitel IS NULL
GO

-- 3.3 Vypi�te body jednotliv�ch student� p�edmetu s n�zvem �matematika�
-- (jm�no, p��jmen�, body)
SELECT s.jmeno, s.prijmeni, z.body
FROM student s, znamka z, predmet p
WHERE s.id_student=z.id_student
AND z.id_predmet=p.id_predmet
AND p.nazev='matematika'
GO

SELECT s.jmeno, s.prijmeni, z.body
FROM student s 
 INNER JOIN znamka z
 ON s.id_student=z.id_student
 INNER JOIN predmet p
 ON z.id_predmet=p.id_predmet
WHERE 
p.nazev='matematika'

-- 3.4 vypi�te v�echny studenty, kter� m�me v tabulce Student a t�m, kte�� 
-- konali n�jakou zkou�ku sou�asn� vypi�te i n�zev p�edm�tu a body
SELECT s.jmeno, s.prijmeni, z.body, p.nazev
FROM student s 
 LEFT JOIN znamka z
 ON s.id_student=z.id_student
 LEFT JOIN predmet p
 ON z.id_predmet=p.id_predmet
GO

-- 3.5 Agrega�n� funkce
-- jsou Po�et, Pr�m�r, Suma, Minimum a Maximum. Obecn� syntace: n�zev funkce() 
SELECT p.nazev, count(z.body) AS Po�et, avg(z.body) AS Pr�m�r, sum(z.body) AS Suma, 
min(z.body) AS Minimum,max(z.body) AS Maximum
FROM znamka z, predmet p
WHERE z.id_predmet=p.id_predmet
GROUP BY p.nazev
GO

-- 3.6 Zobrazte pr�m�rn�, minim�ln� a maxim�ln� po�et bod� z jednotliv�ch p�edm�t�
-- pro ka�d�ho studenta, kter� konal zkou�ku, d�le po�et p�edm�t� ze kter�ch 
-- byl bodov�n a sou�asn� vypi�te jeho p��jmen�
SELECT s.prijmeni, count(z.body) AS Po�et, avg(z.body) AS Prumer, min(z.body) AS Minimum,
max(z.body) AS Maximum 
FROM student s, znamka z, predmet p
WHERE z.id_predmet=p.id_predmet
AND z.id_student=s.id_student
GROUP BY s.prijmeni
GO

-- 3.7 Zobrazte cel� jm�na u�itel� (jm�no a p��jmen� v jednom sloupci), 
-- kte�� zapsali body student�m zobrazte tak� body, 
-- n�zev p�edmetu a cel� jm�no studenta (jm�no a p��jmen� v jednom sloupci)
SELECT u.jmeno+' '+u.prijmeni as 'Jm�no u�itele', z.body, 
p.nazev, s.jmeno+' '+s.prijmeni as 'Jm�no studenta'
FROM ucitel u
INNER JOIN znamka z 
 ON z.id_ucitel=u.id_ucitel
INNER JOIN student s
 ON z.id_student=s.id_student
INNER JOIN predmet p
 ON z.id_predmet=p.id_predmet
GO

-- 3.8 Upravte p�edch�zej�c� dotaz (3.7) tak, aby se zobrazila cel� jm�na u�itel�, 
-- kte�� zapsali body student�m se jm�nem "Jarda" a zamezte v�pisu duplicitn�ch z�znam�.
-- Pozn.: Jako n�pov�da je pou�it podobn� dotaz s klauzul� WHERE, 
-- vy provedete dotaz s p��kazem JOIN. 
SELECT DISTINCT u.jmeno, u.prijmeni 
FROM ucitel u, znamka z, student s, predmet p
WHERE u.id_ucitel=z.id_ucitel
AND z.id_student=s.id_student
AND z.id_predmet=p.id_predmet
AND s.jmeno='Jarda'
GO

SELECT DISTINCT u.jmeno+' '+u.prijmeni as 'Jm�no u�itele'
FROM ucitel u
INNER JOIN znamka z 
 ON z.id_ucitel=u.id_ucitel
INNER JOIN student s
 ON z.id_student=s.id_student
INNER JOIN predmet p
 ON z.id_predmet=p.id_predmet
WHERE 
s.jmeno='Jarda'
GO

-- VYTVO�EN� JEDNODUCH�CH POHLED�
-- 4.Vytvo�te pohled s n�zvem Prehled, kter� bude obsahovat 
-- cel� jm�na u�itel� (jm�no a p��jmen� v jednom sloupci), kte�� zapsali body student�m, 
-- v�etn� bod�, n�zv� p�edm�tu a cel�ch jmen student� (jm�no a p��jmen� v jednom sloupci)
CREATE VIEW Prehled AS
SELECT u.jmeno+' '+u.prijmeni as 'Jm�no_u�itele', z.body, 
p.nazev, s.jmeno+' '+s.prijmeni as 'Jm�no_studenta'
FROM ucitel u
INNER JOIN znamka z 
 ON z.id_ucitel=u.id_ucitel
INNER JOIN student s
 ON z.id_student=s.id_student
INNER JOIN predmet p
 ON z.id_predmet=p.id_predmet
GO  

-- 4.1 kter� u�itel zn�mkoval, kolik bod� obdr�el a z jak�ho p�edm�tu student Nov�k   
SELECT Jm�no_u�itele, body FROM Prehled  WHERE Jm�no_studenta LIKE '%Nov�k%'
GO

-- 4.2 kter� u�itel zn�mkoval, kolik bod� obdr�el a z jak�ho p�edm�tu student Nov�k
-- a student Po��zek
 SELECT Jm�no_u�itele, nazev, body FROM Prehled  WHERE Jm�no_studenta LIKE '%Nov�k%'
 OR Jm�no_studenta LIKE '%Po��z%' 
GO

-- 4.3 Kte�� studenti obdr�eli 60 a v�ce bod� z matematiky a 20 a m�n� bod� z chemie
SELECT Jm�no_studenta, body, nazev FROM Prehled  WHERE body >=60 AND nazev='matematika'
OR body <=20 AND nazev='chemie'
GO

-- 5. ULOZENE PROCEDURY
-- 5.1 Vytvo�te si tabulky student_zaloha a znamky_zaloha kam budete ukl�dat mazan� data. 
--(nebude se z�lohovat u�itel, kter� zn�mku vlo�il).
-- Napi�te proceduru, kter� sma�e studenta z tabulky student a vytvo�� z�lohu. 
-- (vstupn� parametr je identifik�tor studenta.

CREATE TABLE Student_zaloha
(
  id_student int,
  jmeno varchar(50),
  prijmeni varchar (50),
  CONSTRAINT PK_Tabulka_Student_Zaloha PRIMARY KEY (id_student)
)
GO

CREATE TABLE Znamka_Zaloha
(
  id_student int, 
  id_predmet int,
  body int,
  CONSTRAINT PK_Tabulka_Znamka_Zaloha PRIMARY KEY (id_student, id_predmet)
 )
GO

CREATE PROCEDURE smaz_studenta 
@id_st int
AS
BEGIN  
  INSERT INTO student_zaloha 
    SELECT * FROM student WHERE id_student=@id_st
  INSERT INTO znamka_zaloha (id_student, id_predmet, body)
   SELECT z.id_student, z.id_predmet, z.body
   FROM znamka z
   WHERE z.id_student=@id_st
  DELETE FROM znamka WHERE id_student=@id_st
  DELETE FROM student WHERE id_student=@id_st
END
GO

EXECUTE Smaz_Studenta 1
GO

select * from student
select * from znamka
select * from Student_zaloha
select * from Znamka_Zaloha
GO

-- 5.2 Napi�te proceduru, kter� bude vkl�dat nov�ho u�itele a p�edm�t, kter� bude vyu�ovat.
-- Nap�. vloz_vyucujiciho(�Jan�, �Nov�k�, �T�locvik�).
-- Procedura zkontroluje, jestli se vyu�uj�c� a p�edm�t nach�z� v datab�zi, 
-- pokud ne, vlo�� je do p��slu�n�ch tabulek. Pot� vlo�� z�znam do tabulky vyu�uj�c�.
--Pozn.: posledn� vlo�en� hodnota sloupce ozna�en�ho IDENTITY se z�sk� 
--IDENT_CURRENT('table_name')


CREATE PROCEDURE vloz_vyucujiciho 
@jmeno varchar(50),
@prijmeni varchar(50),
@predmet varchar(50)
AS
BEGIN
  DECLARE @id_pred int
  SELECT @id_pred=id_predmet 
   FROM predmet WHERE nazev=@predmet
  IF (@id_pred IS NULL) 
  BEGIN
    INSERT INTO predmet VALUES (@predmet)
    SET @id_pred=IDENT_CURRENT('predmet')
  END
  DECLARE @id_uc int
  SELECT @id_uc=id_ucitel 
    FROM ucitel WHERE jmeno=@jmeno AND prijmeni=@prijmeni
  IF (@id_uc IS NULL) BEGIN
    INSERT INTO ucitel (jmeno, prijmeni) 
     VALUES (@jmeno, @prijmeni)
    SET @id_uc=IDENT_CURRENT('ucitel')
  END  
  INSERT INTO vyucujici (id_ucitel, id_predmet)
  VALUES (@id_uc, @id_pred)
END
GO

EXECUTE vloz_vyucujiciho 'Jan','Nov�k','T�locvik'
GO

SELECT * FROM Ucitel
SELECT * FROM Vyucujici
SELECT * FROM PREDMET
GO

-- 5.3 Naprogramujte ulo�enou proceduru se jm�nem save_student, kter� bude m�t dva vstupn� 
-- parametry (jm�no a p��jmen�) studenta a jeden v�stupn� parametr (jeho id). 
-- Procedura zjist�, zda se student s dan�m jm�nem a p��jmen�m nach�z� v datab�zi,
-- pokud ano, pouze vr�t� jeho id a pokud ne, vlo�� jej a tak� vr�t� jeho id. 
-- Toto id se generuje identitou (IDENTITY) a z�sk� se pomoc� @@IDENTITY.

CREATE PROCEDURE save_student 
  @jmeno varchar (50),
  @prijmeni varchar (50),
  @id_student int output  
AS  
BEGIN
  SET @id_student = (SELECT TOP 1 id_student  -- kdyby existovaly duplicity 
	FROM student 
	WHERE jmeno = @jmeno AND prijmeni = @prijmeni) 
  IF (@id_student IS NULL)  
  BEGIN
    INSERT INTO student (jmeno, prijmeni)
    VALUES (@jmeno, @prijmeni)
	SET @id_student = @@IDENTITY    
  END
END
GO

DECLARE @id_student int -- v�stupn� prom�nn�
EXEC save_student 'Franti�ek', 'Koudelka', @id_student output
print @id_student
GO

-- 5.4 Naprogramujte analogickou proceduru save_ucitel, kter� ulo�� u�itele.
-- Bude m�t dva vstupn� parametry (jm�no a p��jmen�) u�itele, dva v�stupn� parametry 
-- (id_ucitele, existuje).

CREATE PROCEDURE save_ucitel
  @jmeno varchar (50),
  @prijmeni varchar (50),
  @id_ucitel int = 0 output,
  @existuje int output
AS
BEGIN
  SET @id_ucitel = (SELECT TOP 1 id_ucitel 
	FROM ucitel 
	WHERE jmeno = @jmeno 
	AND prijmeni = @prijmeni)  
    SET @existuje = 0
  IF (@id_ucitel IS NULL)  
  BEGIN
    INSERT INTO ucitel (jmeno, prijmeni)
    VALUES (@jmeno, @prijmeni)
	SET @id_ucitel = @@IDENTITY    
	SET @existuje = 1
  END
END
GO

DECLARE @id_ucitel int
DECLARE @existuje int
EXEC save_ucitel 'wwsadsaddgfdgfdfdw', 'pdd�kljfoo', @id_ucitel output,@existuje output
IF (@existuje = 0)
BEGIN
  PRINT 'U�itel s t�mto jm�nem ji� existuje'
END
ELSE 
BEGIN
	PRINT 'U�itel byl vlo�en s ID'+' '+convert(varchar(3),@id_ucitel)
END
GO

-- 5.5 Analogick� procedura save_ucitel1 s vyu�it�m vno�en� procedury Vypis
CREATE PROCEDURE Vypis
@id_ucitel int,
@existuje int
AS
BEGIN
	IF (@existuje = 0)
	BEGIN
		PRINT 'U�itel s t�mto jm�nem ji� existuje'
	END
	IF (@existuje =1)
	BEGIN
		PRINT 'U�itel byl vlo�en s ID'+' '+convert(varchar(3),@id_ucitel)
	END
END
GO

CREATE PROCEDURE save_ucitel1
  @jmeno varchar (50),
  @prijmeni varchar (50),
  @id_ucitel int output,
  @existuje int output
AS
BEGIN
  SET @id_ucitel = (SELECT TOP 1 id_ucitel 
	FROM ucitel 
	WHERE jmeno = @jmeno 
	AND prijmeni = @prijmeni)  
    SET @existuje = 0
  IF (@id_ucitel IS NULL)  
  BEGIN
    INSERT INTO ucitel (jmeno, prijmeni)
    VALUES (@jmeno, @prijmeni)
	SET @id_ucitel = @@IDENTITY    
	SET @existuje = 1
  END
EXECUTE Vypis @id_ucitel,@existuje
END
GO

DECLARE @id_ucitel int
DECLARE @existuje int
EXEC save_ucitel1 'wwfdwhdsGHasadadagjghj', 'pjfoo', @id_ucitel output, @existuje output
GO


-- 5.6 D�le naprogramujte proceduru save_hodnoceni, kter� bude m�t 6 vstupn�ch parametr�.
-- Bude to jm�no a p��jmen� u�itele, jm�no a p��jmen� studenta, n�zev p�edm�tu a po�et bod� - ��slo, 
-- kter� student z p�edm�tu obdr�el. Tato procedura vyu�ije v�echny 3 p�edch�zej�c� procedury.
-- Nakonec vyp�e zn�mku, kterou student obdr�el (A-F), to znamen�, �e body p�evede na zn�mku. 
-- Pokud u� existuje hodnocen� od dan�ho u�itele pro dan� p�edm�t a dan�ho studenta, pouze vyp�e, �e zn�mka ji� byla zadan�.

CREATE PROCEDURE vloz_vyucujiciho1 
@jmeno varchar(50),
@prijmeni varchar(50),
@predmet varchar(50),
@id_predmet int = 0 output,
@id_ucitel int = 0 output 
AS
BEGIN
  DECLARE @id_pred int
  SELECT @id_pred=id_predmet 
   FROM predmet WHERE nazev=@predmet
  IF (@id_pred IS NULL) 
  BEGIN
    INSERT INTO predmet VALUES (@predmet)
    SET @id_pred=IDENT_CURRENT('predmet')
  END
  DECLARE @id_uc int
  SELECT @id_uc=id_ucitel 
    FROM ucitel WHERE jmeno=@jmeno AND prijmeni=@prijmeni
  IF (@id_uc IS NULL) BEGIN
    INSERT INTO ucitel (jmeno, prijmeni) 
     VALUES (@jmeno, @prijmeni)
    SET @id_uc=IDENT_CURRENT('ucitel')
  END  
  IF (@id_uc IS NULL) OR (@id_pred IS NULL) BEGIN
    INSERT INTO vyucujici (id_ucitel, id_predmet)
    VALUES (@id_uc, @id_pred)
  END
SET @id_predmet=IDENT_CURRENT('predmet')
SET @id_ucitel=IDENT_CURRENT('ucitel')
END
GO


CREATE PROCEDURE save_student 
  @jmeno varchar (50),
  @prijmeni varchar (50),
  @id_student int output  
AS  
BEGIN
  SET @id_student = (SELECT TOP 1 id_student  -- kdyby existovaly duplicity 
	FROM student 
	WHERE jmeno = @jmeno AND prijmeni = @prijmeni) 
  IF (@id_student IS NULL)  
  BEGIN
    INSERT INTO student (jmeno, prijmeni)
    VALUES (@jmeno, @prijmeni)
	SET @id_student = @@IDENTITY    
  END
END
GO

CREATE PROCEDURE save_hodnoceni
  @jmeno_uc varchar (50),
  @prijmeni_uc varchar (50),
  @jmeno_stud varchar (50),
  @prijmeni_stud varchar (50),
  @nazev_pred varchar (50), 
  @body int
AS
BEGIN
  DECLARE 
    @id_ucitel int,
	@id_student int,
	@id_predmet int
--  EXEC save_ucitel @jmeno_uc, @prijmeni_uc, @id_ucitel output
  	EXEC vloz_vyucujiciho1 @jmeno_uc,@prijmeni_uc,@nazev_pred, @id_predmet output, @id_ucitel output
    EXEC save_student @jmeno_stud, @prijmeni_stud, @id_student output
--  EXEC save_predmet @nazev_pred, @id_predmet output
  
  IF ((SELECT count (*) 
	FROM znamka 
	WHERE id_ucitel = @id_ucitel 
	AND id_student = @id_student 
	AND id_predmet = @id_predmet) > 0)
  BEGIN
    PRINT 'znamka jiz byla zadana'
  END
  ELSE
  BEGIN
    INSERT INTO znamka (id_ucitel, id_predmet, id_student, body) 
    VALUES (@id_ucitel, @id_predmet, @id_student, @body)
    IF (@body < 50)
      PRINT 'Student'+' '+@prijmeni_stud+' '+'hodnocen zn�mkou:'+' '+'F'+' '+'z p�edm�tu'+' '+@nazev_pred
    ELSE IF (@body < 60)
      PRINT 'Student'+' '+@prijmeni_stud+' '+'hodnocen zn�mkou:'+' '+'E'+' '+'z p�edm�tu'+' '+@nazev_pred
    ELSE IF (@body < 70)
      PRINT 'Student'+' '+@prijmeni_stud+' '+'hodnocen zn�mkou:'+' '+'D'+' '+'z p�edm�tu'+' '+@nazev_pred
    ELSE IF (@body < 80)
      PRINT 'Student'+' '+@prijmeni_stud+' '+'hodnocen zn�mkou:'+' '+'C'+' '+'z p�edm�tu'+' '+@nazev_pred
    ELSE IF (@body < 90)
      PRINT 'Student'+' '+@prijmeni_stud+' '+'hodnocen zn�mkou:'+' '+'B'+' '+'z p�edm�tu'+' '+@nazev_pred
    ELSE 
      PRINT 'Student'+' '+@prijmeni_stud+' '+'hodnocen zn�mkou:'+' '+'A'+' '+'z p�edm�tu'+' '+@nazev_pred
  END
END
GO

EXEC save_hodnoceni 'Ji��', 'K��', 'Roman', 'Ku�era', 'ZPC', 75
GO


