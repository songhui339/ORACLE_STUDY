/*
    <JOIN>
        두 개 이상의 테이블에서 데이터를 조회하고자 할 때 사용하는 구문이다.
    
    1. INNER JOIN
        연결시키는 컬럼의 값이 일치하는 행들만 하나의 행으로 조회한다. (일치하는 값이 없는 행은 조회 X)
    
        1) 오라클 전용 구문 
            SELECT 컬럼, ..., 컬럼
            FROM 테이블1, 테이블 2, ...
            WHERE 테이블1.컬럼명 = 테이블2.컬럼명;
            
            - FROM 절에 조인하려는 테이블들을 콤마로(,) 구분하여 나열한다
            - WHERE 절에 매칭 시킬 컬럼명에 대한 조건을 제시한다
            
        2) ANSI 표준 구문 
            SELECT 컬럼, ..., 컬럼
            FROM 테이블1 
            [INNER] JOIN 테이블2 ON (테이블1.컬럼명 = 테이블2.컬럼명);
            
            - FROM 절에서 기준이 되는 테이블을 기술한다
            - JOIN 절에서 조인하려는 테이블을 기술 후에 매칭 시킬 컬럼에 대한 조건을 제시한다.
            - 연결에 사용하려는 컬럼명이 같은 경우 USING(컬럼명) 구문을 사용한다.
*/
-- 사원들의 사번, 직원명, 부서 코드, 부서명을 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

-- 사원들의 사번, 직원명, 직급 코드, 직급명을 조회 
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE;

SELECT JOB_CODE, JOB_NAME
FROM JOB;

-- 오라클 구문
-- 1-1) 연결할 두 컬럼명이 다른 경우
-- EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인하여 사번, 직원명, 부서 코드, 부서명을 조회
-- 일치하는 값이 없는 행은 조회에서 제외된다. (DEPT_CODE가 NULL인 사원, DEPT_ID가 D3, D4, D7인 사원)
SELECT EMP_ID, EMP_NAME, DEPT_ID, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

-- 1-2) 연결할 두 컬럼명이 같은 경우 
-- EMPLOYEE 테이블과 JOB 테이블을 조인하여 사번, 직원명, 직급 코드, 직급명 조회
-- 방법 1) 테이블명을 이용하는 방법 
SELECT EMP_ID, EMP_NAME, JOB.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 방법 2) 테이블의 별칭을 이용하는 방법
SELECT EMP_ID, EMP_NAME, J.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

-- ANSI 구문
-- 2-1) 연결할 두 컬럼명이 다른 경우
-- EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인하여 사번, 직원명, 부서 코드, 부서명을 조회
SELECT E.EMP_ID, 
       E.EMP_NAME, 
       D.DEPT_ID, 
       D.DEPT_TITLE
FROM EMPLOYEE E
/*INNER*/ JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID);

-- 2-2) 연결할 두 컬럼명이 같은 경우
-- EMPLOYEE 테이블과 JOB 테이블을 조인하여 사번, 직원명, 직급 코드, 직급명 조회
-- 방법 1) 테이블명을 이용하는 방법
SELECT EMPLOYEE.EMP_ID, 
       EMPLOYEE.EMP_NAME, 
       JOB.JOB_CODE, 
       JOB.JOB_NAME
FROM EMPLOYEE
INNER JOIN JOB ON (EMPLOYEE.JOB_CODE = JOB.JOB_CODE);

-- 방법 2) 테이블 별칭을 이용하는 방법 
SELECT E.EMP_ID, 
       E.EMP_NAME, 
       J.JOB_CODE, 
       J.JOB_NAME
FROM EMPLOYEE E
INNER JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);

-- 방법 3) USING 구문을 이용하는 방법 
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE 
INNER JOIN JOB  USING(JOB_CODE);

-- 방법 4)NATURAL JOIN을 이용하는 방법 *참고용 
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE 
NATURAL JOIN JOB;

-- EMPLOYEE 테이블과 JOB 테이블을 조인해서 직급이 대리인 사원의 사번, 직원명, 직급명, 급여를 조회 
-- 오라클 구문
SELECT E.EMP_ID,
       E.EMP_NAME,
       J.JOB_NAME,
       E.SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE AND J.JOB_NAME = '대리';

-- ANSI 구문
SELECT E.EMP_ID,
       E.EMP_NAME,
       J.JOB_NAME,
       E.SALARY
FROM EMPLOYEE E
INNER JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE AND J.JOB_NAME = '대리');
--WHERE J.JOB_NAME = '대리';

------------------- 실습 문제 -------------------

-- 1. DEPARTMENT 테이블과 LOCATION 테이블을 조인하여 부서 코드, 부서 명, 지역 코드, 지역명을 조회
-- 오라클 구문
SELECT D.DEPT_ID,
       D.DEPT_TITLE,
       L.LOCAL_CODE,
       L.LOCAL_NAME
FROM DEPARTMENT D, LOCATION L
WHERE D.LOCATION_ID = L.LOCAL_CODE;

-- ANSI 구문
SELECT D.DEPT_ID,
       D.DEPT_TITLE,
       L.LOCAL_CODE,
       L.LOCAL_NAME
FROM DEPARTMENT D
INNER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE);

-- 2. EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인해서 보너스를 받는 사원들의 사번, 직원명, 부서명, 보너스를 조
-- 오라클 구문
SELECT E.EMP_ID,
       E.EMP_NAME,
       D.DEPT_TITLE,
       E.BONUS
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID AND E.BONUS IS NOT NULL;

-- ANSI 구문
SELECT E.EMP_ID,
       E.EMP_NAME,
       D.DEPT_TITLE,
       E.BONUS
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
--WHERE E.BONUS IS NOT NULL;
WHERE NVL(BONUS, 0) > 0;


-- 3. EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인해서 인사관리부가 아닌 사원들의 직원명, 부서명, 급여를 조회
-- 오라클 구문
SELECT E.EMP_NAME,
       D.DEPT_TITLE,
       E.SALARY
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID AND D.DEPT_TITLE != '인사관리부';
-- ANSI 구문
SELECT E.EMP_NAME,
       D.DEPT_TITLE,
       E.SALARY
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
--WHERE D.DEPT_TITLE != '인사관리부';
WHERE D.DEPT_ID != 'D1';

-- 4. EMPLOYEE 테이블과 DEPARTMENT 테이블, JOB 테이블을 조인해서 사원들의 사번, 직원명, 부서명, 직급명을 조
-- 오라클 구문
SELECT E.EMP_ID,
       E.EMP_NAME,
       D.DEPT_TITLE,
       J.JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID AND E.JOB_CODE = J.JOB_CODE
ORDER BY E.EMP_ID;

-- ANSI 구문
SELECT E.EMP_ID,
       E.EMP_NAME,
       D.DEPT_TITLE,
       J.JOB_NAME
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
INNER JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
ORDER BY E.EMP_ID;

-----------------------------------------------

/*
    2. OUTER JOIN
        두 테이블 간의 JOIN 시 일치하지 않는 행도 포함시켜서 조회할 때 사용하는 구문 
        반드시 기준이 되는 테이블(컬럼)을 지정해야 한다 (LEFT, RIGHT, FULL, (+))
*/

-- OUTER JOIN 과 비교할 INNER JOIN을 조회
-- EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인해서 사원들의 사원명, 부서명, 급여, 연봉 조회
-- INNER JOIN의 경우 부서가 지정되지 않은 2명에 대 한 정보가 조회되지 않는다.
SELECT E.EMP_NAME 사원명,
       D.DEPT_TITLE 부서명,
       E.SALARY 급여,
       (E.SALARY * 12) 연봉
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID);

/*
    1) LEFT [OUTER] JOIN
        두 테이블 중 왼편에 기술된 테이블의 컬럼을 기준으로 JOIN을 진행 
*/
-- ANSI 구문 
SELECT E.EMP_NAME 사원명,
       D.DEPT_TITLE 부서명,
       E.SALARY 급여,
       (E.SALARY * 12) 연봉
FROM EMPLOYEE E
LEFT /*OUTER*/ JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
ORDER BY DEPT_TITLE DESC;

-- 오라클 구문 
SELECT E.EMP_NAME 사원명,
       D.DEPT_TITLE 부서명,
       E.SALARY 급여,
       E.SALARY * 12 연봉
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID(+) -- 오른쪽 테이블 컬럼에 + 표시 
ORDER BY DEPT_TITLE DESC;

/*
    2) RIGHT [OUTER] JOIN
        두 테이블 중 오른편에 기술된 테이블의 컬럼을 기준으로 JOIN을 진행 
*/

-- ANSI 구문
SELECT E.EMP_NAME 사원명,
       D.DEPT_TITLE 부서명,
       E.SALARY 급여,
       (E.SALARY * 12) 연봉
FROM EMPLOYEE E
RIGHT /*OUTER*/ JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
ORDER BY DEPT_TITLE DESC;

SELECT *
FROM EMPLOYEE E
RIGHT /*OUTER*/ JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
ORDER BY DEPT_ID;


-- 오라클 구문 
SELECT E.EMP_NAME 사원명,
       D.DEPT_TITLE 부서명,
       E.SALARY 급여,
       E.SALARY * 12 연봉
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE(+) = D.DEPT_ID -- 왼쪽 테이블 컬럼에 + 표시 
ORDER BY DEPT_TITLE DESC;

/*
    3) FULL OUTER JOIN
        두 테이블이 가진 모든 행을 조회할 수 있다 (단, 오라클 구문은 지원하지 않는다)
*/
-- ANSI 구문
SELECT E.EMP_NAME 사원명,
       D.DEPT_TITLE 부서명,
       E.SALARY 급여,
       (E.SALARY * 12) 연봉
FROM EMPLOYEE E
FULL /*OUTER*/ JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
ORDER BY DEPT_TITLE DESC;

-- 오라클 구문 
SELECT E.EMP_NAME 사원명,
       D.DEPT_TITLE 부서명,
       E.SALARY 급여,
       E.SALARY * 12 연봉
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE(+) = D.DEPT_ID(+) -- 에러 발생 
ORDER BY DEPT_TITLE DESC;

/*
    3. CROSS JOIN
        조인되는 모든 테이블의 각 행들이 서로서로 모두 매팅된 데이터가 검색된다.
        두 테이블의 행들이 모두 곱해진 조합이 출력 -> 방대한 데이터 출력 -> 과부하의 위험
        ㄴ 실무에서 잘 사용하지 않는 쿼리문 
*/
-- ANSI 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT -- 23 * 9 = 207 행이 조회됨 
ORDER BY EMP_NAME;

-- 오라클 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
ORDER BY EMP_NAME;

/*
    4. 비등가 조인 = NON EQUAL JOIN
        조인 조건에 등호(=)를 사용하지 않는 조인을 NON EQUAL JOIN이라 한다
        > < >= <= BETWEEN AND, IS NULL, IS NOT NULL, IN, NOT IN 
        USING 구문 사용 불가 
*/
-- EMPLOYEE 테이블과 SAL_GRADE 테이블을 비등가 조인하여 직원명, 급여 ,급여 등급 조회 
-- ANSI 구문
SELECT E.EMP_NAME 직원명,
       E.SALARY 급여,
       S.SAL_LEVEL "급여 등급"
FROM EMPLOYEE E
/*LEFT*/JOIN SAL_GRADE S ON(SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);
--/*LEFT*/JOIN SAL_GRADE S ON(E.SALARY >= S.MIN_SAL AND E.SALARY <= S.MAX_SAL);

-- 오라클 구문 
SELECT E.EMP_NAME 직원명,
       E.SALARY 급여,
       S.SAL_LEVEL "급여 등급"
FROM EMPLOYEE E, SAL_GRADE S 
--WHERE SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL;
WHERE E.SALARY >= S.MIN_SAL AND E.SALARY <= S.MAX_SAL;

/*
    5. SELF JOIN = 자체 조인
        동일한 테이블을 조인하는 경우에 사용한다 (자기 자신과 조인한다)
*/
SELECT EMP_ID, EMP_NAME, MANAGER_ID
FROM EMPLOYEE;

-- EMPLOYEE 테이블을 SELF JOIN 하여 사번, 직원명, 부서 코드, 사수 사번, 사수명 조회
-- ANSI 구문
SELECT E.EMP_ID 사번,
       E.EMP_NAME 직원명,
       E.DEPT_CODE "부서 코드",
       E.MANAGER_ID "사수 사번",
       M.EMP_NAME 사수명
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M ON E.MANAGER_ID = M.EMP_ID;

-- 오라클 구문 
SELECT E.EMP_ID 사번,
       E.EMP_NAME 직원명,
       E.DEPT_CODE "부서 코드",
       E.MANAGER_ID "사수 사번",
       M.EMP_NAME 사수명
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID(+);

/*
    6. 다중 JOIN
        여러 개의 테이블을 조인하는 경우에 사용
*/
-- EMPLOYEE, DEPARTMENT, LOCATION 테이블을 다중 JOIN하여 사번, 직원명, 부서명, 지역명을 조회 
SELECT * FROM EMPLOYEE;   -- DEPT_CODE
SELECT * FROM DEPARTMENT; -- DEPT_ID      LOCATION_ID
SELECT * FROM LOCATION;   --              LOCAL_CODE

-- ANSI 구문 (다중 조인은 순서가 중요하다)
SELECT E.EMP_ID,
       E.EMP_NAME,
       D.DEPT_TITLE,
       L.LOCAL_NAME
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
LEFT JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
ORDER BY DEPT_TITLE DESC;
--WHERE L.LOCAL_NAME = 'ASIA1';

-- 오라클 구문 (순서 중요하지 않음)
SELECT E.EMP_ID,
       E.EMP_NAME,
       D.DEPT_TITLE,
       L.LOCAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE E.DEPT_CODE = D.DEPT_ID AND D.LOCATION_ID = L.LOCAL_CODE AND L.LOCAL_NAME = 'ASIA1';

--------------- 다중 조인 실습 문제 -------------------
-- 1. 사번, 직원명, 부서명, 지역명, 국가명 조회
-- ANSI 구문 
SELECT * FROM EMPLOYEE; -- DEPT_CODE
SELECT * FROM DEPARTMENT; -- DEPT_ID      LOCATION_ID
SELECT * FROM LOCATION; --                LOCAL_CODE         NATIONAL_CODE
SELECT * FROM NATIONAL; --                                   NATIONAL_CODE

SELECT E.EMP_ID 사번,
       E.EMP_NAME 직원명,
       D.DEPT_TITLE 부서명,
       L.LOCAL_NAME 지역명,
       N.NATIONAL_NAME 국가명
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
INNER JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
INNER JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE;

-- 오라클 구문 
SELECT E.EMP_ID 사번,
       E.EMP_NAME 직원명,
       D.DEPT_TITLE 부서명,
       L.LOCAL_NAME 지역명,   
       N.NATIONAL_NAME 국가명
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID AND D.LOCATION_ID = L.LOCAL_CODE AND L.NATIONAL_CODE = N.NATIONAL_CODE;

-- 2. 사번, 직원명, 부서명, 직급명, 지역명, 국가명, 급여 등급 조회
SELECT * FROM EMPLOYEE; -- DEPT_CODE
SELECT * FROM DEPARTMENT; -- DEPT_ID      LOCATION_ID
SELECT * FROM LOCATION; --                LOCAL_CODE         NATIONAL_CODE
SELECT * FROM NATIONAL; --                                   NATIONAL_CODE
-- ANSI 구문
SELECT E.EMP_ID 사번,
       E.EMP_NAME 직원명,
       D.DEPT_TITLE 부서명,
       J.JOB_NAME 직급명,
       L.LOCAL_NAME 지역명,
       N.NATIONAL_NAME 국가명,
       S.SAL_LEVEL "급여 등급"
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
--INNER JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
INNER JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
INNER JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE
INNER JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
INNER JOIN SAL_GRADE S ON (SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);

-- 오라클 구문 
SELECT E.EMP_ID 사번,
       E.EMP_NAME 직원명,
       D.DEPT_TITLE 부서명,
       J.JOB_NAME 직급명,
       L.LOCAL_NAME 지역명,
       N.NATIONAL_NAME 국가명,
       S.SAL_LEVEL "급여 등급"
FROM EMPLOYEE E, DEPARTMENT D, JOB J, LOCATION L, NATIONAL N, SAL_GRADE S
WHERE E.DEPT_CODE = D.DEPT_ID
AND E.JOB_CODE = J.JOB_CODE
AND D.LOCATION_ID = L.LOCAL_CODE
AND L.NATIONAL_CODE = N.NATIONAL_CODE
AND (SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);


--------------- 종합 실습 문제 --------------------------
-- 1. 직급이 대리이면서 ASIA 지역에서 근무하는 직원들의 사번, 직원명, 직급명, 근무지역, 급여를 조회
SELECT * FROM EMPLOYEE; -- JOB_CODE
SELECT * FROM JOB; -- JOB_CODE
SELECT * FROM DEPARTMENT; -- LOCATION_ID
SELECT * FROM LOCATION; -- LOCAL_CODE
-- ANSI 구문 
SELECT E.EMP_ID 사번,
       E.EMP_NAME 직원명,
       J.JOB_NAME 직급명,
       L.LOCAL_NAME 근무지역,
       TO_CHAR(E.SALARY, 'FM999,999,999') 급여
FROM EMPLOYEE E
INNER JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
INNER JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
INNER JOIN LOCATION L ON D.LOCATION_ID = LOCAL_CODE
-- 내 풀이 
--WHERE J.JOB_NAME = '대리' AND (L.LOCAL_CODE = 'L1' OR L.LOCAL_CODE = 'L2' OR L.LOCAL_CODE = 'L3');
-- 쌤 풀이 
--WHERE J.JOB_NAME = '대리' AND L.LOCAL_NAME LIKE 'ASIA%';
-- 노경님 
WHERE J.JOB_NAME = '대리' AND SUBSTR(L.LOCAL_NAME, 1, 4) = 'ASIA';

-- 오라클 구문 
SELECT E.EMP_ID 사번,
       E.EMP_NAME 직원명,
       L.LOCAL_NAME 근무지역,
       E.SALARY 급여
FROM EMPLOYEE E, JOB J, DEPARTMENT D, LOCATION L
WHERE E.JOB_CODE = J.JOB_CODE 
AND E.DEPT_CODE = D.DEPT_ID
AND D.LOCATION_ID = L.LOCAL_CODE
AND J.JOB_NAME = '대리'
AND L.LOCAL_NAME LIKE 'ASIA%';

-- 2. 70년대 생이면서 여자이고, 성이 전씨인 직원들의 직원명, 주민번호, 부서명을 조회 
SELECT * FROM EMPLOYEE;
-- ANSI 구문
SELECT E.EMP_NAME 직원명,
       E.EMP_NO 주민번호,
       D.DEPT_TITLE 부서명
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
-- 내 풀이 (SUBSTR 사용)
--WHERE SUBSTR(E.EMP_NO, 1, 1) = 7
-- 쌤 풀이 (LIKE 사용)
WHERE E.EMP_NO LIKE '7%'
AND SUBSTR(E.EMP_NO, 8, 1) = 2
AND E.EMP_NAME LIKE '전%';

-- 오라클 구문 
SELECT E.EMP_NAME 직원명,
       E.EMP_NO 주민번호,
       D.DEPT_TITLE 부서명
FROM EMPLOYEE E, DEPARTMENT D 
WHERE E.DEPT_CODE = D.DEPT_ID
AND SUBSTR(E.EMP_NO, 1, 1) = 7
AND SUBSTR(E.EMP_NO, 8, 1) = 2
AND E.EMP_NAME LIKE '전%';

-- 3. 보너스를 받는 직원들의 직원명, 보너스, 연봉, 부서명, 근무 지역을 조회 
-- ANSI 구문
SELECT E.EMP_NAME 직원명,
       E.BONUS 보너스,
       TO_CHAR(E.SALARY * 12, 'FM99,999,999') 연봉,
       D.DEPT_TITLE 부서명,
       L.LOCAL_NAME "근무 지역"
FROM EMPLOYEE E
LEFT OUTER JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
LEFT OUTER JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
WHERE E.BONUS IS NOT NULL;

-- 오라클 구문 
SELECT E.EMP_NAME 직원명,
       E.BONUS 보너스,
       E.SALARY * 12 연봉,
       D.DEPT_TITLE 부서명,
       L.LOCAL_NAME "근무 지역"
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE E.DEPT_CODE = D.DEPT_ID(+)
AND D.LOCATION_ID = L.LOCAL_CODE(+)
AND E.BONUS IS NOT NULL;

-- 4. 한국과 일본에서 근무하는 직원들의 직원명, 부서명, 근무 지역, 근무 국가를 조회
-- ANSI 구문
SELECT E.EMP_NAME 직원명,
       D.DEPT_TITLE 부서명,
       L.LOCAL_NAME "근무 지역",
       N.NATIONAL_NAME "근무 국가"
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE
--WHERE L.LOCAL_CODE = 'L1' OR L.LOCAL_CODE = 'L2';
WHERE N.NATIONAL_NAME IN ('한국', '일본')
ORDER BY N.NATIONAL_NAME DESC;

-- 오라클 구문
SELECT E.EMP_NAME 직원명,
       D.DEPT_TITLE 부서명,
       L.LOCAL_NAME "근무 지역",
       N.NATIONAL_NAME "근무 국가"
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID
AND D.LOCATION_ID = L.LOCAL_CODE
AND L.NATIONAL_CODE = N.NATIONAL_CODE
AND (L.LOCAL_CODE = 'L1' OR L.LOCAL_CODE = 'L2');

-- 5. 각 부서별 평균 급여를 조회하여 부서명, 평균 급여를 조회 (정수처리) (단, 부서 배치가 안된 사원들의 평균도 출력)
-- ANSI 구문
SELECT NVL(D.DEPT_TITLE, '부서 없음') 부서명,
       TO_CHAR(FLOOR(AVG(NVL(E.SALARY, 0))), 'FM999,999,999') 급여
FROM EMPLOYEE E
LEFT OUTER JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
GROUP BY D.DEPT_TITLE
ORDER BY D.DEPT_TITLE;

-- 오라클 구문
SELECT D.DEPT_TITLE 부서명,
       TO_CHAR(FLOOR(AVG(NVL(E.SALARY, 0))), 'FM999,999,999') 급여
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID(+)
GROUP BY D.DEPT_TITLE;

-- 6. 각 부서별 총 급여의 합이 1000만원 이상인 부서명, 급여의 합을 조회 
-- ANSI 구문 
SELECT D.DEPT_TITLE 부서명,
       TO_CHAR(SUM(E.SALARY), 'FM999,999,999') "급여의 합"
FROM EMPLOYEE E
LEFT OUTER JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
GROUP BY D.DEPT_TITLE
HAVING SUM(E.SALARY) >= 10000000;

-- 오라클 구문 
SELECT D.DEPT_TITLE 부서명,
       TO_CHAR(SUM(E.SALARY), 'FM999,999,999') "급여의 합"
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID
GROUP BY D.DEPT_TITLE
HAVING SUM(E.SALARY) >= 10000000;

-- 7. 사번, 직원명, 직급명, 급여 등급, 구분을 조회 
-- 이때 구분에 해당하는 값은 아래와 같이 조회되도록 하시오
-- 급여 등급이 S1, S2인 경우 '고급' 
-- 급여 등급이 S3, S4인 경우 '중급'
-- 급여 등급이 S5, S6인 경우 '초급'
-- ANSI 구문
SELECT E.EMP_ID 사번,
       E.EMP_NAME 직원명,
       J.JOB_NAME 직급명,
       S.SAL_LEVEL "급여 등급",
       CASE WHEN S.SAL_LEVEL = 'S1' OR S.SAL_LEVEL = 'S2' THEN '고급'
            WHEN S.SAL_LEVEL = 'S3' OR S.SAL_LEVEL = 'S4' THEN '중급'
            ELSE '초급'
       END AS "구분"
FROM EMPLOYEE E
INNER JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
LEFT OUTER JOIN SAL_GRADE S ON (E.SALARY BETWEEN MIN_SAL AND MAX_SAL)
ORDER BY 4;

-- 오라클 구문
SELECT E.EMP_ID 사번,
       E.EMP_NAME 직원명,
       J.JOB_NAME 직급명,
       S.SAL_LEVEL "급여 등급",
       CASE WHEN S.SAL_LEVEL = 'S1' OR S.SAL_LEVEL = 'S2' THEN '고급'
            WHEN S.SAL_LEVEL = 'S3' OR S.SAL_LEVEL = 'S4' THEN '중급'
            ELSE '초급'
       END AS "구분"
FROM EMPLOYEE E, JOB J, SAL_GRADE S
WHERE E.JOB_CODE = J.JOB_CODE
AND E.SALARY BETWEEN MIN_SAL AND MAX_SAL;

-- 8. 보너스를 받지 않는 직원들 중 직급 코드가 J4 또는 J7인 직원들의 직원명, 직급명, 급여를 조회
-- ANSI 구문 
SELECT E.EMP_NAME 직원명,
       J.JOB_NAME 직급명,
       TO_CHAR(E.SALARY, 'FM999,999,999') 급여
FROM EMPLOYEE E
INNER JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE E.BONUS IS NULL
--AND (J.JOB_CODE = 'J4' OR J.JOB_CODE = 'J7');
AND J.JOB_CODE IN ('J4', 'J7');

-- 오라클 구문 
SELECT E.EMP_NAME 직원명,
       J.JOB_NAME 직급명,
       TO_CHAR(E.SALARY, 'FM999,999,999') 급여
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND E.BONUS IS NULL
AND (J.JOB_CODE = 'J4' OR J.JOB_CODE = 'J7');


-- 9. 해외 영업팀에 근무하는 직원들의 직원명, 직급명, 부서 코드, 부서명을 조회
-- ANSI 구문
SELECT E.EMP_NAME 직원명,
       J.JOB_NAME 직급명,
       D.DEPT_ID "부서 코드",
       D.DEPT_TITLE 부서명
FROM EMPLOYEE E
INNER JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
INNER JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
WHERE DEPT_TITLE LIKE '해외영업%'
--ORDER BY DEPT_TITLE;
ORDER BY 4;


-- 오라클 구문 
SELECT E.EMP_NAME 직원명,
       J.JOB_NAME 직급명,
       D.DEPT_ID "부서 코드",
       D.DEPT_TITLE 부서명
FROM EMPLOYEE E, JOB J, DEPARTMENT D
WHERE E.JOB_CODE = J.JOB_CODE
AND E.DEPT_CODE = D.DEPT_ID
AND DEPT_TITLE LIKE '해외영업%'
ORDER BY DEPT_TITLE;


-- 10. 이름에 '형'자가 들어가는 직원들의 사번, 직원명, 직급명을 조회 
-- ANSI 구문 
SELECT E.EMP_ID 사번,
       E.EMP_NAME 직원명,
       J.JOB_NAME 직급명
FROM EMPLOYEE E
INNER JOIN JOB J USING(JOB_CODE)
WHERE E.EMP_NAME LIKE '%형%';

-- 오라클 구문
SELECT E.EMP_ID 사번,
       E.EMP_NAME 직원명,
       J.JOB_NAME 직급명
FROM EMPLOYEE E, JOB J 
WHERE E.JOB_CODE = J.JOB_CODE
AND E.EMP_NAME LIKE '%형%';

