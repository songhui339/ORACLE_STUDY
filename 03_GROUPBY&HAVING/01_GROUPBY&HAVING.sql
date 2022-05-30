/*
    <GROUP BY>
        그룹 기준을 제시할 수 있는 구문이다.
        여러 개의 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용한다.
*/

SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- 각 부서별 그룹으로 묶어서 부서별 총합을 구한 결과를 조회 
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE NULLS FIRST;

-- EMPLOYEE 테이블에서 전체 사원의 수를 조회
SELECT COUNT(*)
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 각 부서별 사원의 수를 조회 
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE NULLS FIRST;

----------- 실습 문제 -----------
-- EMPLOYEE 테이블에서 부서별 급여의 합계를 조회 (부서별 내림차순 정렬)
SELECT DEPT_CODE 부서명, 
       TO_CHAR(SUM(SALARY) , 'FM999,999,999') "부서별 급여의 합"
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE DESC;

-- EMPLOYEE 테이블에서 직급별 사원의 수를 조회 (직급별 내림차순 정렬)
SELECT JOB_CODE 직급명,
       COUNT(*) "직급별 사원의 수"
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE DESC;

-- EMPLOYEE 테이블에서 직급별 보너스를 받는 사원의 수를 조회 (직급별 오름차순 정렬)
SELECT JOB_CODE 직급명,
       COUNT(BONUS) "직급별 사원의 수"
FROM EMPLOYEE
--WHERE BONUS IS NOT NULL
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- EMPLOYEE 테이블에서 부서별 보너스를 받는 사원의 수를 조회 (부서별 오름차순 정렬)
SELECT DEPT_CODE 부서,
       COUNT(*) "보너스 받는 직원수"
FROM EMPLOYEE
WHERE BONUS IS NOT NULL
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

SELECT DEPT_CODE 부서,
       COUNT(BONUS) "보너스 받는 직원수"
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- EMPLOYEE 테이블에서 직급별 급여의 평균을 조회
SELECT JOB_CODE 직급, 
       TO_CHAR(FLOOR(AVG(NVL(SALARY,0))), 'FM999,999,999') "직급별 급여 평균"
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- EMPLOYEE 테이블에서 부서별 사원의 수, 보너스를 받는 사원의 수, 급여의 합, 평균 급여, 최고 급여, 최저 급여를 조회 (부서별 내림차순)
SELECT NVL(DEPT_CODE, '부서 없음') "부서 코드", 
       COUNT(*) "사원 수", 
       COUNT(BONUS) "보너스", 
       TO_CHAR(SUM(SALARY), 'FM999,999,999') "급여의 합",
       TO_CHAR(CEIL(AVG(NVL(SALARY, 0))), 'FM999,999,999') "평균 급여",
       TO_CHAR(MAX(SALARY), 'FM999,999,999') "최고 급여",
       TO_CHAR(MIN(SALARY), 'FM999,999,999') "최저 급여"
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE DESC NULLS LAST;
                  
-- EMPLOYEE 테이블에서 성별 별 사원의 수를 조회
SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남자', '2', '여자') AS "성별",
       COUNT(*) AS "사원 수"
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8, 1); -- 컬럼 계산식, 함수 호출 구문이 올 수 있다.
-- GROUP BY "성별 코드"; -- 컬럼 순번, 별칭은 사용할수 없다.

-- EMPLOYEE 테이블에서 부서 코드와 직급 코드가 같은 사원의 직원 수, 급여의 합을 조회 
SELECT DEPT_CODE "부서 코드",
       JOB_CODE "직급 코드",
       COUNT(*) "직원 수",
       SUM(SALARY) "급여의 합"
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE -- 여러 컬럼을 제시해서 그룹 기준을 지정할 수 있다.
ORDER BY DEPT_CODE, JOB_CODE;

/*
    <HAVING>
        그룹에 대한 조건을 제시할 때 사용하는 구문이다.
    
    <SELECT 구문의 실행 순서>
        5: SELECT
        1: FROM
        2: WHERE
        3: GROUP BY
        4: HAVING
        6: ORDER BY
*/
-- EMPLOYEE 테이블에서 부서별로 급여가 300만원 이상인 직원 조회
SELECT DEPT_CODE,
       AVG(SALARY)
FROM EMPLOYEE
WHERE SALARY >= 3000000
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- EMPLOYEE 테이블에서 평균 급여가 300만원 이상인 부서를 조회
SELECT DEPT_CODE,
       FLOOR(AVG(NVL(SALARY, 0)))
FROM EMPLOYEE
--WHERE FLOOR(AVG(NVL(SALARY, 0))) >= 3000000 -- 에러 발생 
GROUP BY DEPT_CODE
HAVING FLOOR(AVG(NVL(SALARY, 0))) >= 3000000
ORDER BY DEPT_CODE;

-- EMPLOYEE  테이블에서 직급별 총 급여의 합이 10,000,000 이상인 직급들만 조회
SELECT JOB_CODE,
       SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000
ORDER BY JOB_CODE;

-- EMPLOYEE 테이블에서 부서별 보너스를 받는 사원이 없는 부서만 조회
SELECT NVL(DEPT_CODE, '부서 없음'),
       COUNT(BONUS)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0
ORDER BY DEPT_CODE;

/*
    <집계 함수>
        그룹별 산출한 결과 값의 중간 집계를 계산하는 함수 
*/

-- EMPLOYEE 테이블에서 직급별 급여의 합계를 조회 
SELECT JOB_CODE, TO_CHAR(SUM(NVL(SALARY, 0)), 'FM999,999,999')
FROM EMPLOYEE
--GROUP BY ROLLUP(JOB_CODE)
GROUP BY CUBE(JOB_CODE)
ORDER BY JOB_CODE;

-- EMPLOYEE 테이블에서 직급 코드와 부서 코드가 같은 사원들의 급여의 합계를 조회 
SELECT JOB_CODE, DEPT_CODE, TO_CHAR(SUM(NVL(SALARY, 0)), 'FM999,999,999')
FROM EMPLOYEE
-- ROLLUP(컬럼1, 컬럼2, ..) -> 컬럼 1을 가지고 중간 집계를 내는 함수
--GROUP BY ROLLUP(JOB_CODE, DEPT_CODE) 
-- CUBE(컬럼1, 컬럼2, ..) -> 전달되는 모든 컬럼을 가지고 중간 집계를 내는 함수 
GROUP BY CUBE(JOB_CODE, DEPT_CODE)
ORDER BY JOB_CODE, DEPT_CODE;

/*
    <집합 연산자>
        여러 개의 쿼리문을 하나의 쿼리문으로 만드는 연산자이다.
        조회하려고 하는 컬럼의 개수와 이름이 같아야 집합 연산자를 사용하 수 있다.
        
    1) UNION (합집합)
        두 쿼리문을 수행한 결과값을 하나로 합쳐서 추출한다. (중복되는 행은 제거)
    2) UNION ALL (합집합)
        두 쿼리문을 수행한 결과값을 하나로 합쳐서 추출한다. (중복되는 행을 제거하지 않음)
    3) INTERSECT (교집합)
        두 쿼리문을 수행한 결과값에 중복된 결과값만 추출한다.
    4) MINUS (차집합)
        선행 쿼리문의 결과값에서 후행 쿼리문의 결과값을 뺀 나머지 결과값만 추출한다. 
*/
-- EMPLOYEE 테이블에서 부서 코드가 D5인 사원들의 사번, 직원명, 부서코드, 급여를 조회 (6명)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- EMPLOYEE 테이블에서 급여가 300만원 초과인 사원들의 사번, 직원명, 부서 코드, 급여를 조회 (8명)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- 1) UNION 
-- EMPLOYEE 테이블에서 부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원들의 사번, 직원명, 부서코드, 급여를 조회 (12명 조회됨)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- 위 쿼리문 대신에 WHERE 절에 OR연산자를 사용해서 처리 가능 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR SALARY > 3000000;

-- 2. UNION ALL
-- EMPLOYEE 테이블에서 부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원들의 사번, 직원명, 부서코드, 급여를 조회 (14명 조회됨)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION ALL

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- 3) INTERSECT
-- EMPLOYEE 테이블에서 부서코드가 D5인 사원 이면서 급여가 300만원 초과인 사원들의 사번, 직원명, 부서코드, 급여를 조회 (2명 조회됨)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

INTERSECT

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- 위 쿼리문 대신에 WHERE 절에 AND 연산자를 사용해서 처리 가능 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY > 3000000;

-- 4) MINUS
-- EMPLOYEE 테이블에서 부서코드가 D5인 사원들 중에 급여가 300만원 초과인 사원들을 제외해서 사번, 직원명, 부서코드, 급여를 조회 (4명 조회됨)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

MINUS

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- 위 쿼리문 대신에 WHERE 절에 AND 연산자를 사용해서 처리 가능 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY <= 3000000;

/*
    <GROUPING SET>
        그룹 별로 처리된 여러 개의 SELECT 문을 하나로 합친 결과로 원할 때 사용한다.
*/

-- 부서별 사원수 
SELECT NVL(DEPT_CODE, '부서 없음'), COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- 직급별 사원수 
SELECT JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY GROUPING SETS (DEPT_CODE, JOB_CODE);

---------- 실습 문제 ----------
-- EMPLOYEE  테이블에서 부서 코드, 직급 코드, 사수 사번이 동일한 사원의 부서 코드, 직급 코드, 사수 사번, 급여 평균을 조회
SELECT DEPT_CODE, JOB_CODE, MANAGER_ID, FLOOR(AVG(NVL(SALARY, 0)))
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE, MANAGER_ID
ORDER BY DEPT_CODE, JOB_CODE, MANAGER_ID;

-- EMPLOYEE 테이블에서 부서 코드, 사수 사번이 동일한 사원의 부서 코드, 사수 사번, 급여 평균을 조회
SELECT DEPT_CODE, MANAGER_ID, FLOOR(AVG(NVL(SALARY, 0)))
FROM EMPLOYEE
GROUP BY DEPT_CODE, MANAGER_ID
ORDER BY DEPT_CODE, MANAGER_ID;

-- EMPLOYEE 테이블에서 직급 코드, 사수 사번이 동일한 사원의 직급 코드, 사수 사번, 급여 평균을 조회 
SELECT JOB_CODE, MANAGER_ID, FLOOR(AVG(NVL(SALARY, 0)))
FROM EMPLOYEE
GROUP BY JOB_CODE, MANAGER_ID
ORDER BY JOB_CODE, MANAGER_ID;

SELECT DEPT_CODE, JOB_CODE, MANAGER_ID, FLOOR(AVG(NVL(SALARY, 0)))
FROM EMPLOYEE
GROUP BY GROUPING SETS ((DEPT_CODE, JOB_CODE, MANAGER_ID), (DEPT_CODE, MANAGER_ID), (JOB_CODE, MANAGER_ID))
ORDER BY DEPT_CODE, JOB_CODE, MANAGER_ID;


















