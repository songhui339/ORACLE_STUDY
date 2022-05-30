/*
    <SUBQUERY>
        하나의 SQL 문 안에 포함된 다른 SQL 문을 말한다
        메인 쿼리를 보조하는 역할을 하는 쿼리문이다
*/
-- 서브 쿼리 예시
-- 1. 노옹철 사원과 같은 부서원들을 조회
-- 1) 노옹철 사원의 부서 코드 조회 (D9)
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철'; -- D9

-- 2) 부서 코드가 노옹철 사원의 부서 코드와 동일한 사원들을 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 위의 2단계를 하나의 쿼리로 작성 
SELECT EMP_NAME, DEPT_CODE 
FROM EMPLOYEE
WHERE DEPT_CODE = ( 
    SELECT DEPT_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME = '노옹철'
);

-- 2. 전 직원의 평균 급여보다 더 많은 급여를 받고 있는 직원들의 사번, 직원명, 직급 코드, 급여를 조회 
-- 1) 전 직원의 평균 급여를 조회 (3047662.60869565217391304347826086956522)
SELECT AVG(SALARY)
FROM EMPLOYEE;

-- 2) 급여가 1)의 조회 결과 이상인 직원들의 사번, 직원명, 직급 코드, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3047662.60869565217391304347826086956522;

-- 위의 2단계를 하나의 쿼리로 작성 
SELECT EMP_ID, 
       EMP_NAME,
       JOB_CODE,
       SALARY
FROM EMPLOYEE 
WHERE SALARY >= (
    SELECT AVG(SALARY)
    FROM EMPLOYEE
);

/*
    <서브 쿼리 구분>
        서브 쿼리는 서브 쿼리를 수행한 결과값에 따라서 분류할 수 있다
        
        1. 단일행 서브 쿼리    : 서브 쿼리의 조회 결과 값의 개수가 1개일 때 
        2. 다중행 서브 쿼리    : 서브 쿼리의 조회 결과 값의 행의 수가 여러행 일 때
        3. 다중열 서브 쿼리
        4. 다중행 다중열 서브 쿼리
        
        * 서브 쿼리의 분류에 따라 서브 쿼리 앞에 붙는 연산자가 달라진다.
*/
-- 1. 단일행 서브 쿼리
--  1) 전 직원의 평균 급여보다 급여를 적게 받는 직원들의 사번, 직원명, 직급 코드, 급여 조회
--  전 직원의 평균 급여
SELECT AVG(NVL(SALARY,0))
FROM EMPLOYEE;

-- 위 쿼리를 서브 쿼리로 사용하는 메인 쿼리 작성
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (
    SELECT AVG(NVL(SALARY,0))
    FROM EMPLOYEE
);

-- 2) 최저 급여를 받는 직원의 사번, 직원명, 직급 코드, 급여, 입사일 조회
-- 최저 급여 조회
SELECT MIN(SALARY)
FROM EMPLOYEE;

-- 위 쿼리를 서브 쿼리로 사용하는 메인 쿼리 작성
SELECT EMP_ID 사번,
       EMP_NAME 직원명,
       JOB_CODE "직급 코드",
       TO_CHAR(SALARY, 'FM999,999,999') 급여,
       HIRE_DATE 입사일
FROM EMPLOYEE
WHERE SALARY = (
    SELECT MIN(SALARY)
    FROM EMPLOYEE
);

-- 3) 노옹철 사원의 급여보다 더 많이 받는 사원의 사번, 직원명, 부서명, 직급 코드, 급여를 조회
-- 노옹철 사원의 급여
SELECT SALARY
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';

-- ANSI 구문 
SELECT E.EMP_ID 사번, 
       E.EMP_NAME 직원명, 
       D.DEPT_TITLE 부서명,
       E.JOB_CODE "직급 코드",
       E.SALARY 급여
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
WHERE SALARY > (
    SELECT SALARY
    FROM EMPLOYEE
    WHERE EMP_NAME = '노옹철'
);

-- 오라클 구문 
SELECT E.EMP_ID 사번, 
       E.EMP_NAME 직원명, 
       D.DEPT_TITLE 부서명,
       E.JOB_CODE "직급 코드",
       E.SALARY 급여
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID
AND SALARY > (
    SELECT SALARY
    FROM EMPLOYEE
    WHERE EMP_NAME = '노옹철'
);

-- 4) 부서별 급여의 합이 가장 큰 부서의 부서 코드, 급여의 합을 조회
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT DEPT_CODE "부서 코드",
       SUM(SALARY) "급여의 합"
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (
    SELECT MAX(SUM(SALARY))
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
);

/*
    2. 다중행 서브 쿼리 
    =, >, <, >=, <= 쓸 수 없음 
    IN / NOT IN : 여러 개의 결과값 중에서 한 개라도 일치하는 값이 있거나 없으면 TRUE를 리턴한다.
    ANY : 여러 개의 값들 중에서 한 개라도 일치하면 TRUE, IN과 다른 점은 비교 연산자를 함께 사용한다는 점이다.
          SALARY = ANY (...) : IN과 같은 결과 
          SALARY != ANY (...) : NOT IN과 같은 결과 
          SALARY > ANY (...) : 최소값 보다 크면 TRUE 리턴 
          SALARY < ANY (...) : 최대값 보다 작으면 TRUE 리턴 
    ALL : 여러 개의 값들 모두와 일치하면 TRUE, IN과 다른 점은 비교 연산자를 함께 사용한다는 점이다.
          SALARY > ALL (...) : 최대값 보다 크면 TRUE 리턴 
          SALARY < ALL (...) : 최소값 보다 작으면 TRUE 리턴 
*/
-- 1) 각 부서별 최고 급여를 받는 직원의 직원명, 직급 코드, 부서코드, 급여를 조회 
-- 부서별 최고 급여 조회 (2890000, 3660000, 8000000, 3760000, 3900000, 2490000, 2550000)
SELECT MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 위 급여를 받는 사원들을 조회 
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (2890000, 3660000, 8000000, 3760000, 3900000, 2490000, 2550000)
ORDER BY DEPT_CODE;

-- 위 쿼리문을 합쳐서 하나의 쿼리문으로 작성 
SELECT EMP_NAME, NVL(DEPT_CODE, '부서 없음'), JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (
    SELECT MAX(SALARY)
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
)
ORDER BY DEPT_CODE;

-- 2) 사원들의 사번, 이름, 부서 코드, 구분(사수/사원) 조회 
-- 사수에 해당하는 사번을 조회 (201, 204, 100, 200, 211, 207, 214)
SELECT DISTINCT MANAGER_ID
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL;

-- 사번이 위와 같은 직원들의 사번, 이름, 부서 코드, 구분(사수) 조회 (6명)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, '사수' AS 구분
FROM EMPLOYEE
WHERE EMP_ID IN (201, 204, 100, 200, 211, 207, 214);

-- 위의 쿼리문을 합쳐서 하나의 쿼리문으로 합쳐서 조회 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, '사수' AS 구분
FROM EMPLOYEE
WHERE EMP_ID IN (
    SELECT DISTINCT MANAGER_ID
    FROM EMPLOYEE
    WHERE MANAGER_ID IS NOT NULL
);
-- 일반 사원에 해당하는 정보를 조회 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, '사원' AS 구분
FROM EMPLOYEE
WHERE EMP_ID NOT IN (
    SELECT DISTINCT MANAGER_ID
    FROM EMPLOYEE
    WHERE MANAGER_ID IS NOT NULL
);

-- 위의 결과들을 하나의 결과로 확인 (UNION) => 비효율적 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, '사수' AS 구분
FROM EMPLOYEE
WHERE EMP_ID IN (
    SELECT DISTINCT MANAGER_ID
    FROM EMPLOYEE
    WHERE MANAGER_ID IS NOT NULL
)

UNION

SELECT EMP_ID, EMP_NAME, DEPT_CODE, '사원' AS 구분
FROM EMPLOYEE
WHERE EMP_ID NOT IN (
    SELECT DISTINCT MANAGER_ID
    FROM EMPLOYEE
    WHERE MANAGER_ID IS NOT NULL
)
ORDER BY EMP_ID;

-- SELECT 절에 서브 쿼리를 사용해서 조회 
SELECT EMP_ID, 
       EMP_NAME, 
       DEPT_CODE,
       CASE WHEN EMP_ID IN (
                    SELECT DISTINCT MANAGER_ID
                    FROM EMPLOYEE
                    WHERE MANAGER_ID IS NOT NULL
        ) 
            THEN '사수'
            ELSE '사원'
       END AS "구분"
FROM EMPLOYEE;

-- 3) 대리 직급임에도 과장 직급들의 최소 급여보다 많이 받는 사번, 직급 코드, 급여를 조회 
-- (사원 -> 대리 -> 과장 -> 차장 -> 부장)
-- 과장 직급들의 급여 조회 (2200000, 2500000, 3760000)
SELECT SALARY
FROM EMPLOYEE
WHERE JOB_CODE = 'J5';

-- 직급이 대리인 직원들 중에서 위의 값 중에 하나라도 큰 경우 (최소값 보다 큰 경우)
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE = 'J6' 
AND SALARY > ANY(2200000, 2500000, 3760000);

-- 한개의 쿼리문으로 합치기 
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE = 'J6' 
AND SALARY > ANY(
    SELECT SALARY
    FROM EMPLOYEE
    WHERE JOB_CODE = 'J5'
); -- SALARY > 220만 OR SALARY > 250만 OR SALARY > 376만

-- 4) 과장 직급임에도 차장 직급의 최대 급여보다 더 많이 받는 직원들의 사번, 이름, 직급 코드, 급여 조회 
-- 차장 직급들의 급여 조회 (2800000, 1550000, 2490000, 2480000)
SELECT SALARY
FROM EMPLOYEE E
INNER JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE J.JOB_NAME= '차장';

-- 과장 직금임에도 차장 직급의 최대 급여보다 더 많이 받는 직원
SELECT E.EMP_ID, 
       E.EMP_NAME, 
       J.JOB_NAME, 
       E.SALARY
FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE J.JOB_NAME ='과장'
AND E.SALARY > ALL (2800000, 1550000, 2490000, 2480000); 
-- SALARY > 280만 AND SALARY > 155만 AND SALARY > 249만 AND SALARY > 248만

-- 두 쿼리문을 합치기 
SELECT E.EMP_ID, 
       E.EMP_NAME, 
       J.JOB_NAME, 
       E.SALARY
FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE J.JOB_NAME ='과장'
AND E.SALARY > ALL (
            SELECT SALARY
            FROM EMPLOYEE E
            INNER JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
            WHERE J.JOB_NAME= '차장'
);

-- 3. 다중열 서브 쿼리 
-- 1) 하이유 사원과 같은 부서 코드, 같은 직급 코드에 해당하는 사원들을 조회 
-- 하이유 사원의 부서 코드와 직급 코드 조회 
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '하이유';

-- 부서 코드가 D5이면서 직급 코드가 J5인 사원들 조회 
SELECT EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND JOB_CODE = 'J5';

-- 각각 단일행 서브 쿼리로 작성
SELECT EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (
    SELECT DEPT_CODE
    FROM EMPLOYEE 
    WHERE EMP_NAME = '하이유'
    )
AND JOB_CODE = (
    SELECT JOB_CODE
    FROM EMPLOYEE 
    WHERE EMP_NAME = '하이유'
);

-- 다중열 서브 쿼리를 사용해서 조회 
SELECT EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (('D5', 'J5'));

SELECT EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (
        SELECT DEPT_CODE, JOB_CODE
        FROM EMPLOYEE
        WHERE EMP_NAME = '하이유'
);

-- 2) 박나라 사원과 직급 코드가 일치하면서 같은 사수를 가지고 있는 사원의 사번, 이름, 직급 코드, 사수 사번 조회 
-- 박나라 사원의 직급 코드와 사수 사번을 조회 
SELECT JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE EMP_NAME = '박나라';

SELECT EMP_ID 사번,
       EMP_NAME 직원명,
       JOB_CODE "직급 코드",
       MANAGER_ID "사수 사번"
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) = (
        SELECT JOB_CODE, MANAGER_ID
        FROM EMPLOYEE
        WHERE EMP_NAME = '박나라'
);

-- 4. 다중행 다중열 서브 쿼리 
-- 1) 각 직급별로 최소 급여를 받는 사원들의 사번, 이름, 직급 코드, 급여를 조회 
-- 각 직급별 최소 급여 조회 ((J2, 3700000), (J7, 1380000),...)
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (
    SELECT JOB_CODE, MIN(SALARY)
    FROM EMPLOYEE
    GROUP BY JOB_CODE
)
ORDER BY JOB_CODE;

-- 2) 각 부서별 최소 급여를 받는 사원들의 사번, 이름, 직급 코드, 급여를 조회 
-- 각 부서별 최소 급여 조회
SELECT NVL(DEPT_CODE, '부서 없음') , MIN(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 다중행 다중열 서브 쿼리를 사용해서 조회 
SELECT EMP_ID 사번,
       EMP_NAME 직원명,
       NVL(DEPT_CODE, '부서 없음') "부서 코드",
       JOB_CODE "직급 코드",
       TO_CHAR(SALARY, 'FM99,999,999')
FROM EMPLOYEE
WHERE (NVL(DEPT_CODE, '부서 없음'), SALARY) IN (
        SELECT NVL(DEPT_CODE, '부서 없음'), MIN(SALARY)
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
)
ORDER BY DEPT_CODE;

/*
    <인라인 뷰>
        FROM 절에 서브 쿼리를 제시하고, 서브 쿼리를 수행한 결과를 테이블 대신에 사용한다  
*/
-- 1. 인라인 뷰를 활영한 TOP-N 분석 
-- 1) 전 직원 중에 급여가 가장 높은 상위 5명의 순위, 이름, 급여 조회 
-- * ROWNUM : 오라클에서 제공하는 컬럼, 조회된 순서대로 1부터 순번을 부여하는 컬럼 
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;
-- 이미 순번이 정해진 다음에 정렬이 된다
-- FROM -> SELECT(순번이 정해진다) -> ORDER BY

SELECT ROWNUM, A.EMP_NAME, A.SALARY
FROM (
    SELECT EMP_NAME, SALARY
    FROM EMPLOYEE
    ORDER BY SALARY DESC
) A
WHERE ROWNUM <= 5;

-- 2.1. 부서별 평균 급여가 높은 3개의 부서의 부서 코드 평균 급여를 조회 
SELECT ROWNUM AS 순위, 부서코드, ROUND(평균급여)
FROM (
    SELECT DEPT_CODE "부서코드", AVG(NVL(SALARY,0)) 평균급여
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
    ORDER BY "평균급여" DESC
) 
WHERE ROWNUM <= 3;

SELECT DEPT_CODE "부서 코드", TO_CHAR(FLOOR(AVG(NVL(SALARY,0))), 'FM999,999,999') "평균 급여"
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY "평균 급여" DESC;

-- 2.2. WITH를 이용한 방법
WITH TOPN_SAL AS (
    SELECT NVL(DEPT_CODE, '부서 없음') "부서코드", AVG(NVL(SALARY,0)) 평균급여
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
    ORDER BY "평균급여" DESC
)
SELECT 부서코드, ROUND(평균급여)
FROM TOPN_SAL
WHERE ROWNUM <= 3;

/*
    <RANK 함수>
        데이터의 순위를 매기는 함수 
        RANK() OVER (정렬 기준) / DENSE_RANK() OVER(정렬 기준)
*/
-- 사원별 급여가 높은 순서대로 순위 매겨서 순위, 직원명, 급여 조회 
-- 공동 19위 2명 뒤에 순위는 21위 
SELECT RANK() OVER(ORDER BY SALARY DESC) 순위,
       EMP_NAME,
       SALARY
FROM EMPLOYEE;

SELECT DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위,
       EMP_NAME,
       SALARY
FROM EMPLOYEE;

-- 상위 5명 
-- RANK 함수는 WHERE 절에 사용할 수 없다
SELECT RANK() OVER(ORDER BY SALARY DESC) 순위,
       EMP_NAME,
       SALARY
FROM EMPLOYEE
WHERE RANK() OVER(ORDER BY SALARY DESC) <= 5; 

SELECT RANK, EMP_NAME, SALARY
FROM (
        SELECT RANK() OVER(ORDER BY SALARY DESC) AS RANK,
               EMP_NAME,
               SALARY
        FROM EMPLOYEE
)
WHERE RANK <= 5;
