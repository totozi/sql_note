select sysdate from dual;

-- 시간 포맷 변경
alter session set nls_date_format='DD-MON-YYYY';

alter session set nls_date_format='YYYY/MM/DD';

SELECT *
  FROM EMP  A
     , DEPT B
 WHERE A.DEPTNO = B.DEPTNO
 ORDER BY ENAME
;

SELECT *
  FROM EMP  A
 INNER 
  JOIN DEPT B
    ON A.DEPTNO = B.DEPTNO
;

-- INTERSECT 교집합 조회

SELECT DEPTNO
  FROM EMP A
INTERSECT
SELECT DEPTNO
  FROM DEPT B
;

-- LEFT OUTER JOIN
SELECT *
  FROM DEPT A
     , EMP  B
 WHERE A.DEPTNO = B.DEPTNO(+)
 -- B에는 있고 A없는 것도 출력
 -- 즉 왼쪽에만 있는 것도 출력하기
;
SELECT *
  FROM DEPT A 
  LEFT OUTER
  JOIN EMP  B
    ON A.DEPTNO = B.DEPTNO
;

-- CARTESIAN JOIN
SELECT *
  FROM EMP 
 CROSS 
  JOIN DEPT
;

-- UNION은 중복 데이터를 제거하며 합친다.
SELECT DEPTNO
  FROM EMP
 UNION
SELECT DEPTNO
  FROM EMP
;

SELECT DEPTNO
  FROM EMP
 UNION ALL
SELECT DEPTNO
  FROM EMP
;


-- MINUS, MS-SQL에서는 EXCEPT
SELECT DEPTNO
  FROM DEPT
 MINUS 
SELECT DEPTNO
  FROM EMP
;

-- CONNECT BY 계층형 조회

-- 최대 깊이 구하기
SELECT MAX(LEVEL)
  FROM EMP
 START WITH MGR IS NULL -- 시작 조건
CONNECT BY PRIOR EMPNO = MGR -- 조인 조건
-- ROOT 노드로부터 하위 노드의 질의를 실행한다.
;

SELECT LEVEL, EMPNO, MGR, ENAME
  FROM EMP
 START WITH MGR IS NULL -- MGR이 NULL인게 가장 상위(ROOT)가 된다.
CONNECT BY PRIOR EMPNO = MGR -- 자식 = 부모 -> 부모에서 자식방향으로 검색
 ORDER BY LEVEL
;

SELECT LEVEL
     , LPAD(' ', 4 * (LEVEL - 1)) || EMPNO
     , MGR
     , CONNECT_BY_ISLEAF
  FROM EMP
 START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR
;

SELECT *
  FROM EMP
 WHERE DEPTNO = (
                SELECT DEPTNO
                  FROM DEPT
                 WHERE DEPTNO = 10
                )
;      

SELECT *
  FROM ( SELECT ROWNUM NUM
              , ENAME
           FROM EMP
        ) A
 WHERE NUM < 5
;

SELECT ENAME, DNAME, SAL
  FROM EMP  A
     , DEPT B
 WHERE A.DEPTNO = B.DEPTNO
   AND A.EMPNO IN ( SELECT EMPNO
                       FROM EMP
                      WHERE SAL > 2000
                  )
;

SELECT *
  FROM EMP
 WHERE DEPTNO <= ALL(20, 30)
 ; -- 20,30 보다 작거나 같은 것

SELECT A.*
  FROM EMP A
 WHERE EXISTS ( 
               SELECT 1 
                 FROM EMP 
                WHERE SAL > 2000
                ) -- TRUE OR FALSE 반환
;
                 
            