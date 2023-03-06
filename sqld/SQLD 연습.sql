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


-- 스칼라 subquery : 반드시 한 행과 한 컬럼만 반환하는 서브쿼리                 
SELECT ENAME AS 이름
     , SAL   AS 급여
     , (SELECT AVG(SAL)
          FROM EMP
        ) AS 평균급여
  FROM EMP
;

-- correlated subquery : 서브쿼리 내에서 메인 쿼리 내의 컬럼을 사용
SELECT A.*
  FROM EMP A
 WHERE A.DEPTNO = (
                   SELECT DEPTNO 
                     FROM DEPT B
                    WHERE B.DEPTNO = A.DEPTNO
                    )

;

-- ROLLUP 한 개인 경우
SELECT DECODE(DEPTNO, NULL, '전체합계', DEPTNO)
      , SUM(SAL)
  FROM EMP
 GROUP BY ROLLUP(DEPTNO)
;

-- ROLLUP 두 개인 경우
SELECT DECODE(DEPTNO, NULL, '전체합계', DEPTNO)
     , DECODE(JOB,    NULL, '부서합계', JOB   )
     , SUM(SAL)
  FROM EMP
 GROUP BY ROLLUP(DEPTNO, JOB)
;

-- GROUPING : 합계값 구분을 위해 만들어진 함수

SELECT DEPTNO
     , GROUPING(DEPTNO)
     , JOB
     , GROUPING(JOB)
     , SUM(SAL)
  FROM EMP
 GROUP BY ROLLUP(DEPTNO, JOB)
 ;
 
-- GROUPING SETS
SELECT DEPTNO, JOB, SUM(SAL)
  FROM EMP
 GROUP BY GROUPING SETS(DEPTNO, JOB);
 -- 서로 관계가 없어 개별적으로 조회된다.
 
-- CUBE : 조합할 수 있는 경우의 수가 모두 조합되어 집계 출력
SELECT DEPTNO, JOB, SUM(SAL)
  FROM EMP
 GROUP BY CUBE(DEPTNO, JOB)
;