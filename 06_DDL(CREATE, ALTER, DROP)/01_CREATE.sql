/*
    <DDL (Data Definition Langauge)>
        데이터 정의 언어로 오라클에서 제공하는 객체를 생성하고, 변경하고, 삭제하는 등
        실제 데이터 값이 아닌 데이터의 구조 자체를 정의하는 언어이다. (DB 관리자, 설계자가 주로 사용)
        
    <CREATE>
        데이터베이스 객체(테이블, 뷰, 사용자 등)를 생성하는 구문이다
        
     <테이블 생성>
        CREATE TABLE 테이블명 (
            컬럼명 자료형(크기) [DEFAULT 기본값] [제약조건],
            컬럼명 자료형(크기) [DEFAULT 기본값] [제약조건],
            컬럼명 자료형(크기) [DEFAULT 기본값] [제약조건],
            ...
        );      
*/
-- 회원에 대한 데이터를 담을 수 있는 MEMBER 테이블 생성
CREATE TABLE MEMBER (
    ID VARCHAR2(20),
    PASSWORD VARCHAR2(20),
    NAME VARCHAR2(15),
    ENROLL_DATE DATE DEFAULT SYSDATE
);

-- 테이블의 구조를 표시해 주는 구문이다.
DESC MEMBER; -- DESCRIBE의 약자 

SELECT *
FROM MEMBER;

/*
    데이터 딕셔너리
        자원을 효율적으로 관리하기 위해 다양한 객체들의 정보를 저장하는 시스템 테이블이다
        데이터 딕셔너리는 사용자가 객체를 생성하거나 변경하는 등의 작업을 할 때 데이터베이스에 의해서 자동으로 갱신되는 테이블이다
        데이터에 관한 데이터가 저장되어 있어서 메타 데이터라고도 한다
    
    * 시험에 출제될 수도 있음     
    USER_TABLES : 사용자가 가지고 있는 테이블의 구조를 확인하는 뷰 테이블이다
    USER_TAB_COLUMNS : 테이블, 뷰의 컬럼과 관련된 정보를 조회하는 뷰 테이블이다
*/
SELECT *
FROM USER_TABLES;

SELECT *
FROM USER_TAB_COLUMNS
WHERE TABLE_NAME = 'MEMBER';

/*
    <컬럼 주석>
        테이블 컬럼에 대한 설명을 작성할 수 있는 구문이다
        
        COMMENT ON COLUMN 테이블명.컬럼명 IS '주석 내용';
*/

COMMENT ON COLUMN MEMBER.ID IS '회원 아이디';
COMMENT ON COLUMN MEMBER.PASSWORD IS '회원 비밀번호';
COMMENT ON COLUMN MEMBER.NAME IS '회원 이름';
COMMENT ON COLUMN MEMBER.ENROLL_DATE IS '회원 가입일';

-- 테이블에 샘플 데이터 추가 
-- DML(INSERT)을 사용해서 만들어진 테이블에 샘플 데이터를 추가할 수 있다
-- INSERT INTO 테이블명[(컬럼명, ..., 컬럼명)] VALUES (값, ..., 값);
INSERT INTO MEMBER VALUES('USER1', '1234', '최송희', '2022-05-12');
INSERT INTO MEMBER VALUES('USER2', '1234', '이슬기', SYSDATE);
INSERT INTO MEMBER VALUES('USER3', '1234', '이정후', DEFAULT);
INSERT INTO MEMBER(ID, PASSWORD) VALUES('USER4', '1234');

SELECT * FROM MEMBER;

-- 위에서 추가한 데이터를 실제 데이터베이스에 반영한다 
-- (메모리 버퍼에 임시 저장된 데이터를 실제 테이블에 반영한다)
COMMIT;

SHOW AUTOCOMMIT; -- autocommit OFF

SET AUTOCOMMIT OFF;

/*
    <제약조건>
        사용자가 원하는 조건의 데이터만 유지하기 위해서 테이블 작성 시 각 컬럼에 대해 제약조건을 설정할 수 있다
        제약조건은 데이터 무결성 보장을 목적으로 한다 (데이터의 정확성과 일관성을 유지시키는 것)
        
    1. NOT NULL 제약조건
        해당 컬럼에 반드시 값이 있어야만 하는 경우 ㅔ사용ㅎ안다
        삽입 / 수정 시 NULL 값을 허용하지 않도록 제한한다 
*/
-- 기존 MEMBER 테이블은 값에 NULL이 있어도 행의 추가가 가능하다
INSERT INTO MEMBER VALUES(NULL, NULL, NULL, NULL);

-- NOT NULL 제약조건을 설정한 테이블 생성 
-- 테이블 삭제하는 구문
DROP TABLE MEMBER;

CREATE TABLE MEMBER (
    ID VARCHAR2(20) NOT NULL,
    PASSWORD VARCHAR2(20) NOT NULL,
    NAME VARCHAR2(15) NOT NULL,
    ENROLL_DATE DATE DEFAULT SYSDATE
);

-- NOT NULL 제약조건에 위배되어 오류 발생 
-- ORA-01400: cannot insert NULL into ("KH"."MEMBER"."ID")
INSERT INTO MEMBER VALUES(NULL, NULL, NULL, NULL);

-- NOT NULL 제약조건이 걸려있는 컬럼에는 반드시 값이 있어야 한다
INSERT INTO MEMBER VALUES('USER1', '1234', '이정후', NULL);
INSERT INTO MEMBER VALUES('USER2', '1234', '이정후', SYSDATE);
INSERT INTO MEMBER VALUES('USER3', '1234', '이정후', DEFAULT);
INSERT INTO MEMBER(ID, PASSWORD, NAME) VALUES('USER4', '1234', '이정후');

-- 테이블의 데이터를 수정하는 SQL 구문
UPDATE MEMBER 
SET ID = NULL;

SELECT * FROM MEMBER;

-- 제약조건 확인
-- 사용자가 작성한 제약조건을 확인하는 뷰 테이블이다
SELECT * 
FROM USER_CONSTRAINTS;

-- 사용자가 작성한 제약조건이 걸려있는 컬럼을 확인하는 뷰 테이블이다
SELECT *
FROM USER_CONS_COLUMNS;

SELECT UC.CONSTRAINT_NAME,
       UC.TABLE_NAME, 
       UCC.COLUMN_NAME,
       UC.CONSTRAINT_TYPE
FROM USER_CONSTRAINTS UC
JOIN USER_CONS_COLUMNS UCC ON UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME
WHERE UC.TABLE_NAME = 'MEMBER';

/*
    2. UNIQUE 제약조건
        컬럼에 입력 값이 중복 값을 가질 수 없도록 제한하는 제약조건이다
*/
SELECT * FROM MEMBER;

-- 아이디가 중복되어도 성공적으로 데이터가 삽입된다
INSERT INTO MEMBER VALUES('USER1', '1234', '최송희', DEFAULT);

DROP TABLE MEMBER;
SELECT * FROM MEMBER;

CREATE TABLE MEMBER (
    ID VARCHAR2(20) NOT NULL UNIQUE,
    PASSWORD VARCHAR2(20) NOT NULL,
    NAME VARCHAR2(15) NOT NULL,
    ENROLL_DATE DATE DEFAULT SYSDATE
);

INSERT INTO MEMBER VALUES('USER1', '1234', '이정후', DEFAULT);
INSERT INTO MEMBER VALUES('USER2', '1234', '김태진', DEFAULT);
-- UNIQUE 제약조건에 위배되어 INSERT 실패
-- ORA-00001: unique constraint (KH.SYS_C007080) violated
INSERT INTO MEMBER VALUES('USER2', '1234', '김태진', DEFAULT);

DROP TABLE MEMBER;

SELECT * FROM MEMBER;

-- 테이블 레벨로 제약조건 지정
CREATE TABLE MEMBER (
    ID VARCHAR2(20) CONSTRAINT MEMBER_ID_NN NOT NULL,
    PASSWORD VARCHAR2(20) CONSTRAINT MEMBER_PASSWORD_NN NOT NULL,
    NAME VARCHAR2(15) CONSTRAINT MEMBER_NAME_NN NOT NULL,
    ENROLL_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT MEMBER_ID_UQ UNIQUE(ID) -- 테이블명_컬럼명_제약조건
);

INSERT INTO MEMBER VALUES('USER1', '1234', '이정후', DEFAULT);
-- ORA-00001: unique constraint (KH.MEMBER_ID_UQ) violated
INSERT INTO MEMBER VALUES('USER1', '1234', '김태진', DEFAULT);
INSERT INTO MEMBER VALUES('USER2', '1234', '김태진', DEFAULT);

DROP TABLE MEMBER;

-- 여러 개의 컬럼을 묶어서 하나의 UNIQUE 제약조건으로 설정할 수 있다(필요 시)
-- ID와 PASSWORD가 동일하면 에러가 나도록 설정 
CREATE TABLE MEMBER (
    NO NUMBER NOT NULL,
    ID VARCHAR2(20) NOT NULL,
    PASSWORD VARCHAR2(20) NOT NULL,
    NAME VARCHAR2(15) NOT NULL,
    ENROLL_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT MEMBER_NOID_UQ UNIQUE(NO, ID)
);

-- 여러 컬럼을 묶어서 UNIQUE 제약조건이 설정되어 있으면 제약조건이 설정되어 있는 컬럼 값이 모두 중복되는 경우에만 오류가 발생한다
INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '이정후', DEFAULT);
-- ORA-00001: unique constraint (KH.MEMBER_NOID_UQ) violated
INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '김태진', DEFAULT);
INSERT INTO MEMBER VALUES(1, 'USER2', '1234', '김태진', DEFAULT);
INSERT INTO MEMBER VALUES(2, 'USER2', '1234', '김태진', DEFAULT);


CREATE TABLE MEMBER (
    NO NUMBER CONSTRAINT MEMBER_NO_NN NOT NULL,
    ID VARCHAR2(20) CONSTRAINT MEMBER_ID_NN NOT NULL,
    PASSWORD VARCHAR2(20) CONSTRAINT MEMBER_PASSWORD_NN NOT NULL,
    NAME VARCHAR2(15) CONSTRAINT MEMBER_NAME_NN NOT NULL,
    ENROLL_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT MEMBER_ID_UQ UNIQUE(ID) -- 테이블명_컬럼명_제약조건
);

SELECT * FROM MEMBER;
SELECT UC.CONSTRAINT_NAME,
       UC.TABLE_NAME, 
       UCC.COLUMN_NAME,
       UC.CONSTRAINT_TYPE
FROM USER_CONSTRAINTS UC
JOIN USER_CONS_COLUMNS UCC ON UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME
WHERE UC.TABLE_NAME = 'MEMBER';

/*
    3. CHECK 제약조건
        컬럼에 기록되는 값에 조건을 설정하고 조건을 만족하는 값만 기록할 수 있다
        비교 값은 리터럴만 사용이 가능하다. 즉 변하는 값이나 함수는 사용할 수 없다
        
        CHECK (비교연산자)
            CHECK(컬럼 [NOT] IN(값, 값, ...))
            CHECK(컬럼 BETWEEN 값 AND 값)
            CHECK(컬럼 LIKE '_문자')
            ...
*/

DROP TABLE MEMBER;

CREATE TABLE MEMBER (
    NO NUMBER NOT NULL,
    ID VARCHAR2(20) NOT NULL,
    PASSWORD VARCHAR2(20) NOT NULL,
    NAME VARCHAR2(15) NOT NULL,
    GENDER CHAR(3),
    AGE NUMBER,
    ENROLL_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT MEMBER_ID_UQ UNIQUE(ID)
);

SELECT * FROM MEMBER;

-- 성별, 나이에 유효한 값이 아닌 값들도 INSERT 된다. 
INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '이정후', '남', 25, DEFAULT);
INSERT INTO MEMBER VALUES(2, 'USER2', '1234', '김태진', '남', 28, DEFAULT);
INSERT INTO MEMBER VALUES(3, 'USER3', '1234', '최송희', '여', 29, DEFAULT);
INSERT INTO MEMBER VALUES(4, 'USER4', '1234', '이슬기', '강', -31, DEFAULT);

DROP TABLE MEMBER;

-- CHECK 제약조건 설정 
CREATE TABLE MEMBER (
    NO NUMBER NOT NULL,
    ID VARCHAR2(20) NOT NULL,
    PASSWORD VARCHAR2(20) NOT NULL,
    NAME VARCHAR2(15) NOT NULL,
    GENDER CHAR(3) CONSTRAINT MEMBER_GENDER_CK CHECK(GENDER IN ('남', '여')),
    AGE NUMBER,
    ENROLL_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT MEMBER_ID_UQ UNIQUE(ID),
    CONSTRAINT MEMBER_AGE_CK CHECK(AGE > 0)
);

INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '이정후', '남', 25, DEFAULT);
INSERT INTO MEMBER VALUES(3, 'USER3', '1234', '최송희', '여', 29, DEFAULT);
-- ORA-02290: check constraint (KH.MEMBER_GENDER_CK) violated
-- GENDER 컬럼에 CHECK 제약조건으로 '남' 또는 '여'만 입력 가능하도록 설정되었기 때문에 에러 발생 
INSERT INTO MEMBER VALUES(2, 'USER2', '1234', '김태진', '강', 28, DEFAULT);
-- ORA-02290: check constraint (KH.MEMBER_AGE_CK) violated
-- AGE 컬럼에 CHECK 제약조건으로 0보다 큰 값만 입력 가능하도록 설정이 되었기 때문에 에러 발생
INSERT INTO MEMBER VALUES(4, 'USER4', '1234', '이슬기', '남', -31, DEFAULT);

COMMIT;

UPDATE MEMBER 
--SET AGE = -100
SET GENDER = '외'
WHERE NO = 1;

ROLLBACK;

SELECT * FROM MEMBER;
SELECT UC.CONSTRAINT_NAME,
       UC.TABLE_NAME, 
       UCC.COLUMN_NAME,
       UC.CONSTRAINT_TYPE,
       UC.SEARCH_CONDITION
FROM USER_CONSTRAINTS UC
JOIN USER_CONS_COLUMNS UCC ON UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME
WHERE UC.TABLE_NAME = 'MEMBER';


/*
    4. PRIMARY KEY(기본 키) 제약조건
        테이블에서 한 행의 정보를 식별하기 위해 사용할 컬럼에 부여하는 제약조건이다.
        기본 키 제약조건을 설정하게 되면 자동으로 해당 컬럼에 NOT NULL, UNIQUE 제약조건이 설정된다
        한 테이블에 한 개만 설정할 수 있다 (단, 한 개 이상의 컬럼을 묶어서 제약조건을 설정할 수 있다)

*/

DROP TABLE MEMBER;

CREATE TABLE MEMBER (
--    NO NUMBER PRIMARY KEY,
    NO NUMBER,
    ID VARCHAR2(20) NOT NULL,
    PASSWORD VARCHAR2(20) NOT NULL,
    NAME VARCHAR2(15) NOT NULL,
    GENDER CHAR(3),
    AGE NUMBER,
    ENROLL_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT MEMBER_NO_PK PRIMARY KEY(NO),
    CONSTRAINT MEMBER_ID_UQ UNIQUE(ID),
    CONSTRAINT MEMBER_GENDER_CK CHECK(GENDER IN ('남', '여')),
    CONSTRAINT MEMBER_AGE_CK CHECK(AGE > 0)
);

INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '이정후', '남', 25, DEFAULT);
INSERT INTO MEMBER VALUES(2, 'USER2', '1234', '최송희', '여', 29, DEFAULT);
INSERT INTO MEMBER VALUES(3, 'USER3', '1234', '김태진', '남', 28, DEFAULT);
INSERT INTO MEMBER VALUES(4, 'USER4', '1234', '이슬기', '남', 31, DEFAULT);
-- ORA-00001: unique constraint (KH.MEMBER_NO_PK) violated
INSERT INTO MEMBER VALUES(4, 'USER5', '1234', '안은정', '여', 27, DEFAULT);

DROP TABLE MEMBER;
-- 컬럼을 묶어서 하나의 기본 키를 생성 (복합 키라고 한다)
CREATE TABLE MEMBER (
--    NO NUMBER PRIMARY KEY,
    NO NUMBER,
    ID VARCHAR2(20), -- PRIMARY KEY,  --table can have only one primary key
    PASSWORD VARCHAR2(20) NOT NULL,
    NAME VARCHAR2(15) NOT NULL,
    GENDER CHAR(3),
    AGE NUMBER,
    ENROLL_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT MEMBER_NO_ID_PK PRIMARY KEY(NO, ID),
    CONSTRAINT MEMBER_ID_UQ UNIQUE(ID),
    CONSTRAINT MEMBER_GENDER_CK CHECK(GENDER IN ('남', '여')),
    CONSTRAINT MEMBER_AGE_CK CHECK(AGE > 0)
);

INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '이정후', '남', 25, DEFAULT);
INSERT INTO MEMBER VALUES(2, 'USER2', '1234', '최송희', '여', 29, DEFAULT);
INSERT INTO MEMBER VALUES(3, 'USER3', '1234', '김태진', '남', 28, DEFAULT);
INSERT INTO MEMBER VALUES(4, 'USER4', '1234', '이슬기', '남', 31, DEFAULT);
INSERT INTO MEMBER VALUES(4, 'USER5', '1234', '안은정', '여', 27, DEFAULT); -- 둘 다 중복이 아니니까 생성 가능
INSERT INTO MEMBER VALUES(4, 'USER5', '1234', '안은정', '여', 27, DEFAULT);
-- 회원번호, 아이디가 세트로 동일한 값이 이미 존재하기 때문에 에러가 발생한다.
-- ORA-00001: unique constraint (KH.MEMBER_NO_PK) violated
INSERT INTO MEMBER VALUES(NULL, 'USER5', '1234', '안은정', '여', 27, DEFAULT);
INSERT INTO MEMBER VALUES(5, NULL, '1234', '안은정', '여', 27, DEFAULT);
-- 기본 키로 설정된 컬럼에 NULL 값이 있으면 에러가 발생한다 


/*
    5. FOREIGN KEY(외래키) 제약조건
        다른 테이블에 존재하는 값만을 가져야하는 컬럼에 부여하는 제약조건이다. (단, NULL 값도 가질 수 있다)
        즉, 외래 키로 참조한 컬럼의 값만 기록할 수 있다 
        
        1) 컬럼 레벨
            컬럼명 자료형 (크기) [CONSTRAINT 제약조건명] REFERENCES 참조할 테이블명 [(기본키)] [삭제룰]
            
        2) 테이블 레벨
            [CONSTRAINT 제약조건명] FOREIGN KEY(컬럼명) REFERENCES 참조할 테이블명 [(기본키)] [삭제룰]
        
        * 삭제룰
            부모 테이블의 데이터가 삭제되었을 때의 옵션을 지정할 수 있다.
            1) ON DELETE RESTRICT : 자식 테이블의 참조 키가 부모 테이블의 키 값을 참조하는 경우 부모 테이블의 행을 삭제할 수 없다 (기본)
            2) ON DELETE SET NULL : 부모 테이블의 데이터 삭제 시 참조하고 있는 자식 테이블의 컬럼 값이 NULL 로 변경된다
            3) ON DELETE CASCADE : 부모 테이블의 데이터 삭제 시 참조하고 있는 자식 테이블의 행 전체가 삭제된다 
*/
-- 회원 등급에 대한 데이터를 보관하는 테이블 생성 (부모 테이블)
CREATE TABLE MEMBER_GRADE (
    GRADE_CODE NUMBER,
    GRADE_NAME VARCHAR2(20) NOT NULL,
    CONSTRAINT MEMBER_GRADE_PK PRIMARY KEY(GRADE_CODE)
);

SELECT * FROM MEMBER_GRADE;

INSERT INTO MEMBER_GRADE VALUES(10, '일반회원');
INSERT INTO MEMBER_GRADE VALUES(20, '우수회원');
INSERT INTO MEMBER_GRADE VALUES(30, '특별회원');


CREATE TABLE MEMBER (
--    NO NUMBER PRIMARY KEY,
    NO NUMBER,
    ID VARCHAR2(20) NOT NULL,
    PASSWORD VARCHAR2(20) NOT NULL,
    NAME VARCHAR2(15) NOT NULL,
    GENDER CHAR(3),
    AGE NUMBER,
    -- FOREIGN KEY 설정 (컬럼 레벨 방식)
    GRADE_ID NUMBER CONSTRAINT MEMBER_GRADE_ID_FK REFERENCES MEMBER_GRADE (GRADE_CODE),
    ENROLL_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT MEMBER_NO_PK PRIMARY KEY(NO),
    CONSTRAINT MEMBER_ID_UQ UNIQUE(ID),
    CONSTRAINT MEMBER_GENDER_CK CHECK(GENDER IN ('남', '여')),
    -- FOREIGN KEY 설정 (테이블 레벨 방식)
--    CONSTRAINT MEMBER_GRADE_ID_FK FOREIGN KEY (GRADE_ID) REFERENCES MEMBER_GRADE /*(GRADE_CODE)*/,
    CONSTRAINT MEMBER_AGE_CK CHECK(AGE > 0)
);

SELECT * FROM MEMBER_GRADE;
SELECT * FROM MEMBER;

INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '이정후', '남', 25, 10, DEFAULT);
INSERT INTO MEMBER VALUES(2, 'USER2', '1234', '최송희', '여', 29, 50, DEFAULT);
-- 50이라는 값이 MEMBER_GRADE 테이블에 GRADE_CODE 컬럼에서 제공하는 값이 아니므로 외래키 제약조건에 위배되어 에러 발생
-- ORA-02291: integrity constraint (KH.MEMBER_GRADE_ID_FK) violated - parent key not found
INSERT INTO MEMBER VALUES(3, 'USER3', '1234', '김태진', '남', 28, NULL, DEFAULT);
-- GRADE_ID 컬럼에 NULL 사용 가능

-- MEMBER 테이블과 MEMBER_GRADE 테이블을 조인하여 아이디, 이름, 회원등급 조회 
-- ANSI 구문
SELECT M.ID 아이디, 
       M.NAME 이름,
       M.GRADE_ID,
       MG.GRADE_NAME
FROM MEMBER M
LEFT OUTER JOIN MEMBER_GRADE MG ON M.GRADE_ID = MG.GRADE_CODE;
       
-- 오라클 구문 
SELECT M.ID 아이디, 
       M.NAME 이름,
       M.GRADE_ID,
       MG.GRADE_NAME
FROM MEMBER M,  MEMBER_GRADE MG
WHERE M.GRADE_ID = MG.GRADE_CODE(+);

-- 20210513
-- MEMBER_GRADE 테이블에서 GRADE_CODE가 10인 데이터 지우기
-- 자식 테이블의 행들 중에 10을 사용하고 있기 때문에 삭제할 수 없다 
DELETE FROM MEMBER_GRADE WHERE GRADE_CODE = 10; -- child record found 에러 발생 
-- MEMBER_GRADE 테이블에서 GRADE_CODE가 30인 데이터 지우기
-- 자식 테이블의 행들 중에 30을 사용하지 않기 때문에 삭제할 수 있다
DELETE FROM MEMBER_GRADE WHERE GRADE_CODE = 30;

-- ON DELETE SET NULL 옵션이 추가된 자식 테이블 생성

DROP TABLE MEMBER;

CREATE TABLE MEMBER (
    NO NUMBER,
    ID VARCHAR2(20) NOT NULL,
    PASSWORD VARCHAR2(20) NOT NULL,
    NAME VARCHAR2(15) NOT NULL,
    GENDER CHAR(3),
    AGE NUMBER,
    GRADE_ID NUMBER CONSTRAINT MEMBER_GRADE_ID_FK REFERENCES MEMBER_GRADE (GRADE_CODE) ON DELETE SET NULL,
    ENROLL_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT MEMBER_NO_PK PRIMARY KEY(NO),
    CONSTRAINT MEMBER_ID_UQ UNIQUE(ID),
    CONSTRAINT MEMBER_GENDER_CK CHECK(GENDER IN ('남', '여')),
    CONSTRAINT MEMBER_AGE_CK CHECK(AGE > 0)
);

INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '이정후', '남', 25, 10, DEFAULT);
INSERT INTO MEMBER VALUES(2, 'USER2', '1234', '최송희', '여', 29, NULL, DEFAULT);

-- MEMBER_GRADE 테이블에서 GRADE_CODE가 10인 데이터 지우기
-- 자식 테이블을 조회해 보면 삭제된 행을 참조하고 있던 컬럼의 값이 NULL로 변경되어 있다
DELETE FROM MEMBER_GRADE WHERE GRADE_CODE = 10;


-- ON DELETE CASCADE 옵션이 추가된 자식 테이블 생성
CREATE TABLE MEMBER (
    NO NUMBER,
    ID VARCHAR2(20) NOT NULL,
    PASSWORD VARCHAR2(20) NOT NULL,
    NAME VARCHAR2(15) NOT NULL,
    GENDER CHAR(3),
    AGE NUMBER,
    GRADE_ID NUMBER CONSTRAINT MEMBER_GRADE_ID_FK REFERENCES MEMBER_GRADE (GRADE_CODE) ON DELETE CASCADE,
    ENROLL_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT MEMBER_NO_PK PRIMARY KEY(NO),
    CONSTRAINT MEMBER_ID_UQ UNIQUE(ID),
    CONSTRAINT MEMBER_GENDER_CK CHECK(GENDER IN ('남', '여')),
    CONSTRAINT MEMBER_AGE_CK CHECK(AGE > 0)
);

INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '이정후', '남', 25, 10, DEFAULT);
INSERT INTO MEMBER VALUES(2, 'USER2', '1234', '최송희', '여', 29, NULL, DEFAULT);

-- MEMBER_GRADE 테이블에서 GRADE_CODE가 10인 데이터 지우기
DELETE FROM MEMBER_GRADE WHERE GRADE_CODE = 10;

SELECT * FROM MEMBER_GRADE;
SELECT * FROM MEMBER;

ROLLBACK;

/*
    <서브 쿼리를 이용한 테이블 생성> 
*/
-- EMPLOYEE 테이블을 복사한 새로운 테이블 생성 (컬럼명, 데이터 타입, 값, NOT NULL 제약 조건을 복사)
CREATE TABLE EMPLOYEE_COPY 
AS SELECT *
   FROM EMPLOYEE;
   
CREATE TABLE MEMBER_COPY
AS SELECT *
   FROM MEMBER;
   
SELECT *
FROM EMPLOYEE_COPY;

SELECT *
FROM MEMBER_COPY;

-- EMPLOYEE 테이블을 복사한 새로운 테이블 생성 (컬럼명, 데이터 타입, NOT NULL 제약조건을 복사)
CREATE TABLE EMPLOYEE_COPY2
AS SELECT *
   FROM EMPLOYEE
   WHERE 1 = 0; -- 모든 행에 대해서 매번 FALSE 이기 때문에 테이블의 구조만 복사되고 데이터 값은 복사되지 않는다

SELECT * FROM EMPLOYEE_COPY2;

-- EMPLOYEE 테이블에서 사번, 직원명, 급여, 연봉을 저장하는 테이블 생성
CREATE TABLE EMPLOYEE_COPY3
AS SELECT EMP_ID 사번,
          EMP_NAME 직원명,
          SALARY 급여,
          SALARY * 12 연봉
    FROM EMPLOYEE;

SELECT * FROM EMPLOYEE_COPY3;

DROP TABLE EMPLOYEE_COPY;
DROP TABLE EMPLOYEE_COPY2;
DROP TABLE EMPLOYEE_COPY3;
DROP TABLE MEMBER_COPY;


















ROLLBACK;
SELECT * FROM MEMBER_GRADE;
SELECT * FROM MEMBER;
SELECT UC.CONSTRAINT_NAME,
       UC.TABLE_NAME, 
       UCC.COLUMN_NAME,
       UC.CONSTRAINT_TYPE,
       UC.SEARCH_CONDITION
FROM USER_CONSTRAINTS UC
JOIN USER_CONS_COLUMNS UCC ON UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME
WHERE UC.TABLE_NAME LIKE 'MEMBER%';
























