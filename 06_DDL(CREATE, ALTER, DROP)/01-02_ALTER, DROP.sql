/*
    <ALTER>
        오라클에서 제공하는 객체를 수정하는 구문 
*/

-- 실습에 사용할 테이블 생성 
CREATE TABLE DEPT_COPY
AS SELECT *
   FROM DEPARTMENT;
   
SELECT * FROM DEPT_COPY;

/*
    1. 컬럼 추가 / 수정 / 삭제 / 이름 변경
        1) 컬럼 추가 (ADD)
            ALTER TABLE 테이블명 ADD 컬럼명 데이터타입 [DEFAULT 기본값];
*/
-- CNAME 컬럼을 테이블 맨 뒤에 추가한다 
-- 기본값을 지정하지 않으면 새로 추가된 컬럼은 NULL 값으로 채워진다
ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20);

-- LNAME 컬럼을 기본값을 지정하여 추가
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20) DEFAULT '대한민국';

/*
        2) 컬럼 수정 (MODIFY)
            ALTER TABLE 테이블명 MODIFY 컬럼명 데이터타입;
            ALTER TABLE 테이블명 MODIFY 컬럼명 DEFAULT 변경할 기본값;
*/
-- DEPT_ID 컬럼의 데이터 타입을 CHAR(3)로 변경
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(2); -- 변경하려는 자료형 크기보다 이미 큰 값이 존재하면 에러 발생
ALTER TABLE DEPT_COPY MODIFY CNAME NUMBER; -- 컬럼에 값이 없으면 데이터 타입 변경이 가능하다

-- DEPT_COPY 테이블에서 
-- DEPT_TITLE 컬럼의 데이터 타입을 VARCHAR2(40)으로 변경 
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(40);
-- LOCATION_ID 컬럼의 데이터 타입을 VARCHAR2(2)으로 변경
ALTER TABLE DEPT_COPY MODIFY LOCATION_ID VARCHAR2(2);
-- LNAME 컬럼의 기본값을 '미국'으로 변경
ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT '미국';

-- 다중 수정 가능 
ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE VARCHAR2(40)
MODIFY LOCATION_ID VARCHAR2(2)
MODIFY LNAME DEFAULT '미국';

SELECT * FROM DEPT_COPY;

/*
    3) 컬럼 삭제 (DROP COLUMN)
        ALTER TABLE 테이블명 DROP COLUMN 컬럼명;
*/
-- DEPT_ID 컬럼 지우기
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_ID;

SELECT * FROM DEPT_COPY;

ROLLBACK; -- ROLLBACK 안됨 DDL 구문은 ROLLBACK으로 복구 불가능

-- 최소 한 개의 컬럼은 존재해야 한다 
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY DROP COLUMN LNAME; -- cannot drop all columns in a table

SELECT * FROM MEMBER_GRADE;
SELECT * FROM MEMBER;

-- 참조되고 있는 컬럼이 있다면 삭제가 불가능하다
ALTER TABLE MEMBER_GRADE DROP COLUMN GRADE_CODE; -- cannot drop parent key column

ALTER TABLE MEMBER_GRADE DROP COLUMN GRADE_CODE CASCADE CONSTRAINTS;

/*
    4) 컬럼명 변경 (RENAME COLUMN)
        ALTER TABLE 테이블명 RENAME COLUMN 기존 컬럼명 TO 변경할 컬럼명;
*/
-- DEPT_COPY 테이블의 LNAME 컬럼명을 LOCATION_NAME으로 변경
ALTER TABLE DEPT_COPY RENAME COLUMN LNAME TO LOCATION_NAME;
SELECT * FROM DEPT_COPY;

DROP TABLE DEPT_COPY;
DROP TABLE MEMBER;
DROP TABLE MEMBER_GRADE;

/*
    2. 제약조건 추가 / 삭제 / 이름 변경 
        1) 제약조건 추가 (ADD) 
            PRIMARY KEY : ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] PRIMARY KEY(컬럼명);
            FOREIGN KEY : ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] FOREIGN KEY(컬럼명)REFERENCES 테이블명[(컬럼명)];
            UNIQUE : ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] UNIQUE(컬럼명);
            CHECK : ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] CHECK(컬럼에 대한 조건);
            NOT NULL : ALTER TABLE 테이블명 MODIFY 컬럼명 [CONSTRAINT 제약조건명] NOT NULL;
*/
-- 실습에 사용할 테이블 생성
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;

-- DEPT_COPY 테이블에 DEPT_ID 컬럼에 PK 제약조건 추가
ALTER TABLE DEPT_COPY ADD CONSTRAINT DEPT_COPY_DEPT_ID_PK PRIMARY KEY(DEPT_ID);
ALTER TABLE DEPT_COPY DROP CONSTRAINT SYS_C007214;

-- DEPT_COPY 테이블에 
-- DEPT_TITLE 컬럼에 UNIQUE, NOT NULL 제약조건 추가
ALTER TABLE DEPT_COPY 
ADD CONSTRAINT DEPT_COPY_DEPT_TITLE_UQ UNIQUE(DEPT_TITLE)
MODIFY DEPT_TITLE CONSTRAINT DEPT_COPY_DEPT_TITLE_NN NOT NULL;

-- 실습 문제 
-- EMPLOYEE 테이블의 DEPT_CODE, JOB_CODE 컬럼에 FOREIGN KEY 제약조건을 적용
-- FOREIGN KEY : ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] FOREIGN KEY(컬럼명)REFERENCES 테이블명[(컬럼명)];
ALTER TABLE EMPLOYEE ADD CONSTRAINT EMPLOYEE_DEPT_CODE_FK FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT(DEPT_ID);
ALTER TABLE EMPLOYEE ADD CONSTRAINT EMPLOYYE_JOB_CODE_FK FOREIGN KEY(JOB_CODE) REFERENCES JOB(JOB_CODE);

/*
    2) 제약조건 삭제
        NOT NULL : ALTER TABLE 테이블명 MODIFY 컬럼명 NULL;
        그 외 : ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
*/
-- DEPT_COPYT 테이블에 DEPT_COPY_DEPT_ID_PK 제약조건 삭제 
ALTER TABLE DEPT_COPY DROP CONSTRAINT DEPT_COPY_DEPT_ID_PK;

-- DEPT_COPYT 테이블에
-- DEPT_TITLE 컬럼에 UNIQUE, NOT NULL 제약조건 삭제 
ALTER TABLE DEPT_COPY
DROP CONSTRAINT DEPT_COPY_DEPT_TITLE_UQ
MODIFY DEPT_TITLE NULL;

/*
    3) 제약조건명 변경 (RENAME CONSTRAINT)
        ALTER TABLE 테이블명 RENAME CONSTRAINT 기존 제약조건명 TO 변경할 제약조건명;
*/
-- DEPT_COPY 테이블에 SYS_C007212 제약조건명을 DEPT_COPY_DEPT_ID_NN으로 변경 
ALTER TABLE DEPT_COPY RENAME CONSTRAINT SYS_C007212 TO DEPT_COPY_DEPT_ID_NN;

/*
    3. 테이블명 변경 (RENAME)
        ALTER TABLE 테이블명 RENAME TO 변경할 테이블명;
        RENAME 기존 테이블명 TO 변경할 테이블명;
*/
-- DEPT_COPY 테이블의 이름을 DEPT_TEST로 변경 
ALTER TABLE DEPT_COPY RENAME TO DEPT_TEST;
RENAME DEPT_COPY TO DEPT_TEST;

SELECT * FROM DEPT_TEST;

/*
    <DROP>
        오라클에서 제공하는 객체를 삭제하는 구문 
*/
-- DEPT_TEST 테이블 삭제
DROP TABLE DEPT_TEST;

-- 참조되고 있는 부모 테이블은 삭제가 되지 않는다 
DROP TABLE MEMBER_GRADE; -- unique/primary keys in table referenced by foreign keys

-- 만약 삭제하고자 한다면
-- 1) 자식 테이블을 먼저 삭제한 후 부모 테이블을 삭제하는 방법 
DROP TABLE MEMBER;
DROP TABLE MEMBER_GRADE;

-- 2) 부모 테이블을 삭제할 때 제약조건도 함께 삭제하는 방법
DROP TABLE MEMBER_GRADE CASCADE CONSTRAINT;



















-- 위 실습에 사용할 테이블 생성 쿼리 
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

