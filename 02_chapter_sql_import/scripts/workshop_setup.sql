------------------------------------------------------------------------------
--  Workshop : Oracle APEX Workshop
--  Script   : workshop_setup.sql
--  Author   : Sajjad Hanifa
--  Company  : S&H Software Solutions
--  Website  : https://shsoftwaresolution.com
--  Version  : 1.0.0
--  Date     : 2026-05-19
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- COMPANIES
------------------------------------------------------------------------------
DECLARE
    l_count NUMBER;
    l_sql   VARCHAR2(32767);
BEGIN
    --------------------------------------------------------------------------
    -- DROP COMPANIES TABLE (if exists)
    --------------------------------------------------------------------------
    SELECT COUNT(1)
      INTO l_count
      FROM user_tables
     WHERE table_name = 'COMPANIES'
    ;

    IF l_count > 0 THEN
        l_sql := 'DROP TABLE COMPANIES CASCADE CONSTRAINTS';
        EXECUTE IMMEDIATE l_sql;
    END IF;

    --------------------------------------------------------------------------
    -- DROP COMP_SEQ SEQUENCE (if exists)
    --------------------------------------------------------------------------
    SELECT COUNT(1)
      INTO l_count
      FROM user_sequences
     WHERE sequence_name = 'COMP_SEQ'
    ;

    IF l_count > 0 THEN
        l_sql := 'DROP SEQUENCE COMP_SEQ';
        EXECUTE IMMEDIATE l_sql;
    END IF;
END;
/

------------------------------------------------------------------------------
-- CREATE COMPANIES SEQUENCE
------------------------------------------------------------------------------
CREATE SEQUENCE COMP_SEQ
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE
;
/

------------------------------------------------------------------------------
-- CREATE COMPANIES TABLE
------------------------------------------------------------------------------
CREATE TABLE COMPANIES(
    --------------------------------------------------------------------------
    -- PRIMARY KEY
    --------------------------------------------------------------------------
    COMP_ID                    NUMBER         DEFAULT COMP_SEQ.NEXTVAL NOT NULL
  , --------------------------------------------------------------------------
    -- COMPANY MASTER DATA
    --------------------------------------------------------------------------
    COMP_NAME                  VARCHAR2(300)  NOT NULL
  , COMP_SHORT_NAME            VARCHAR2(100)
  , COMP_EMAIL                 VARCHAR2(320)
  , COMP_PHONE                 VARCHAR2(50)
  , COMP_STREET                VARCHAR2(400)
  , COMP_STREET_NR             VARCHAR2(50)
  , COMP_POSTCODE              VARCHAR2(20)
  , COMP_CITY                  VARCHAR2(200)
  , COMP_COUNTRY               VARCHAR2(100)
  , COMP_ACTIVE_YN             VARCHAR2(4)    DEFAULT 'YES' NOT NULL
  , --------------------------------------------------------------------------
    -- AUDIT & LIFECYCLE
    --------------------------------------------------------------------------
    COMP_REMARK                CLOB
  , COMP_CREATED               TIMESTAMP(6)   DEFAULT SYSDATE
  , COMP_CREATED_BY            VARCHAR2(4000) DEFAULT COALESCE( SYS_CONTEXT('apex$session', 'app_user') , SYS_CONTEXT('userenv', 'os_user') , SYS_CONTEXT('userenv', 'session_user') )
  , COMP_UPDATED               TIMESTAMP(6)   DEFAULT SYSDATE
  , COMP_UPDATED_BY            VARCHAR2(4000) DEFAULT COALESCE( SYS_CONTEXT('apex$session', 'app_user') , SYS_CONTEXT('userenv', 'os_user') , SYS_CONTEXT('userenv', 'session_user') )
  , COMP_VALID_FROM            TIMESTAMP(6)   DEFAULT SYSDATE
  , COMP_VALID_TO              TIMESTAMP(6)   DEFAULT TO_DATE('31.12.2999', 'DD.MM.YYYY')
  , COMP_DELETED_YN            VARCHAR2(4)    DEFAULT 'NO'
  , --------------------------------------------------------------------------
    -- CONSTRAINTS
    --------------------------------------------------------------------------
    CONSTRAINT PK_COMP_ID PRIMARY KEY (COMP_ID)
);
/

------------------------------------------------------------------------------
-- USERS
------------------------------------------------------------------------------
DECLARE
    l_count NUMBER;
    l_sql   VARCHAR2(32767);
BEGIN
    --------------------------------------------------------------------------
    -- DROP USERS TABLE (if exists)
    --------------------------------------------------------------------------
    SELECT COUNT(1)
      INTO l_count
      FROM user_tables
     WHERE table_name = 'USERS'
    ;

    IF l_count > 0 THEN
        l_sql := 'DROP TABLE USERS CASCADE CONSTRAINTS';
        EXECUTE IMMEDIATE l_sql;
    END IF;

    --------------------------------------------------------------------------
    -- DROP USER_SEQ SEQUENCE (if exists)
    --------------------------------------------------------------------------
    SELECT COUNT(1)
      INTO l_count
      FROM user_sequences
     WHERE sequence_name = 'USER_SEQ'
    ;

    IF l_count > 0 THEN
        l_sql := 'DROP SEQUENCE USER_SEQ';
        EXECUTE IMMEDIATE l_sql;
    END IF;
END;
/

------------------------------------------------------------------------------
-- CREATE USERS SEQUENCE
------------------------------------------------------------------------------
CREATE SEQUENCE USER_SEQ
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE
;
/

------------------------------------------------------------------------------
-- CREATE USERS TABLE
------------------------------------------------------------------------------
CREATE TABLE USERS(
    --------------------------------------------------------------------------
    -- PRIMARY KEY
    --------------------------------------------------------------------------
    USER_ID                    NUMBER         DEFAULT USER_SEQ.NEXTVAL NOT NULL
  , --------------------------------------------------------------------------
    -- RELATIONSHIPS
    --------------------------------------------------------------------------
    USER_COMP_FK               NUMBER         NOT NULL
  , --------------------------------------------------------------------------
    -- USER MASTER DATA
    --------------------------------------------------------------------------
    USER_FIRST_NAME            VARCHAR2(200)  NOT NULL
  , USER_LAST_NAME             VARCHAR2(200)  NOT NULL
  , USER_LOGIN_EMAIL           VARCHAR2(320)  NOT NULL
  , USER_LOGIN_PASSWORD        VARCHAR2(4000) NOT NULL
  , USER_ACTIVE_YN             VARCHAR2(4)    DEFAULT 'YES' NOT NULL
  , --------------------------------------------------------------------------
    -- AUDIT & LIFECYCLE
    --------------------------------------------------------------------------
    USER_REMARK                CLOB
  , USER_CREATED               TIMESTAMP(6)   DEFAULT SYSDATE
  , USER_CREATED_BY            VARCHAR2(4000) DEFAULT COALESCE( SYS_CONTEXT('apex$session', 'app_user') , SYS_CONTEXT('userenv', 'os_user') , SYS_CONTEXT('userenv', 'session_user') )
  , USER_UPDATED               TIMESTAMP(6)   DEFAULT SYSDATE
  , USER_UPDATED_BY            VARCHAR2(4000) DEFAULT COALESCE( SYS_CONTEXT('apex$session', 'app_user') , SYS_CONTEXT('userenv', 'os_user') , SYS_CONTEXT('userenv', 'session_user') )
  , USER_VALID_FROM            TIMESTAMP(6)   DEFAULT SYSDATE
  , USER_VALID_TO              TIMESTAMP(6)   DEFAULT TO_DATE('31.12.2999', 'DD.MM.YYYY')
  , USER_DELETED_YN            VARCHAR2(4)    DEFAULT 'NO'
  , --------------------------------------------------------------------------
    -- CONSTRAINTS
    --------------------------------------------------------------------------
    CONSTRAINT PK_USER_ID      PRIMARY KEY (USER_ID)
  , CONSTRAINT FK_USER_COMP_FK FOREIGN KEY (USER_COMP_FK) REFERENCES COMPANIES (COMP_ID)
);
/

------------------------------------------------------------------------------
-- CUSTOMERS
------------------------------------------------------------------------------
DECLARE
    l_count NUMBER;
    l_sql   VARCHAR2(32767);
BEGIN
    --------------------------------------------------------------------------
    -- DROP CUSTOMERS TABLE (if exists)
    --------------------------------------------------------------------------
    SELECT COUNT(1)
      INTO l_count
      FROM user_tables
     WHERE table_name = 'CUSTOMERS'
    ;

    IF l_count > 0 THEN
        l_sql := 'DROP TABLE CUSTOMERS CASCADE CONSTRAINTS';
        EXECUTE IMMEDIATE l_sql;
    END IF;

    --------------------------------------------------------------------------
    -- DROP CUST_SEQ SEQUENCE (if exists)
    --------------------------------------------------------------------------
    SELECT COUNT(1)
      INTO l_count
      FROM user_sequences
     WHERE sequence_name = 'CUST_SEQ'
    ;

    IF l_count > 0 THEN
        l_sql := 'DROP SEQUENCE CUST_SEQ';
        EXECUTE IMMEDIATE l_sql;
    END IF;
END;
/

------------------------------------------------------------------------------
-- CREATE CUSTOMERS SEQUENCE
------------------------------------------------------------------------------
CREATE SEQUENCE CUST_SEQ
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE
;
/

------------------------------------------------------------------------------
-- CREATE CUSTOMERS TABLE
------------------------------------------------------------------------------
CREATE TABLE CUSTOMERS(
    --------------------------------------------------------------------------
    -- PRIMARY KEY
    --------------------------------------------------------------------------
    CUST_ID                    NUMBER         DEFAULT CUST_SEQ.NEXTVAL NOT NULL
  , --------------------------------------------------------------------------
    -- RELATIONSHIPS
    --------------------------------------------------------------------------
    CUST_COMP_FK               NUMBER         NOT NULL
  , --------------------------------------------------------------------------
    -- CUSTOMER MASTER DATA
    --------------------------------------------------------------------------
    CUST_FIRST_NAME            VARCHAR2(200)  NOT NULL
  , CUST_LAST_NAME             VARCHAR2(200)  NOT NULL
  , CUST_EMAIL                 VARCHAR2(320)
  , CUST_PHONE                 VARCHAR2(50)
  , CUST_STREET                VARCHAR2(400)
  , CUST_STREET_NR             VARCHAR2(50)
  , CUST_POSTCODE              VARCHAR2(20)
  , CUST_CITY                  VARCHAR2(200)
  , CUST_COUNTRY               VARCHAR2(100)
  , CUST_ACTIVE_YN             VARCHAR2(4)    DEFAULT 'YES' NOT NULL
  , --------------------------------------------------------------------------
    -- AUDIT & LIFECYCLE
    --------------------------------------------------------------------------
    CUST_REMARK                CLOB
  , CUST_CREATED               TIMESTAMP(6)   DEFAULT SYSDATE
  , CUST_CREATED_BY            VARCHAR2(4000) DEFAULT COALESCE( SYS_CONTEXT('apex$session', 'app_user') , SYS_CONTEXT('userenv', 'os_user') , SYS_CONTEXT('userenv', 'session_user') )
  , CUST_UPDATED               TIMESTAMP(6)   DEFAULT SYSDATE
  , CUST_UPDATED_BY            VARCHAR2(4000) DEFAULT COALESCE( SYS_CONTEXT('apex$session', 'app_user') , SYS_CONTEXT('userenv', 'os_user') , SYS_CONTEXT('userenv', 'session_user') )
  , CUST_VALID_FROM            TIMESTAMP(6)   DEFAULT SYSDATE
  , CUST_VALID_TO              TIMESTAMP(6)   DEFAULT TO_DATE('31.12.2999', 'DD.MM.YYYY')
  , CUST_DELETED_YN            VARCHAR2(4)    DEFAULT 'NO'
  , --------------------------------------------------------------------------
    -- CONSTRAINTS
    --------------------------------------------------------------------------
    CONSTRAINT PK_CUST_ID      PRIMARY KEY (CUST_ID)
  , CONSTRAINT FK_CUST_COMP_FK FOREIGN KEY (CUST_COMP_FK) REFERENCES COMPANIES (COMP_ID)
);
/

------------------------------------------------------------------------------
-- ITEMS
------------------------------------------------------------------------------
DECLARE
    l_count NUMBER;
    l_sql   VARCHAR2(32767);
BEGIN
    --------------------------------------------------------------------------
    -- DROP ITEMS TABLE (if exists)
    --------------------------------------------------------------------------
    SELECT COUNT(1)
      INTO l_count
      FROM user_tables
     WHERE table_name = 'ITEMS'
    ;

    IF l_count > 0 THEN
        l_sql := 'DROP TABLE ITEMS CASCADE CONSTRAINTS';
        EXECUTE IMMEDIATE l_sql;
    END IF;

    --------------------------------------------------------------------------
    -- DROP ITEM_SEQ SEQUENCE (if exists)
    --------------------------------------------------------------------------
    SELECT COUNT(1)
      INTO l_count
      FROM user_sequences
     WHERE sequence_name = 'ITEM_SEQ'
    ;

    IF l_count > 0 THEN
        l_sql := 'DROP SEQUENCE ITEM_SEQ';
        EXECUTE IMMEDIATE l_sql;
    END IF;
END;
/

------------------------------------------------------------------------------
-- CREATE ITEMS SEQUENCE
------------------------------------------------------------------------------
CREATE SEQUENCE ITEM_SEQ
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE
;
/

------------------------------------------------------------------------------
-- CREATE ITEMS TABLE
------------------------------------------------------------------------------
CREATE TABLE ITEMS(
    --------------------------------------------------------------------------
    -- PRIMARY KEY
    --------------------------------------------------------------------------
    ITEM_ID                    NUMBER         DEFAULT ITEM_SEQ.NEXTVAL NOT NULL
  , --------------------------------------------------------------------------
    -- RELATIONSHIPS
    --------------------------------------------------------------------------
    ITEM_COMP_FK               NUMBER         NOT NULL
  , --------------------------------------------------------------------------
    -- ITEM MASTER DATA
    --------------------------------------------------------------------------
    ITEM_NAME                  VARCHAR2(300)  NOT NULL
  , ITEM_DESCRIPTION           CLOB
  , ITEM_PRICE                 NUMBER         NOT NULL
  , ITEM_STOCK_QTY             NUMBER         DEFAULT 0
  , ITEM_ACTIVE_YN             VARCHAR2(4)    DEFAULT 'YES' NOT NULL
  , --------------------------------------------------------------------------
    -- AUDIT & LIFECYCLE
    --------------------------------------------------------------------------
    ITEM_REMARK                CLOB
  , ITEM_CREATED               TIMESTAMP(6)   DEFAULT SYSDATE
  , ITEM_CREATED_BY            VARCHAR2(4000) DEFAULT COALESCE( SYS_CONTEXT('apex$session', 'app_user') , SYS_CONTEXT('userenv', 'os_user') , SYS_CONTEXT('userenv', 'session_user') )
  , ITEM_UPDATED               TIMESTAMP(6)   DEFAULT SYSDATE
  , ITEM_UPDATED_BY            VARCHAR2(4000) DEFAULT COALESCE( SYS_CONTEXT('apex$session', 'app_user') , SYS_CONTEXT('userenv', 'os_user') , SYS_CONTEXT('userenv', 'session_user') )
  , ITEM_VALID_FROM            TIMESTAMP(6)   DEFAULT SYSDATE
  , ITEM_VALID_TO              TIMESTAMP(6)   DEFAULT TO_DATE('31.12.2999', 'DD.MM.YYYY')
  , ITEM_DELETED_YN            VARCHAR2(4)    DEFAULT 'NO'
  , --------------------------------------------------------------------------
    -- CONSTRAINTS
    --------------------------------------------------------------------------
    CONSTRAINT PK_ITEM_ID      PRIMARY KEY (ITEM_ID)
  , CONSTRAINT FK_ITEM_COMP_FK FOREIGN KEY (ITEM_COMP_FK) REFERENCES COMPANIES (COMP_ID)
);
/

------------------------------------------------------------------------------
-- ORDERS
------------------------------------------------------------------------------
DECLARE
    l_count NUMBER;
    l_sql   VARCHAR2(32767);
BEGIN
    --------------------------------------------------------------------------
    -- DROP ORDERS TABLE (if exists)
    --------------------------------------------------------------------------
    SELECT COUNT(1)
      INTO l_count
      FROM user_tables
     WHERE table_name = 'ORDERS'
    ;

    IF l_count > 0 THEN
        l_sql := 'DROP TABLE ORDERS CASCADE CONSTRAINTS';
        EXECUTE IMMEDIATE l_sql;
    END IF;

    --------------------------------------------------------------------------
    -- DROP ORDE_SEQ SEQUENCE (if exists)
    --------------------------------------------------------------------------
    SELECT COUNT(1)
      INTO l_count
      FROM user_sequences
     WHERE sequence_name = 'ORDE_SEQ'
    ;

    IF l_count > 0 THEN
        l_sql := 'DROP SEQUENCE ORDE_SEQ';
        EXECUTE IMMEDIATE l_sql;
    END IF;
END;
/

------------------------------------------------------------------------------
-- CREATE ORDERS SEQUENCE
------------------------------------------------------------------------------
CREATE SEQUENCE ORDE_SEQ
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE
;
/

------------------------------------------------------------------------------
-- CREATE ORDERS TABLE
------------------------------------------------------------------------------
CREATE TABLE ORDERS(
    --------------------------------------------------------------------------
    -- PRIMARY KEY
    --------------------------------------------------------------------------
    ORDE_ID                    NUMBER         DEFAULT ORDE_SEQ.NEXTVAL NOT NULL
  , --------------------------------------------------------------------------
    -- RELATIONSHIPS
    --------------------------------------------------------------------------
    ORDE_CUST_FK               NUMBER         NOT NULL
  , --------------------------------------------------------------------------
    -- ORDER MASTER DATA
    --------------------------------------------------------------------------
    ORDE_DATE                  TIMESTAMP(6)   DEFAULT SYSDATE NOT NULL
  , ORDE_STATUS                VARCHAR2(50)   DEFAULT 'NEW' NOT NULL
  , ORDE_ACTIVE_YN             VARCHAR2(4)    DEFAULT 'YES' NOT NULL
  , --------------------------------------------------------------------------
    -- AUDIT & LIFECYCLE
    --------------------------------------------------------------------------
    ORDE_REMARK                CLOB
  , ORDE_CREATED               TIMESTAMP(6)   DEFAULT SYSDATE
  , ORDE_CREATED_BY            VARCHAR2(4000) DEFAULT COALESCE( SYS_CONTEXT('apex$session', 'app_user') , SYS_CONTEXT('userenv', 'os_user') , SYS_CONTEXT('userenv', 'session_user') )
  , ORDE_UPDATED               TIMESTAMP(6)   DEFAULT SYSDATE
  , ORDE_UPDATED_BY            VARCHAR2(4000) DEFAULT COALESCE( SYS_CONTEXT('apex$session', 'app_user') , SYS_CONTEXT('userenv', 'os_user') , SYS_CONTEXT('userenv', 'session_user') )
  , ORDE_VALID_FROM            TIMESTAMP(6)   DEFAULT SYSDATE
  , ORDE_VALID_TO              TIMESTAMP(6)   DEFAULT TO_DATE('31.12.2999', 'DD.MM.YYYY')
  , ORDE_DELETED_YN            VARCHAR2(4)    DEFAULT 'NO'
  , --------------------------------------------------------------------------
    -- CONSTRAINTS
    --------------------------------------------------------------------------
    CONSTRAINT PK_ORDE_ID      PRIMARY KEY (ORDE_ID)
  , CONSTRAINT FK_ORDE_CUST_FK FOREIGN KEY (ORDE_CUST_FK) REFERENCES CUSTOMERS (CUST_ID)
);
/

------------------------------------------------------------------------------
-- ORDER_ITEMS
------------------------------------------------------------------------------
DECLARE
    l_count NUMBER;
    l_sql   VARCHAR2(32767);
BEGIN
    --------------------------------------------------------------------------
    -- DROP ORDER_ITEMS TABLE (if exists)
    --------------------------------------------------------------------------
    SELECT COUNT(1)
      INTO l_count
      FROM user_tables
     WHERE table_name = 'ORDER_ITEMS'
    ;

    IF l_count > 0 THEN
        l_sql := 'DROP TABLE ORDER_ITEMS CASCADE CONSTRAINTS';
        EXECUTE IMMEDIATE l_sql;
    END IF;

    --------------------------------------------------------------------------
    -- DROP ORIT_SEQ SEQUENCE (if exists)
    --------------------------------------------------------------------------
    SELECT COUNT(1)
      INTO l_count
      FROM user_sequences
     WHERE sequence_name = 'ORIT_SEQ'
    ;

    IF l_count > 0 THEN
        l_sql := 'DROP SEQUENCE ORIT_SEQ';
        EXECUTE IMMEDIATE l_sql;
    END IF;
END;
/

------------------------------------------------------------------------------
-- CREATE ORDER_ITEMS SEQUENCE
------------------------------------------------------------------------------
CREATE SEQUENCE ORIT_SEQ
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE
;
/

------------------------------------------------------------------------------
-- CREATE ORDER_ITEMS TABLE
------------------------------------------------------------------------------
CREATE TABLE ORDER_ITEMS(
    --------------------------------------------------------------------------
    -- PRIMARY KEY
    --------------------------------------------------------------------------
    ORIT_ID                    NUMBER         DEFAULT ORIT_SEQ.NEXTVAL NOT NULL
  , --------------------------------------------------------------------------
    -- RELATIONSHIPS
    --------------------------------------------------------------------------
    ORIT_ORDE_FK               NUMBER         NOT NULL
  , ORIT_ITEM_FK               NUMBER         NOT NULL
  , --------------------------------------------------------------------------
    -- ORDER ITEM DATA
    --------------------------------------------------------------------------
    ORIT_QUANTITY              NUMBER         NOT NULL
  , ORIT_UNIT_PRICE            NUMBER         NOT NULL
  , --------------------------------------------------------------------------
    -- AUDIT & LIFECYCLE
    --------------------------------------------------------------------------
    ORIT_REMARK                CLOB
  , ORIT_CREATED               TIMESTAMP(6)   DEFAULT SYSDATE
  , ORIT_CREATED_BY            VARCHAR2(4000) DEFAULT COALESCE( SYS_CONTEXT('apex$session', 'app_user') , SYS_CONTEXT('userenv', 'os_user') , SYS_CONTEXT('userenv', 'session_user') )
  , ORIT_UPDATED               TIMESTAMP(6)   DEFAULT SYSDATE
  , ORIT_UPDATED_BY            VARCHAR2(4000) DEFAULT COALESCE( SYS_CONTEXT('apex$session', 'app_user') , SYS_CONTEXT('userenv', 'os_user') , SYS_CONTEXT('userenv', 'session_user') )
  , ORIT_VALID_FROM            TIMESTAMP(6)   DEFAULT SYSDATE
  , ORIT_VALID_TO              TIMESTAMP(6)   DEFAULT TO_DATE('31.12.2999', 'DD.MM.YYYY')
  , ORIT_DELETED_YN            VARCHAR2(4)    DEFAULT 'NO'
  , --------------------------------------------------------------------------
    -- CONSTRAINTS
    --------------------------------------------------------------------------
    CONSTRAINT PK_ORIT_ID      PRIMARY KEY (ORIT_ID)
  , CONSTRAINT FK_ORIT_ORDE_FK FOREIGN KEY (ORIT_ORDE_FK) REFERENCES ORDERS     (ORDE_ID)
  , CONSTRAINT FK_ORIT_ITEM_FK FOREIGN KEY (ORIT_ITEM_FK) REFERENCES ITEMS      (ITEM_ID)
);
/
------------------------------------------------------------------------------
-- COMPANIES
------------------------------------------------------------------------------
INSERT INTO COMPANIES (
    COMP_NAME
  , COMP_SHORT_NAME
  , COMP_EMAIL
  , COMP_PHONE
  , COMP_STREET
  , COMP_STREET_NR
  , COMP_POSTCODE
  , COMP_CITY
  , COMP_COUNTRY
) VALUES (
    'S&H Software Solutions GmbH'
  , 'SH-SS'
  , 'info@shsoftwaresolution.com'
  , '+49 69 123456'
  , 'Frankfurter Straße'
  , '1'
  , '60311'
  , 'Frankfurt am Main'
  , 'Germany'
);

------------------------------------------------------------------------------
-- USERS
------------------------------------------------------------------------------
INSERT INTO USERS (
    USER_COMP_FK
  , USER_FIRST_NAME
  , USER_LAST_NAME
  , USER_LOGIN_EMAIL
  , USER_LOGIN_PASSWORD
) VALUES (
    (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS')
  , 'John'
  , 'Doe'
  , 'john.doe@shsoftwaresolution.com'
  , 'Admin1234!'
);

------------------------------------------------------------------------------
-- CUSTOMERS
------------------------------------------------------------------------------

-- Sajjad – Frankfurt, Germany
INSERT INTO CUSTOMERS ( CUST_COMP_FK, CUST_FIRST_NAME, CUST_LAST_NAME, CUST_EMAIL, CUST_CITY, CUST_COUNTRY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Sajjad', 'Hanifa', 'sajjad@shsoftwaresolution.com', 'Frankfurt am Main', 'Germany' );

-- Pakistan
INSERT INTO CUSTOMERS ( CUST_COMP_FK, CUST_FIRST_NAME, CUST_LAST_NAME, CUST_CITY, CUST_COUNTRY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Awais', 'Ahmed', 'Karachi', 'Pakistan' );

INSERT INTO CUSTOMERS ( CUST_COMP_FK, CUST_FIRST_NAME, CUST_LAST_NAME, CUST_CITY, CUST_COUNTRY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Ahmad', 'Ali', 'Lahore', 'Pakistan' );

INSERT INTO CUSTOMERS ( CUST_COMP_FK, CUST_FIRST_NAME, CUST_LAST_NAME, CUST_CITY, CUST_COUNTRY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Abbas', 'Khan', 'Islamabad', 'Pakistan' );

INSERT INTO CUSTOMERS ( CUST_COMP_FK, CUST_FIRST_NAME, CUST_LAST_NAME, CUST_CITY, CUST_COUNTRY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Shahzaib', 'Ahmed', 'Rawalpindi', 'Pakistan' );

INSERT INTO CUSTOMERS ( CUST_COMP_FK, CUST_FIRST_NAME, CUST_LAST_NAME, CUST_CITY, CUST_COUNTRY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Hassan', 'Khan', 'Peshawar', 'Pakistan' );

INSERT INTO CUSTOMERS ( CUST_COMP_FK, CUST_FIRST_NAME, CUST_LAST_NAME, CUST_CITY, CUST_COUNTRY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Rameen', 'Khan', 'Karachi', 'Pakistan' );

INSERT INTO CUSTOMERS ( CUST_COMP_FK, CUST_FIRST_NAME, CUST_LAST_NAME, CUST_CITY, CUST_COUNTRY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Kamran', 'Sheikh', 'Lahore', 'Pakistan' );

INSERT INTO CUSTOMERS ( CUST_COMP_FK, CUST_FIRST_NAME, CUST_LAST_NAME, CUST_CITY, CUST_COUNTRY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Abdullah', 'Malik', 'Faisalabad', 'Pakistan' );

INSERT INTO CUSTOMERS ( CUST_COMP_FK, CUST_FIRST_NAME, CUST_LAST_NAME, CUST_CITY, CUST_COUNTRY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Hassaan', 'Tahir', 'Islamabad', 'Pakistan' );

INSERT INTO CUSTOMERS ( CUST_COMP_FK, CUST_FIRST_NAME, CUST_LAST_NAME, CUST_CITY, CUST_COUNTRY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Saif', 'Ullah', 'Multan', 'Pakistan' );

INSERT INTO CUSTOMERS ( CUST_COMP_FK, CUST_FIRST_NAME, CUST_LAST_NAME, CUST_CITY, CUST_COUNTRY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Jamshaid', 'Khan', 'Quetta', 'Pakistan' );

INSERT INTO CUSTOMERS ( CUST_COMP_FK, CUST_FIRST_NAME, CUST_LAST_NAME, CUST_CITY, CUST_COUNTRY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Mustafa', 'Ahmed', 'Karachi', 'Pakistan' );

-- Worldwide
INSERT INTO CUSTOMERS ( CUST_COMP_FK, CUST_FIRST_NAME, CUST_LAST_NAME, CUST_CITY, CUST_COUNTRY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'James', 'Smith', 'New York', 'USA' );

INSERT INTO CUSTOMERS ( CUST_COMP_FK, CUST_FIRST_NAME, CUST_LAST_NAME, CUST_CITY, CUST_COUNTRY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Maria', 'Garcia', 'Madrid', 'Spain' );

INSERT INTO CUSTOMERS ( CUST_COMP_FK, CUST_FIRST_NAME, CUST_LAST_NAME, CUST_CITY, CUST_COUNTRY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Yuki', 'Tanaka', 'Tokyo', 'Japan' );

INSERT INTO CUSTOMERS ( CUST_COMP_FK, CUST_FIRST_NAME, CUST_LAST_NAME, CUST_CITY, CUST_COUNTRY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Sophie', 'Müller', 'Berlin', 'Germany' );

INSERT INTO CUSTOMERS ( CUST_COMP_FK, CUST_FIRST_NAME, CUST_LAST_NAME, CUST_CITY, CUST_COUNTRY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Carlos', 'Silva', 'São Paulo', 'Brazil' );

COMMIT;

------------------------------------------------------------------------------
-- ITEMS
------------------------------------------------------------------------------

-- Smartphones
INSERT INTO ITEMS ( ITEM_COMP_FK, ITEM_NAME, ITEM_PRICE, ITEM_STOCK_QTY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'iPhone 16 Pro Max', 1329.00, 50 );

INSERT INTO ITEMS ( ITEM_COMP_FK, ITEM_NAME, ITEM_PRICE, ITEM_STOCK_QTY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'iPhone 16 Pro', 1199.00, 75 );

INSERT INTO ITEMS ( ITEM_COMP_FK, ITEM_NAME, ITEM_PRICE, ITEM_STOCK_QTY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Samsung Galaxy S25 Ultra', 1299.00, 40 );

INSERT INTO ITEMS ( ITEM_COMP_FK, ITEM_NAME, ITEM_PRICE, ITEM_STOCK_QTY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Samsung Galaxy S25', 899.00, 60 );

INSERT INTO ITEMS ( ITEM_COMP_FK, ITEM_NAME, ITEM_PRICE, ITEM_STOCK_QTY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Google Pixel 9 Pro', 1099.00, 35 );

-- Laptops
INSERT INTO ITEMS ( ITEM_COMP_FK, ITEM_NAME, ITEM_PRICE, ITEM_STOCK_QTY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'MacBook Pro 14" M4 Pro', 2199.00, 25 );

INSERT INTO ITEMS ( ITEM_COMP_FK, ITEM_NAME, ITEM_PRICE, ITEM_STOCK_QTY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'MacBook Air 13" M3', 1299.00, 45 );

INSERT INTO ITEMS ( ITEM_COMP_FK, ITEM_NAME, ITEM_PRICE, ITEM_STOCK_QTY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Dell XPS 15 2025', 1799.00, 30 );

INSERT INTO ITEMS ( ITEM_COMP_FK, ITEM_NAME, ITEM_PRICE, ITEM_STOCK_QTY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Lenovo ThinkPad X1 Carbon Gen 13', 1649.00, 20 );

INSERT INTO ITEMS ( ITEM_COMP_FK, ITEM_NAME, ITEM_PRICE, ITEM_STOCK_QTY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Microsoft Surface Laptop 7', 1499.00, 30 );

-- Tablets
INSERT INTO ITEMS ( ITEM_COMP_FK, ITEM_NAME, ITEM_PRICE, ITEM_STOCK_QTY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'iPad Pro 13" M4', 1299.00, 40 );

INSERT INTO ITEMS ( ITEM_COMP_FK, ITEM_NAME, ITEM_PRICE, ITEM_STOCK_QTY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Samsung Galaxy Tab S10 Ultra', 1119.00, 35 );

-- Accessories
INSERT INTO ITEMS ( ITEM_COMP_FK, ITEM_NAME, ITEM_PRICE, ITEM_STOCK_QTY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'AirPods Pro 2nd Gen', 249.00, 150 );

INSERT INTO ITEMS ( ITEM_COMP_FK, ITEM_NAME, ITEM_PRICE, ITEM_STOCK_QTY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Samsung Galaxy Buds 3 Pro', 199.00, 120 );

INSERT INTO ITEMS ( ITEM_COMP_FK, ITEM_NAME, ITEM_PRICE, ITEM_STOCK_QTY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Apple Watch Series 10', 449.00, 80 );

INSERT INTO ITEMS ( ITEM_COMP_FK, ITEM_NAME, ITEM_PRICE, ITEM_STOCK_QTY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Apple Magic Keyboard with Touch ID', 109.00, 100 );

INSERT INTO ITEMS ( ITEM_COMP_FK, ITEM_NAME, ITEM_PRICE, ITEM_STOCK_QTY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'MagSafe Charger 25W', 39.00, 200 );

INSERT INTO ITEMS ( ITEM_COMP_FK, ITEM_NAME, ITEM_PRICE, ITEM_STOCK_QTY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'iPhone 16 Pro Silicone Case', 55.00, 250 );

INSERT INTO ITEMS ( ITEM_COMP_FK, ITEM_NAME, ITEM_PRICE, ITEM_STOCK_QTY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'USB-C Hub 10-in-1', 49.00, 180 );

INSERT INTO ITEMS ( ITEM_COMP_FK, ITEM_NAME, ITEM_PRICE, ITEM_STOCK_QTY )
VALUES ( (SELECT COMP_ID FROM COMPANIES WHERE COMP_SHORT_NAME = 'SH-SS'), 'Laptop Stand Pro', 79.00, 150 );

COMMIT;

------------------------------------------------------------------------------
-- ORDERS
------------------------------------------------------------------------------

-- Sajjad Hanifa
INSERT INTO ORDERS ( ORDE_CUST_FK, ORDE_STATUS )
VALUES ( (SELECT CUST_ID FROM CUSTOMERS WHERE CUST_FIRST_NAME = 'Sajjad' AND CUST_LAST_NAME = 'Hanifa'), 'NEW' );

-- Awais Ahmed
INSERT INTO ORDERS ( ORDE_CUST_FK, ORDE_STATUS )
VALUES ( (SELECT CUST_ID FROM CUSTOMERS WHERE CUST_FIRST_NAME = 'Awais' AND CUST_LAST_NAME = 'Ahmed'), 'CONFIRMED' );

-- Hassan Khan
INSERT INTO ORDERS ( ORDE_CUST_FK, ORDE_STATUS )
VALUES ( (SELECT CUST_ID FROM CUSTOMERS WHERE CUST_FIRST_NAME = 'Hassan' AND CUST_LAST_NAME = 'Khan'), 'SHIPPED' );

-- Hassaan Tahir
INSERT INTO ORDERS ( ORDE_CUST_FK, ORDE_STATUS )
VALUES ( (SELECT CUST_ID FROM CUSTOMERS WHERE CUST_FIRST_NAME = 'Hassaan' AND CUST_LAST_NAME = 'Tahir'), 'DONE' );

COMMIT;

------------------------------------------------------------------------------
-- ORDER_ITEMS (random, 4-7 items per order)
------------------------------------------------------------------------------
DECLARE
    TYPE t_ids         IS TABLE OF NUMBER;
    l_order_ids        t_ids;
    l_item_ids         t_ids;
    l_item_count       NUMBER;
    l_item_idx         NUMBER;
    l_used_items       t_ids := t_ids();
    l_already_used     BOOLEAN;
BEGIN
    -- Load all order IDs
    SELECT ORDE_ID BULK COLLECT INTO l_order_ids FROM ORDERS;

    -- Load all item IDs
    SELECT ITEM_ID BULK COLLECT INTO l_item_ids FROM ITEMS;

    -- Loop through each order and insert 4-7 random items
    FOR i IN 1..l_order_ids.COUNT LOOP

        l_item_count := TRUNC(DBMS_RANDOM.VALUE(4, 8)); -- 4 to 7
        l_used_items := t_ids();

        FOR j IN 1..l_item_count LOOP

            -- Pick a random item, avoid duplicates within the same order
            LOOP
                l_item_idx     := TRUNC(DBMS_RANDOM.VALUE(1, l_item_ids.COUNT + 1));
                l_already_used := FALSE;

                FOR k IN 1..l_used_items.COUNT LOOP
                    IF l_used_items(k) = l_item_ids(l_item_idx) THEN
                        l_already_used := TRUE;
                        EXIT;
                    END IF;
                END LOOP;

                EXIT WHEN NOT l_already_used;
            END LOOP;

            -- Mark item as used for this order
            l_used_items.EXTEND;
            l_used_items(l_used_items.COUNT) := l_item_ids(l_item_idx);

            -- Insert order item
            INSERT INTO ORDER_ITEMS (
                ORIT_ORDE_FK
              , ORIT_ITEM_FK
              , ORIT_QUANTITY
              , ORIT_UNIT_PRICE
            ) VALUES (
                l_order_ids(i)
              , l_item_ids(l_item_idx)
              , TRUNC(DBMS_RANDOM.VALUE(1, 6))
              , (SELECT ITEM_PRICE FROM ITEMS WHERE ITEM_ID = l_item_ids(l_item_idx))
            );

        END LOOP;
    END LOOP;

    COMMIT;
END;
/
