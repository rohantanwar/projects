CREATE DATABASE INVENTORY;

CREATE TABLE SUPPLIER
(
SID CHAR(5),
SNAME VARCHAR (20),
SADD VARCHAR (20),
SCITY VARCHAR (20),
SPHONE CHAR(10),
EMAIL VARCHAR (20) 
);


CREATE TABLE PRODUCT
(
PID CHAR (5),
PDESC VARCHAR (30),
PRICE INT,
CATEGORY CHAR(2),
SID CHAR (5)
);
 
SELECT * FROM SUPPLIER;

CREATE TABLE STOCK
(
PID CHAR (5),
SQTY INT,
ROL INT,
MOQ INT
);

CREATE TABLE CUST
(
CID CHAR(5),
CNAME VARCHAR (20),
CADDRESS VARCHAR (20),
CITY VARCHAR (10),
PHONE CHAR (10),
EMAIL VARCHAR (20),
DOB DATE
);

CREATE TABLE ORDERS
(
OID CHAR (5),
ODATE DATE,
PID CHAR (5),
CID CHAR(5),
OQTY INT
);

SELECT * FROM ORDERS;

ALTER TABLE SUPPLIER
ALTER COLUMN SID CHAR(5) NOT NULL;


ALTER TABLE SUPPLIER 
ADD CONSTRAINT S1 PRIMARY KEY(SID); 

ALTER TABLE SUPPLIER
ALTER COLUMN SNAME VARCHAR(20) NOT NULL;


ALTER TABLE SUPPLIER
ALTER COLUMN SADD VARCHAR(20) NOT NULL;

ALTER TABLE SUPPLIER
ADD CONSTRAINT S2 DEFAULT 'DELHI' FOR SCITY;

ALTER TABLE SUPPLIER 
ADD CONSTRAINT S3 UNIQUE (SPHONE);


ALTER TABLE PRODUCT
ALTER COLUMN PID CHAR (5) NOT NULL;

ALTER TABLE PRODUCT
ADD CONSTRAINT P1 PRIMARY KEY(PID);

ALTER TABLE PRODUCT
ALTER COLUMN PDESC VARCHAR (30) NOT NULL;

ALTER TABLE PRODUCT
ADD CONSTRAINT P2 CHECK (PRICE > 0);


ALTER TABLE PRODUCT
ADD CONSTRAINT P3 CHECK (CATEGORY IN ('IT', 'HA', 'HC'));

ALTER TABLE PRODUCT
ADD CONSTRAINT FKID FOREIGN KEY(SID) REFERENCES SUPPLIER(SID); 

ALTER TABLE STOCK
ADD CONSTRAINT FKID1 FOREIGN KEY(PID) REFERENCES PRODUCT(PID); 

ALTER TABLE STOCK 
ADD CONSTRAINT ST1 CHECK (SQTY >= 0);

ALTER TABLE STOCK 
ADD CONSTRAINT ST2 CHECK (ROL >= 0);

ALTER TABLE STOCK 
ADD CONSTRAINT ST3 CHECK (MOQ >= 5);


ALTER TABLE CUST
ALTER COLUMN CID CHAR(5) NOT NULL;

ALTER TABLE CUST
ADD CONSTRAINT C1 PRIMARY KEY (CID);


ALTER TABLE CUST
ALTER COLUMN CNAME VARCHAR(20) NOT NULL;

ALTER TABLE CUST
ALTER COLUMN CADDRESS VARCHAR(20) NOT NULL;

ALTER TABLE CUST
ALTER COLUMN CITY VARCHAR(10) NOT NULL;

ALTER TABLE CUST
ALTER COLUMN PHONE CHAR(10) NOT NULL;

ALTER TABLE CUST
ALTER COLUMN EMAIL VARCHAR(20) NOT NULL;


ALTER TABLE CUST
ADD CONSTRAINT C2 CHECK (DOB < '1-JAN-2000');

ALTER TABLE ORDERS 
ALTER COLUMN OID CHAR(5) NOT NULL;

ALTER TABLE ORDERS 
ADD CONSTRAINT O1 PRIMARY KEY(OID); 

ALTER TABLE ORDERS 
ADD CONSTRAINT FKID3 FOREIGN KEY(PID) REFERENCES PRODUCT(PID);

ALTER TABLE ORDERS 
ADD CONSTRAINT FKID4 FOREIGN KEY(CID) REFERENCES CUST(CID);

ALTER TABLE ORDERS 
ADD CONSTRAINT O2 CHECK (OQTY >=1);

SELECT * FROM SUPPLIER;

SELECT * FROM PRODUCT;

SELECT * FROM STOCK;

SELECT * FROM ORDERS;


SELECT O.OID, O.ODATE, C.CNAME, C.CADDRESS, C.PHONE, P.PDESC, P.PRICE, O.OQTY, (P.PRICE*O.OQTY) AS 'AMOUNT'
FROM ORDERS O
INNER JOIN PRODUCT P ON P.PID = O.OID
INNER JOIN CUST C ON O.CID = C.CID;

INSERT INTO SUPPLIER
VALUES('S0008', 'SATURN ELEC LTD', 'CP', 'DELHI', '6523014789', 'SELEC@GMAIL.COM');

SELECT * FROM PRODUCT;

INSERT INTO PRODUCT
VALUES('P0015', 'WIFI ROUTERS',850, 'IT', 'S0002');

INSERT INTO STOCK
VALUES('P0007', 8, 15, 30);


INSERT INTO CUST
VALUES('C0008', 'VIKRANT SINGH', 'SECTOR 62', 'NOIDA', '6320147895', 'VKS@GMAIL.COM', '08-NOV-1998');


INSERT INTO ORDERS 
VALUES('O0005', '28-JUN-2022', 'P0003', 'C0006', 2);

SELECT * FROM ORDERS;

SELECT * FROM SUPPLIER;

SELECT * FROM PRODUCT;

 SELECT * FROM CUST;


SELECT * FROM STOCK;

CREATE VIEW BILL
AS
SELECT O.OID, O.ODATE, C.CNAME, C.CADDRESS,C.CITY, C.PHONE, P.PDESC, P.PRICE, O.OQTY, (P.PRICE*O.OQTY) AS 'AMOUNT'
FROM ORDERS O
INNER JOIN PRODUCT P ON P.PID = O.PID
INNER JOIN CUST C ON O.CID = C.CID;


SELECT * FROM BILL;

CREATE PROCEDURE ADD_SUPPLIER @I AS CHAR(5), @N AS VARCHAR(30), @A AS VARCHAR(40), @C AS VARCHAR(20), @P AS CHAR(15), @E AS VARCHAR(50)
AS 
BEGIN
   INSERT INTO SUPPLIER
   VALUES (@I, @N, @A, @C, @P, @E);

   SELECT * FROM SUPPLIER WHERE SID = @I;
   END;


ADD_SUPPLIER 'S0009', 'GLOBAL COMPUTERS LTD', 'PASCHIM VIHAR', 'DELHI', '2563104789','GC@GMAIL.COM';


CREATE PROCEDURE ADD_PRO @I AS CHAR(5), @D AS VARCHAR(50), @P AS INT, @C AS CHAR(3), @S  AS CHAR(5)
AS 
BEGIN
  INSERT INTO PRODUCT
  VALUES (@I, @D, @P, @C, @S);

  SELECT * FROM PRODUCT WHERE PID = @I;
  END;

  ADD_PRO 'P0016', 'EXTENDED CHORDS', 300, 'HA', 'S0004';

  CREATE PROCEDURE ADD_CUST @I AS CHAR(5), @N AS VARCHAR(20), @A AS VARCHAR(20), @C AS VARCHAR(10), @P AS CHAR(15), @E AS VARCHAR(30), @D AS DATE
  AS
  BEGIN
   
   INSERT INTO CUST
   VALUES(@I, @N, @A, @C, @P, @E, @D);
   
   SELECT * FROM CUST WHERE CID = @I;
   END;  

   ADD_CUST 'C0009', 'RITIK JHA', 'NANGLOI', 'DELHI', '7896320145', 'RJHA@GMAIL.COM', '12-AUG-1997';


CREATE PROCEDURE ADD_ORDER @I AS CHAR(5), @P AS CHAR(5), @C AS CHAR(5), @Q AS INT
AS
BEGIN

   INSERT INTO ORDERS
   VALUES(@I, GETDATE(), @P, @C, @Q);

   SELECT * FROM ORDERS WHERE OID = @I;
   END;

   ADD_ORDER 'O0006', 'P0016', 'C0001', 2