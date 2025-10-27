/* VIEW
 * 
 * 	- 논리적 가상 테이블
 * 	-> 테이블 모양을 하고는 있지만, 실제로 값을 저장하고 있진 않음.
 * 
 *  - SELECT문의 실행 결과(RESULT SET)를 저장하는 객체
 * 
 * 
 * ** VIEW 사용 목적 **
 *  1) 복잡한 SELECT문을 쉽게 재사용하기 위해.
 *  2) 테이블의 진짜 모습을 감출 수 있어 보안상 유리.
 * 
 * ** VIEW 사용 시 주의 사항 **
 * 	1) 가상의 테이블(실체 X)이기 때문에 ALTER 구문 사용 불가.
 * 	2) VIEW를 이용한 DML(INSERT,UPDATE,DELETE)이 가능한 경우도 있지만
 *     제약이 많이 따르기 때문에 조회(SELECT) 용도로 대부분 사용.
 * 
 * 
 *  ** VIEW 작성법 **
 *  CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰이름 [컬럼 별칭]
 *  AS 서브쿼리(SELECT문)
 *  [WITH CHECK OPTION]
 *  [WITH READ OLNY];
 * 
 * 
 *  1) OR REPLACE 옵션 : 
 * 		기존에 동일한 이름의 VIEW가 존재하면 이를 변경
 * 		없으면 새로 생성
 * 
 *  2) FORCE | NOFORCE 옵션 : 
 *    FORCE : 서브쿼리에 사용된 테이블이 존재하지 않아도 뷰 생성
 *    NOFORCE(기본값): 서브쿼리에 사용된 테이블이 존재해야만 뷰 생성
 *    
 *  3) 컬럼 별칭 옵션 : 조회되는 VIEW의 컬럼명을 지정
 * 
 *  4) WITH CHECK OPTION 옵션 : 
 * 		옵션을 지정한 컬럼의 값을 수정 불가능하게 함.
 * 
 *  5) WITH READ OLNY 옵션 :
 * 		뷰에 대해 SELECT만 가능하도록 지정.
 * */

-- VIEW 를 생성하기 위해서는 권한이 필요하다!!!
-- 권한 부여 방법
-- (SYS 계정 접속)

-- VIEW 생성 권한 부여 (SYS ->kh_hdk 계정으로)
GRANT CREATE VIEW TO kh_hdk;


-- VIEW 생성
CREATE VIEW V_EMP
AS SELECT * FROM EMPLOYEE;
-- ORA-01031: 권한이 불충분합니다 -> kh 계정에 부여된 권한만으로는 만들 수 없다는 의미다.


SELECT * FROM V_EMP;


-- 사번, 이름, 부서명, 직급명 조회하기 위한 VIEW 생성
CREATE OR REPLACE VIEW V_EMP 
AS
SELECT  EMP_ID 사번,
EMP_NAME 이름,
NVL(DEPT_TITLE, '없음') 부서명,
JOB_NAME 직급명
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
ORDER BY 사번;
-- ORA-00955: 기존의 객체가 이름을 사용하고 있습니다.


SELECT * FROM V_EMP;

-- 직급명이 대리인 사원 모두 조회
-- VIEW 조회 결과로 보이는 컬럼명을 이용해야 한다.
SELECT * FROM V_EMP
WHERE 직급명 = '대리'
ORDER BY 이름;

---------------------------------------------

-- VIEW를 이용해서 DML 사용하기 + 문제점 확인

-- DEPARTMENT 테이블 복사한 DEPT_COPY2 생성 (테이블로 생성)
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPARTMENT; --> DEPT_COPY2는 DEPARTMENT의 복사본 테이블이다. (VIEW가 아님.)



-- DEPT_COPY2 테이블에서 DEPT_ID, LOCATION_ID 컬럼만 이용해서
-- V_DCOPY2 VIEW 생성
CREATE OR REPLACE VIEW V_DCOPY2
AS SELECT DEPT_ID, LOCATION_ID FROM DEPT_COPY2;

-- V_DCOPY2 VIEW 생성 확인
SELECT * FROM V_DCOPY2;

-- 원본 테이블
SELECT * FROM DEPT_COPY2;


-- V_DCOPY2 VIEW에 INSERT 수행
INSERT INTO V_DCOPY2
VALUES('D0', 'L2');
--> 가상 테이블 VIEW에 INSERT가 성공한 것을 확인함.


SELECT * FROM DEPT_DCOPY2;

-- VIEW 에 INSERT를 수행했지만
-- VIEW 생성 시 사용한 원본 테이블 DEPT_COPY2에
-- 값이 INSERT 됨을 확인

--> 모든 컬럼값이 INSERT 된 것이 아니라
-- VIEW를 생성할 때 사용된 컬럼에만 데이터가 삽입되었고
-- 반대로, 사용되지 않은 컬럼(DEPT_TITLE)에는 NULL이 들어감
--> NULL은 DB의 무결성을 약하게 만드는 주요 원인
-- 가능하면 의도되지 않은 NULL은 존재하지 않게 해야 함.

-- 무결성 : 데이터베이스에서 데이터를 정확하고 일관되게 유지하기 위한 중요한 개념.
-- 데이터의 정확성, 일관성, 신뢰성을 보장함.


-- WITH READ ONLY 옵션 사용하기
-- VIEW를 이용해서 DML(INSERT/UPDATE/DELETE) 막기 위해 사용.

CREATE OR REPLACE VIEW V_DCOPY2
AS SELECT DEPT_ID, LOCATION_ID FROM DEPT_COPY2
WITH READ ONLY; -- 읽기 전용 옵션


INSERT INTO V_DCOPY2
VALUES('D0', 'L2');
-- ORA-42399: 읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.


SELECT * FROM V_DCOPY2;













































