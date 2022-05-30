/*

    <SELECT>
        SELECT 컬럼 [, 컬럼, ...]
            FROM 테이블명;
        
        - 테이블에서 데이터를 조회할 때 사용하는 SQL 문이다.
        - SELECT를 통해서 조회된 결과를 RESULT SET이라고 한다.
        - 조회하고자 하는 칼럼은 반드시 FROM 절에 기술한 테이블에 존재하는 컬럼이어야 한다.
        - 모든ㄷ 컬럼을 조회할 경우 컬럼명 대신 * 기호를 사용할 수 있다.
            
*/

-- 현재 계정이 소유한 테이블 목록을 조회
SELECT TABLE_NAME 
    FROM TABS;
    
-- 테이블의 컬럼 정보 확인
DESC EMPLOYEE;

-- EMPLOYEE 테이블에서 전체 사원의 모든 컬럼 정보를 조회
SELECT *
FROM EMPLOYEE;
--WHERE DEPT_CODE = 'D9';

-- EMPLOYEE 테이블에서 전체 사원들의 사번, 이름, 급여만 조회
SELECT EMP_ID, EMP_NAME, SALARY
    FROM EMPLOYEE;
   
-- 아래와 같이 쿼리는 대소문자를 가리지 않지만 관례상 대문자로 작성한다 
select emp_id, emp_name, salary
    from employee;
    
----------------- 실습 문제 -----------------    
-- 1. JOB 테이블의 모든 컬럼 정보 조회
SELECT * 
    FROM JOB;

-- 2. JOB 테이블의 직급명 컬럼만 조회
SELECT JOB_NAME
    FROM JOB;


-- 3. DEPARTMENT 테이블의 모든 컬럼 정보 조회
SELECT *
    FROM DEPARTMENT;


-- 4. EMPLOYEE 테이블의 사원명, 이메일, 전화번호, 입사일(HIRE_DATE) 정보 조회
SELECT EMP_NAME, 
       EMAIL, 
       PHONE, 
       HIRE_DATE
    FROM EMPLOYEE;

--------------------------------------------

/*
    <컬럼의 산술 연산>
        SELECT 절에 컬럼명 입력 부분에서 산술 연산자를 사용하여 결과를 조회할 수 있다.       
*/

-- EMPLOYEE 테이블에서 직원명, 직원의 연봉 (연봉 = 급여 * 12) 조회
SELECT EMP_NAME, SALARY * 12
    FROM EMPLOYEE;
    
-- EMPLOYEE 테이블에서 직원명, 급여, 연봉, 보너스가 포함된 연봉(급여 + (보너스 * 급여)) * 12 조회
-- 산술 연산 중 NULL 값이 존재할 경우 산술 연산한 결과값은 무조건 NULL이다.
SELECT   EMP_NAME, 
         SALARY * 12, 
         BONUS,
--         NVL(BONUS, 0),
--         (SALARY + (BONUS * SALARY)) * 12
--       NVL : NULL 값 조정
         (SALARY + (NVL(BONUS, 0) * SALARY)) * 12
    FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 직원명, 입사일, 근무일수 조회
-- SYSDATE는 현재 날짜를 출력한다.
SELECT SYSDATE
    FROM DUAL;

-- DATE 타입도 연산인 가능하다.    
SELECT   EMP_NAME, 
         HIRE_DATE,
         SYSDATE - HIRE_DATE
    FROM EMPLOYEE;

SELECT   EMP_NAME, 
         HIRE_DATE,
         CEIL(SYSDATE - HIRE_DATE) -- CEIL : 매개값으로 전달되는 수를 올림하는 함수
    FROM EMPLOYEE;


/*
    <컬럼 별칭>
        [표현법]
            컬럼 AS 별칭 / 컬럼 AS "별칭" / 컬럼 별칭 / 컬럼 "별칭"
            
            - 산술 연산을 하게 되면 컬럼명이 지저분해진다. 이때 컬럼명에 별칭을 부여해 깔끔하게 조회할 수 있다.
            - 특수문자나 공백이 있으면 ""으로 감싸줘야한다
            - 별칭을 지정할 때 띄어쓰기 혹은 특수문자가 별칭에 포함될 경우 반드시 큰따옴표("")로 감싸준다
*/

-- EMPLOYEE 테이블에서 직원명, 급여, 연봉, 보너스가 포함된 연봉(급여 + (보너스 * 급여)) * 12 조회
-- 산술 연산 중 NULL 값이 존재할 경우 산술 연산한 결과값은 무조건 NULL이다.
SELECT   EMP_NAME AS 직원명, 
         SALARY * 12 AS 연봉,
         (SALARY + (NVL(BONUS, 0) * SALARY)) * 12 "보너스가 포함된 연봉"
    FROM EMPLOYEE;
--    ORDER BY 연봉 DESC


/*
    <리터럴>
        SELECT절에 리터럴을 사용하면 테이블에 존재하는 데이터처럼 조회가 가능하다.
        즉, 리터럴은 RESULT SET의 모든 행에 반복적으로 출력된다.
*/
SELECT '안녕' FROM DUAL;

SELECT EMP_NAME, '안녕하세요' 
    FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사번, 직원명, 급여, 단위(원)
SELECT   EMP_ID, 
         EMP_NAME, 
         SALARY,
         '원' AS 단위
    FROM EMPLOYEE;


/*
    <DISTINCT>
        컬럼에 포함된 중복 값을 한 번씩만 표시하고 할 때 사용한다.
        SELECT 절에 한 번만 기술할 수 있다.
        컬럼이 여러개면 컬럼 값들이 모두 동일해야 중복 값으로 판단되어 중복이 제거된다.
*/
-- EMPLOYEE 테이블에서 직급 코드(중복 제거) 조회
SELECT DISTINCT JOB_CODE
    FROM EMPLOYEE
    ORDER BY JOB_CODE;

-- EMPLOYEE 테이블에서 부서 코드(중복 제거) 조회
SELECT DISTINCT DEPT_CODE
    FROM EMPLOYEE
    ORDER BY DEPT_CODE DESC;

-- DISTINCT는 SELECT 절에 한 번만 기술할 수 있다.
SELECT DISTINCT JOB_CODE, DEPT_CODE
FROM EMPLOYEE
ORDER BY JOB_CODE;

/*
    <WHERE>
        SELECT 컬럼 [, 컬럼, ...]
            FROM 테이블명
            WHERE 조건식;   
            
    <비교 연산자>
        >, <, >=, <= : 대소 비교 연산자
        = (같음), !=, ^=, <> (같지 않음) : 동등 비교 연산자
        
*/

-- EMPLOYEE 테이블에서 부서 코드가 D9와 일치하는 사원들의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- EMPLOYEE 테이블에서 부서 코드가 D9와 일치하는 사원들의 직원명, 부서 코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- EMPLOYEE 테이블에서 부서 코드가 D9와 일치하지 않는 사원들의 사번,직원명, 부서 코드 조회
SELECT EMP_ID,
       EMP_NAME,
       DEPT_CODE
FROM EMPLOYEE
--WHERE DEPT_CODE != 'D9'
--WHERE DEPT_CODE <> 'D9'
WHERE DEPT_CODE ^= 'D9'
ORDER BY DEPT_CODE;

---------------------- 실습 문제 ----------------------
-- EMPLOYEE 테이블에서 급여가 400만원 이상인 직원들의 직원명, 부서 코드, 급여 조회
SELECT EMP_NAME AS 직원명,
       DEPT_CODE AS "부서 코드",
       SALARY 급여
FROM EMPLOYEE
WHERE SALARY >= 4000000;


-- EMPLOYEE 테이블에서 재직 중인 직원들읠 사번, 이름, 입사일 조회
SELECT EMP_ID AS 사번,
       EMP_NAME 이름,
       HIRE_DATE 입사일
FROM EMPLOYEE
WHERE ENT_YN != 'Y';
-- NULL은 비교 연산자 사용 불가
--WHERE ENT_DATE != NULL;

-- EMPLOYEE 테이블에서 연봉이 5000만원 이상인 직원들의 직원명, 급여, 연봉, 입사일 조회
SELECT EMP_NAME AS 직원명,
       SALARY AS 급여,
       SALARY * 12 연봉,
       HIRE_DATE 입사일
FROM EMPLOYEE
WHERE SALARY * 12 >= 50000000;

/*
    <ORDER BY>
        SELECT 컬럼 [, 컬럼, ...]
            FROM 테이블명
            WHERE 조건식;
            ORDER BY 컬럼|별칭|컬럼 순번 [ASC|DESC] [NULLS FIRST|NULLS LAST];
        
            - ASC : 오름차순 정렬 (ASC, DESC 생략 시 기본값)
            - DESC : 내림차순 정렬
            - NULLS FIRST : 정렬하고자 하는 컬럼 값에 NULL이 있는 경우 NULL 값을 맨 앞으로 정렬한다.
            - NULL LAST : 정렬하고자 하는 컬럼 값에 NULL이 있는 경우 NULL 값을 맨 뒤로 정렬한다.
    
    <SELECT 문이 실행(해석) 되는 순서>
        1. FROM 절
        2. WHERE 절
        3. SELECT 절
        4. ORDER BY 절
*/

-- EMPLOYEE 테이블에서 BONUS 오름차순 정렬
SELECT *
FROM EMPLOYEE
--ORDER BY BONUS ASC; -- 오름차순 정렬은 기본적으로 NULLS LAST
--ORDER BY BONUS NULLS FIRST;
ORDER BY BONUS ASC NULLS FIRST;

-- EMPLOYEE 테이블에서 BONUS 내림차순 정렬 (단, BONUS 값이 일치할 경우 SALARY를 가지고 오름차순 정렬
SELECT *
FROM EMPLOYEE
--ORDER BY BONUS DESC; -- 내림차순 정렬은 기본적으로 NULLS FIRST
--ORDER BY BONUS DESC NULLS LAST;
ORDER BY BONUS DESC NULLS LAST, SALARY; -- 정렬 기준 여러 개를 제시할 수 있다

-- EMPLOYEE 테이블에서 연봉별 내림차순 정렬된 직원들의 직원명, 연봉 조회
SELECT EMP_NAME AS 직원명,
       SALARY * 12 AS 연봉
FROM EMPLOYEE
--ORDER BY SALARY * 12;
--ORDER BY 연봉 DESC;
ORDER BY 2 DESC;

/*
    <연결 연산자>
        여러 컬럼 값들을 하나의 컬럼인 것 처럼 연결하거나, 컬럼과 리터럴을 연결할 수 있는 연산자이다.
*/

-- EMPLOYEE 테이블에서 사번, 직원명, 급여를 연결해서 조회
SELECT EMP_ID || EMP_NAME || SALARY AS "사번 직원명 급여"
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 직원명, 급여를 리터럴과 연결해서 조회
SELECT EMP_NAME || '의 월급은 ' || SALARY || '원 입니다.' AS "직원명 급여"
FROM EMPLOYEE;

/*
    <논리 연산자>
        AND (~이면서, 그리고)
*/

-- EMPLOYEE 테이블에서 부서 코드가 D6이면 급여가 300만원 이상인 직원들의 사번, 직원명, 부서 코드, 급여 조회
SELECT EMP_ID 사번, 
       EMP_NAME 직원명, 
       DEPT_CODE "부서 코드", 
       SALARY 급여
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6' AND SALARY >= 3000000;

-- EMPLOYEE 테이블에서 부서 코드가 D5이거나 급여가 500만원 이상인 직원들의 사번, 직원명, 부서 코드, 급여 조회
SELECT EMP_ID 사번, 
       EMP_NAME 직원명, 
       DEPT_CODE "부서 코드", 
       SALARY 급여
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR SALARY >= 5000000;

-- EMPLOYEE 테이블에서 급여가 350만원 이상 600만원 이하를 받는 직원의 사번, 직원명, 부서 코드, 급여 조회
SELECT EMP_ID 사번, 
       EMP_NAME 직원명, 
       DEPT_CODE "부서 코드", 
       SALARY 급여
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND SALARY <= 6000000
ORDER BY SALARY;

/*
    <BETWEEN AND>
        WHERE (비교대상) 컬럼 BETWEEN 하한값 AND 상한값
        
        WHERE 절에서 사용되는 연산자로 범위에 대한 조건을 제시할 때 사용한다
        컬럼의 값이 하한값 이상이고, 상한값 이하인 경우 검색 대상이 된다.
*/
-- EMPLOYEE 테이블에서 급여가 350만원 이상 600만원 이하를 받는 직원의 사번, 직원명, 부서 코드, 급여 조회
SELECT EMP_ID 사번, 
       EMP_NAME 직원명, 
       DEPT_CODE "부서 코드", 
       SALARY 급여
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000
ORDER BY SALARY;

-- EMPLOYEE 테이블에서 급여가 350만원 이상 600만원 이하가 아닌 직원의 사번, 직원명, 부서 코드, 급여 조회
SELECT EMP_ID 사번, 
       EMP_NAME 직원명, 
       DEPT_CODE "부서 코드", 
       SALARY 급여
FROM EMPLOYEE
--WHERE SALARY NOT BETWEEN 3500000 AND 6000000
WHERE NOT SALARY BETWEEN 3500000 AND 6000000 -- NOT 연산자는 컬럼명 앞 또는 BETWEEN 앞에 사용 가능
ORDER BY SALARY;

-- EMPLOYEE 테이블에서 입사일이 '90/01/01' ~ '01/ 01/01'가 아닌 사원의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE
--WHERE NOT HIRE_DATE BETWEEN '90/01/01' AND '01/01/01'
WHERE HIRE_DATE NOT BETWEEN '90/01/01' AND '01/01/01'
ORDER BY HIRE_DATE DESC;

/*
    <IN>
        WHERE 컬럼 IN(값, 값,..., 값)
        
        컬럼의 값이 값 목록 중에 일치하는 값이 있을 때 검색 대상이 된다.
        
*/
-- EMPLOYEE 테이블에서 부서 코드가 'D5', 'D6', 'D8'인 부서원들의 직원명, 부서 코드, 급여 조회
SELECT EMP_NAME 직원명, 
       DEPT_CODE "부서 코드", 
       SALARY 급여
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D8')
ORDER BY DEPT_CODE;

SELECT EMP_NAME
FROM EMPLOYEE;

/*
    <LIKE>
        WHERE 컬럼 LIKE '특정 패턴'
        
        컬럼 값이 지정된 특정 패턴을 만족할 경우 검색 대상이 된다.
        특정 패턴에는 '%', '_'를 와일드카드로 사용할 수 있다.
        '%' : 0 글자 이상
             Ex) 컬럼 LIKE '문자%' -> 컬럼 값 중에 '문자'로 시작하는 모든 행을 조회한다.
                 컬럼 LIKE '%문자' -> 컬럼 값 중에 '문자'로 끝나는 모든 행을 조회한다.
                 컬럼 LIKE '%문자%' -> 컬럼 값 중에 '문자'가 포함되어 있는 모든 행을 조회한다.
        '_' : 1 글자 
             Ex) 컬럼 LIKE '_문자' -> 컬럼 값 중에 '문자'앞에 무조건 한 글자가 오는 모든 행을 조회한다.
                 컬럼 LIKE '__문자' -> 컬럼 값 중에 '문자'앞에 무조건 두 글자가 오는 모든 행을 조회한다.    
*/

-- EMPLOYEE 테이블에서 성이 전 씨인 사원의 직원명, 급여, 입사일 조회
SELECT EMP_NAME 직원명,
       SALARY 급여,
       HIRE_DATE 입사일
FROM EMPLOYEE
WHERE EMP_NAME LIKE '전%';

-- EMPLOYEE 테이블에서 이름 중에 '하'가 포함된 사원의 직원명, 주민번호, 부서코드 조회
SELECT EMP_NAME 직원명, EMP_NO, DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%';

--EMPLOYEE 테이블에서 김씨 성이 아닌 직원의 사번, 직원명, 입사일을 조회
SELECT EMP_NO, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME NOT LIKE '김%';


-- EMPLOYEE 테이블에서 전화번호 4번째 자리가 9로 시작하는 직원의 사번, 직원명, 전화번호, 이메일 조회 
SELECT EMP_ID, EMP_NAME, PHONE, EMAIL
FROM EMPLOYEE
WHERE PHONE LIKE '___9%';

-- EMPLOYEE 테이블에서 이메일 중 '_' 앞 글자가 3자리인 이메일 주소를 가진 직원의 사번, 직원명, 이메일 조회
SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
--WHERE EMAIL LIKE '____%'; -- 와일드 카드와 데이터 값이 구분이 되지 않는다/
WHERE EMAIL LIKE '___$_%' ESCAPE '$';    

/*
    <IS NULL>
        WHERE 컬럼 IS NULL    
        
        컬럼 값이 NULL이 있을 경우 검색 대상이 된다
    
*/

-- EMPLOYEE 테이블에서 보너스를 받지 않는 사원의 사번, 직원명, 급여, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
--WHERE BONUS = NULL -- NULL은 비교 연산자로 비교할 수 없다.
WHERE BONUS IS NULL;


-- EMPLOYEE 테이블에서 관리자가 없는 사원의 이름, 부서코드 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL;

-- EMPLOYEE 테이블에서 관리자도 없고 부서도 배치 받지 않은 사원의 이름, 부서코드 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;

-- EMPLOYEE 테이블에서 부서 배치를 받진 않았지만 보너스는 받는 사원의 직원명, 부서 코드, 보너스 조회
SELECT EMP_NAME, DEPT_CODE, BONUS
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND NOT BONUS IS NULL;

/*
    연산자 우선 순위 
*/

-- EMPLOYEE 테이블에서 직급 코드가 J2 또는 J7 직급인 사원들 중 급여가 200만원 이상인 사원들의 모든 컬럼을 조회
SELECT *
FROM EMPLOYEE
--WHERE (JOB_CODE = 'J7' OR JOB_CODE = 'J2') AND SALARY >= 2000000;
WHERE JOB_CODE IN ('J7', 'J2') AND SALARY >= 2000000;

SELECT *
FROM EMPLOYEE
WHERE JOB_CODE = 'J2' AND SALARY >= 2000000;

SELECT *
FROM EMPLOYEE
WHERE JOB_CODE = 'J7';













