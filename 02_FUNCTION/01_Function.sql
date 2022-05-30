/*
    <문자 관련 함수>
    
    1) LENGTH . LENGTHB
        LENGTH ('문자값') : 글자 수 반환
        LENGTHB ('문자값') : 글자의 바이트 수 반환 
        
        한글 한 글자 -> 3 BYTE
        영문자, 숫자, 특수문자 한 글자 -> 1 BYTE
*/

SELECT LENGTH('오라클'), 
       LENGTHB('오라클') -- 3 / 9
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME),
       EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE;

/*
    2) INSTR
        INSTR('문자값', '문자값'[, POSITION, OCCURRENCE])
*/
SELECT INSTR('AABAACAABBAA', 'B') FROM DUAL; -- 3
SELECT INSTR('AABAACAABBAA', 'B', 1) FROM DUAL; -- 3
SELECT INSTR('AABAACAABBAA', 'B', -1) FROM DUAL; -- 10
SELECT INSTR('AABAACAABBAA', 'B', 1, 2) FROM DUAL; -- 9
--SELECT INSTR('AABAACAABBAA', 'B', 1, -1) FROM DUAL; -- 음수 사용 불가 
SELECT INSTR('AABAACAABBAA', 'B', -1, 3) FROM DUAL; -- 3

-- EMPLOYEE 테이블의 EMAIL에 @ 위치 조회 
SELECT EMAIL AS "이메일", INSTR(EMAIL, '@') AS "@위치"
FROM EMPLOYEE;


/*
    3) LPAD / RPAD
        LPAD/RPAD('문자값', 최종적으로 반환할 문자의 길이(BYTE)[, 덧붙이고자 하는 문자])
*/

SELECT LPAD('Hello', 10, 'A') -- AAAAAHello
FROM DUAL;

SELECT RPAD('Hello', 10, 'A') -- HelloAAAAA
FROM DUAL;

-- 20만큼의 길이 중 EMAIL 값이 오른쪽으로 정렬하고 공백을 왼쪽으로 채운다.
SELECT LPAD(EMAIL, 20)
FROM EMPLOYEE;

SELECT LPAD(EMAIL, 10)
FROM EMPLOYEE;

SELECT LPAD(EMAIL, 3)
FROM EMPLOYEE;

-- 20만큼의 길이 중 EMAIL 값은 왼쪽으로 정렬하고 #을 오른쪽으로 채운다
SELECT RPAD(EMAIL, 20, '#')
FROM EMPLOYEE;

-- 220429-3****** 를 출력 
SELECT RPAD('220429-3', 14, '*')
FROM DUAL;

-- EMPLOYEE 주민번호 성별 코드 이후 * 표시
--SELECT RPAD(EMP_NUM, 14, '*')
--FROM EMPLOYEE;


/*
    4) LTRIM / RTRIM
        LTRIM/RTRIM('문자값'[, 제거하고자 하는 문자값])
*/
SELECT LTRIM('   KH') FROM DUAL;
SELECT LTRIM('000123456', '0') FROM DUAL; -- 123456
SELECT LTRIM('123123KH', '123') FROM DUAL; -- KH
SELECT LTRIM('123123KH', '213') FROM DUAL; -- KH
SELECT LTRIM('123123KH123', '123') FROM DUAL; -- KH123

SELECT RTRIM('KH    ') FROM DUAL;
SELECT RTRIM('KH    ', ' ') FROM DUAL;
SELECT RTRIM('00123000456000', '0') FROM DUAL; -- 0012300456

SELECT LTRIM(RTRIM('00123000456000', '0'), '0') FROM DUAL; -- 123000456

/*
    5) TRIM
        TRIM([[LEADING | TRAILING | BOTH] '제거하고자 하는 문자값' FROM] '문자값')
        // 문자열은 넘겨줄수 없다!
        
        문자값 앞/뒤/양쪽에 있는 지정한 문자를 제거한 나머지를 반환한다.
*/

-- 기본적으로 양쪽에 있는 공백 문자를 제거한다.
SELECT TRIM('   KH   ') FROM DUAL; -- 앞 뒤 공백 제거됨 
SELECT TRIM(' ' FROM '   KH   ') FROM DUAL; -- KH
SELECT TRIM('Z' FROM 'ZZZKHZZZ') FROM DUAL; -- KH
SELECT TRIM(BOTH 'Z' FROM 'ZZZKHZZZ') FROM DUAL; -- KH
SELECT TRIM(LEADING'Z' FROM 'ZZZKHZZZ') FROM DUAL; -- KHZZZ
SELECT TRIM(TRAILING'Z' FROM 'ZZZKHZZZ') FROM DUAL; -- ZZZKH

/*
    6) SUBSTR
        SUBSTR('문자값', POSTION[, LENGTH])
*/

SELECT SUBSTR('SHOWMETHEMONEY', 7) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 7, 3) FROM DUAL; -- 왼쪽에서부터 찾기 
SELECT SUBSTR('SHOWMETHEMONEY', -8, 3) FROM DUAL; -- 오른쪽에서부터 찾기 
SELECT SUBSTR('쇼우 미 더 머니', 2, 5) FROM DUAL; -- 한글도 가능!

-- EMPLOYEE 테이블에서 주민등록번호에 성별을 나타내는 부분만 잘라서 조회하기 (직원명, 성별 코드)
SELECT EMP_NAME 직원명, SUBSTR(EMP_NO, 8, 1) "성별 코드"
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 여자 사원의 직원명, 성별 코드 조회
SELECT EMP_NAME 직원명, 
       SUBSTR(EMP_NO, 8, 1) "성별 코드"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8 , 1) = '2';

-- EMPLOYEE 테이블에서 남자 사원의 직원명, 성별 조회 
SELECT EMP_NAME 직원명, 
       '남자' AS "성별 코드" -- 리터럴 
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8 , 1) = '1';

-- EMPLOYEE 테이블에서 주민등록번호 첫 번째 자리부터 성별까지 추출한 결과값에 오른쪽에 *문자를 채워서 출력
-- ex) 991212-1******
SELECT RPAD(SUBSTR('991212-1222222', 1, 8), 14, '*')
FROM DUAL;

SELECT EMP_NAME 직원명, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*') "주민등록번호"
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 직원명, 이메일, 아이디(이메일 @ 앞의 문자 값만 출력)를 조회
SELECT INSTR('sun_di@kh.or.kr', '@')
FROM DUAL;

SELECT SUBSTR('sun_di@kh.or.kr', 1, INSTR('sun_di@kh.or.kr', '@') -1)
FROM DUAL;

-- 내 풀이 
SELECT EMP_NAME 직원명, EMAIL 이메일, RTRIM(EMAIL, '@kh.or.kr') 아이디
FROM EMPLOYEE;

-- 쌤 풀이
SELECT EMP_NAME 직원명, 
       EMAIL 이메일,  
       SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') -1) 아이디
--       SUBSTR(EMAIL, 1, LENGTH(EMAIL) -9)
--       LPAD(EMAIL, INSTR(EMAIL, '@') -1) 아이디
FROM EMPLOYEE;

/*
    7) LOWER / UPPER / INITCAP
        LOWER/UPPER/INITCAP('문자값')
*/

SELECT 'welcome to mara world' FROM DUAL;
SELECT LOWER('WELCOME TO MARA WORLD') FROM DUAL; -- welcome to mara world
SELECT UPPER('welcome to mara world') FROM DUAL; -- WELCOME TO MARA WORLD
SELECT INITCAP('welcome to mara world') FROM DUAL; -- Welcome To Mara World

/*
    8) CONCAT
        CONCAT('문자값', '문자값')
*/

SELECT CONCAT('가나다라', 'ABCD') FROM DUAL;
SELECT '가나다라' || 'ABCD' FROM DUAL; -- 연결 연산자와 동일한 결과를 출력한다

SELECT CONCAT('가나다라', 'ABCD', 'EFG') FROM DUAL; -- 에러발생 2개의 문자값만 받을 수 있다.
SELECT '가나다라' || 'ABCD' || 'EFG' FROM DUAL;

SELECT CONCAT(EMP_ID, EMP_NAME)
FROM EMPLOYEE;

SELECT EMP_ID || EMP_NAME || EMP_NO
FROM EMPLOYEE;

/*
    9) REPLACE
        REPLACE('문자값', '변경하려고 하는 문자값', '변경할 문자값')
*/

SELECT REPLACE('서울시 강남구 역삼동', '역삼동', '삼성동')
FROM DUAL;

-- EMPLOYEE 테이블에서 이메일의 kh.or.kr을 gmail.com으로 변경해서 조회
SELECT EMP_NAME,
       EMAIL,
       REPLACE(EMAIL, 'kh.or.kr', 'gmail.com')
FROM EMPLOYEE;

/*
    <숫자 처리 함수>
    
    1) ABS
        ABS(NUMBER)
        - 숫자의 절대값을 넘겨주는 함수 
*/
SELECT ABS(10.9) FROM DUAL; -- 10.9
SELECT ABS(-10.9) FROM DUAL; -- 10.9

/*
    2) MOD
        MOD(NUMBER, NUMBER(나눌값))
        - 나머지를 반환해주는 함수 
        - JAVA의 % 연산자와 동일 
    
*/
-- SELECT 10% 3 FROM DUAL; -- 에러 뜸 
SELECT MOD(10, 3) FROM DUAL; -- 1
SELECT MOD(-10, 3) FROM DUAL; -- -1
SELECT MOD(10, -3) FROM DUAL; -- 1
SELECT MOD(10.9, 3) FROM DUAL; -- 1.9

/*
    3) ROUND
        ROUND(NUMBER [, POSITION])
        POSITION : 기본적으로 0, 양수(소수점 기준으로 오른쪽)와 음수(소수점 기준으로 왼쪽)로 입력이 가능 
*/
SELECT ROUND(123.456) FROM DUAL; -- 123
SELECT ROUND(123.656, 2) FROM DUAL; -- 124
SELECT ROUND(-10.65) FROM DUAL; -- -11
SELECT ROUND(123.456, 1) FROM DUAL; -- 123.5 
SELECT ROUND(123.456, 2) FROM DUAL; -- 123.46
SELECT ROUND(123.456, 4) FROM DUAL; -- 123.456
SELECT ROUND(123.456, -1) FROM DUAL; -- 120
SELECT ROUND(123.456, -3) FROM DUAL; -- 0

/*
    4) CEIL
        CEIL(NUMBER)
        - 올림 함수 
*/
SELECT CEIL(123.456) FROM DUAL; -- 124

/*
    5) FLOOR
        FLOOR(NUMBER)
        - 버림 함수 
*/
SELECT FLOOR(123.456) FROM DUAL; -- 123

/*
    5) TRUNC
        TRUNC(NUMBER[, POSITION])
        - 주어진 숫자에서 지정한 위치부터 버림하여 값을 반환한다.
*/
SELECT TRUNC(123.456) FROM DUAL;
SELECT TRUNC(456.789, 1) FROM DUAL; -- 456.7
SELECT TRUNC(456.789, -1) FROM DUAL; -- 450

/*
    4) CEIL
        CEIL(NUMBER)
        - 올림 함수 
*/
SELECT CEIL(123.456) FROM DUAL; -- 124

/*
    5) FLOOR
        FLOOR(NUMBER)
        - 버림 함수 
*/
SELECT FLOOR(123.456) FROM DUAL; -- 123

/*
    5) TRUNC
        TRUNC(NUMBER[, POSITION])
        - 주어진 숫자에서 지정한 위치부터 버림하여 값을 반환한다.
*/
SELECT TRUNC(123.456) FROM DUAL;
SELECT TRUNC(456.789, 1) FROM DUAL; -- 456.7
SELECT TRUNC(456.789, -1) FROM DUAL; -- 450

/*
    <날짜 처리 함수>
    1) SYSDATE
*/
SELECT SYSDATE FROM DUAL; -- 22/05/02

-- 날짜 포맷 변경 
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH:MI:SS';
SELECT SYSDATE FROM DUAL; -- 2022-05-02 09:46:58

ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';
SELECT SYSDATE FROM DUAL; -- 22/05/02

/*
    2) MONTHS_BETWEEN
        MONTHS_BETWEEN(DATE, DATE)
*/
SELECT FLOOR(MONTHS_BETWEEN(SYSDATE, '20210525')) FROM DUAL;

-- EMPLOYEE 테이블에서 직원명, 입사일, 근무개월수 조회
SELECT EMP_NAME 직원명,
       HIRE_DATE 입사일,
       FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) 근무개월수
FROM EMPLOYEE;

/*
    3) ADD_MONTHS
        ADD_MONTHS(DATE, NUMBER)
*/
SELECT ADD_MONTHS(SYSDATE, 12) FROM DUAL;

-- EMPLOYEE 테이블에서 직원명, 입사일, 입사 후 6개월이 된 날짜를 조회 
SELECT EMP_NAME 직원명,
       HIRE_DATE 입사일,
       ADD_MONTHS(HIRE_DATE, 6) AS "입사일 + 6개월"
FROM EMPLOYEE;

/*
    4) NEXT_DAY
        NEXT_DAY(DATE, 요일(문자, 숫자))    
*/

-- 현재 날짜에서 제일 가까운 일요일 조회 
SELECT SYSDATE, NEXT_DAY(SYSDATE, '일요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 1) FROM DUAL; -- 1: 일요일, 2: 월요일, ... 7: 토요일 
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'SUNDAY') FROM DUAL; -- 에러 발생 (오라클 시스템 언어가 KOREAN이라서 에러 남)

ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'MONDAY') FROM DUAL; 
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'MON') FROM DUAL; 
SELECT SYSDATE, NEXT_DAY(SYSDATE, 2) FROM DUAL; 

ALTER SESSION SET NLS_LANGUAGE = KOREAN;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '일요일') FROM DUAL;

/*
    5) LAST_DAY
        LAST_DAY(DATE)    
*/
SELECT LAST_DAY(SYSDATE) FROM DUAL;
SELECT LAST_DAY('20210810') FROM DUAL;

-- EMPLOYEE 테이블에서 직원명, 입사일, 입사월의 마지막 날짜 조회 
SELECT EMP_NAME,
       HIRE_DATE,
       LAST_DAY(HIRE_DATE)
FROM EMPLOYEE;

/*
    6) EXTRACT
        EXTRACT(YEAR|MONTH|DAY FROM DATE)
*/
-- EMPLOYEE 테이블에서 직원명, 입사년도, 입사월, 입사일 조회 
SELECT EMP_NAME AS 직원명,
       EXTRACT(YEAR FROM HIRE_DATE) AS 입사년도,
       EXTRACT(MONTH FROM HIRE_DATE) AS  입사월,
       EXTRACT(DAY FROM HIRE_DATE) AS 입사일
FROM EMPLOYEE
--ORDER BY EXTRACT(YEAR FROM HIRE_DATE);
--ORDER BY "입사년도" DESC, "입사월";
ORDER BY 2, 3, 4;

/*
    <형 변환 함수>
    
    1) TO_CHAR(날짜|숫자[, 포맷])
*/

-- 숫자 -> 문자 
SELECT TO_CHAR(1234) FROM DUAL;
SELECT TO_CHAR(1234, '999999') FROM DUAL; -- 6칸의 공간을 확보, 오른쪽으로 정렬, 빈칸은 공백으로 채움 
SELECT TO_CHAR(1234, '000000') FROM DUAL; -- 6칸의 공간을 확보, 오른쪽으로 정렬, 빈칸은 0으로 채움 
SELECT TO_CHAR(1234, 'L999999') FROM DUAL; -- ￦1234 현재 설정된 나라의 화폐 단위 
SELECT TO_CHAR(1234, 'L999,999') FROM DUAL; -- ￦1,234 자리수 구분 

-- EMPLOYEE 테이블에서 직원명, 급여 조회 
SELECT EMP_NAME 직원명,
       TO_CHAR(SALARY, '99,999,999') 급여
FROM EMPLOYEE;

-- 날짜 -> 문자 
SELECT TO_CHAR(SYSDATE) FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'AM HH24:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'DAY') FROM DUAL; -- 월요일
SELECT TO_CHAR(SYSDATE, 'DY') FROM DUAL; -- 월 
SELECT TO_CHAR(SYSDATE, 'MONTH') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MON') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD(DY)') FROM DUAL;

-- EMPLOYEE 테이블에서 직원명, 입사일(2022-05-02)
SELECT EMP_NAME 직원병,
       TO_CHAR(HIRE_DATE, 'YYYY"년"MM"월"DD"일"') 입사일
FROM EMPLOYEE;

-- 날짜 포맷 변경 
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH:MI:SS';
ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';

-- 연도 포맷 문자
-- YY는 무조건 현재 세기를 반영하고, RR은 50 미만이면 현재 세기를 반영, 50 이상이면 이전 세기를 반영한다.
SELECT TO_CHAR(SYSDATE, 'YYYY'),
       TO_CHAR(SYSDATE, 'RRRR'),
       TO_CHAR(SYSDATE, 'YY'),
       TO_CHAR(SYSDATE, 'RR'),
       TO_CHAR(SYSDATE, 'YEAR') -- TWENTY TWENTY-TWO
FROM DUAL;

-- 월에 대한 포맷 
SELECT HIRE_DATE,
       TO_CHAR(HIRE_DATE, 'MM'),
       TO_CHAR(HIRE_DATE, 'MON'),
       TO_CHAR(HIRE_DATE, 'RM') -- 로마 기호로 표시 
FROM EMPLOYEE;

-- 일에 대한 포맷
SELECT HIRE_DATE,
       TO_CHAR(HIRE_DATE, 'DY'),
       TO_CHAR(HIRE_DATE, 'D'), -- 1주를 기준으로 며칠째 
       TO_CHAR(HIRE_DATE, 'DD'), -- 1달을 기준으로 며칠째인지 
       TO_CHAR(HIRE_DATE, 'DDD') -- 해당하는 년도를 기준으로 며칠째인지 
FROM EMPLOYEE;

-- 요일에 대한 포맷
SELECT HIRE_DATE,
       TO_CHAR(HIRE_DATE, 'DAY'),
       TO_CHAR(HIRE_DATE, 'DY')
FROM EMPLOYEE;

-- 실습 과제 --
-- EMPLOYEE 테이블에서 직원명, 입사일(2022-05-02 (화)) 조회
SELECT EMP_NAME 직원명,
       TO_CHAR(HIRE_DATE, 'YYYY-MM-DD(DY)') 입사일
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 직원명, 입사일(2022년 05월 02일 (화요일)) 조회
SELECT EMP_NAME 직원명,
       TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일"(DAY)') 입사일
FROM EMPLOYEE;

/*
    2) TO_DATE
        TO_DATE(숫자|문자[, 포맷])    
*/

-- 숫자 -> 날짜
SELECT TO_DATE(20201212) FROM DUAL;
SELECT TO_DATE(20201212122530) FROM DUAL;

-- 문자 -> 날짜
SELECT TO_DATE('20201212') FROM DUAL;
SELECT TO_DATE('20201212 122530') FROM DUAL; -- 2020-12-12 12:25:30
SELECT TO_DATE('20201212 222530', 'YYYYMMDD HH24MISS') FROM DUAL; -- 2020-12-12 10:25:30

-- YY와 RR 비교 
-- YY는 무조건 현재 세기를 반영하고, RR은 50 미만이면 현재 세기를 반영, 50 이상이면 이전 세기를 반영한다.
SELECT TO_DATE('220502', 'YYMMDD') FROM DUAL;
SELECT TO_DATE('980502', 'YYMMDD') FROM DUAL; -- 2098-05-02 12:00:00
SELECT TO_DATE('220502', 'RRMMDD') FROM DUAL;
SELECT TO_DATE('980502', 'RRMMDD') FROM DUAL; -- 1998-05-02 12:00:00

-- EMPLOYEE 테이블에서 1998년 1월 1일 이후에 입사한 사원의 사번, 직원명, 입사일 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
--WHERE HIRE_DATE > '19980101'
WHERE HIRE_DATE > TO_DATE('980101', 'RRMMDD')
--WHERE HIRE_DATE > TO_DATE('19980101', 'YYYYMMDD')
--WHERE HIRE_DATE > TO_DATE('19980101', 'RRRRMMDD')
ORDER BY HIRE_DATE;

-- 날짜 포맷 변경 
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH:MI:SS';
ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';

/*
    3) TO_NUMBER
        TO_NUMBER('문자값'[, 포맷])    
*/
SELECT TO_NUMBER('012345678') FROM DUAL;

SELECT '123' + '456' FROM DUAL; -- 자동으로 숫자 타입으로 형 변환 뒤에 연산처리를 한다.
SELECT '123' + '456A' FROM DUAL; -- 에러 발생
SELECT '10,000,000' + '500,000' FROM DUAL; -- 에러 발생

SELECT TO_NUMBER('10,000,000', '999,999,999') + TO_NUMBER('500,000', '9,999,999') FROM DUAL; 

SELECT *
FROM EMPLOYEE
WHERE EMP_ID >= 210;

/*
    <NULL 처리 함수>
    
    1) NVL
        NVL(값 1, 값 2)
        - 값1이 NULL이 아니면 값1을 반환하고 값이 NULL이면 값 2를 반환한다,
    
    2) NVL2
        NVL2(값 1, 값 2, 값 3)
        - 값1이 NULL이 아니면 값2를 반환하고 값이 NULL이면 값 3을 반환한다.
    
    3) NULLIF
        NULIF(값 1, 값 2)
        - 두개의 값이 동일하면 NULL을 반환하고, 두 개의 값이 동일하지 않으면 값 1을 반환한다.
        - 실무에서 자주 쓰이지 않음 
*/

-- EMPLOYEE 테이블에서 직원명, 보너스, 보너스가 포함된 연봉 조회
SELECT EMP_NAME 직원명,
       NVL(BONUS, 0), 
       SALARY + (SALARY * NVL(BONUS, 0)) * 12 "보너스가 포함된 연봉"
FROM EMPLOYEE;

-- EMPLOYEE 테이블에 직원명, 부서 코드를 조회
SELECT EMP_NAME 직원명,
       NVL(DEPT_CODE, '부서없음') 부서
FROM EMPLOYEE
ORDER BY DEPT_CODE DESC;

-- EMPLOYEE 테이블에서 보너스를 0.1로 동결하여 직원명, 보너스율, 동결된 보너스율, 보너스가 포함된 연봉 조회
SELECT EMP_NAME AS "직원명",
       NVL(BONUS, 0) AS "보너스율",
       NVL2(BONUS, 0.1, 0) AS "동결된 보너스율",
       SALARY + (SALARY * NVL2(BONUS, 0.1, 0)) * 12 "연봉"
FROM EMPLOYEE;

SELECT NULLIF('123', '123') FROM DUAL; -- null
SELECT NULLIF('123', '456') FROM DUAL; -- 123

SELECT NULLIF(123, 123) FROM DUAL; -- null
SELECT NULLIF(123, 456) FROM DUAL; -- 123

/*
    <선택 함수>
    
    1) DECODE
        DECODE(값, 조건 1, 결과값 1, 조건 2, 결과값2, ..., 결과값 N)
*/

-- EMPLOYEE 테이블에서 사번, 직원명, 주민번호, 성별(남자, 여자)
SELECT EMP_ID "사번",
       EMP_NAME "직원명",
       EMP_NO "주민번호",
--       SUBSTR(EMP_NO, 8, 1) "성별 코드",
       DECODE(SUBSTR(EMP_NO,8,1), 1, '남자', 2, '여자', '잘못된 주민번호입니다.') "성별"
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 직원명, 직급 코드, 기존급여, 인상된 급여를 조회
-- 직급 코드 J7인 직원은 급여를 10% 인상
-- 직급 코드가 J6인 직원은 급여를 15% 인상
-- 직급 보드가 J5인 직원은 급여를 20% 인상
-- 그 외 직급의 직원은 급여를 5% 인상 
SELECT EMP_NAME "직원명",
       JOB_CODE "직급 코드",
       SALARY "기존 급여",
       DECODE(JOB_CODE, 'J7', '10%', 'J6', '15%', 'J5' , '20%', '5%') "인상률",
       DECODE(JOB_CODE, 'J7', SALARY * 1.1, 'J6', SALARY * 1.15, 'J5', SALARY * 1.2, SALARY * 1.05) "인상된 급여"
FROM EMPLOYEE
ORDER BY JOB_CODE DESC;

/*
    2) CASE
         CASE WHEN 조건식 1 THEN 결과값 1
              WHEN 조건식 2 THEN 결과값 2
              WHEN 조건식 3 THEN 결과값 3
              ...
         END 결과값
*/

-- EMPLOYEE 테이블에서 사번, 직원명, 주민번호, 성별(남자, 여자)
SELECT EMP_ID "사번",
       EMP_NAME "직원명",
       EMP_NO "주민번호",
       CASE WHEN SUBSTR(EMP_NO, 8, 1) = '1' THEN '남자'
            WHEN SUBSTR(EMP_NO, 8, 1) = '2' THEN '여자'
            ELSE '잘못된 주민번호입니다.'
       END AS "성별"
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 직원명, 급여, 급여 등급 (1 ~4등급) 조회
-- SALARY 값이 500만원 초과일 경우 1등급
-- SALARY 값이 500만원 이하 350만원 초과일 경우 2등급
-- SALARY 값이 350만원 이하 200마원 초과일 경우 3등급
-- 그외 4등급 
SELECT EMP_NAME "직원명",
       TO_CHAR (SALARY, 'FM9,999,999') "급여",
       CASE WHEN SALARY > 5000000 THEN '1등급'
--            WHEN SALARY > 3500000 AND SALARY <= 5000000 THEN '2등급'
--            WHEN SALARY > 2000000 AND SALARY <= 3500000 THEN '3등급'
            WHEN SALARY > 3500000 THEN '2등급'
            WHEN SALARY > 2000000  THEN '3등급'            
            ELSE '4등급'
       END AS "급여 등급"
FROM EMPLOYEE
ORDER BY SALARY DESC;

/*
    <그룹 함수>
        대량의 데이터들로 집계나 통계 같은 작업을 처리해야하는 경우 사용되는 함수들이다.
        모든 그룹 함수는 NULL 값을 자동으로 제외하고 값이 있는 것들만 계산을 한다.
    
    1) SUM
        SUM(NUMBER 타입의 컬럼)
        제시된 컬럼의 값들의 합계를 반환한다.
*/

-- EMPLOYEE 테이블에서 전사원의 총 급여의 합계를 조회
SELECT TO_CHAR (SUM(SALARY), 'FML999,999,999') "총 급여"
FROM EMPLOYEE;

-- 부서 별 총 급여의 합계를 조회
SELECT DEPT_CODE, SALARY
FROM EMPLOYEE
ORDER BY DEPT_CODE;

------------- 실습 문제 -------------
-- EMPLOYEE 테이블에서 남자 사원의 총 급여의 합계를 조회
SELECT TO_CHAR (SUM(SALARY), 'FML999,999,999') "남직원 총 급여"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '1';

-- EMPLOYEE 테이블에서 여자 사원의 총 급여의 합계를 조회
SELECT TO_CHAR (SUM(SALARY), 'FML999,999,999') "여직원 총 급여"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '2';

-- EMPLOYEE 테이블에서 전 사원의 총 연봉의 합계를 조회
SELECT TO_CHAR(SUM(SALARY*12), 'FML999,999,999') "총 연봉의 합계"
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 부서 코드가 D5인 사원들의 총 연봉의 합계를 조회
SELECT TO_CHAR(SUM(SALARY*12), 'FML999,999,999') "D5 직원 연봉 합계"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

/*
    2) AVG
        AVG(NUMBER 타입의 컬럼)
        제시된 컬럼 값들의 평균값을 반환한다.
        모든 그룹 함수는 NULL 값을 자동으로 제외하기 떄문에 AVG 함수를 사용할 때는 NVL 함수와 함께 사용하는 것을 권장한다.
*/

-- EMPLOYEE 테이블에서 전 사원의 급여의 평균을 조회
SELECT AVG(SALARY)
FROM EMPLOYEE;

SELECT AVG(NVL(SALARY,0))
FROM EMPLOYEE;

SELECT FLOOR(AVG(NVL(SALARY, 0))) "전 사원 급여 평균"
FROM EMPLOYEE;

SELECT TO_CHAR(FLOOR(AVG(NVL(SALARY, 0))), 'FML999,999,999') "전 사원 급여 평균"
FROM EMPLOYEE;

/*
    3) MIN / MAX
        MIN/MAX(모든 타입의 컬럼)
        
        MIN : 제시된 컬럼 값들 중에 가장 작은 값을 반환한다.
        MAX : 제시된 컬럼 값들 중에 가장 큰 값을 반환한다.
*/
SELECT MIN(EMP_NAME),
       MIN(EMAIL),
       MIN(SALARY),
       MIN(HIRE_DATE)
FROM EMPLOYEE;

SELECT MAX(EMP_NAME),
       MAX(EMAIL),
       MAX(SALARY),
       MAX(HIRE_DATE)
FROM EMPLOYEE;

/*
    4) COUNT
        COUNT(* |[DISTINCT] 컬럼명)
        
        COUNT * : 조회 결과에서 모든 행의 개수를 반환한다.
        COUNT (컬럼명) : 제시된 컬럼 값이 NULL이 아닌 행의 개수를 반환한다.
        COUNT(DISTINCT 컬럼명) : 제시된 컬럼 값의 중복을 제거한 행의 개수를 반환한다.
*/

-- EMPLOYEE 테이블에서 전체 사원의 수를 조회
SELECT COUNT(*)
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 남자 사원의 수를 조회
SELECT COUNT(*)"남자 직원 수"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '1';

-- EMPLOYEE 테이블에서 여자 사원의 수를 조회
SELECT COUNT(*)"여자 직원 수"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '2';

-- EMPLOYEE 테이블에서 보너스를 받는 직원의 수를 조회
SELECT COUNT(BONUS) -- BONUS가 NULL이 아닌 사람만 카운팅
FROM EMPLOYEE;

SELECT COUNT(*)
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;

-- EMPLOYEE 테이블에서 퇴사한 직원의 수를 조회
SELECT COUNT(ENT_DATE)
FROM EMPLOYEE;

SELECT COUNT(*)
FROM EMPLOYEE
WHERE ENT_DATE IS NOT NULL;

-- EMPLOYEE 테이블에서 부서가 배치 된 사원의 수를 조회
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE;

SELECT COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL;

-- EMPLOYEE 테이블에서 현재 사원들이 속해 있는 부서의 수를 조회
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;

-- EMPLOYEE 테이블엣어 현재 사원들이 분포되어 있는 직급의 수를 조회 
SELECT COUNT(DISTINCT JOB_CODE)
FROM EMPLOYEE;
