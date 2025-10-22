-- 1. 영어영문학과 학생들의 학번, 이름, 입학년도 표시(단, 입학년도 오름차순으로)
SELECT STUDENT_NO "학번", STUDENT_NAME "이름", ENTRANCE_DATE "입학년도"
FROM TB_STUDENT
WHERE DEPARTMENT_NO = 002
ORDER BY ENTRANCE_DATE ASC;

-- 2. 교수 중 이름이 세 글자가 아닌 사람만 이름, 주민번호 출력
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE LENGTH(PROFESSOR_NAME) != 3;

-- 3. 남교수들 이름과 나이 출력(단, 나이가 오름차순 정렬+2000년 이후 출생자는 없음)
-- 이어 풀기
SELECT PROFESSOR_NAME "교수 이름", TO_CHAR(PROFESSOR_SSN) "나이"
FROM TB_PROFESSOR






