SELECT *
FROM MEMBER
WHERE PHONE_NUMBER = 16888888;

CREATE TABLE "C##INSLIB"."BOOK"
   (
	 "BOOK_ID" NUMBER(10),
	"BOOK_NAME" VARCHAR2(255),
	"AUTHOR_ID" VARCHAR2(5),
	"PUBLISHER_NAME" VARCHAR2(255),
	"COVER_IMAGE" BLOB,
	"STATUS" VARCHAR2(255),
	"DATE_OF_ARRIVAL" DATE,
	"YEAR" NUMBER,
	"EDITION" VARCHAR2(255),
	"NO_OF_PAGES" NUMBER,
	"LANGUAGE" VARCHAR2(255),
	"ADMIN_ID" VARCHAR2(255),
	 CHECK ("BOOK_ID" IS NOT NULL) ENABLE,
	 PRIMARY KEY ("BOOK_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  TABLESPACE "USERS"  ENABLE,
	 FOREIGN KEY ("AUTHOR_ID")
	  REFERENCES "C##INSLIB"."AUTHOR" ("AUTHOR_ID") ENABLE,
	 CONSTRAINT "BOOK_PUB_FK" FOREIGN KEY ("PUBLISHER_NAME")
	  REFERENCES "C##INSLIB"."PUBLISHER" ("PUBLISHER_NAME") ENABLE,
	 CONSTRAINT "BOOK_AD_FK" FOREIGN KEY ("ADMIN_ID")
	  REFERENCES "C##INSLIB"."ADMIN" ("ADMIN_ID") ENABLE
   );

CREATE TABLE "C##INSLIB"."BOOKLIST_ACADEMIC"
   (	"BOOK_ID" NUMBER(10,0),
	"SUBJECT" VARCHAR2(255),
	"TOPIC" VARCHAR2(255),
	"DEPARTMENT" VARCHAR2(255),
	 CONSTRAINT "AC_BOOK_FK" FOREIGN KEY ("BOOK_ID")
	  REFERENCES "C##INSLIB"."BOOK" ("BOOK_ID") ENABLE
   );

CREATE TABLE "C##INSLIB"."BOOKLIST_OTHERS"
   (	"BOOK_ID" NUMBER(10,0) NOT NULL ENABLE,
	"GENRE" VARCHAR2(255),
	"CATEGORY" VARCHAR2(255),
	 CONSTRAINT "OT_BOOK_FK" FOREIGN KEY ("BOOK_ID")
	  REFERENCES "C##INSLIB"."BOOK" ("BOOK_ID") ENABLE
   );

CREATE TABLE "C##INSLIB"."ISSUE_LIST"
   (	"ISSUE_ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
	 "MEMBER_ID" NUMBER(10) NOT NULL,
	"BOOK_ID" NUMBER(10) NOT NULL,
	"ISSUE_DATE" DATE,
	"ADMIN_ID" VARCHAR2(255),
	 PRIMARY KEY ("ISSUE_ID"),

	 CONSTRAINT "ISS_MEM_FK" FOREIGN KEY ("MEMBER_ID")
	  REFERENCES "C##INSLIB"."MEMBER" ("MEMBER_ID") ENABLE,
	 CONSTRAINT "ISS_BK_FK" FOREIGN KEY ("BOOK_ID")
	  REFERENCES "C##INSLIB"."BOOK" ("BOOK_ID") ENABLE,
	 CONSTRAINT "ISS_AD_FK" FOREIGN KEY ("ADMIN_ID")
	  REFERENCES "C##INSLIB"."ADMIN" ("ADMIN_ID") ENABLE
   );

CREATE TABLE "C##INSLIB"."REVIEW_LIST"
   (	"MEMBER_ID" NUMBER NOT NULL ENABLE,
	"BOOK_ID" NUMBER,
	"REVIEW_TEXT" VARCHAR2(255),
	 CONSTRAINT "REV_MEM_FK" FOREIGN KEY ("MEMBER_ID")
	  REFERENCES "C##INSLIB"."MEMBER" ("MEMBER_ID") ENABLE,
	 CONSTRAINT "REV_BK_FK" FOREIGN KEY ("BOOK_ID")
	  REFERENCES "C##INSLIB"."BOOK" ("BOOK_ID") ENABLE
   );

CREATE TABLE "C##INSLIB"."SUGG_LIST"
   (	"MEMBER_ID" NUMBER(10) NOT NULL ENABLE,
	"NAME" VARCHAR2(255),
	"MESSAGE" VARCHAR2(255),
	 CONSTRAINT "SUG_MEM_FK" FOREIGN KEY ("MEMBER_ID")
	  REFERENCES "C##INSLIB"."MEMBER" ("MEMBER_ID") ENABLE
   );


CREATE TABLE "C##INSLIB"."FAV_LIST"
   (	"MEMBER_ID" NUMBER NOT NULL ENABLE,
	"BOOK_ID" NUMBER,
	 CONSTRAINT "FAV_MEM_FK" FOREIGN KEY ("MEMBER_ID")
	  REFERENCES "C##INSLIB"."MEMBER" ("MEMBER_ID") ENABLE,
	 CONSTRAINT "FAV_BK_FK" FOREIGN KEY ("BOOK_ID")
	  REFERENCES "C##INSLIB"."BOOK" ("BOOK_ID") ENABLE
   );

CREATE TABLE "C##INSLIB"."CONTACT_US"
   (
	"NAME" VARCHAR2(255),
	"EMAIL" VARCHAR2(255),
	"PHONE_NUMBER" VARCHAR2(20),
	 "MESSAGE" VARCHAR2(255)
	 );

CREATE TABLE "C##INSLIB"."BOOKLIST_ACADEMIC"
   (	"BOOK_ID" NUMBER(10,0),
	"SUBJECT" VARCHAR2(255),
	"TOPIC" VARCHAR2(255),
	"DEPARTMENT" VARCHAR2(255),
	 CONSTRAINT "AC_BOOK_FK" FOREIGN KEY ("BOOK_ID")
	  REFERENCES "C##INSLIB"."BOOK" ("BOOK_ID") ENABLE
   );

CREATE TABLE "C##INSLIB"."BOOKLIST_OTHERS"
   (	"BOOK_ID" NUMBER(10,0) NOT NULL ENABLE,
	"GENRE" VARCHAR2(255),
	"CATEGORY" VARCHAR2(255),
	 CONSTRAINT "OT_BOOK_FK" FOREIGN KEY ("BOOK_ID")
	  REFERENCES "C##INSLIB"."BOOK" ("BOOK_ID") ENABLE
   );

INSERT INTO AUTHOR (AUTHOR_ID, AUTHOR_NAME, NATIONALITY, "LIFE-SPAN")
VALUES ('SMA', 'SYED MUJTABA ALI' , 'BENGALI', 'JAN-1911: MAY-76') ;

INSERT INTO AUTHOR (AUTHOR_ID, AUTHOR_NAME, NATIONALITY, "LIFE-SPAN")
VALUES ('AH', 'ANISUL HAQUE' , 'BENGALI', 'FEB-1960:PRESENT') ;

INSERT INTO PUBLISHER (PUBLISHER_NAME, ADDRESS, PHONE_NUMBER)
VALUES ('HAKKANI', 'BANGLABAZAR, DHAKA-1212', '016874837');

INSERT INTO PUBLISHER (PUBLISHER_NAME, ADDRESS, PHONE_NUMBER)
VALUES ('PROTHOM_ALO', 'KARWAN BAZAR, DHAKA-1212', '016874827');

INSERT INTO BOOK (BOOK_ID, BOOK_NAME, AUTHOR_ID, PUBLISHER_NAME, COVER_IMAGE, STATUS, DATE_OF_ARRIVAL, YEAR, EDITION, NO_OF_PAGES, ADMIN_ID, LANGUAGE)
VALUES (10, 'MAA', 'AH', 'PROTHOM_ALO', NULL, 'AVAILABLE', NULL, 2008, 'THIRD', 234, 'AD1', 'BANGLA') ;

ALTER TABLE MEMBER
ADD NUM_OF_ISSUE NUMBER(10,0);

INSERT INTO ISSUE_LIST (MEMBER_ID, BOOK_ID, ISSUE_DATE, ADMIN_ID) VALUES (2,1,'19-NOV-2020','AD1');

CREATE OR REPLACE TRIGGER DELETE_BOOK
BEFORE DELETE
ON BOOK
FOR EACH ROW
DECLARE
    V_BOOK_ID NUMBER(10);
    V_MEMBER_ID NUMBER(10,0);
BEGIN
    V_BOOK_ID := :OLD.BOOK_ID;
    BEGIN
       DELETE FROM FAV_LIST
       WHERE FAV_LIST.BOOK_ID = V_BOOK_ID;

       DELETE FROM BOOKLIST_ACADEMIC
       WHERE BOOKLIST_ACADEMIC.BOOK_ID = V_BOOK_ID;

       DELETE FROM BOOKLIST_OTHERS
       WHERE BOOKLIST_OTHERS.BOOK_ID = V_BOOK_ID;

       DELETE FROM REVIEW_LIST
       WHERE REVIEW_LIST.BOOK_ID = V_BOOK_ID;
       DBMS_OUTPUT.PUT_LINE('DELETED');
    END;

    FOR R IN (SELECT * FROM ISSUE_LIST WHERE ISSUE_LIST.BOOK_ID = V_BOOK_ID)
    LOOP
        V_MEMBER_ID := R.MEMBER_ID;
        UPDATE MEMBER SET MEMBER.NUM_OF_ISSUE = (MEMBER.NUM_OF_ISSUE - 1)
        WHERE MEMBER_ID = V_MEMBER_ID;
    END LOOP;
    BEGIN
        DELETE FROM ISSUE_LIST
        WHERE ISSUE_LIST.BOOK_ID = V_BOOK_ID;

    END;
END;

CREATE OR REPLACE TRIGGER ISSUE_BOOK
BEFORE INSERT
ON ISSUE_LIST
FOR EACH ROW
DECLARE
    V_BOOK_ID NUMBER(10);
    V_MEMBER_ID NUMBER(10,0);
BEGIN
    V_BOOK_ID := :NEW.BOOK_ID;
    V_MEMBER_ID := :NEW.MEMBER_ID;
    UPDATE MEMBER SET MEMBER.NUM_OF_ISSUE = (MEMBER.NUM_OF_ISSUE + 1)
    WHERE MEMBER_ID = V_MEMBER_ID;

    UPDATE BOOK SET BOOK.STATUS = 'NOT AVAILABLE'
    WHERE BOOK.BOOK_ID = V_BOOK_ID;
    DBMS_OUTPUT.PUT_LINE('INSERTED');
END;


DELETE FROM BOOK
WHERE BOOK_ID = 69;



CREATE OR REPLACE TRIGGER DELETE_ISSUE
BEFORE DELETE
ON ISSUE_LIST
FOR EACH ROW
DECLARE
    V_BOOK_ID NUMBER(10);
    V_MEMBER_ID NUMBER(10,0);
BEGIN
    V_BOOK_ID := :OLD.BOOK_ID;
    V_MEMBER_ID := :OLD.MEMBER_ID;

    UPDATE BOOK SET BOOK.STATUS = 'AVAILABLE'
    WHERE BOOK_ID = V_BOOK_ID;

    UPDATE MEMBER SET MEMBER.NUM_OF_ISSUE = (MEMBER.NUM_OF_ISSUE - 1)
    WHERE MEMBER_ID = V_MEMBER_ID;

END;

CREATE TABLE "C##INSLIB"."NEWS_AND_EVENTS"
   (	"NEWS_DATE" DATE,
	"IMAGE" BLOB,
	"DESCRIPTION" VARCHAR2(255)
   );

INSERT INTO LINKS (LINK_NAME, LINK_TEXT) VALUES (:1,:2);

DROP TABLE NEWS_AND_EVENTS PURGE;

SELECT BOOK.BOOK_ID, BOOK.BOOK_NAME, AUTHOR.AUTHOR_NAME, BOOK.PUBLISHER_NAME, BOOK.STATUS, BOOK.LANGUAGE, BOOK.YEAR, BOOK.EDITION, BOOK.NO_OF_PAGES
FROM BOOK JOIN AUTHOR ON (BOOK.AUTHOR_ID = AUTHOR.AUTHOR_ID)
WHERE AUTHOR.AUTHOR_NAME LIKE 'AH';



INSERT INTO "C##INSLIB"."BOOK" (BOOK_ID,BOOK_NAME,AUTHOR_ID,PUBLISHER_NAME,STATUS,DATE_OF_ARRIVAL,YEAR, EDITION, NO_OF_PAGES,ADMIN_ID,LANGUAGE,BOOK_TYPE,COVER_IMAGE) VALUES ('12', 'CHACHA KAHINI', 'SMA', 'HAKKANI', 'AVAILABLE', TO_DATE('2022-02-13 22:31:34', 'SYYYY-MM-DD HH24:MI:SS'), '2008', 'THIRD', '234', 'AD1', 'BANGLA', 'OTHERS',  UTL_RAW.CAST_TO_RAW('https://bdebooks.com/wp-content/uploads/2019/09/15778722.jpg'));
INSERT INTO "C##INSLIB"."BOOK" (BOOK_ID,BOOK_NAME,AUTHOR_ID,PUBLISHER_NAME,STATUS,DATE_OF_ARRIVAL,YEAR, EDITION, NO_OF_PAGES,ADMIN_ID,LANGUAGE,BOOK_TYPE,COVER_IMAGE) VALUES ('14', 'ITOL BITOL', 'HA', 'KOTHAMALA', 'AVAILABLE', TO_DATE('2022-02-08 15:38:33', 'SYYYY-MM-DD HH24:MI:SS'), '2008', NULL, '50', 'AD1', 'BANGLA', 'others', UTL_RAW.CAST_TO_RAW( 'https://i.ytimg.com/vi/BZUN-wTbGl4/maxresdefault.jpg'));
INSERT INTO "C##INSLIB"."BOOK" (BOOK_ID,BOOK_NAME,AUTHOR_ID,PUBLISHER_NAME,STATUS,DATE_OF_ARRIVAL,YEAR, EDITION, NO_OF_PAGES,ADMIN_ID,LANGUAGE,BOOK_TYPE,COVER_IMAGE) VALUES ('13', 'SESER KOBITA', 'AH', 'KOTHAMALA', 'AVAILABLE', TO_DATE('2022-01-10 19:43:58', 'SYYYY-MM-DD HH24:MI:SS'), '2016', 'SECOND', '120', 'AD1', 'BANGLA', 'OTHER', UTL_RAW.CAST_TO_RAW('https://ds.rokomari.store/rokomari110/ProductNew20190903/260X372/23f2f82cb_41029.jpg'));
INSERT INTO "C##INSLIB"."BOOK" (BOOK_ID,BOOK_NAME,AUTHOR_ID,PUBLISHER_NAME,STATUS,DATE_OF_ARRIVAL,YEAR, EDITION, NO_OF_PAGES,ADMIN_ID,LANGUAGE,BOOK_TYPE,COVER_IMAGE) VALUES ('11', 'DESE BIDESE', 'SMA', 'HAKKANI', 'AVAILABLE', TO_DATE('2022-01-31 22:31:24', 'SYYYY-MM-DD HH24:MI:SS'), '2008', 'THIRD', '164', 'AD1', 'BANGLA', 'OTHER', UTL_RAW.CAST_TO_RAW('https://1.bp.blogspot.com/-azI7RfXYCYM/VL5GQH6hJrI/AAAAAAAAAmQ/-3cK9QmpCD4/s1600/desh%2Bbideshe%2Bby%2Bsayed%2Bmostoba%2Bali.jpg'));
INSERT INTO "C##INSLIB"."BOOK" (BOOK_ID,BOOK_NAME,AUTHOR_ID,PUBLISHER_NAME,STATUS,DATE_OF_ARRIVAL,YEAR, EDITION, NO_OF_PAGES,ADMIN_ID,LANGUAGE,BOOK_TYPE,COVER_IMAGE) VALUES ('21', 'COLLEGE ALGEBRA', 'JI', 'PROTHOM_ALO', 'AVAILABLE', TO_DATE('2022-02-01 11:54:06', 'SYYYY-MM-DD HH24:MI:SS'), '2019', 'SECOND', '204', 'AD1', 'ENGLISH', 'ACADEMIC', UTL_RAW.CAST_TO_RAW('https://i.pinimg.com/originals/14/df/43/14df437e93ef277b0771bc46964c663c.jpg'));

ALTER TABLE BOOK ADD BOOK_TYPE VARCHAR2(255);

-- CREATE TABLE TEST (
--   id NUMBER(9) NOT NULL,
--   name VARCHAR2(20)
-- );

CREATE OR REPLACE FUNCTION ID_GENERATOR(N IN NUMBER,ID IN NUMBER)
RETURN NUMBER IS
 I NUMBER(10) := N;
 APPEND NUMBER := ID;
 ANSWER NUMBER;
BEGIN
  WHILE I > 0
  LOOP
    I := I/10;
    APPEND := APPEND * 10;
  END LOOP;
  ANSWER := APPEND + N;
  RETURN ANSWER;
END;

CREATE SEQUENCE BOOK__ID__SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE MEMBER__ID__SEQ INCREMENT BY 1 START WITH 1;

CREATE OR REPLACE PROCEDURE GENERATE_BOOK_ID(PRE_ID IN NUMBER,REQ_ID OUT NUMBER) IS
BEGIN
   REQ_ID := ID_GENERATOR( BOOK__ID__SEQ.nextval, PRE_ID);
END;

CREATE OR REPLACE PROCEDURE GENERATE_MEMBER_ID(PRE_ID IN NUMBER,REQ_ID OUT NUMBER) IS
BEGIN
   REQ_ID := ID_GENERATOR( MEMBER__ID__SEQ.nextval, PRE_ID);
END;

DECLARE
    NEW_BOOK_ID NUMBER(10);
BEGIN
    GENERATE_BOOK_ID(2,NEW_BOOK_ID);
    INSERT INTO BOOK (BOOK_ID, BOOK_NAME, AUTHOR_ID, PUBLISHER_NAME, COVER_IMAGE, STATUS, DATE_OF_ARRIVAL, YEAR,
    EDITION, NO_OF_PAGES, LANGUAGE, ADMIN_ID) VALUES (NEW_BOOK_ID,'ooooooo','AH','HAKKANI',NULL,'AVAILABLE',NULL,NULL,NULL,9,10,'AD1');
    INSERT INTO BOOKLIST_ACADEMIC (BOOK_ID, SUBJECT, TOPIC, DEPARTMENT) VALUES (NEW_BOOK_ID,'CSE','CSE','CSE');
END;


DECLARE
    NEW_MEMBER_ID NUMBER(10);
BEGIN
    GENERATE_MEMBER_ID(2,NEW_MEMBER_ID);
    INSERT INTO MEMBER (MEMBER_ID, MEMBER_NAME, EMAIL, PHONE_NUMBER, BLOOD_GROUP, DATE_OF_BIRTH, ADMIN_ID, PASSWORD,NUM_OF_ISSUE)
    VALUES (NEW_MEMBER_ID,:1,:2,:3,:4,:5,:6,:7,:8);
    INSERT INTO MEMBER_STUDENT (DEPT, STUDENT_ID, RESIDENCE, MEMBER_ID) VALUES (:9,:10,:11,NEW_MEMBER_ID);
END;





--DROP MENU
DROP FUNCTION ID_GENERATOR;
DROP PROCEDURE GENERATE_BOOK_ID;
DROP SEQUENCE BOOK__ID__SEQ;

SELECT COUNT(*) PRESENT
FROM BOOK
WHERE BOOK_ID = 12;

SELECT COUNT(*) PRESENT
FROM FAV_LIST
WHERE MEMBER_ID = :1 AND BOOK_ID = :2;

INSERT INTO FAV_LIST (MEMBER_ID, BOOK_ID) VALUES (:1,:2)

SELECT lower(MEMBER_NAME) MMNAME
FROM MEMBER
WHERE MEMBER_ID = 48;

INSERT INTO SUGG_LIST (MEMBER_ID, NAME, MESSAGE) VALUES (:1,:2,:3)

SELECT *
FROM ADMIN
WHERE ADMIN_ID = :1;

SELECT COUNT(*)
FROM MEMBER
WHERE MEMBER_ID = 1 OR PHONE_NUMBER = 2;

SELECT COUNT(*)
FROM MEMBER_STUDENT
WHERE STUDENT_ID = 1;

SELECT COUNT(*)
FROM MEMBER_TEACHER
WHERE TEACHER_ID = 1;

SELECT COUNT(*)
FROM MEMBER_OTHERS
WHERE DESIGNATION = 1 AND DEPT = 2 AND ADDRESS = 3;

INSERT INTO MEMBER (MEMBER_ID, MEMBER_NAME, EMAIL, PHONE_NUMBER, BLOOD_GROUP, DATE_OF_BIRTH, ADMIN_ID, PASSWORD) VALUES (1,2,3,4,5,6,7,8);

INSERT INTO MEMBER_STUDENT (DEPT, STUDENT_ID, RESIDENCE, MEMBER_ID) VALUES (1,2,3,4);

INSERT INTO MEMBER_TEACHER (MEMBER_ID, DEPT, ADDRESS, TEACHER_ID, DESIGNATION) VALUES (1,2,3,4,5);

INSERT INTO MEMBER_OTHERS (MEMBER_ID, DEPT, ADDRESS, DESIGNATION) VALUES (1,2,3,4);

SELECT COUNT(*) CNT
FROM MEMBER
WHERE MEMBER_ID = 1;

DELETE FROM MEMBER_STUDENT
WHERE MEMBER_ID = 1;

DELETE FROM MEMBER_TEACHER
WHERE MEMBER_ID = 1;

DELETE FROM MEMBER_OTHERS
WHERE MEMBER_ID = 1;

SELECT COUNT(*) CNT
FROM BOOK
WHERE BOOK_ID = 1;

SELECT COUNT(*) CNT
FROM AUTHOR
WHERE AUTHOR_ID = 1;

SELECT COUNT(*) CNT
FROM PUBLISHER
WHERE PUBLISHER_NAME = 1;

INSERT INTO BOOK (BOOK_ID, BOOK_NAME, AUTHOR_ID, PUBLISHER_NAME, COVER_IMAGE, STATUS, DATE_OF_ARRIVAL, YEAR, EDITION, NO_OF_PAGES, LANGUAGE, ADMIN_ID)
VALUES (1,2,3,4,5,6,7,8,9,10,11,12);

INSERT INTO BOOKLIST_ACADEMIC (BOOK_ID, SUBJECT, TOPIC, DEPARTMENT) VALUES (1,2,3,4);

INSERT INTO BOOKLIST_OTHERS (BOOK_ID, GENRE, CATEGORY) VALUES (1,2,3);

SELECT COUNT(*) CNT
FROM BOOK
WHERE BOOK_ID = 1;

SELECT COUNT(*) CNT
FROM MEMBER
WHERE MEMBER_ID = 1;

SELECT COUNT(*) CNT
FROM BOOK
WHERE BOOK_ID = 1;

INSERT INTO ISSUE_LIST (MEMBER_ID, BOOK_ID, ISSUE_DATE, ADMIN_ID) VALUES (:1,:2,:3);

DELETE FROM ISSUE_LIST
WHERE ISSUE_ID = :1;

INSERT INTO NEWS_AND_EVENTS (NEWS_DATE, IMAGE, DESCRIPTION) VALUES (:1,:2,:3);

SELECT COUNT(*) CNT
FROM ADMIN
WHERE ADMIN_ID = 1;

SELECT COUNT(*) CNT
FROM ADMIN
WHERE PHONE_NUMBER = 1;

INSERT INTO ADMIN (ADMIN_ID, ADMIN_PSW, NAME, EMAIL, PHONE_NUMBER) VALUES (1,2,3,4,5);

SELECT COUNT(*) CNT
FROM AUTHOR
WHERE AUTHOR_ID = 1;

INSERT INTO AUTHOR (AUTHOR_ID, AUTHOR_NAME, NATIONALITY, "LIFE-SPAN") VALUES (1,2,3,4);

SELECT COUNT(*) CNT
FROM PUBLISHER
WHERE PUBLISHER_NAME = 1;

INSERT INTO PUBLISHER (PUBLISHER_NAME, ADDRESS, PHONE_NUMBER) VALUES (1,2,3);

SELECT NAME, DESIGNATION, DEPT, ID, DATE_OF_BIRTH, ADDRESS, EMAIL, PHONE_NUMBER, BLOOD_GROUP, RESIDENCE
FROM APPLICANT
ORDER BY NAME;

SELECT BOOK.BOOK_ID, BOOK.BOOK_NAME, AUTHOR.AUTHOR_NAME, BOOK.PUBLISHER_NAME, BOOK.STATUS, BOOK.LANGUAGE, BOOK.YEAR, BOOK.EDITION, BOOK.NO_OF_PAGES
FROM BOOK JOIN AUTHOR ON (BOOK.AUTHOR_ID = AUTHOR.AUTHOR_ID)
WHERE BOOK.BOOK_NAME LIKE :1 AND BOOK.AUTHOR_ID LIKE :2;


SELECT *
    FROM MEMBER
    WHERE PHONE_NUMBER = 1--where


SELECT BOOK.BOOK_ID, BOOK.BOOK_NAME, AUTHOR.AUTHOR_NAME, BOOK.PUBLISHER_NAME, BOOK.STATUS, BOOK.LANGUAGE, BOOK.YEAR, BOOK.EDITION, BOOK.NO_OF_PAGES,COVER_IMAGE
    FROM BOOK JOIN AUTHOR ON (BOOK.AUTHOR_ID = AUTHOR.AUTHOR_ID)
WHERE AUTHOR.AUTHOR_ID = 'AH';

SELECT BOOK.BOOK_ID, BOOK.BOOK_NAME, AUTHOR.AUTHOR_NAME, BOOK.PUBLISHER_NAME, BOOK.STATUS, BOOK.LANGUAGE, BOOK.YEAR,
    BOOK.EDITION, BOOK.NO_OF_PAGES,COVER_IMAGE
    FROM BOOK JOIN AUTHOR ON (BOOK.AUTHOR_ID = AUTHOR.AUTHOR_ID);

INSERT INTO CONTACT_US (NAME, EMAIL, PHONE_NUMBER, MESSAGE) VALUES (1,:2,:3,:4);

SELECT * FROM SI_INFORMTN_SCHEMA.Tables;


SELECT BOOK.BOOK_ID, BOOK.BOOK_NAME, AUTHOR.AUTHOR_NAME, BOOK.PUBLISHER_NAME, BOOK.STATUS, BOOK.LANGUAGE, BOOK.YEAR,
    BOOK.EDITION, BOOK.NO_OF_PAGES,COVER_IMAGE
    FROM BOOK
    JOIN AUTHOR ON (BOOK.AUTHOR_ID = AUTHOR.AUTHOR_ID)
    JOIN BOOKLIST_ACADEMIC ON (BOOK.BOOK_ID = BOOKLIST_ACADEMIC.BOOK_ID)
    WHERE (BOOK.BOOK_NAME LIKE '%')
    OR (BOOK.BOOK_ID LIKE '%')
    OR (BOOK.STATUS LIKE '%')
    OR (AUTHOR.AUTHOR_NAME LIKE '%')
    OR (AUTHOR.AUTHOR_ID LIKE '%')
    OR (BOOK.PUBLISHER_NAME LIKE '%')
    OR (BOOK.LANGUAGE LIKE '%')
    OR (BOOKLIST_ACADEMIC.SUBJECT LIKE '%')
    ORDER BY AUTHOR.AUTHOR_NAME;

SELECT BOOK.BOOK_ID, BOOK.BOOK_NAME, AUTHOR.AUTHOR_NAME, BOOK.PUBLISHER_NAME, BOOK.STATUS, BOOK.LANGUAGE, BOOK.YEAR,
    BOOK.EDITION, BOOK.NO_OF_PAGES,COVER_IMAGE
    FROM BOOK
    JOIN AUTHOR ON (BOOK.AUTHOR_ID = AUTHOR.AUTHOR_ID)
    JOIN BOOKLIST_OTHERS ON (BOOK.BOOK_ID = BOOKLIST_OTHERS.BOOK_ID)
    WHERE (BOOK.BOOK_NAME LIKE '%')
    OR (BOOK.STATUS LIKE '%')
    OR (AUTHOR.AUTHOR_NAME LIKE '%')
    OR (AUTHOR.AUTHOR_ID LIKE '%')
    OR (BOOK.PUBLISHER_NAME LIKE '%')
    OR (BOOK.LANGUAGE LIKE '%')
    OR (BOOKLIST_OTHERS.CATEGORY LIKE '%')
    OR (BOOKLIST_OTHERS.GENRE LIKE '%')
    ORDER BY AUTHOR.AUTHOR_NAME;