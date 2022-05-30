---------------------------------------------------------------------
-- 실습 문제
-- 다음에 복습할때는 계정 하나 만들어서 해보기
-- 도서관리 프로그램을 만들기 위한 테이블 만들기
-- 이때, 제약조건에 이름을 부여하고, 각 컬럼에 주석 달기


-- 1. 출판사들에 대한 데이터를 담기 위한 출판사 테이블(TB_PUBLISHER) 
--  1) 컬럼 : PUB_NO(출판사 번호) -- 기본 키
--           PUB_NAME(출판사명) -- NOT NULL
--           PHONE(출판사 전화번호) -- 제약조건 없음
CREATE TABLE TB_PUBLISHER (
    PUB_NO NUMBER,
    PUB_NAME VARCHAR2(30) CONSTRAINT PUB_NAME_NN NOT NULL,
    PHONE NUMBER,
--    PHONE VARCHAR2(15) -- 쌤은 VARCHAR2 타입으로 설정함
    CONSTRAINT PUB_NO_PK PRIMARY KEY(PUB_NO)
);

COMMENT ON COLUMN TB_PUBLISHER.PUB_NO IS '출판사 번호';
COMMENT ON COLUMN TB_PUBLISHER.PUB_NAME IS '출판사명';
COMMENT ON COLUMN TB_PUBLISHER.PHONE IS '출판사 전화번호';

SELECT * FROM TB_PUBLISHER;

--  2) 3개 정도의 샘플 데이터 추가하기
INSERT INTO TB_PUBLISHER VALUES(1, '출판사A', 031123123);
INSERT INTO TB_PUBLISHER VALUES(2, '출판사B', 02345345);
INSERT INTO TB_PUBLISHER VALUES(3, '출판사C', 032567567);

-- 2. 도서들에 대한 데이터를 담기 위한 도서 테이블 (TB_BOOK)
--  1) 컬럼 : BK_NO (도서번호) -- 기본 키
--           BK_TITLE (도서명) -- NOT NULL
--           BK_AUTHOR(저자명) -- NOT NULL
--           BK_PRICE(가격)
--           BK_PUB_NO(출판사 번호) -- 외래 키 (TB_PUBLISHER 테이블을 참조하도록)
--                                  이때 참조하고 있는 부모 데이터 삭제 시 자식 데이터도 삭제 되도록 옵션 지정
CREATE TABLE TB_BOOK(
    BK_NO NUMBER CONSTRAINT BK_NO_PK PRIMARY KEY,
    BK_TITLE VARCHAR2(50) CONSTRAINT BK_TITLE_NN NOT NULL,
    BK_AUTHOR VARCHAR2(15) CONSTRAINT BK_AUTHOR_NN NOT NULL,
    BK_PRICE NUMBER,
    BK_PUB_NO NUMBER REFERENCES TB_PUBLISHER (PUB_NO) ON DELETE CASCADE
--    CONSTRAINT BK_NO_PK PRIMARY KEY,
--    CONSTRAINT BK_PUB_NO_FK FOREIGN KEY(BK_PUB_NO) REFERENCES TB_PUBLISHER ON DELETE CASCADE
);

SELECT * FROM TB_BOOK;

COMMENT ON COLUMN TB_BOOK.BK_NO IS '도서번호';
COMMENT ON COLUMN TB_BOOK.BK_TITLE IS '도서명';
COMMENT ON COLUMN TB_BOOK.BK_AUTHOR IS '저자명';
COMMENT ON COLUMN TB_BOOK.BK_PRICE IS '가격';
COMMENT ON COLUMN TB_BOOK.BK_PUB_NO IS '출판사 번호';

--  2) 5개 정도의 샘플 데이터 추가하기
INSERT INTO TB_BOOK VALUES(1, '도서A', '저자A', 15000, 3);
INSERT INTO TB_BOOK VALUES(2, '도서B', '저자B', 10000, 2);
INSERT INTO TB_BOOK VALUES(3, '도서C', '저자C', 13000, 1);
INSERT INTO TB_BOOK VALUES(4, '도서D', '저자D', 20000, 2);
INSERT INTO TB_BOOK VALUES(5, '도서E', '저자E', 9000, 3);

DELETE FROM TB_PUBLISHER WHERE PUB_NO = 1;
ROLLBACK;

-- 3. 회원에 대한 데이터를 담기 위한 회원 테이블 (TB_MEMBER)
--  1) 컬럼 : MEMBER_NO(회원번호) -- 기본 키
--           MEMBER_ID(아이디)   -- 중복 금지
--           MEMBER_PWD(비밀번호) -- NOT NULL
--           MEMBER_NAME(회원명) -- NOT NULL
--           GENDER(성별)        -- 'M' 또는 'F'로 입력되도록 제한
--           ADDRESS(주소)       
--           PHONE(연락처)       
--           STATUS(탈퇴 여부)     -- 기본값으로 'N'  그리고 'Y' 혹은 'N'으로 입력되도록 제약조건?
--           ENROLL_DATE(가입일)  -- 기본값으로 SYSDATE, NOT NULL?
CREATE TABLE TB_MEMBER(
    MEMBER_NO NUMBER CONSTRAINT TB_MEMBER_NO_PK PRIMARY KEY,
    MEMBER_ID VARCHAR2(20),
    MEMBER_PWD VARCHAR2(20) CONSTRAINT MEMBER_PWD_NN NOT NULL,
    MEMBER_NAME VARCHAR2(15) CONSTRAINT MEMBER_NAME_NN NOT NULL,
    GENDER CHAR(2),
    ADDRESS VARCHAR2(100),
    PHONE NUMBER,
    STATUS CHAR(2) DEFAULT 'N',
    ENROLL_DATE DATE DEFAULT SYSDATE, -- NOT NULL 설정 못함 ㅜㅠ 
--    ENROLL_DATE DATE DEFAULT SYSDATE CONSTRAINT TB_MEMBER_ENROLL_DATE_NN NOT NULL
    CONSTRAINT TB_MEMBER_ID_UQ UNIQUE(MEMBER_ID),
    CONSTRAINT TB_MEMBER_GENDER_CK CHECK(GENDER IN('M', 'F')),
    CONSTRAINT MEMBER_STATUS_CK CHECK(STATUS IN('Y', 'N')) 
);

COMMENT ON COLUMN TB_MEMBER.MEMBER_NO IS '회원번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_ID IS '아이디';
COMMENT ON COLUMN TB_MEMBER.MEMBER_PWD IS '비밀번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_NAME IS '회원명';
COMMENT ON COLUMN TB_MEMBER.GENDER IS '성별';
COMMENT ON COLUMN TB_MEMBER.PHONE IS '연락처';
COMMENT ON COLUMN TB_MEMBER.ADDRESS IS '주소';
COMMENT ON COLUMN TB_MEMBER.STATUS IS '탈퇴 여부';
COMMENT ON COLUMN TB_MEMBER.ENROLL_DATE IS '가입일';

SELECT * FROM TB_MEMBER;

--  2) 3개 정도의 샘플 데이터 추가하기
INSERT INTO TB_MEMBER VALUES(1051, 'USER1', '1234', '이정후', 'M', '서울시 강남구', 01012341234, DEFAULT, DEFAULT);
INSERT INTO TB_MEMBER VALUES(1099, 'USER2', '1234', '최송희', 'F', '수원시 팔달구', 01036573657, DEFAULT, DEFAULT);
INSERT INTO TB_MEMBER VALUES(1052, 'USER3', '1234', '박병호', 'M', '서울시 목동구', 01052525252, DEFAULT, DEFAULT);

-- 4. 도서를 대여한 회원에 대한 데이터를 담기 위한 대여 목록 테이블(TB_RENT)
--  1) 컬럼 : RENT_NO(대여번호) -- 기본 키
--           RENT_MEM_NO(대여 회원번호) -- 외래 키 (TB_MEMBER와 참조하도록)
--                                      이때 부모 데이터 삭제 시 NULL 값이 되도록 옵션 설정
--           RENT_BOOK_NO(대여도서번호) -- 외래 키 ( TB_BOOK와 참조하도록)
--                                      이때 부모 데이터 삭제 시 NULL 값이 되도록 옵션 설정
--           RENT_DATE(대여일) -- 기본값 SYSDATE
CREATE TABLE TB_RENT (
    RENT_NO NUMBER CONSTRAINT RENT_NO_PK PRIMARY KEY,
    RENT_MEM_NO NUMBER REFERENCES TB_MEMBER (MEMBER_NO) ON DELETE SET NULL,
    RENT_BOOK_NO NUMBER REFERENCES TB_BOOK (BK_NO) ON DELETE SET NULL,
    RENT_DATE DATE DEFAULT SYSDATE
);

SELECT * FROM TB_RENT;

COMMENT ON COLUMN TB_RENT.RENT_NO IS '대여번호';
COMMENT ON COLUMN TB_RENT.RENT_MEM_NO IS '대여 회원번호';
COMMENT ON COLUMN TB_RENT.RENT_BOOK_NO IS '대여도서번호';
COMMENT ON COLUMN TB_RENT.RENT_DATE IS '대여일';

--  2) 샘플 데이터 3개 정도 
INSERT INTO TB_RENT VALUES(1, 1051, 3, DEFAULT);
INSERT INTO TB_RENT VALUES(2, 1052, 5, DEFAULT);
INSERT INTO TB_RENT VALUES(3, 1099, 1, '2022-04-30');


-- 5. 5번 도서를 대여한 회원의 이름, 아이디, 대여일, 반납 예정일(대여일 + 7일)을 조회하시오
SELECT M.MEMBER_NAME 이름,
       M.MEMBER_ID 아이디,
       R.RENT_DATE 대여일,
       R.RENT_DATE + 7 "반납 예정일"
FROM TB_MEMBER M
INNER JOIN TB_RENT R ON M.MEMBER_NO = R.RENT_MEM_NO
WHERE R.RENT_BOOK_NO = 5;

SELECT M.MEMBER_NAME 이름, 
       M.MEMBER_ID 아이디,
       R.RENT_DATE 대여일,
       R.RENT_DATE + 7 "반납 예정일"
FROM TB_MEMBER M, TB_RENT R
WHERE M.MEMBER_NO = R.RENT_MEM_NO
AND R.RENT_BOOK_NO = 5;


-- 6. 회원번호가 1051번인 회원이 대여한 도서들의 도서명, 출판사명, 대여일, 반납예정일을 조회하시오
SELECT B.BK_TITLE 도서명,
       P.PUB_NAME 출판사명,
       R.RENT_DATE 대여일,
       R.RENT_DATE + 7 "반납 예정일"
FROM TB_PUBLISHER P
INNER JOIN TB_BOOK B ON P.PUB_NO = B.BK_PUB_NO
INNER JOIN TB_RENT R ON B.BK_NO = R.RENT_BOOK_NO
WHERE R.RENT_MEM_NO = 1051;

SELECT B.BK_TITLE 도서명,
       P.PUB_NAME 출판사명,
       R.RENT_DATE 대여일,
       R.RENT_DATE + 7 "반납 예정일"
FROM TB_PUBLISHER P, TB_BOOK B, TB_RENT R
WHERE P.PUB_NO = B.BK_PUB_NO
AND B.BK_NO = R.RENT_BOOK_NO
AND R.RENT_MEM_NO = 1051;


SELECT TB.BK_TITLE 도서명,
       TP.PUB_NAME 출판사명,
       TM.MEMBER_NAME "대여 회원 이름",
       TR.RENT_DATE 대여일,
       TR.RENT_DATE + 7 "반납 예정일"
FROM TB_RENT TR
INNER JOIN TB_BOOK TB ON TR.RENT_BOOK_NO = TB.BK_NO
INNER JOIN TB_PUBLISHER TP ON TP.PUB_NO = TB.BK_PUB_NO
INNER JOIN TB_MEMBER TM ON TM.MEMBER_NO = TR.RENT_MEM_NO
WHERE TR.RENT_MEM_NO = 1051;

----------------------------------------------------------------------------------------------------------------