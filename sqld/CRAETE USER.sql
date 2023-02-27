-- 유저 생성
CREATE USER SQLP_PRACTICE
IDENTIFIED BY 1234
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP;

-- 권한 부여
GRANT CONNECT TO SQLP_PRACTICE;
GRANT RESOURCE TO SQLP_PRACTICE;
GRANT DBA TO SQLP_PRACTICE;