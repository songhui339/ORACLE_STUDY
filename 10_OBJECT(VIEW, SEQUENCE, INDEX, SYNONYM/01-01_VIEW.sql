/*
    <VIEW>
        SELECT 문을 저장할 수 있는 객체이다 (논리적인 가상 테이블)
        데이터를 저장하고 있지 않으며 테이블에 대한 SQL만 저장되어 있어 VIEW에 접근할 때 SQL을 수행하고 결과값을 가져온다

*/
-- 한국에서 근무하는 사원들의 사번, 직원명, 부서명, 급여, 근무 국가명 조회
SELECT * FROM DEPARTMENT;
SELECT * FROM LOCATION;
SELECT * FROM NATIONAL;

SELECT E.EMP_ID,
       E.EMP_NAME,
       D.DEPT_TITLE,
       E.SALARY,
       N.NATIONAL_NAME
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
INNER JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
INNER JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE
WHERE L.NATIONAL_CODE = 'KO';

-- 러시아에서 근무하는 사원들의 사번, 직원명, 부서명, 급여, 근무 국가명 조회
SELECT E.EMP_ID,
       E.EMP_NAME,
       D.DEPT_TITLE,
       E.SALARY,
       N.NATIONAL_NAME
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
INNER JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
INNER JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE
WHERE N.NATIONAL_NAME = '러시아';

-- 일본에서 근무하는 사원들의 사번, 직원명, 부서명, 급여, 근무 국가명 조회
SELECT E.EMP_ID,
       E.EMP_NAME,
       D.DEPT_TITLE,
       E.SALARY,
       N.NATIONAL_NAME
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
INNER JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
INNER JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE
WHERE N.NATIONAL_NAME = '일본';

-- 관리자 계정으로 CREATE VIEW 권한을 부여 
GRANT CREATE VIEW TO KH; 

CREATE VIEW V_EMPLOYEE
AS SELECT E.EMP_ID,E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME
   FROM EMPLOYEE E
   INNER JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
   INNER JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
   INNER JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE;

SELECT * 
FROM V_EMPLOYEE; -- 가상 테이블로 실제 데이터가 담겨있는 것은 아니다

-- 접속한 계정이 가지고 있는 VIEW의 정보를 조회하는 데이터 딕셔너리이다
SELECT * FROM USER_VIEWS;

-- 한국에서 근무하는 사원들의 사번, 직원명, 부서명, 급여, 근무 국가명 조회
SELECT *
FROM V_EMPLOYEE
WHERE NATIONAL_NAME = '한국';

-- 일본에서 근무하는 사원들의 사번, 직원명, 부서명, 급여, 근무 국가명 조회
SELECT *
FROM V_EMPLOYEE
WHERE NATIONAL_NAME = '일본';

-- 서브 쿼리의 SELECT 절에 함수나 산술연산이 기술되어 있는 경우 반드시 컬럼에 별칭을 지정해야한다
-- 직원들의 사번, 직원명, 성별, 근무년수 조회할수 있는 뷰를 생성
SELECT EMP_ID,
       EMP_NAME,
       DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') 성별,
       EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 근무년수
FROM EMPLOYEE;

-- 1) 서브 쿼리에서 별칭을 지정하는 방법
CREATE VIEW V_EMP_01
AS SELECT EMP_ID,
          EMP_NAME,
          DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') 성별,
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 근무년수
    FROM EMPLOYEE;

-- 2) VIEW 생성 시 모든 컬럼에 별칭을 부여하는 방법
CREATE OR REPLACE VIEW V_EMP_01("사번", "직원명", "성별", "근무년수") -- 모든 컬럼에 별칭을 부여해야 한다
AS SELECT EMP_ID,
          EMP_NAME,
          DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여'),
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
    FROM EMPLOYEE;

SELECT * FROM V_EMP_01;

DROP VIEW V_EMPLOYEE;
DROP VIEW V_EMP_01;

/*
    <VIEW를 이용해서 DML 사용>
        뷰를 통해서 데이터를 변경하게 되면 실제 데이터가 담겨있는 테이블에도 적용된다
*/
CREATE VIEW V_JOB
AS SELECT *
   FROM JOB;

-- VIEW에 SELECT 실행
SELECT JOB_CODE, JOB_NAME
FROM V_JOB;

-- VIEW에 INSERT 실행
INSERT INTO V_JOB VALUES('J8', '알바');

-- VIEW에 UPDATE 실행
UPDATE V_JOB
SET JOB_NAME = '인턴'
WHERE JOB_CODE = 'J8';

-- VIEW에 DELETE 실행
DELETE FROM V_JOB
WHERE JOB_CODE = 'J8';

SELECT * FROM V_JOB;
SELECT * FROM JOB;

/*
    <DML 구문으로 VIEW 조작이 불가능한 경우>
    
    1. 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우
*/
CREATE OR REPLACE VIEW V_JOB
AS SELECT JOB_CODE
FROM JOB;

-- 뷰에 정의되어 있지 않는 컬럼 JOB_NAME을 조작하는 DML 작성
-- INSERT
INSERT INTO V_JOB VALUES('J8');
INSERT INTO V_JOB VALUES('J8', '인턴'); -- too many values

SELECT * FROM JOB;
SELECT * FROM V_JOB;

-- UPDATE
UPDATE V_JOB
SET JOB_NAME = '인턴'
WHERE JOB_CODE = 'J8'; -- 에러

UPDATE V_JOB
SET JOB_CODE = 'J0'
WHERE JOB_CODE = 'J8';

-- DELETE
DELETE FROM V_JOB
WHERE JOB_NAME = '사원'; -- 에러

DELETE FROM V_JOB
WHERE JOB_CODE = 'J0';

-- 2. 뷰에 포함되지 않은 컬럼 중에 베이스가 되는 컬럼이 NOT NULL 제약조건이 지정된 경우
CREATE OR REPLACE VIEW V_JOB
AS SELECT JOB_NAME
   FROM JOB;

-- INSERT
INSERT INTO V_JOB VALUES('인턴'); -- 에러 발생
-- cannot insert NULL into ("KH"."JOB"."JOB_CODE")

-- UPDATE
UPDATE V_JOB
SET JOB_NAME = '인턴'
WHERE JOB_NAME = '사원';

-- DELETE (FK 제약조건으로 인해 삭제되지 않는다)
DELETE FROM V_JOB
WHERE JOB_NAME = '인턴';

ROLLBACK;

-- 3. 산술 표현식으로 정의된 경우
-- 사원들의 급여 정보를 조회하는 뷰
ALTER TABLE EMPLOYEE MODIFY JOB_CODE NULL;

CREATE OR REPLACE VIEW V_EMP_SAL
AS SELECT EMP_ID,
          EMP_NAME,
          EMP_NO,
          SALARY,
          SALARY * 12 연봉
   FROM EMPLOYEE;

-- INSERT
-- 산술 연산으로 정의된 컬럼은 데이터 삽입 불가능
INSERT INTO V_EMP_SAL VALUES('1000', '이정후', 3000000, 36000000);
-- 산술 연산과 무관한 컬럼은 데이터 삽입 가능
INSERT INTO V_EMP_SAL(EMP_ID, EMP_NAME, EMP_NO, SALARY) VALUES('100', '이정후', '940409-1231234', 3000000);

-- UPDATE
UPDATE V_EMP_SAL
SET "연봉" = 40000000
WHERE EMP_ID = '100'; -- 에러발생 virtual column not allowed here

-- 산술연산과 무관한 컬럼의 데이터 변경 가능
UPDATE V_EMP_SAL
SET SALARY = 3500000
WHERE EMP_ID = '100';

-- DELETE
DELETE FROM V_EMP_SAL
WHERE "연봉" = 42000000;

SELECT * FROM V_EMP_SAL;
SELECT * FROM EMPLOYEE;

-- 4. 그룹 함수나 GROUP BY 절을 포함한 경우
-- 부서별 급여의 합계, 급여 평균을 조회하는 VIEW 생성
SELECT DEPT_CODE, 
       SUM(SALARY)"급여의 합계", 
       FLOOR(AVG(NVL(SALARY, 0))) "급여 평균"
FROM EMPLOYEE
GROUP BY DEPT_CODE;

CREATE OR REPLACE VIEW V_EMP_SAL
AS SELECT DEPT_CODE, 
          SUM(SALARY)"합계", 
          FLOOR(AVG(NVL(SALARY, 0))) "평균"
   FROM EMPLOYEE
   GROUP BY DEPT_CODE;

-- INSERT
INSERT INTO V_EMP_SAL VALUES('D0', 8000000, 4000000);
INSERT INTO V_EMP_SAL(DEPT_CODE) VALUES('D0'); -- 에러 발생 / 참조키와 NOT NULL 제약조건

-- UPDATE
UPDATE V_EMP_SAL
SET "합계" = 8000000
WHERE DEPT_CODE = 'D1'; -- 에러 발생 data manipulation operation not legal on this view

UPDATE V_EMP_SAL
SET DEPT_CODE = 'D0'
WHERE DEPT_CODE = 'D1'; -- 에러 발생 data manipulation operation not legal on this view

-- DELETE
DELETE FROM V_EMP_SAL
WHERE DEPT_CODE = 'D1'; -- 에러 발생 data manipulation operation not legal on this view
-- 내가 생각지도 못했던 다른 행들이 모든 행들이 지워지는 것이기 때문에 실행이 안된다 

-- 5. DISTINCT를 포함한 경우
CREATE VIEW V_EMP_JOB
AS SELECT DISTINCT JOB_CODE
   FROM EMPLOYEE;

-- INSERT
INSERT INTO V_EMP_JOB VALUES('J7'); -- 에러 발생 "data manipulation operation not legal on this view"

-- UPDATE
UPDATE V_EMP_JOB
SET JOB_CODE = 'J6'
WHERE JOB_CODE = 'J7'; -- 에러 발생 "data manipulation operation not legal on this view"

-- DELETE
DELETE FROM V_EMP_JOB
WHERE JOB_CODE = 'J7';  -- 에러 발생 "data manipulation operation not legal on this view"

SELECT * FROM V_EMP_JOB;
SELECT * FROM EMPLOYEE;

-- 6. JOIN을 이용해 여러 테이블을 연결한 경우
-- 직원들의 사번, 직원명, 부서명을 조회하는 뷰를 생성
SELECT E.EMP_ID,
       E.EMP_NAME,
       D.DEPT_TITLE
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID;

CREATE OR REPLACE VIEW V_EMP
AS SELECT E.EMP_ID,
          E.EMP_NAME,
          E.EMP_NO,
          D.DEPT_TITLE
   FROM EMPLOYEE E
   INNER JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID;

SELECT * FROM V_EMP;
SELECT * FROM EMPLOYEE;

-- INSERT
INSERT INTO V_EMP VALUES('100', '이정후', '980820-1111232', '야구부');
INSERT INTO V_EMP(EMP_ID, EMP_NAME, EMP_NO) VALUES('100', '이정후', '980820-1111232'); -- 이건 적용 가능 

-- UPDATE
UPDATE V_EMP
SET DEPT_TITLE = '마케팅부'
WHERE EMP_ID = '200'; -- 에러

UPDATE V_EMP
SET EMP_NAME = '서동일'
WHERE EMP_ID = '200'; -- 조인한 테이블의 값 업데이트는 불가능하지만 기존의 테이블 값은 변경 가능하다

-- DELETE
DELETE FROM V_EMP
WHERE EMP_ID = '200'; -- 실행 됨

-- 서브 쿼리에 FROM 절의 테이블에만 영향을 끼친다. (JOIN된 테이블은 영향 X)
DELETE FROM V_EMP
WHERE DEPT_TITLE = '총무부';
SELECT * FROM DEPARTMENT; --총무부는 안 지워짐 


SELECT * FROM V_EMP;
SELECT * FROM EMPLOYEE;

ROLLBACK;

/*
    <VIEW 옵션>
    
    1. OR REPLACE 
        기존에 동일한 뷰가 있을 경우 덮어쓰고, 존재하지 않으면 뷰를 새로 생성한다
*/
CREATE OR REPLACE VIEW V_EMP_01
AS SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
   FROM EMPLOYEE;


SELECT * FROM V_EMP_01;
SELECT * FROM USER_VIEWS;

/*
    2. FORCE / NOFORCE
    1) NOFORCE
        서브 쿼리에 기술된 테이블이 존재해야만 뷰가 생성된다 (기본값)
*/
CREATE /* NOFORCE */ VIEW V_EMP_02
AS SELECT *
   FROM TEST_TABLE; -- 에러 발생 table or view does not exist




/*
    2) FORCE
        서브 쿼리에 기술된 테이블이 존재하지 않아도 뷰가 생성된다 
*/
CREATE FORCE VIEW V_EMP_02
AS SELECT *
   FROM TEST_TABLE;

SELECT * FROM USER_VIEWS;
SELECT * FROM V_EMP_02; -- 에러 발생 

CREATE TABLE TEST_TABLE (
    TCODE NUMBER,
    TNAME VARCHAR2(20)
);
-- TEST_TABLE 테이블을 생성하면 이후부터는 VIEW 조회 가능 
SELECT * FROM V_EMP_02;

/*
    3. WITH CHECK OPTION
        서브 쿼리에 기술된 조건에 부합하지 않는 값으로 수정하는 경우 오류를 발생시킨다.
*/
CREATE VIEW V_EMP_03
AS SELECT * 
   FROM EMPLOYEE
   WHERE SALARY >= 3000000;

-- 선동일사장의 급여를 200만원으로 변경 시도 --> 서브 쿼리의 조건에 부합하지 않아도 변겨이 가능하다 
UPDATE V_EMP_03
SET SALARY = 2000000
WHERE EMP_ID = '200';

SELECT * FROM V_EMP_03;
SELECT * FROM EMPLOYEE;

ROLLBACK;

-- WITH CHECK OPTION 추가해 VIEW 생성
CREATE OR REPLACE VIEW V_EMP_03
AS SELECT * 
   FROM EMPLOYEE
   WHERE SALARY >= 3000000
WITH CHECK OPTION;

-- 선동일사장의 급여를 200만원으로 변경 시도 --> 서브 쿼리의 조건에 부합하지 않기 때문에 변경이 불가능 
-- " 400만원으로 변경 시도 -> 서브 쿼리의 조건에 부합하기 때문에 변경 가능 
UPDATE V_EMP_03
SET SALARY = 4000000
WHERE EMP_ID = '200';

SELECT * FROM V_EMP_03;
SELECT * FROM EMPLOYEE;
SELECT * FROM USER_VIEWS;

/*
    4. WITH READ ONLY
        뷰에 대해 조회만 가능하다 (DML 수행 불가)
*/
CREATE OR REPLACE VIEW V_DEPT
AS SELECT *
   FROM DEPARTMENT
WITH READ ONLY;

SELECT * FROM V_DEPT;

-- INSERT 불가
INSERT INTO V_DEPT VALUES('D0', '마케팅부', 'L1'); -- 에러 
-- UPDATE 불가
UPDATE V_DEPT
SET DEPT_ID = 'D0'
WHERE DEPT_ID = 'D1'; -- 에러
-- DELETE 불가
DELETE FROM V_DEPT; -- 에러

SELECT * FROM USER_VIEWS;

/*
    <VIEW 삭제>
*/
DROP VIEW V_JOB;
DROP VIEW V_EMP_SAL;
DROP VIEW V_EMP_JOB;
DROP VIEW V_EMP;
DROP VIEW V_EMP_01;
DROP VIEW V_EMP_02;
DROP VIEW V_EMP_03;
DROP VIEW V_DEPT;

SELECT * FROM USER_VIEWS;