CREATE SEQUENCE "sessionSequence"
MAXVALUE 10000
/

CREATE SEQUENCE "recSequence"
MAXVALUE 10000
/

CREATE SEQUENCE "objectionSequence"
MAXVALUE 10000
/

CREATE SEQUENCE "leaveSequence"
MAXVALUE 10000
/

CREATE SEQUENCE "jobSequence"
MAXVALUE 10000
/

CREATE SEQUENCE "intSesSequence"
MAXVALUE 10000
/

CREATE SEQUENCE "intSequence"
MAXVALUE 10000
/

CREATE SEQUENCE "contractSequence"
MAXVALUE 10000
/

CREATE SEQUENCE "appSequence"
MAXVALUE 10000
/

CREATE SEQUENCE "annSequence"
MAXVALUE 10000
/

CREATE TYPE JOB_BOARD_REC AS OBJECT ("RowNo" NUMBER, "JobID" NUMBER, "Name" NVARCHAR2(32), "HrSalary" NUMBER, "IsReqInterview" CHAR(1), "IsContinuous" CHAR(1))
/

CREATE TYPE JOB_BOARD AS TABLE OF JOB_BOARD_REC
/

CREATE TABLE ADDRESS
(
  "PersonID"    VARCHAR2(16 CHAR) NOT NULL,
  "StreetAddr1" NVARCHAR2(32)     NOT NULL,
  "StreetAddr2" NVARCHAR2(32),
  "City"        NVARCHAR2(16)     NOT NULL,
  "State"       NVARCHAR2(16)     NOT NULL,
  "ZipCode"     VARCHAR2(8 CHAR)  NOT NULL
)
/

CREATE TABLE DEPARTMENT
(
  "DeptID"   NUMBER           NOT NULL
    PRIMARY KEY,
  "DeptAbbr" VARCHAR2(4 CHAR) NOT NULL
)
/

CREATE TABLE DEPT_ABBR_INFO
(
  "DeptAbbr" VARCHAR2(4 CHAR)  NOT NULL
    PRIMARY KEY,
  "Name"     VARCHAR2(70 CHAR) NOT NULL
)
/

ALTER TABLE DEPARTMENT
  ADD FOREIGN KEY ("DeptAbbr") REFERENCES DEPT_ABBR_INFO
/

CREATE TABLE LANG_PREF_HASH
(
  "PrefCode" NUMBER NOT NULL
    PRIMARY KEY,
  "PrefCTN"  NUMBER NOT NULL,
  "PrefENG"  NUMBER NOT NULL,
  "PrefPTH"  NUMBER NOT NULL
)
/

CREATE TABLE MAJOR
(
  "MajorID"   VARCHAR2(10 CHAR) NOT NULL
    PRIMARY KEY,
  "DeptID"    NUMBER            NOT NULL
    REFERENCES DEPARTMENT,
  "MajorAbbr" VARCHAR2(4 CHAR)  NOT NULL
)
/

CREATE TABLE MAJOR_ABBR_INFO
(
  "MajorAbbr" VARCHAR2(4 CHAR)  NOT NULL
    PRIMARY KEY,
  "Name"      VARCHAR2(64 CHAR) NOT NULL
)
/

ALTER TABLE MAJOR
  ADD FOREIGN KEY ("MajorAbbr") REFERENCES MAJOR_ABBR_INFO
/

CREATE TABLE PERSON
(
  "PersonID"  VARCHAR2(16 CHAR) NOT NULL
    PRIMARY KEY,
  "Type"      VARCHAR2(4 CHAR)  NOT NULL,
  "Password"  VARCHAR2(32 CHAR) NOT NULL,
  "Title"     VARCHAR2(6 CHAR)  NOT NULL,
  "FirstName" NVARCHAR2(32)     NOT NULL,
  "LastName"  NVARCHAR2(32)     NOT NULL,
  "PhoneNo"   VARCHAR2(32 CHAR) NOT NULL,
  "Email"     NVARCHAR2(64)     NOT NULL,
  "Gender"    CHAR(1 CHAR)      NOT NULL
)
/

ALTER TABLE ADDRESS
  ADD CONSTRAINT ADDRESS_PERSON_FK
FOREIGN KEY ("PersonID") REFERENCES PERSON
ON DELETE CASCADE
/

CREATE TABLE STUDENT
(
  "PersonID"     VARCHAR2(16 CHAR) NOT NULL
    PRIMARY KEY
    CONSTRAINT STUDENT_PERSON_FK
    REFERENCES PERSON
    ON DELETE CASCADE,
  "MajorID"      VARCHAR2(10 CHAR) NOT NULL
    REFERENCES MAJOR,
  "IsLocal"      CHAR(1 CHAR)      NOT NULL,
  CV             NVARCHAR2(64)     NOT NULL,
  "EntranceYear" NUMBER            NOT NULL,
  "PrefCode"     NUMBER            NOT NULL
    REFERENCES LANG_PREF_HASH
)
/

CREATE TABLE SUPERVISOR
(
  "PersonID" VARCHAR2(16 CHAR) NOT NULL
    PRIMARY KEY
    CONSTRAINT SUPERVISOR_PERSON_FK
    REFERENCES PERSON
    ON DELETE CASCADE,
  "DeptID"   NUMBER            NOT NULL
    REFERENCES DEPARTMENT
)
/

CREATE TABLE ADMIN
(
  "PersonID" VARCHAR2(16 CHAR) NOT NULL
    CONSTRAINT ADMIN_PK
    PRIMARY KEY
    CONSTRAINT ADMIN_PERSON_FK
    REFERENCES PERSON
    ON DELETE CASCADE,
  "DeptID"   NUMBER            NOT NULL
    CONSTRAINT ADMIN_DEPTID_FK
    REFERENCES DEPARTMENT
)
/

CREATE TABLE JOB
(
  "JobID"          NUMBER        NOT NULL
    PRIMARY KEY,
  "Name"           NVARCHAR2(64) NOT NULL,
  "Description"    NVARCHAR2(512),
  "HrSalary"       NUMBER,
  "HrPerWeek"      NUMBER,
  "MinWeek"        NUMBER,
  "MaxWeek"        NUMBER,
  "IsContinuous"   CHAR(1 CHAR)  NOT NULL,
  "Quota"          NUMBER        NOT NULL,
  "IsReqInterview" CHAR(1 CHAR)  NOT NULL,
  "MinStudyYear"   NUMBER,
  "PrefCode"       NUMBER
    REFERENCES LANG_PREF_HASH,
  "IsValid"        CHAR(1 CHAR)  NOT NULL,
  "LastModDate"    DATE          NOT NULL,
  "IsOpen"         CHAR(1 CHAR)  NOT NULL,
  "AppDeadline"    DATE          NOT NULL
)
/

CREATE TABLE JOB_ANNOUNCEMENT
(
  "AncID"        NUMBER            NOT NULL
    PRIMARY KEY,
  "JobID"        NUMBER            NOT NULL
    CONSTRAINT JOB_ANNOUNCEMENT_JOB_FK
    REFERENCES JOB
    ON DELETE CASCADE,
  "SupervisorID" VARCHAR2(16 CHAR) NOT NULL,
  "Message"      NVARCHAR2(1024)   NOT NULL
)
/

CREATE TABLE JOB_APPLICATION
(
  "AppID"        NUMBER            NOT NULL
    PRIMARY KEY,
  "JobID"        NUMBER            NOT NULL
    CONSTRAINT JOB_APPLICATION_JOB_FK
    REFERENCES JOB
    ON DELETE CASCADE,
  "StudentID"    VARCHAR2(16 CHAR) NOT NULL
    CONSTRAINT JOB_APPLICATION_STUDENT_FK
    REFERENCES STUDENT
    ON DELETE CASCADE,
  "CoverLetter"  NVARCHAR2(1024),
  "Score"        NUMBER,
  "IsSuccessful" CHAR(1 CHAR)      NOT NULL,
  "IsValid"      CHAR(1 CHAR)      NOT NULL
)
/

CREATE TABLE JOB_ATTENDANCE
(
  "SessionID"   NUMBER            NOT NULL,
  "StudentID"   VARCHAR2(16 CHAR) NOT NULL
    CONSTRAINT JOB_ATTENDANCE_STUDENT_FK
    REFERENCES STUDENT
    ON DELETE CASCADE,
  "IsPresent"   CHAR(1 CHAR)      NOT NULL,
  "AttendHours" NUMBER            NOT NULL,
  "Remark"      VARCHAR2(128 CHAR),
  CONSTRAINT JOB_ATTENDANCE_PK
  PRIMARY KEY ("SessionID", "StudentID")
)
/

CREATE TABLE JOB_INTERVIEW
(
  "InterviewID" NUMBER NOT NULL
    PRIMARY KEY,
  "AppID"       NUMBER NOT NULL
    CONSTRAINT JOB_INTERVIEW_JOB_APP_FK
    REFERENCES JOB_APPLICATION
    ON DELETE CASCADE,
  "Score"       NUMBER,
  "Remark"      NVARCHAR2(256),
  "IvSessionID" NUMBER
)
/

CREATE TABLE JOB_LEAVE
(
  "JobID"        NUMBER            NOT NULL
    CONSTRAINT JOB_LEAVE_JOB_FK
    REFERENCES JOB
    ON DELETE CASCADE,
  "StudentID"    VARCHAR2(16 CHAR) NOT NULL
    CONSTRAINT JOB_LEAVE_STUDENT_FK
    REFERENCES STUDENT
    ON DELETE CASCADE,
  "SupervisorID" VARCHAR2(16 CHAR)
    CONSTRAINT JOB_LEAVE_SUPERVISOR_FK
    REFERENCES SUPERVISOR
    ON DELETE CASCADE,
  "Reason"       NVARCHAR2(256)    NOT NULL,
  "StartDate"    DATE              NOT NULL,
  "EndDate"      DATE              NOT NULL,
  "IsApproved"   CHAR(1 CHAR)      NOT NULL,
  "LeaveNo"      NUMBER            NOT NULL
    CONSTRAINT JOB_LEAVE_PK
    PRIMARY KEY
)
/

CREATE TABLE JOB_RECORD
(
  "RecordID"     NUMBER            NOT NULL
    PRIMARY KEY,
  "JobID"        NUMBER            NOT NULL
    CONSTRAINT JOB_RECORD_JOB_FK
    REFERENCES JOB
    ON DELETE CASCADE,
  "StudentID"    VARCHAR2(16 CHAR) NOT NULL
    CONSTRAINT JOB_RECORD_STUDENT_FK
    REFERENCES STUDENT
    ON DELETE CASCADE,
  "SupervisorID" VARCHAR2(16 CHAR)
    CONSTRAINT JOB_RECORD_SUPERVISOR_FK
    REFERENCES SUPERVISOR
    ON DELETE CASCADE,
  "Date"         DATE              NOT NULL,
  "Type"         VARCHAR2(16 CHAR) NOT NULL,
  "Desc"         NVARCHAR2(256),
  "Payment"      FLOAT             NOT NULL,
  "IsValid"      CHAR(1 CHAR)      NOT NULL
)
/

CREATE TABLE JOB_SESSION
(
  "SessionID"    NUMBER            NOT NULL
    PRIMARY KEY,
  "JobID"        NUMBER            NOT NULL
    CONSTRAINT JOB_SESSION_JOB_FK
    REFERENCES JOB
    ON DELETE CASCADE,
  "SupervisorID" VARCHAR2(16 CHAR) NOT NULL
    CONSTRAINT JOB_SESSION_SUPERVISOR_FK
    REFERENCES SUPERVISOR
    ON DELETE CASCADE,
  "Date"         DATE              NOT NULL,
  "Hours"        NUMBER            NOT NULL,
  "Venue"        VARCHAR2(32 CHAR) NOT NULL,
  "Desc"         VARCHAR2(64 CHAR)
)
/

ALTER TABLE JOB_ATTENDANCE
  ADD CONSTRAINT JOB_ATTENDANCE_JOB_SESSION_FK
FOREIGN KEY ("SessionID") REFERENCES JOB_SESSION
ON DELETE CASCADE
/

CREATE TABLE JOB_SUPERVISE
(
  "JobID"        NUMBER            NOT NULL
    CONSTRAINT JOB_SUPERVISE_JOB_FK
    REFERENCES JOB
    ON DELETE CASCADE,
  "SupervisorID" VARCHAR2(16 CHAR) NOT NULL
    CONSTRAINT JOB_SUPERVISE_SUPERVISOR_FK
    REFERENCES SUPERVISOR
    ON DELETE CASCADE
)
/

CREATE TABLE OBJECTION
(
  "ObjectionID" NUMBER       NOT NULL
    PRIMARY KEY,
  "RecordID"    NUMBER       NOT NULL
    CONSTRAINT OBJECTION_JOB_RECORD_FK
    REFERENCES JOB_RECORD
    ON DELETE CASCADE,
  "Type"        CHAR(1 CHAR) NOT NULL,
  "Reason"      NVARCHAR2(256),
  "Reply"       NVARCHAR2(256)
)
/

CREATE TABLE SP_OBJECTION
(
  "ObjectionID"  NUMBER            NOT NULL
    PRIMARY KEY
    CONSTRAINT SP_OBJECTION_OBJECTION_FK
    REFERENCES OBJECTION
    ON DELETE CASCADE,
  "SupervisorID" VARCHAR2(16 CHAR) NOT NULL
    CONSTRAINT SP_OBJECTION_SUPERVISOR_FK
    REFERENCES SUPERVISOR
    ON DELETE CASCADE,
  "IsApproved"   CHAR(1 CHAR)      NOT NULL
)
/

CREATE TABLE JOB_CONTRACT
(
  "CtrtNo"       NUMBER            NOT NULL
    PRIMARY KEY,
  "JobID"        NUMBER            NOT NULL
    CONSTRAINT JOB_CONTRACT_JOB_FK
    REFERENCES JOB,
  "StudentID"    VARCHAR2(16 CHAR) NOT NULL
    CONSTRAINT JOB_CONTRACT_STUDENT_FK
    REFERENCES STUDENT,
  "SupervisorID" VARCHAR2(16 CHAR) NOT NULL
    CONSTRAINT JOB_CONTRACT_SUPERVISOR_FK
    REFERENCES SUPERVISOR,
  "HrPerWeek"    NUMBER            NOT NULL,
  "Weeks"        NUMBER            NOT NULL,
  "StartDate"    DATE              NOT NULL,
  "EndDate"      DATE              NOT NULL,
  "IsActive"     CHAR(1 CHAR)      NOT NULL,
  "Remark"       NVARCHAR2(256),
  "IsValid"      CHAR(1 CHAR)      NOT NULL,
  "HrSalary"     NUMBER            NOT NULL
)
/

CREATE TABLE JOB_MAJOR_REQ
(
  "JobID"   NUMBER            NOT NULL
    CONSTRAINT JOB_MAJOR_REQ_JOB_FK
    REFERENCES JOB
    ON DELETE CASCADE,
  "MajorID" VARCHAR2(10 CHAR) NOT NULL
    REFERENCES MAJOR
)
/

CREATE TABLE JOB_INTERVIEW_SESSION
(
  "IvSessionID" NUMBER NOT NULL
    PRIMARY KEY,
  "JobID"       NUMBER NOT NULL
    CONSTRAINT IV_SESSION_JOB_FK
    REFERENCES JOB
    ON DELETE CASCADE,
  "Date"        DATE   NOT NULL,
  "Venue"       VARCHAR2(64 CHAR),
  "Quota"       NUMBER NOT NULL,
  "Hours"       NUMBER NOT NULL
)
/

ALTER TABLE JOB_INTERVIEW
  ADD CONSTRAINT JOB_INTERVIEW_SESSION_FK
FOREIGN KEY ("IvSessionID") REFERENCES JOB_INTERVIEW_SESSION
ON DELETE CASCADE
/

CREATE PACKAGE add_People AS
  PROCEDURE aStudent(
    p_id      IN VARCHAR2,
    p_type    IN VARCHAR2,
    p_pw      IN VARCHAR2,
    p_title   IN VARCHAR2,
    p_fname   IN NVARCHAR2,
    p_lname   IN NVARCHAR2,
    p_phone   IN VARCHAR2,
    p_email   IN NVARCHAR2,
    p_gender  IN CHAR,
    p_major   IN VARCHAR2,
    p_islocal IN CHAR,
    p_CV      IN NVARCHAR2,
    p_year    IN NUMBER,
    p_code    IN NUMBER,
    a_addr1   IN NVARCHAR2,
    a_addr2   IN NVARCHAR2,
    a_city    IN NVARCHAR2,
    a_state   IN NVARCHAR2,
    a_zip     IN VARCHAR2);

  PROCEDURE aSupervisor(
    p_id     IN VARCHAR2,
    p_type   IN VARCHAR2,
    p_pw     IN VARCHAR2,
    p_title  IN VARCHAR2,
    p_fname  IN NVARCHAR2,
    p_lname  IN NVARCHAR2,
    p_phone  IN VARCHAR2,
    p_email  IN NVARCHAR2,
    p_gender IN CHAR,
    p_dept   IN NUMBER,
    a_addr1  IN NVARCHAR2,
    a_addr2  IN NVARCHAR2,
    a_city   IN NVARCHAR2,
    a_state  IN NVARCHAR2,
    a_zip    IN VARCHAR2);

  PROCEDURE aAdmin(
    p_id     IN VARCHAR2,
    p_type   IN VARCHAR2,
    p_pw     IN VARCHAR2,
    p_title  IN VARCHAR2,
    p_fname  IN NVARCHAR2,
    p_lname  IN NVARCHAR2,
    p_phone  IN VARCHAR2,
    p_email  IN NVARCHAR2,
    p_gender IN CHAR,
    p_dept   IN NUMBER,
    a_addr1  IN NVARCHAR2,
    a_addr2  IN NVARCHAR2,
    a_city   IN NVARCHAR2,
    a_state  IN NVARCHAR2,
    a_zip    IN VARCHAR2);
END;
/

CREATE PACKAGE BODY add_People AS
  PROCEDURE aStudent(
    p_id      IN VARCHAR2,
    p_type    IN VARCHAR2,
    p_pw      IN VARCHAR2,
    p_title   IN VARCHAR2,
    p_fname   IN NVARCHAR2,
    p_lname   IN NVARCHAR2,
    p_phone   IN VARCHAR2,
    p_email   IN NVARCHAR2,
    p_gender  IN CHAR,
    p_major   IN VARCHAR2,
    p_islocal IN CHAR,
    p_CV      IN NVARCHAR2,
    p_year    IN NUMBER,
    p_code    IN NUMBER,
    a_addr1   IN NVARCHAR2,
    a_addr2   IN NVARCHAR2,
    a_city    IN NVARCHAR2,
    a_state   IN NVARCHAR2,
    a_zip     IN VARCHAR2)
  IS
    p_id1 VARCHAR2(16 CHAR);
    BEGIN
      INSERT INTO PERSON ("PersonID", "Type", "Password", "Title", "FirstName", "LastName", "PhoneNo", "Email", "Gender")
      VALUES (p_id, p_type, p_pw, p_title, p_fname, p_lname, p_phone, p_email, p_gender)
      RETURNING "PersonID" INTO p_id1;

      INSERT INTO STUDENT ("PersonID", "MajorID", "IsLocal", CV, "EntranceYear", "PrefCode")
      VALUES (p_id1, p_major, p_islocal, p_CV, p_year, p_code);

      INSERT INTO ADDRESS ("PersonID", "StreetAddr1", "StreetAddr2", "City", "State", "ZipCode")
      VALUES (p_id1, a_addr1, a_addr2, a_city, a_state, a_zip);

      COMMIT;

    END aStudent;

  PROCEDURE aSupervisor(
    p_id     IN VARCHAR2,
    p_type   IN VARCHAR2,
    p_pw     IN VARCHAR2,
    p_title  IN VARCHAR2,
    p_fname  IN NVARCHAR2,
    p_lname  IN NVARCHAR2,
    p_phone  IN VARCHAR2,
    p_email  IN NVARCHAR2,
    p_gender IN CHAR,
    p_dept   IN NUMBER,
    a_addr1  IN NVARCHAR2,
    a_addr2  IN NVARCHAR2,
    a_city   IN NVARCHAR2,
    a_state  IN NVARCHAR2,
    a_zip    IN VARCHAR2)
  IS
    p_id1 VARCHAR2(16 CHAR);
    BEGIN
      INSERT INTO PERSON ("PersonID", "Type", "Password", "Title", "FirstName", "LastName", "PhoneNo", "Email", "Gender")
      VALUES (p_id, p_type, p_pw, p_title, p_fname, p_lname, p_phone, p_email, p_gender)
      RETURNING "PersonID" INTO p_id1;

      INSERT INTO SUPERVISOR ("PersonID", "DeptID")
      VALUES (p_id1, p_dept);

      INSERT INTO ADDRESS ("PersonID", "StreetAddr1", "StreetAddr2", "City", "State", "ZipCode")
      VALUES (p_id1, a_addr1, a_addr2, a_city, a_state, a_zip);

      COMMIT;

    END aSupervisor;

  PROCEDURE aAdmin(
    p_id     IN VARCHAR2,
    p_type   IN VARCHAR2,
    p_pw     IN VARCHAR2,
    p_title  IN VARCHAR2,
    p_fname  IN NVARCHAR2,
    p_lname  IN NVARCHAR2,
    p_phone  IN VARCHAR2,
    p_email  IN NVARCHAR2,
    p_gender IN CHAR,
    p_dept   IN NUMBER,
    a_addr1  IN NVARCHAR2,
    a_addr2  IN NVARCHAR2,
    a_city   IN NVARCHAR2,
    a_state  IN NVARCHAR2,
    a_zip    IN VARCHAR2)
  IS
    p_id1 VARCHAR2(16 CHAR);
    BEGIN
      INSERT INTO PERSON ("PersonID", "Type", "Password", "Title", "FirstName", "LastName", "PhoneNo", "Email", "Gender")
      VALUES (p_id, p_type, p_pw, p_title, p_fname, p_lname, p_phone, p_email, p_gender)
      RETURNING "PersonID" INTO p_id1;

      INSERT INTO ADMIN ("PersonID", "DeptID")
      VALUES (p_id1, p_dept);

      INSERT INTO ADDRESS ("PersonID", "StreetAddr1", "StreetAddr2", "City", "State", "ZipCode")
      VALUES (p_id1, a_addr1, a_addr2, a_city, a_state, a_zip);

      COMMIT;

    END aAdmin;
END add_People;
/

CREATE PACKAGE UPDATE_PEOPLE AS
  PROCEDURE IAdmin(
    p_id    IN VARCHAR2,
    p_fname IN NVARCHAR2,
    p_lname IN NVARCHAR2,
    p_phone IN VARCHAR2,
    p_email IN NVARCHAR2,
    p_dept  IN NUMBER);

  PROCEDURE IStudent(
    p_id      IN VARCHAR2,
    p_fname   IN NVARCHAR2,
    p_lname   IN NVARCHAR2,
    p_phone   IN VARCHAR2,
    p_email   IN NVARCHAR2,
    p_major   IN VARCHAR2,
    p_islocal IN CHAR,
    p_code    IN NUMBER);

  PROCEDURE ISupervisor(
    p_id    IN VARCHAR2,
    p_fname IN NVARCHAR2,
    p_lname IN NVARCHAR2,
    p_phone IN VARCHAR2,
    p_email IN NVARCHAR2,
    p_dept  IN NUMBER);

  PROCEDURE IAddress(
    id      IN VARCHAR2,
    a_addr1 IN NVARCHAR2,
    a_addr2 IN NVARCHAR2,
    a_city  IN NVARCHAR2,
    a_state IN NVARCHAR2,
    a_zip   IN VARCHAR2);

  PROCEDURE Icv(
    pid    IN VARCHAR2,
    cvlink IN VARCHAR2
  );

  PROCEDURE ILangPreInfo(pid IN VARCHAR2, PrefCode IN NUMBER);

  PROCEDURE ICONINFO(
    p_id    IN VARCHAR2,
    p_phone IN VARCHAR2,
    p_email IN NVARCHAR2,
    p_Add1  IN VARCHAR2,
    p_Add2  IN VARCHAR2,
    p_City  IN VARCHAR2,
    p_State IN VARCHAR2
  );

END UPDATE_PEOPLE;
/

CREATE PACKAGE BODY UPDATE_PEOPLE AS
  PROCEDURE IAdmin(
    p_id    IN VARCHAR2,
    p_fname IN NVARCHAR2,
    p_lname IN NVARCHAR2,
    p_phone IN VARCHAR2,
    p_email IN NVARCHAR2,
    p_dept  IN NUMBER)
  AS
    BEGIN
      UPDATE PERSON
      SET
        "FirstName" = p_fname,
        "LastName"  = p_lname,
        "PhoneNo"   = p_phone,
        "Email"     = p_email
      WHERE "PersonID" = p_id;
      UPDATE ADMIN
      SET
        "DeptID" = p_dept
      WHERE "PersonID" = p_id;
      COMMIT;
    END IAdmin;

  PROCEDURE IStudent(
    p_id      IN VARCHAR2,
    p_fname   IN NVARCHAR2,
    p_lname   IN NVARCHAR2,
    p_phone   IN VARCHAR2,
    p_email   IN NVARCHAR2,
    p_major   IN VARCHAR2,
    p_islocal IN CHAR,
    p_code    IN NUMBER)
  AS
    BEGIN
      UPDATE STUDENT
      SET
        "MajorID"  = p_major,
        "IsLocal"  = p_islocal,
        "PrefCode" = p_code
      WHERE "PersonID" = p_id;
      UPDATE PERSON
      SET
        "FirstName" = p_fname,
        "LastName"  = p_lname,
        "PhoneNo"   = p_phone,
        "Email"     = p_email
      WHERE "PersonID" = p_id;
    END IStudent;

  PROCEDURE ISupervisor(
    p_id    IN VARCHAR2,
    p_fname IN NVARCHAR2,
    p_lname IN NVARCHAR2,
    p_phone IN VARCHAR2,
    p_email IN NVARCHAR2,
    p_dept  IN NUMBER)
  AS
    BEGIN
      UPDATE PERSON
      SET
        "FirstName" = p_fname,
        "LastName"  = p_lname,
        "PhoneNo"   = p_phone,
        "Email"     = p_email
      WHERE "PersonID" = p_id;
      UPDATE SUPERVISOR
      SET
        "DeptID" = p_dept
      WHERE "PersonID" = p_id;
      COMMIT;
    END ISupervisor;

  PROCEDURE IAddress(
    id      IN VARCHAR2,
    a_addr1 IN NVARCHAR2,
    a_addr2 IN NVARCHAR2,
    a_city  IN NVARCHAR2,
    a_state IN NVARCHAR2,
    a_zip   IN VARCHAR2)
  AS
    BEGIN
      UPDATE ADDRESS
      SET
        "StreetAddr1" = a_addr1,
        "StreetAddr2" = a_addr2,
        "City"        = a_city,
        "State"       = a_state,
        "ZipCode"     = a_zip
      WHERE "PersonID" = id;
      COMMIT;
    END IAddress;

  PROCEDURE Icv(
    pid    IN VARCHAR2,
    cvlink IN VARCHAR2
  )
  AS
    BEGIN
      UPDATE STUDENT
      SET
        CV = cvlink
      WHERE "PersonID" = pid;
    END;

  PROCEDURE ILangPreInfo(pid IN VARCHAR2, PrefCode IN NUMBER) AS
    BEGIN
      UPDATE STUDENT
      SET
        "PrefCode" = PrefCode
      WHERE "PersonID" = pid;
      COMMIT;
    END;

  PROCEDURE ICONINFO(
    p_id    IN VARCHAR2,
    p_phone IN VARCHAR2,
    p_email IN NVARCHAR2,
    p_Add1  IN VARCHAR2,
    p_Add2  IN VARCHAR2,
    p_City  IN VARCHAR2,
    p_State IN VARCHAR2
  )
  AS
    BEGIN
      UPDATE PERSON
      SET
        "PhoneNo" = p_phone,
        "Email"   = p_email
      WHERE "PersonID" = p_id;
      UPDATE ADDRESS
      SET
        "StreetAddr1" = p_Add1,
        "StreetAddr2" = p_Add2,
        "City"        = p_City,
        "State"       = p_State
      WHERE "PersonID" = p_id;
      COMMIT;
    END;

END UPDATE_PEOPLE;
/

CREATE PACKAGE destroy AS
  PROCEDURE dAnnouncement(
    a_id IN NUMBER
  );

  PROCEDURE dApplication(
    a_id IN NUMBER
  );

  PROCEDURE dAttendance(
    session_id IN NUMBER,
    stud_id    IN VARCHAR2
  );

  PROCEDURE dContract(
    c_no IN NUMBER
  );

  PROCEDURE dInterview(
    i_id IN NUMBER
  );
  PROCEDURE dJob(
    a_id IN NUMBER
  );
  PROCEDURE dJob_Request(
    a_id IN NUMBER
  );
  PROCEDURE dJob_supervisor(
    job_id IN NUMBER,
    sup_id IN VARCHAR2
  );

  PROCEDURE dPerson(
    p_id IN VARCHAR2
  );

  PROCEDURE dRecord(
    a_id IN NUMBER
  );

  PROCEDURE dSession(
    s_id IN NUMBER
  );

  PROCEDURE dint_session(
    iv_id IN NUMBER
  );
END;
/

CREATE PACKAGE BODY destroy AS
  PROCEDURE dAnnouncement(
    a_id IN NUMBER
  )
  IS
    BEGIN
      -- Delete is set to cascade, so all child will also be removed.
      DELETE JOB_ANNOUNCEMENT
      WHERE "AncID" = a_id;
      COMMIT;
    END dAnnouncement;

  PROCEDURE dApplication(
    a_id IN NUMBER
  )
  IS
    BEGIN
      -- Delete is set to cascade, so all child will also be removed.
      DELETE JOB_APPLICATION
      WHERE "AppID" = a_id;
      COMMIT;
    END dApplication;

  PROCEDURE dAttendance(
    session_id IN NUMBER,
    stud_id    IN VARCHAR2
  )
  IS
    BEGIN
      -- Delete is set to cascade, so all child will also be removed.
      DELETE JOB_ATTENDANCE
      WHERE "SessionID" = session_id
            AND "StudentID" = stud_id;
      COMMIT;
    END dAttendance;

  PROCEDURE dContract(
    c_no IN NUMBER
  )
  IS
    BEGIN
      -- Need to delete contract first (safety)
      DELETE JOB_CONTRACT
      WHERE "CtrtNo" = c_no;
      COMMIT;
    END dContract;

  PROCEDURE dInterview(
    i_id IN NUMBER
  )
  IS
    BEGIN
      DELETE JOB_INTERVIEW
      WHERE "InterviewID" = i_id;
      COMMIT;
    END dInterview;

  PROCEDURE dJob(
    a_id IN NUMBER
  )
  IS
    BEGIN
      -- Delete is set to cascade, so all child will also be removed.
      DELETE JOB
      WHERE "JobID" = a_id;
      COMMIT;
    END dJob;

  PROCEDURE dJob_Request(
    a_id IN NUMBER
  )
  IS
    BEGIN
      -- Delete is set to cascade, so all child will also be removed.
      UPDATE JOB
      SET "IsValid" = 'D'
      WHERE "JobID" = a_id;
      COMMIT;
    END dJob_Request;

  PROCEDURE dJob_supervisor(
    job_id IN NUMBER,
    sup_id IN VARCHAR2
  )
  IS
    BEGIN
      DELETE JOB_SUPERVISE
      WHERE "JobID" = job_id
            AND "SupervisorID" = sup_id;
      COMMIT;
    END dJob_supervisor;

  PROCEDURE dPerson(
    p_id IN VARCHAR2
  )
  IS
    BEGIN
      -- Delete is set to cascade, so all child will also be removed.
      DELETE PERSON
      WHERE "PersonID" = p_id;
      COMMIT;
    END dPerson;

  PROCEDURE dRecord(
    a_id IN NUMBER
  )
  IS
    BEGIN
      -- Delete is set to cascade, so all child will also be removed.
      DELETE JOB_RECORD
      WHERE "RecordID" = a_id;
      COMMIT;
    END dRecord;

  PROCEDURE dint_session(
    iv_id IN NUMBER
  )
  IS
    BEGIN
      DELETE JOB_INTERVIEW_SESSION
      WHERE "IvSessionID" = iv_id;
      DELETE JOB_INTERVIEW
      WHERE "IvSessionID" = iv_id;
      COMMIT;
    END dint_session;

  PROCEDURE dSession(
    s_id IN NUMBER
  )
  IS
    BEGIN
      -- Delete is set to cascade, so all child will also be removed.
      DELETE JOB_SESSION
      WHERE "SessionID" = s_id;
      COMMIT;
    END dSession;

END destroy;
/

CREATE PACKAGE approve AS
  PROCEDURE job_changes(
    j_id     IN NUMBER,
    is_valid IN CHAR
  );

  PROCEDURE contract_changes(
    c_id     IN NUMBER,
    is_valid IN CHAR
  );
  PROCEDURE application(
    app_id   IN NUMBER,
    is_valid IN CHAR
  );

  PROCEDURE objection(
    obj_id  IN NUMBER,
    is_appr IN CHAR,
    reply   IN NVARCHAR2
  );

  PROCEDURE ViewNA_App(tableset OUT SYS_REFCURSOR);

  PROCEDURE ViewNA_Contract(tableset OUT SYS_REFCURSOR);

  PROCEDURE ViewNA_Job(tableset OUT SYS_REFCURSOR);

  PROCEDURE ViewNA_Objection(tableset OUT SYS_REFCURSOR);

END;
/

CREATE PACKAGE BODY approve AS
  PROCEDURE job_changes(
    j_id     IN NUMBER,
    is_valid IN CHAR
  )
  AS
    BEGIN
      UPDATE JOB
      SET
        "IsValid" = is_valid
      WHERE "JobID" = j_id;
      COMMIT;
    END;

  PROCEDURE contract_changes(
    c_id     IN NUMBER,
    is_valid IN CHAR
  )
  AS
    BEGIN
      UPDATE JOB_CONTRACT
      SET
        "IsValid" = is_valid
      WHERE "CtrtNo" = c_id;
      COMMIT;
    END;

  PROCEDURE application(
    app_id   IN NUMBER,
    is_valid IN CHAR
  )
  AS
    BEGIN
      UPDATE JOB_APPLICATION
      SET
        "IsValid" = is_valid
      WHERE "AppID" = app_id;
      COMMIT;
    END;

  PROCEDURE objection(
    obj_id  IN NUMBER,
    is_appr IN CHAR,
    reply   IN NVARCHAR2
  )
  AS
    BEGIN
      UPDATE SP_OBJECTION
      SET
        "IsApproved" = is_appr
      WHERE "ObjectionID" = obj_id;

      UPDATE OBJECTION
      SET
        "Reply" = reply
      WHERE "ObjectionID" = obj_id;
      COMMIT;
    END;

  PROCEDURE ViewNA_App(tableset OUT SYS_REFCURSOR) AS
    BEGIN
      OPEN tableset FOR
      SELECT
        "AppID",
        "JobID",
        "StudentID",
        "Score",
        "IsSuccessful",
        "IsValid"
      FROM JOB_APPLICATION
      WHERE "IsValid" = 'P';
    END;

  PROCEDURE ViewNA_Contract(tableset OUT SYS_REFCURSOR) AS
    BEGIN
      OPEN tableset FOR
      SELECT *
      FROM JOB_CONTRACT
      WHERE "IsValid" = 'P';
    END;

  PROCEDURE ViewNA_Job(tableset OUT SYS_REFCURSOR) AS
    BEGIN
      OPEN tableset FOR
      SELECT *
      FROM JOB
      WHERE "IsValid" = 'P';
    END;

  PROCEDURE ViewNA_Objection(tableset OUT SYS_REFCURSOR) AS
    BEGIN
      OPEN tableset FOR
      WITH needap AS (
          SELECT *
          FROM SP_OBJECTION
          WHERE "IsApproved" = 'P'
      )
      SELECT
        needap."ObjectionID",
        "RecordID",
        "Type",
        "Reason",
        "SupervisorID",
        "IsApproved"
      FROM OBJECTION
        RIGHT JOIN needap
          ON needap."ObjectionID" = OBJECTION."ObjectionID";
    END;


END approve;
/

CREATE PACKAGE JOB_LIST AS

  PROCEDURE ADD_JOB(
    V_NAME     IN NVARCHAR2,
    V_DESC     IN NVARCHAR2,
    V_HRSLR    IN NUMBER,
    V_HPW      IN NUMBER,
    V_MINWK    IN NUMBER,
    V_MAXWK    IN NUMBER,
    V_ISCON    IN CHAR,
    V_QUOTA    IN NUMBER,
    V_ISREQIV  IN CHAR,
    V_MINYR    IN NUMBER,
    V_PREFCODE IN NUMBER,
    V_ISOPEN   IN CHAR,
    V_APPDDL   IN VARCHAR2,
    PERSON_ID  IN VARCHAR2);

  PROCEDURE Assign_supervisor(
    job_id IN NUMBER,
    sup_id IN VARCHAR2
  );

  PROCEDURE Count_Jobs(
    FIL_REQIV    IN  INT := 0, -- 2 = 'Y'; 1 = 'N'; 0 = IGNORE
    FIL_ISCON    IN  INT := 0, -- 2 = 'Y'; 1 = 'N'; 0 = IGNORE
    FIL_LANGPREF IN  INT := 0, -- 1 = APPLY; 0 = IGNORE
    PERSON_ID    IN  VARCHAR2,
    OUT_COUNT    OUT INT
  );

  FUNCTION GET_JOB_BOARD(
    FIL_REQIV    IN INT := 0, -- 2 = 'Y'; 1 = 'N'; 0 = IGNORE
    FIL_ISCON    IN INT := 0, -- 2 = 'Y'; 1 = 'N'; 0 = IGNORE
    FIL_LANGPREF IN INT := 0, -- 1 = APPLY; 0 = IGNORE
    SRT_HRSLR    IN INT := 0, -- 1 = APPLY; 0 = IGNORE
    PERSON_ID    IN VARCHAR2 := NULL
  )
    RETURN JOB_BOARD;

  FUNCTION GET_JOB_BOARD_CUR(
    FIL_REQIV    IN INT := 0, -- 2 = 'Y'; 1 = 'N'; 0 = IGNORE
    FIL_ISCON    IN INT := 0, -- 2 = 'Y'; 1 = 'N'; 0 = IGNORE
    FIL_LANGPREF IN INT := 0, -- 1 = APPLY; 0 = IGNORE
    SRT_HRSLR    IN INT := 0, -- 1 = APPLY; 0 = IGNORE
    PERSON_ID    IN VARCHAR2
  )
    RETURN SYS_REFCURSOR;

  PROCEDURE Update_Job(
    job_id      IN NUMBER,
    name        IN NVARCHAR2,
    description IN NVARCHAR2,
    salary      IN NUMBER,
    hrPerWeek   IN NUMBER,
    minWeek     IN NUMBER,
    maxWeek     IN NUMBER,
    iscon       IN CHAR,
    quota       IN NUMBER,
    isint       IN CHAR,
    minyear     IN NUMBER,
    code        IN NUMBER,
    io          IN CHAR,
    dln         IN VARCHAR2,
    person_id   IN VARCHAR2
  );

  PROCEDURE View_Jobs(
    START_POS    IN INT := 1, -- STARTING ROW NUMBER
    ITEM_COUNT   IN INT, -- AMOUNT OF JOBS TO RETURN
    FIL_REQIV    IN INT := 0, -- 2 = 'Y'; 1 = 'N'; 0 = IGNORE
    FIL_ISCON    IN INT := 0, -- 2 = 'Y'; 1 = 'N'; 0 = IGNORE
    FIL_LANGPREF IN INT := 0, -- 1 = APPLY; 0 = IGNORE
    SRT_HRSLR    IN INT := 0, -- 1 = APPLY; 0 = IGNORE
    PERSON_ID    IN VARCHAR2,
    OUT_TABLE    OUT SYS_REFCURSOR
  );

  PROCEDURE VIEW_JOB_DETAIL(
    JOB_ID    IN INT,
    PERSON_ID IN VARCHAR2,
    OUT_TABLE OUT SYS_REFCURSOR
  );

  PROCEDURE Close_Job(
    job_id IN NUMBER
  );

END;
/

CREATE PACKAGE BODY JOB_LIST AS
  PROCEDURE ADD_JOB(
    V_NAME     IN NVARCHAR2,
    V_DESC     IN NVARCHAR2,
    V_HRSLR    IN NUMBER,
    V_HPW      IN NUMBER,
    V_MINWK    IN NUMBER,
    V_MAXWK    IN NUMBER,
    V_ISCON    IN CHAR,
    V_QUOTA    IN NUMBER,
    V_ISREQIV  IN CHAR,
    V_MINYR    IN NUMBER,
    V_PREFCODE IN NUMBER,
    V_ISOPEN   IN CHAR,
    V_APPDDL   IN VARCHAR2,
    PERSON_ID  IN VARCHAR2
  ) AS
    V_USERTYPE CHAR(4);
    V_ISVALID  CHAR(1);
    BEGIN
      SELECT "Type"
      INTO V_USERTYPE
      FROM PERSON
      WHERE "PersonID" = person_id;
      IF V_USERTYPE = 'ADMI'
      THEN
        V_ISVALID := 'Y';
      ELSIF V_USERTYPE = 'SUPE'
        THEN
          V_ISVALID := 'P';
      ELSE
        V_ISVALID := 'N';
      END IF;
      INSERT INTO JOB ("JobID", "Name", "Description", "HrSalary", "HrPerWeek", "MinWeek", "MaxWeek", "IsContinuous", "Quota", "IsReqInterview", "MinStudyYear", "PrefCode", "IsValid", "LastModDate", "IsOpen", "AppDeadline")
      VALUES
        ("jobSequence".nextval, V_NAME, V_DESC, V_HRSLR, V_HPW, V_MINWK, V_MAXWK, V_ISCON, V_QUOTA, V_ISREQIV, V_MINYR,
          V_PREFCODE, V_ISVALID, SYSDATE, V_ISOPEN, TO_DATE(V_APPDDL, 'YYYY-MM-DD HH24:MI:SS'));
      COMMIT;
    END ADD_JOB;

  PROCEDURE Assign_supervisor(
    job_id IN NUMBER,
    sup_id IN VARCHAR2
  )
  IS
    BEGIN
      INSERT INTO JOB_SUPERVISE ("JobID", "SupervisorID")
      VALUES (job_id, sup_id);

      COMMIT;
    END;

  PROCEDURE Count_Jobs(
    FIL_REQIV    IN  INT := 0, -- 2 = 'Y'; 1 = 'N'; 0 = IGNORE
    FIL_ISCON    IN  INT := 0, -- 2 = 'Y'; 1 = 'N'; 0 = IGNORE
    FIL_LANGPREF IN  INT := 0, -- 1 = APPLY; 0 = IGNORE
    PERSON_ID    IN  VARCHAR2,
    OUT_COUNT    OUT INT
  )
  AS
    BEGIN
      SELECT count(*)
      INTO OUT_COUNT
      FROM TABLE (JOB_LIST.GET_JOB_BOARD(FIL_REQIV, FIL_ISCON, FIL_LANGPREF, 0, PERSON_ID));
    END;

  FUNCTION GET_JOB_BOARD(
    FIL_REQIV    IN INT := 0, -- 2 = 'Y'; 1 = 'N'; 0 = IGNORE
    FIL_ISCON    IN INT := 0, -- 2 = 'Y'; 1 = 'N'; 0 = IGNORE
    FIL_LANGPREF IN INT := 0, -- 1 = APPLY; 0 = IGNORE
    SRT_HRSLR    IN INT := 0, -- 1 = APPLY; 0 = IGNORE
    PERSON_ID    IN VARCHAR2 := NULL
  )
    RETURN JOB_BOARD IS
    V_JOBBOARD JOB_BOARD := JOB_BOARD();
    V_COUNT    NUMBER := 0;
    V_RC SYS_REFCURSOR;
    V_ROWNO    NUMBER;
    V_JOBID    NUMBER;
    V_NAME     NVARCHAR2(32);
    V_HRSALARY NUMBER;
    V_REQIV    CHAR(1);
    V_ISCON    CHAR(1);
    BEGIN
      V_RC := JOB_LIST.GET_JOB_BOARD_CUR(FIL_REQIV, FIL_ISCON, FIL_LANGPREF, SRT_HRSLR, PERSON_ID);
      LOOP
        FETCH V_RC INTO V_ROWNO, V_JOBID, V_NAME, V_HRSALARY, V_REQIV, V_ISCON;
        EXIT WHEN V_RC%NOTFOUND;
        V_JOBBOARD.extend;
        V_COUNT := V_COUNT + 1;
        V_JOBBOARD(V_COUNT) := JOB_BOARD_REC(V_ROWNO, V_JOBID, V_NAME, V_HRSALARY, V_REQIV, V_ISCON);
      END LOOP;
      CLOSE V_RC;
      RETURN V_JOBBOARD;
    END;

  FUNCTION GET_JOB_BOARD_CUR(
    FIL_REQIV    IN INT := 0, -- 2 = 'Y'; 1 = 'N'; 0 = IGNORE
    FIL_ISCON    IN INT := 0, -- 2 = 'Y'; 1 = 'N'; 0 = IGNORE
    FIL_LANGPREF IN INT := 0, -- 1 = APPLY; 0 = IGNORE
    SRT_HRSLR    IN INT := 0, -- 1 = APPLY; 0 = IGNORE
    PERSON_ID    IN VARCHAR2
  )
    RETURN SYS_REFCURSOR
  IS
    view_query VARCHAR2(2048);
    user_type  VARCHAR2(4);
    V_RC SYS_REFCURSOR;
    BEGIN
      SELECT "Type"
      INTO user_type
      FROM PERSON
      WHERE "PersonID" = PERSON_ID;
      IF user_type = 'STUD'
      THEN -- major restriction not implemented yet
        view_query := 'SELECT * FROM (
        SELECT row_number() OVER (ORDER BY ';
        IF SRT_HRSLR = 1
        THEN
          view_query := view_query || '"HrSalary" DESC, ';
        END IF;
        view_query := view_query || '"JobID" DESC) RNO, "JobID", "Name", "HrSalary", "IsReqInterview", "IsContinuous"
        FROM JOB WHERE "JobID" IN (
          SELECT "JobID" FROM JOB WHERE "JobID" IN (
            SELECT "JobID" FROM JOB WHERE "JobID" IN (
              SELECT "JobID" FROM JOB_MAJOR_REQ WHERE "MajorID" IN (
                SELECT "MajorID" FROM STUDENT
                  WHERE ''' || PERSON_ID || ''' = "PersonID"
              )
            )
            UNION
            SELECT "JobID" FROM JOB WHERE "JobID" NOT IN (
              SELECT DISTINCT "JobID" FROM JOB_MAJOR_REQ
            )
          ) AND "JobID" NOT IN (
            SELECT "JobID" FROM JOB_CONTRACT
              WHERE "StudentID" = ''' || PERSON_ID || ''' AND "IsActive" = ''Y'' AND "IsValid" = ''Y''
            UNION
            SELECT "JobID" FROM JOB_APPLICATION
              WHERE "StudentID" = ''' || PERSON_ID || ''' AND "IsSuccessful" = ''P''
          )
        ) AND "IsOpen"=''Y'' AND "IsValid"=''Y'' AND UTIL.STUDY_YEAR_CHECK(''' || PERSON_ID || ''', "JobID") = 1 ';
      ELSE
        view_query := 'SELECT * FROM (
      SELECT row_number() OVER (ORDER BY ';
        IF SRT_HRSLR = 1
        THEN
          view_query := view_query || '"HrSalary" DESC, ';
        END IF;
        view_query := view_query || '"JobID" DESC) RNO, "JobID", "Name", "HrSalary", "IsReqInterview", "IsContinuous"
      FROM JOB WHERE "IsValid"!=''N''';
      END IF;
      IF FIL_REQIV = 2
      THEN
        view_query := view_query || ' AND "IsReqInterview"=''Y''';
      ELSIF FIL_REQIV = 1
        THEN
          view_query := view_query || ' AND "IsReqInterview"=''N''';
      END IF;
      IF FIL_ISCON = 2
      THEN
        view_query := view_query || ' AND "IsContinuous"=''Y''';
      ELSIF FIL_ISCON = 1
        THEN
          view_query := view_query || ' AND "IsContinuous"=''N''';
      END IF;
      -- language pref
      IF FIL_LANGPREF = 1
      THEN
        view_query := view_query || ' AND UTIL.LANG_PREF_CHECK(''' || PERSON_ID || ''', "JobID") = 1';
      END IF;
      IF SRT_HRSLR = 1
      THEN
        view_query := view_query || ' ORDER BY "HrSalary" DESC, "JobID" DESC)';
      ELSE
        view_query := view_query || ' ORDER BY "JobID" DESC)';
      END IF;
      OPEN V_RC FOR view_query;
      RETURN V_RC;
    END;

  PROCEDURE Update_Job(
    job_id      IN NUMBER,
    name        IN NVARCHAR2,
    description IN NVARCHAR2,
    salary      IN NUMBER,
    hrPerWeek   IN NUMBER,
    minWeek     IN NUMBER,
    maxWeek     IN NUMBER,
    iscon       IN CHAR,
    quota       IN NUMBER,
    isint       IN CHAR,
    minyear     IN NUMBER,
    code        IN NUMBER,
    io          IN CHAR,
    dln         IN VARCHAR2,
    person_id   IN VARCHAR2
  )
  AS
    V_USERTYPE CHAR(4);
    V_ISVALID  CHAR(1);
    BEGIN
      SELECT "Type"
      INTO V_USERTYPE
      FROM PERSON
      WHERE "PersonID" = person_id;
      IF V_USERTYPE = 'ADMI'
      THEN
        V_ISVALID := 'Y';
      ELSIF V_USERTYPE = 'SUPE'
        THEN
          V_ISVALID := 'P';
      ELSE
        V_ISVALID := 'N';
      END IF;
      UPDATE JOB
      SET
        "Name"           = name,
        "Description"    = description,
        "HrSalary"       = salary,
        "HrPerWeek"      = hrPerWeek,
        "MinWeek"        = minWeek,
        "MaxWeek"        = maxWeek,
        "IsContinuous"   = iscon,
        "Quota"          = quota,
        "IsReqInterview" = isint,
        "MinStudyYear"   = minyear,
        "PrefCode"       = code,
        "LastModDate"    = SYSDATE,
        "IsOpen"         = io,
        "AppDeadline"    = TO_DATE(dln, 'YYYY-MM-DD HH24:MI:SS'),
        "IsValid"        = V_ISVALID
      WHERE "JobID" = job_id;
      COMMIT;
    END;

  PROCEDURE VIEW_JOB_DETAIL(
    JOB_ID    IN INT,
    PERSON_ID IN VARCHAR2,
    OUT_TABLE OUT SYS_REFCURSOR
  )
  AS
    view_query VARCHAR2(512);
    user_type  VARCHAR2(4);
    BEGIN
      SELECT "Type"
      INTO user_type
      FROM PERSON
      WHERE "PersonID" = PERSON_ID;
      view_query :=
      'SELECT "JobID", "Name", "Description", "HrSalary", "HrPerWeek", "MinWeek", "MaxWeek", "IsContinuous", "Quota", "IsReqInterview", "MinStudyYear", "PrefCode", "IsValid", TO_CHAR("LastModDate", ''YYYY-MM-DD HH24:MI:SS''), "IsOpen", TO_CHAR("AppDeadline", ''YYYY-MM-DD HH24:MI:SS'') FROM JOB WHERE "JobID" = '
      || to_char(JOB_ID);
      OPEN OUT_TABLE FOR view_query;
    END;

  PROCEDURE View_Jobs(
    START_POS    IN INT := 1, -- STARTING ROW NUMBER
    ITEM_COUNT   IN INT, -- AMOUNT OF JOBS TO RETURN
    FIL_REQIV    IN INT := 0, -- 2 = 'Y'; 1 = 'N'; 0 = IGNORE
    FIL_ISCON    IN INT := 0, -- 2 = 'Y'; 1 = 'N'; 0 = IGNORE
    FIL_LANGPREF IN INT := 0, -- 1 = APPLY; 0 = IGNORE
    SRT_HRSLR    IN INT := 0, -- 1 = APPLY; 0 = IGNORE
    PERSON_ID    IN VARCHAR2,
    OUT_TABLE    OUT SYS_REFCURSOR
  )
  AS
    view_query VARCHAR2(2048);
    BEGIN
      view_query := 'SELECT "JobID", "Name", "HrSalary", "IsReqInterview", "IsContinuous" ' ||
                    'FROM TABLE(JOB_LIST.GET_JOB_BOARD(' || FIL_REQIV || ', ' || FIL_ISCON || ', ' || FIL_LANGPREF ||
                    ', ' || SRT_HRSLR || ', ''' || PERSON_ID || ''')) WHERE ' ||
                    ' "RowNo" >= ' || to_char(START_POS) || ' AND "RowNo" < ' || to_char(START_POS + ITEM_COUNT);
      OPEN OUT_TABLE FOR view_query;
    END;

  PROCEDURE Close_Job(
    job_id IN NUMBER
  )
  AS
    BEGIN
      UPDATE JOB
      SET
        "LastModDate" = SYSDATE,
        "IsOpen"      = 'N'
      WHERE "JobID" = job_id;
      COMMIT;
    END;

END JOB_LIST;
/

CREATE PACKAGE JOB_APPLY AS
  -- Submit application part
  PROCEDURE SUBMIT_APP(JobID IN NUMBER, StudentID IN VARCHAR2, CovLetter IN VARCHAR2);
  FUNCTION NO_WORK(StudentID IN VARCHAR2)
    RETURN BOOLEAN;

  --Add or update interview session
  PROCEDURE Add_IntSession(job_id IN NUMBER, dt IN VARCHAR2, venue IN VARCHAR2, quota IN NUMBER, hr IN NUMBER);
  PROCEDURE Update_IntSession(ivs_id IN NUMBER, dt IN VARCHAR2, venue IN VARCHAR2, quota IN NUMBER, hr IN NUMBER);

  --Choose session and do interview
  PROCEDURE Choose_Session(StdID IN VARCHAR2, IvSessionID IN NUMBER);
  FUNCTION Have_Place(IvSessionID IN NUMBER)
    RETURN BOOLEAN;
  PROCEDURE Change_Session(inv_id IN NUMBER, ses_id IN NUMBER);

  --Score interview
  PROCEDURE Score_Interview(inv_id IN NUMBER, score IN NUMBER, remark IN NVARCHAR2);
  PROCEDURE Int_Status(appid IN NUMBER, tableset OUT SYS_REFCURSOR);
  PROCEDURE Int_Result(appid IN NUMBER, tableset OUT SYS_REFCURSOR);

  --Score applicant
  PROCEDURE Score_App(app_id IN NUMBER, score IN NUMBER, succ IN CHAR);
  PROCEDURE App_Info(appid IN NUMBER, tableset OUT SYS_REFCURSOR);
  PROCEDURE App_Result(appid IN NUMBER, tableset OUT SYS_REFCURSOR);

END;
/

CREATE PACKAGE BODY JOB_APPLY AS

  PROCEDURE SUBMIT_APP(
    JobID     IN NUMBER,
    StudentID IN VARCHAR2,
    CovLetter IN VARCHAR2)
  AS
    BEGIN
      INSERT INTO JOB_APPLICATION ("AppID", "JobID", "StudentID", "CoverLetter", "Score", "IsSuccessful", "IsValid")
      VALUES ("appSequence".nextval, JobID, StudentID, CovLetter, 0, 'P', 'P');

      COMMIT;
    END;

  FUNCTION NO_WORK(StudentID IN VARCHAR2)
    RETURN BOOLEAN AS
    RESULT NUMBER;
    BEGIN
      RESULT := 0;
      SELECT MAX("StudentID")
      INTO RESULT
      FROM JOB_CONTRACT
      WHERE StudentID = "StudentID";

      IF RESULT = 0
      THEN
        RETURN TRUE;
      ELSE
        RETURN FALSE;
      END IF;

    END;

  PROCEDURE Add_IntSession(job_id IN NUMBER, dt IN VARCHAR2, venue IN VARCHAR2, quota IN NUMBER, hr IN NUMBER) AS
    BEGIN
      INSERT INTO JOB_INTERVIEW_SESSION ("IvSessionID", "JobID", "Date", "Venue", "Quota", "Hours")
      VALUES ("intSesSequence".nextval, job_id, TO_DATE(dt, 'YYYY-MM-DD HH24:MI:SS'), venue, quota, hr);

      COMMIT;
    END;

  PROCEDURE UPDATE_INTSESSION(ivs_id IN NUMBER, dt IN VARCHAR2, venue IN VARCHAR2, quota IN NUMBER, hr IN NUMBER) AS
    BEGIN
      UPDATE JOB_INTERVIEW_SESSION
      SET
        "Date"  = TO_DATE(dt, 'YYYY-MM-DD HH24:MI:SS'),
        "Venue" = venue,
        "Quota" = quota,
        "Hours" = hr
      WHERE "IvSessionID" = ivs_id;

      COMMIT;
    END;

  PROCEDURE Choose_Session(StdID IN VARCHAR2, IvSessionID IN NUMBER) AS
    AppID NUMBER;
    BEGIN
      SELECT TO_NUMBER(max("AppID"))
      INTO AppID
      FROM JOB_APPLICATION
      WHERE StdID = "StudentID";

      IF JOB_APPLY.HAVE_PLACE(IvSessionID)
      THEN
        INSERT INTO JOB_INTERVIEW ("InterviewID", "AppID", "Score", "Remark", "IvSessionID")
        VALUES ("intSequence".nextval, AppID, 0, 'Have not updated', IvSessionID);
      END IF;

      COMMIT;
    END;

  FUNCTION Have_Place(IvSessionID IN NUMBER)
    RETURN BOOLEAN AS
    MAXNUMBER NUMBER;
    StdCount  NUMBER;
    BEGIN
      SELECT TO_NUMBER(MAX("Quota"))
      INTO MAXNUMBER
      FROM JOB_INTERVIEW_SESSION
      WHERE IvSessionID = "IvSessionID";

      SELECT TO_NUMBER(count(*))
      INTO StdCount
      FROM JOB_INTERVIEW
      WHERE IvSessionID = "IvSessionID";

      RETURN StdCount < MAXNUMBER;
    END;

  PROCEDURE CHANGE_SESSION(inv_id IN NUMBER, ses_id IN NUMBER) AS
    BEGIN
      UPDATE JOB_INTERVIEW
      SET
        "IvSessionID" = ses_id
      WHERE "InterviewID" = inv_id;

      COMMIT;
    END;

  PROCEDURE SCORE_INTERVIEW(inv_id IN NUMBER, score IN NUMBER, remark IN NVARCHAR2) AS
    BEGIN
      UPDATE JOB_INTERVIEW
      SET
        "Score"  = score,
        "Remark" = remark
      WHERE "InterviewID" = inv_id;

      COMMIT;
    END;

  PROCEDURE Int_Status(appid IN NUMBER, tableset OUT SYS_REFCURSOR) AS
    BEGIN
      OPEN tableset FOR
      SELECT
        I."AppID",
        S."Date",
        S."Venue",
        S."Hours"
      FROM JOB_INTERVIEW_SESSION S, JOB_INTERVIEW I
      WHERE S."IvSessionID" = I."IvSessionID"
            AND "InterviewID" = AppID;
    END;

  PROCEDURE Int_Result(appid IN NUMBER, tableset OUT SYS_REFCURSOR) AS
    BEGIN
      OPEN tableset FOR
      SELECT
        "AppID",
        "Score",
        "Remark"
      FROM JOB_INTERVIEW
      WHERE "InterviewID" = appID;
    END;

  PROCEDURE Score_App(app_id IN NUMBER, score IN NUMBER, succ IN CHAR) AS
    isValid CHAR;
    BEGIN
      IF succ = 'N'
      THEN
        isValid := 'N';
      ELSE
        isValid := 'P';
      END IF;

      UPDATE JOB_APPLICATION
      SET
        "Score"        = score,
        "IsSuccessful" = succ,
        "IsValid"      = isValid
      WHERE "AppID" = app_id;

      COMMIT;
    END;

  PROCEDURE App_Info(AppID IN NUMBER, tableset OUT SYS_REFCURSOR) AS
    BEGIN
      OPEN tableset FOR
      SELECT
        "AppID",
        "JobID",
        "StudentID",
        "CoverLetter"
      FROM JOB_APPLICATION
      WHERE "AppID" = AppID;
    END;

  PROCEDURE App_Result(AppID IN NUMBER, tableset OUT SYS_REFCURSOR) AS
    BEGIN
      OPEN tableset FOR
      SELECT
        "AppID",
        "JobID",
        "StudentID",
        "Score",
        "IsSuccessful"
      FROM JOB_APPLICATION
      WHERE "AppID" = AppID;
    END;
END JOB_APPLY;
/

CREATE PACKAGE JOB_MANAGE AS

  PROCEDURE SIGN_CONTRACT(
    job_id     IN NUMBER,
    stud_id    IN VARCHAR2,
    sup_id     IN VARCHAR2,
    hr         IN NUMBER,
    week       IN NUMBER,
    start_date IN VARCHAR2,
    end_date   IN VARCHAR2,
    remark     IN NVARCHAR2,
    hrsalary   IN NUMBER
  );

  PROCEDURE TERMINATE_CONTRACT(ctrl_no IN NUMBER);

  PROCEDURE VContract(StdID IN VARCHAR2, tableset OUT SYS_REFCURSOR);

  PROCEDURE ADD_ANNOUNCEMENT(job_id IN NUMBER, sup_id IN VARCHAR2, msg IN NVARCHAR2);

  PROCEDURE UPDATE_ANNOUNCEMENT(anc_id IN NUMBER, msg IN NVARCHAR2);

  PROCEDURE VAnno(StdID IN VARCHAR2, tableset OUT SYS_REFCURSOR);

  PROCEDURE TAKE_ATTENDANCE(
    session_id IN NUMBER,
    stud_id    IN VARCHAR2,
    ispresent  IN CHAR,
    att_hr     IN NUMBER,
    remark     IN NVARCHAR2
  );

  PROCEDURE UPDATE_ATTENDANCE(ses_id    IN NUMBER, stud_id IN VARCHAR2,
                              is_attend IN CHAR, hr IN NUMBER, remark IN VARCHAR2);

  PROCEDURE VAttenRec(StdID IN VARCHAR2, tableset OUT SYS_REFCURSOR);

  PROCEDURE Take_Leave(StdID   IN VARCHAR2, Job_ID IN NUMBER, Reason IN VARCHAR2, StartDate IN VARCHAR2,
                       EndDate IN VARCHAR2);

  PROCEDURE APPROVE_LEAVE(lv_no IN NUMBER, is_valid IN CHAR);

  PROCEDURE Add_Job_Session(
    job_id  IN NUMBER,
    sup_id  IN VARCHAR2,
    s_date  IN VARCHAR2,
    s_hr    IN NUMBER,
    s_venue IN VARCHAR2,
    s_desc  IN VARCHAR2
  );

  PROCEDURE Update_Job_Session(ses_id IN NUMBER, sup_id IN VARCHAR2,
                               dt     IN VARCHAR2, hr IN NUMBER, venue IN VARCHAR2, msg IN VARCHAR2);

  PROCEDURE VJobSession(StdID IN VARCHAR2, tableset OUT SYS_REFCURSOR);

  PROCEDURE TAKE_RECORD(job_id  IN NUMBER,
                        stud_id IN VARCHAR2,
                        sup_id  IN VARCHAR2,
                        r_date  IN VARCHAR2,
                        r_type  IN VARCHAR2,
                        r_desc  IN NVARCHAR2,
                        r_pay   IN FLOAT);

  PROCEDURE STUDENT_OBJECT(rec_id IN NUMBER, reason IN NVARCHAR2);

  PROCEDURE SUPERVISOR_OBJECT(rec_id IN NUMBER, reason IN NVARCHAR2, sur_id IN VARCHAR2);

  PROCEDURE SUPERVISOR_REPLY(obj_id IN NUMBER, reply IN NVARCHAR2);

  PROCEDURE ADMIN_REPLY(obj_id IN NUMBER, isvalid IN CHAR, reply IN NVARCHAR2);

  PROCEDURE VMonSalary(StdID IN VARCHAR2, tableset OUT SYS_REFCURSOR);

  FUNCTION MONSALARY(HOURS IN NUMBER, HrSalary IN NUMBER)
    RETURN NUMBER;

  PROCEDURE VPersonInfo(StdID IN VARCHAR2, tableset OUT SYS_REFCURSOR);

  PROCEDURE Int_Status(StdID IN VARCHAR2, tableset OUT SYS_REFCURSOR);

  PROCEDURE Int_Result(StdID IN VARCHAR2, tableset OUT SYS_REFCURSOR);

  PROCEDURE VPERREVIEW(StdID IN VARCHAR2, tableset OUT SYS_REFCURSOR);

END JOB_MANAGE;
/

CREATE PACKAGE BODY JOB_MANAGE AS

  PROCEDURE SIGN_CONTRACT(
    job_id     IN NUMBER,
    stud_id    IN VARCHAR2,
    sup_id     IN VARCHAR2,
    hr         IN NUMBER,
    week       IN NUMBER,
    start_date IN VARCHAR2,
    end_date   IN VARCHAR2,
    remark     IN NVARCHAR2,
    hrsalary   IN NUMBER
  )
  IS
    BEGIN
      INSERT INTO JOB_CONTRACT ("CtrtNo", "JobID", "StudentID", "SupervisorID", "HrPerWeek", "Weeks", "StartDate", "EndDate", "IsActive", "Remark", "IsValid", "HrSalary")
      VALUES ("contractSequence".nextval, job_id, stud_id, sup_id, hr, week, TO_DATE(start_date, 'YYYY-MM-DD'),
        TO_DATE(end_date, 'YYYY-MM-DD'), 'Y', remark, 'P', hrsalary);

      COMMIT;
    END;

  PROCEDURE TERMINATE_CONTRACT(ctrl_no IN NUMBER) AS
    BEGIN
      UPDATE JOB_CONTRACT
      SET
        "IsActive" = 'N'
      WHERE "CtrtNo" = ctrl_no;
      COMMIT;
    END;

  PROCEDURE VContract(StdID IN VARCHAR2, tableset OUT SYS_REFCURSOR) AS
    BEGIN
      OPEN tableset FOR
      SELECT
        "HrPerWeek",
        "HrSalary",
        "StartDate",
        "EndDate"
      FROM JOB_CONTRACT
      WHERE "StudentID" = StdID;
    END;

  PROCEDURE add_Announcement(
    job_id IN NUMBER,
    sup_id IN VARCHAR2,
    msg    IN NVARCHAR2
  )
  IS
    BEGIN
      INSERT INTO JOB_ANNOUNCEMENT ("AncID", "JobID", "SupervisorID", "Message")
      VALUES ("annSequence".nextval, job_id, sup_id, msg);

      COMMIT;
    END add_Announcement;

  PROCEDURE UPDATE_ANNOUNCEMENT(anc_id IN NUMBER, msg IN NVARCHAR2) AS
    BEGIN
      UPDATE JOB_ANNOUNCEMENT
      SET
        "Message" = msg
      WHERE "AncID" = anc_id;
      COMMIT;
    END;

  PROCEDURE VAnno(StdID IN VARCHAR2, tableset OUT SYS_REFCURSOR) AS
    BEGIN
      OPEN tableset FOR
      SELECT
        A."AncID",
        B."Name" AS "Job Name",
        P."FirstName",
        P."LastName",
        A."Message"
      FROM JOB_ANNOUNCEMENT A, JOB B, JOB_CONTRACT C, PERSON P
      WHERE A."JobID" = B."JobID"
            AND A."SupervisorID" = P."PersonID"
            AND C."JobID" = B."JobID"
            AND C."StudentID" = StdID;
    END;

  PROCEDURE TAKE_ATTENDANCE(session_id IN NUMBER,
                            stud_id    IN VARCHAR2,
                            ispresent  IN CHAR,
                            att_hr     IN NUMBER,
                            remark     IN NVARCHAR2
  )
  IS
    BEGIN
      INSERT INTO JOB_ATTENDANCE ("SessionID", "StudentID", "IsPresent", "AttendHours", "Remark")
      VALUES (session_id, stud_id, ispresent, att_hr, remark);
      COMMIT;
    END;

  PROCEDURE UPDATE_ATTENDANCE(ses_id    IN NUMBER, stud_id IN VARCHAR2,
                              is_attend IN CHAR, hr IN NUMBER, remark IN VARCHAR2) AS
    BEGIN
      UPDATE JOB_ATTENDANCE
      SET
        "IsPresent"   = is_attend,
        "AttendHours" = hr,
        "Remark"      = remark
      WHERE "SessionID" = ses_id
            AND "StudentID" = stud_id;
      COMMIT;
    END;

  PROCEDURE VAttenRec(StdID IN VARCHAR2, tableset OUT SYS_REFCURSOR) AS
    BEGIN
      OPEN tableset FOR
      SELECT *
      FROM JOB_ATTENDANCE
      WHERE StdID = "StudentID";
    END;

  PROCEDURE Take_Leave(StdID   IN VARCHAR2, Job_ID IN NUMBER, Reason IN VARCHAR2, StartDate IN VARCHAR2,
                       EndDate IN VARCHAR2) AS
    SupervisorID VARCHAR2(16);
    BEGIN
      SELECT MAX("SupervisorID")
      INTO SupervisorID
      FROM JOB A, JOB_CONTRACT B
      WHERE A."JobID" = B."JobID" AND A."JobID" = Job_ID;
      IF StartDate > TO_CHAR(SYSDATE)
      THEN
        INSERT INTO JOB_LEAVE ("JobID", "StudentID", "SupervisorID", "Reason", "StartDate", "EndDate", "IsApproved", "LeaveNo")
        VALUES (Job_ID, StdID, SupervisorID, Reason, TO_DATE(StartDate, 'YYYY-MM-DD HH24:MI:SS'),
          TO_DATE(EndDate, 'YYYY-MM-DD HH24:MI:SS'), 'P', "leaveSequence".nextval);
      END IF;
      COMMIT;
    END;

  PROCEDURE APPROVE_LEAVE(lv_no IN NUMBER, is_valid IN CHAR) AS
    BEGIN
      UPDATE JOB_LEAVE
      SET
        "IsApproved" = is_valid
      WHERE "LeaveNo" = lv_no;
      COMMIT;
    END;

  PROCEDURE Add_Job_Session(
    job_id  IN NUMBER,
    sup_id  IN VARCHAR2,
    s_date  IN VARCHAR2,
    s_hr    IN NUMBER,
    s_venue IN VARCHAR2,
    s_desc  IN VARCHAR2
  )
  IS
    BEGIN
      INSERT INTO JOB_SESSION ("SessionID", "JobID", "SupervisorID", "Date", "Hours", "Venue", "Desc")
      VALUES
        ("sessionSequence".nextval, job_id, sup_id, TO_DATE(s_date, 'YYYY-MM-DD HH24:MI:SS'), s_hr, s_venue, s_desc);

      COMMIT;
    END;

  PROCEDURE Update_Job_Session(ses_id IN NUMBER, sup_id IN VARCHAR2,
                               dt     IN VARCHAR2, hr IN NUMBER, venue IN VARCHAR2, msg IN VARCHAR2) AS
    BEGIN
      UPDATE JOB_SESSION
      SET
        "SessionID"    = ses_id,
        "SupervisorID" = sup_id,
        "Date"         = dt,
        "Hours"        = hr,
        "Venue"        = venue,
        "Desc"         = msg
      WHERE "SessionID" = ses_id;
      COMMIT;
    END;

  PROCEDURE VJobSession(StdID IN VARCHAR2, tableset OUT SYS_REFCURSOR) AS
    BEGIN
      OPEN tableset FOR
      SELECT
        A."Date",
        A."Hours",
        A."Venue"
      FROM JOB_SESSION A, JOB B, JOB_CONTRACT C
      WHERE A."JobID" = B."JobID" AND B."JobID" = C."JobID"
            AND C."StudentID" = StdID;
    END;

  PROCEDURE TAKE_RECORD(
    job_id  IN NUMBER,
    stud_id IN VARCHAR2,
    sup_id  IN VARCHAR2,
    r_date  IN VARCHAR2,
    r_type  IN VARCHAR2,
    r_desc  IN NVARCHAR2,
    r_pay   IN FLOAT
  )
  IS
    BEGIN
      INSERT INTO JOB_RECORD ("RecordID", "JobID", "StudentID", "SupervisorID", "Date", "Type", "Desc", "Payment", "IsValid")
      VALUES ("recSequence".nextval, job_id, stud_id, sup_id, TO_DATE(r_date, 'YYYY-MM-DD HH24:MI:SS'), r_type, r_desc,
        r_pay, 'P');

      COMMIT;
    END;

  PROCEDURE STUDENT_OBJECT(rec_id IN NUMBER, reason IN NVARCHAR2) AS
    BEGIN
      INSERT INTO OBJECTION
      VALUES ("objectionSequence".nextval, rec_id, 'A', reason, NULL);
      COMMIT;
    END;

  PROCEDURE SUPERVISOR_OBJECT(rec_id IN NUMBER, reason IN NVARCHAR2, sur_id IN VARCHAR2) AS
    obj_id  NUMBER;
    obj_id1 NUMBER;
    BEGIN
      obj_id := "objectionSequence".nextval;
      INSERT INTO OBJECTION
      VALUES (obj_id, rec_id, 'B', reason, NULL)
      RETURNING "ObjectionID" INTO obj_id1;

      INSERT INTO SP_OBJECTION
      VALUES (obj_id1, sur_id, 'P');
      COMMIT;
    END;

  PROCEDURE SUPERVISOR_REPLY(obj_id IN NUMBER, reply IN NVARCHAR2) AS
    BEGIN
      UPDATE OBJECTION
      SET
        "Reply" = reply
      WHERE "ObjectionID" = obj_id;
      COMMIT;
    END;

  PROCEDURE ADMIN_REPLY(obj_id IN NUMBER, isvalid IN CHAR, reply IN NVARCHAR2) AS
    BEGIN
      UPDATE OBJECTION
      SET
        "Reply" = reply
      WHERE "ObjectionID" = obj_id;

      UPDATE SP_OBJECTION
      SET
        "IsApproved" = isvalid
      WHERE "ObjectionID" = obj_id;

      COMMIT;
    END;


  PROCEDURE VMonSalary(StdID IN VARCHAR2, tableset OUT SYS_REFCURSOR)
  AS
    CURSOR sumhour IS SELECT
                        "JobID",
                        SUM("Hours")
                      FROM JOB_SESSION
                      WHERE TO_CHAR("Date", 'YEAR') = TO_CHAR(SYSDATE, 'YEAR')
                            AND to_char("Date", 'MONTH') = TO_CHAR(SYSDATE, 'MONTH');
    BEGIN
      OPEN tableset FOR
      SELECT
        A."JobID",
        JOB_MANAGE.MONSALARY(A."Hours", B."HrSalary")
      FROM JOB_SESSION A, JOB_CONTRACT B
      WHERE A."JobID" = B."JobID"
            AND B."StudentID" = StdID;
    END;

  FUNCTION MONSALARY(HOURS IN NUMBER, HrSalary IN NUMBER)
    RETURN NUMBER AS
    BEGIN
      RETURN HOURS * HrSalary;
    END;

  PROCEDURE VPersonInfo(StdID IN VARCHAR2, tableset OUT SYS_REFCURSOR) AS
    BEGIN
      OPEN tableset FOR
      WITH STUDENT_INFO AS (
          SELECT
            S."PersonID",
            P."Title",
            P."FirstName",
            P."LastName",
            S."IsLocal",
            P."PhoneNo",
            P."Email",
            I."Name"    AS "Major",
            H."PrefCTN" AS "Cantonese level",
            H."PrefENG" AS "English level",
            H."PrefPTH" AS "Putonghua level"
          FROM STUDENT S, PERSON P, MAJOR M, MAJOR_ABBR_INFO I, LANG_PREF_HASH H
          WHERE S."PersonID" = P."PersonID"
                AND S."MajorID" = M."MajorID"
                AND M."MajorAbbr" = I."MajorAbbr"
                AND S."PrefCode" = H."PrefCode" )
      SELECT *
      FROM STUDENT_INFO
      WHERE "PersonID" = StdID;
    END;

  PROCEDURE Int_Status(StdID IN VARCHAR2, tableset OUT SYS_REFCURSOR) AS
    BEGIN
      OPEN tableset FOR
      SELECT
        C."Date",
        C."Venue"
      FROM JOB_INTERVIEW A, JOB_APPLICATION B, JOB_INTERVIEW_SESSION C
      WHERE B."StudentID" = StdID
            AND A."AppID" = B."AppID"
            AND A."IvSessionID" = C."IvSessionID";
    END;

  PROCEDURE Int_Result(StdID IN VARCHAR2, tableset OUT SYS_REFCURSOR) AS
    BEGIN
      OPEN tableset FOR
      SELECT
        A."Score",
        A."Remark"
      FROM JOB_INTERVIEW A,
        JOB_APPLICATION B, JOB_INTERVIEW_SESSION C
      WHERE B."StudentID" = StdID;
    END;

  PROCEDURE VPERREVIEW(StdID IN VARCHAR2, tableset OUT SYS_REFCURSOR) AS
    BEGIN
      OPEN tableset FOR
      SELECT "Desc"
      FROM JOB_RECORD
      WHERE "StudentID" = StdID;
    END;

END JOB_MANAGE;
/

CREATE PACKAGE UTIL AS
  PROCEDURE SIGNIN_CHECK(
    ID          IN  VARCHAR2,
    PW          IN  VARCHAR2,
    CHECK_STATE OUT INT
  );

  PROCEDURE PERMISSION_CHECK(
    V_JOBID      IN  NUMBER,
    V_PERSONID   IN  VARCHAR2,
    O_PERMISSION OUT NUMBER
  );

  FUNCTION LANG_PREF_CHECK(
    PERSON_ID IN VARCHAR2 := NULL,
    JOB_ID    IN INT := NULL
  )
    RETURN INT;

  FUNCTION get_date(n IN NUMBER)
    RETURN DATE;

  FUNCTION CALC_PREFCODE(ctn IN NUMBER, eng IN NUMBER, pth IN NUMBER)
    RETURN NUMBER;

  FUNCTION STUDY_YEAR_CHECK(
    STUD_ID VARCHAR2,
    JOB_ID  INT
  )
    RETURN INT;

END;
/

CREATE PACKAGE BODY UTIL AS
  PROCEDURE SIGNIN_CHECK(
    ID          IN  VARCHAR2,
    PW          IN  VARCHAR2,
    CHECK_STATE OUT INT
  ) IS
    USER_RECORD PERSON%ROWTYPE;
    BEGIN
      SELECT *
      INTO USER_RECORD
      FROM PERSON
      WHERE "PersonID" = ID;
      IF PW = USER_RECORD."Password"
      THEN
        -- SUCCESS
        IF USER_RECORD."Type" = 'ADMI'
        THEN
          CHECK_STATE := 4;
        ELSIF USER_RECORD."Type" = 'SUPE'
          THEN
            CHECK_STATE := 3;
        ELSIF USER_RECORD."Type" = 'STUD'
          THEN
            CHECK_STATE := 2;
        ELSE
          CHECK_STATE := -1;
        END IF;
      ELSE
        -- PASSWORD INCORRECT
        CHECK_STATE := 1;
      END IF;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
      -- USER NOT FOUND
      CHECK_STATE := 0;
      WHEN OTHERS THEN
      CHECK_STATE := -1;
      RAISE;
    END SIGNIN_CHECK;

  PROCEDURE PERMISSION_CHECK(
    V_JOBID      IN  NUMBER,
    V_PERSONID   IN  VARCHAR2,
    O_PERMISSION OUT NUMBER
  ) IS
    V_USERTYPE  VARCHAR2(4);
    V_SUPECOUNT NUMBER;
    BEGIN
      SELECT "Type"
      INTO V_USERTYPE
      FROM PERSON
      WHERE V_PERSONID = PERSON."PersonID";
      IF V_USERTYPE = 'STUD'
      THEN
        O_PERMISSION := 0;
      ELSIF V_USERTYPE = 'ADMI'
        THEN
          O_PERMISSION := 2;
      ELSIF V_USERTYPE = 'SUPE'
        THEN
          SELECT COUNT(*)
          INTO V_SUPECOUNT
          FROM JOB_SUPERVISE
          WHERE "JobID" = V_JOBID AND "SupervisorID" = V_PERSONID;
          IF V_SUPECOUNT = 1
          THEN
            O_PERMISSION := 1;
          ELSE
            O_PERMISSION := 0;
          END IF;
      END IF;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
      O_PERMISSION := 0;
      WHEN OTHERS THEN
      RAISE;
    END;

  FUNCTION LANG_PREF_CHECK(
    PERSON_ID IN VARCHAR2 := NULL,
    JOB_ID    IN INT := NULL
  )
    RETURN INT IS
    P_CTN NUMBER;
    P_ENG NUMBER;
    P_PTH NUMBER;
    J_CTN NUMBER;
    J_ENG NUMBER;
    J_PTH NUMBER;
    BEGIN
      SELECT
        "PrefCTN",
        "PrefENG",
        "PrefPTH"
      INTO P_CTN, P_ENG, P_PTH
      FROM LANG_PREF_HASH, STUDENT
      WHERE STUDENT."PersonID" = PERSON_ID AND STUDENT."PrefCode" = LANG_PREF_HASH."PrefCode";
      SELECT
        "PrefCTN",
        "PrefENG",
        "PrefPTH"
      INTO J_CTN, J_ENG, J_PTH
      FROM LANG_PREF_HASH, JOB
      WHERE JOB."JobID" = JOB_ID AND JOB."PrefCode" = LANG_PREF_HASH."PrefCode";
      IF P_CTN >= J_CTN AND P_ENG >= J_ENG AND P_PTH >= J_PTH
      THEN
        RETURN 1;
      ELSE
        RETURN 0;
      END IF;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
      RETURN 1;
      WHEN OTHERS THEN
      RAISE;
    END;

  FUNCTION get_date(n IN NUMBER)
    RETURN DATE AS
    BEGIN
      RETURN SYSDATE + n;
    END get_date;

  FUNCTION CALC_PREFCODE(ctn IN NUMBER, eng IN NUMBER, pth IN NUMBER)
    RETURN NUMBER AS
    lang NUMBER;
    BEGIN
      SELECT "PrefCode"
      INTO lang
      FROM LANG_PREF_HASH
      WHERE "PrefENG" = eng
            AND "PrefCTN" = ctn
            AND "PrefPTH" = pth;
      RETURN lang;
    END;

  FUNCTION STUDY_YEAR_CHECK(
    STUD_ID IN VARCHAR2,
    JOB_ID  IN INT
  )
    RETURN INT IS
    V_STUD_YEAR INT;
    V_JOB_REQ   INT := NULL;
    BEGIN
      SELECT "EntranceYear"
      INTO V_STUD_YEAR
      FROM STUDENT
      WHERE "PersonID" = STUD_ID;
      SELECT "MinStudyYear"
      INTO V_JOB_REQ
      FROM JOB
      WHERE "JobID" = JOB_ID;
      V_STUD_YEAR := extract(YEAR FROM sysdate) - V_STUD_YEAR + 1;
      IF V_JOB_REQ IS NULL
      THEN
        RETURN 1;
      ELSIF V_STUD_YEAR >= V_JOB_REQ
        THEN
          RETURN 1;
      ELSIF V_STUD_YEAR < V_JOB_REQ
        THEN
          RETURN 0;
      END IF;
    END;

END UTIL;
/

CREATE PACKAGE VIEW_PEOPLE AS
  PROCEDURE VIEW_ALL_PERSON(c_d OUT SYS_REFCURSOR);

  PROCEDURE VIEW_ALL_STUDENT(c_d OUT SYS_REFCURSOR);

  PROCEDURE View_all_Supervisor(c_d OUT SYS_REFCURSOR);

  PROCEDURE STUD_GENERAL_SEARCH(
    keyword  IN NVARCHAR2,
    tableset OUT SYS_REFCURSOR
  );

  PROCEDURE SUPE_GENERAL_SEARCH(
    keyword  IN NVARCHAR2,
    tableset OUT SYS_REFCURSOR
  );

  PROCEDURE View_SUPE_Detail(s_id IN VARCHAR2, c_d OUT SYS_REFCURSOR);

  PROCEDURE View_Stud_Detail(s_id IN VARCHAR2, c_d OUT SYS_REFCURSOR);
END;
/

CREATE PACKAGE BODY VIEW_PEOPLE AS
  PROCEDURE View_all_person(c_d OUT SYS_REFCURSOR) AS
    BEGIN

      OPEN c_d FOR
      SELECT
        "PersonID",
        "FirstName",
        "LastName",
        "PhoneNo",
        "Email"
      FROM PERSON;

    END;

  PROCEDURE VIEW_ALL_STUDENT(c_d OUT SYS_REFCURSOR) AS
    BEGIN
      OPEN c_d FOR
      SELECT
        P."PersonID",
        P."FirstName",
        P."LastName",
        P."PhoneNo",
        P."Email",
        M."MajorAbbr",
        P."Gender",
        S."IsLocal"
      FROM PERSON P, STUDENT S, MAJOR M
      WHERE P."PersonID" = S."PersonID"
            AND S."MajorID" = M."MajorID";

    END;

  PROCEDURE View_all_Supervisor(c_d OUT SYS_REFCURSOR) AS
    BEGIN
      OPEN c_d FOR
      SELECT
        P."PersonID",
        P."Title",
        P."FirstName",
        P."LastName",
        P."PhoneNo",
        P."Email",
        P."Gender",
        I."Name"
      FROM PERSON P, SUPERVISOR S, DEPARTMENT D, DEPT_ABBR_INFO I
      WHERE P."PersonID" = S."PersonID"
            AND S."DeptID" = D."DeptID"
            AND D."DeptAbbr" = I."DeptAbbr";

    END;

  PROCEDURE STUD_GENERAL_SEARCH(
    keyword  IN NVARCHAR2,
    tableset OUT SYS_REFCURSOR
  )
  AS
    BEGIN
      OPEN tableset FOR
      WITH STUDENT_INFO AS (
          SELECT
            S."PersonID",
            P."Title",
            P."FirstName",
            P."LastName",
            S."IsLocal",
            P."PhoneNo",
            P."Email",
            M."MajorAbbr" AS "Major"
          FROM STUDENT S, PERSON P, MAJOR M
          WHERE S."PersonID" = P."PersonID"
                AND S."MajorID" = M."MajorID" )

      SELECT *
      FROM STUDENT_INFO
      WHERE SUBSTR(UPPER("FirstName"), 1, LENGTH(keyword)) = UPPER(keyword)
            OR SUBSTR(UPPER("LastName"), 1, LENGTH(keyword)) = UPPER(keyword)
            OR SUBSTR(UPPER("PhoneNo"), 1, LENGTH(keyword)) = UPPER(keyword)
            OR SUBSTR(UPPER("Email"), 1, LENGTH(keyword)) = UPPER(keyword);
    END;

  PROCEDURE SUPE_GENERAL_SEARCH(
    keyword  IN NVARCHAR2,
    tableset OUT SYS_REFCURSOR
  )
  AS
    BEGIN
      OPEN tableset FOR
      WITH SUPER_INFO AS (
          SELECT
            S."PersonID",
            P."Title",
            P."FirstName",
            P."LastName",
            P."PhoneNo",
            P."Email",
            D."DeptAbbr"
          FROM SUPERVISOR S, PERSON P, DEPARTMENT D
          WHERE S."PersonID" = P."PersonID"
                AND D."DeptID" = S."DeptID" )

      SELECT *
      FROM SUPER_INFO
      WHERE SUBSTR(UPPER("FirstName"), 1, LENGTH(keyword)) = UPPER(keyword)
            OR SUBSTR(UPPER("LastName"), 1, LENGTH(keyword)) = UPPER(keyword)
            OR SUBSTR(UPPER("PhoneNo"), 1, LENGTH(keyword)) = UPPER(keyword)
            OR SUBSTR(UPPER("Email"), 1, LENGTH(keyword)) = UPPER(keyword);
    END;

  PROCEDURE View_SUPE_Detail(s_id IN VARCHAR2, c_d OUT SYS_REFCURSOR) AS
    BEGIN
      OPEN c_d FOR
      SELECT
        P."PersonID",
        "FirstName",
        "LastName",
        "PhoneNo",
        "Email",
        "DeptID",
        "StreetAddr1",
        "StreetAddr2",
        "City",
        "State",
        "ZipCode"
      FROM SUPERVISOR S, PERSON P, ADDRESS A
      WHERE S."PersonID" = s_id
            AND S."PersonID" = P."PersonID"
            AND A."PersonID" = P."PersonID";
    END;

  PROCEDURE View_Stud_Detail(s_id IN VARCHAR2, c_d OUT SYS_REFCURSOR) AS
    BEGIN
      OPEN c_d FOR
      SELECT
        P."PersonID",
        "FirstName",
        "LastName",
        "PhoneNo",
        "Email",
        "MajorID",
        "IsLocal",
        "PrefCode",
        "StreetAddr1",
        "StreetAddr2",
        "City",
        "State",
        "ZipCode"
      FROM STUDENT S, PERSON P, ADDRESS A
      WHERE S."PersonID" = s_id
            AND S."PersonID" = P."PersonID"
            AND A."PersonID" = P."PersonID";
    END;

END VIEW_PEOPLE;
/

CREATE PACKAGE SUPE_Access AS
  PROCEDURE Show_ALL_Job_AppNo(s_id IN VARCHAR2, tableset OUT SYS_REFCURSOR);

  PROCEDURE SHOW_INTER_SESSION(
    id       IN NUMBER,
    tableset OUT SYS_REFCURSOR);

  PROCEDURE SHOW_JOB_INTER(
    id       IN NUMBER,
    tableset OUT SYS_REFCURSOR);

  PROCEDURE show_pi_applicants(
    id       IN NUMBER,
    jobidaaa IN NUMBER,
    tableset OUT SYS_REFCURSOR);

  PROCEDURE SHOW_SUPERVISOR_JOB(
    userid   IN VARCHAR2,
    tableset OUT SYS_REFCURSOR);

  PROCEDURE SHOW_SUPERVISOR_JOB_APP(
    id       IN NUMBER,
    tableset OUT SYS_REFCURSOR);

END;
/

CREATE PACKAGE BODY SUPE_Access AS

  PROCEDURE Show_ALL_Job_AppNo(s_id IN VARCHAR2, tableset OUT SYS_REFCURSOR) AS

    BEGIN
      OPEN tableset FOR
      WITH Numba AS (
          SELECT
            "JobID",
            count(*) AS num
          FROM job_application
          GROUP BY "JobID" )
      SELECT
        d."JobID",
        d."Name",
        n.num
      FROM (
             SELECT
               b."JobID",
               b."Name"
             FROM JOB b, JOB_SUPERVISE a
             WHERE a."JobID" = b."JobID"
                   AND a."SupervisorID" = s_id
           ) d
        LEFT JOIN Numba n ON d."JobID" = n."JobID";
    END;

  PROCEDURE SHOW_INTER_SESSION(
    id       IN NUMBER,
    tableset OUT SYS_REFCURSOR)
  AS
    BEGIN
      OPEN tableset FOR
      SELECT
        "InterviewID",
        a."AppID",
        b."PersonID",
        c."FirstName",
        c."LastName",
        "MajorAbbr",
        b."EntranceYear",
        "CV",
        a."Score"
      FROM JOB_INTERVIEW a, STUDENT b, PERSON c, MAJOR d, JOB_APPLICATION e
      WHERE a."IvSessionID" = id
            AND a."AppID" = e."AppID"
            AND e."StudentID" = b."PersonID"
            AND e."StudentID" = c."PersonID"
            AND b."MajorID" = d."MajorID";
    END;

  PROCEDURE SHOW_JOB_INTER(
    id       IN NUMBER,
    tableset OUT SYS_REFCURSOR)
  AS
    BEGIN
      OPEN tableset FOR
      SELECT
        a."IvSessionID",
        to_char("Date", 'YYYY-MM-DD HH24:MI:SS'),
        "Venue",
        a."Quota",
        "Hours",
        num
      FROM JOB_INTERVIEW_SESSION a, JOB b, (WITH Numba AS (
          SELECT
            "IvSessionID",
            count(*) AS num
          FROM JOB_INTERVIEW
          GROUP BY "IvSessionID" )
      SELECT
        b."IvSessionID",
        c.num
      FROM JOB_INTERVIEW_SESSION b
        LEFT JOIN Numba c ON b."IvSessionID" = c."IvSessionID") c
      WHERE a."JobID" = id
            AND a."JobID" = b."JobID" AND a."IvSessionID" = c."IvSessionID";
    END;

  PROCEDURE show_pi_applicants(
    id       IN NUMBER,
    jobidaaa IN NUMBER,
    tableset OUT SYS_REFCURSOR)
  AS
    BEGIN
      OPEN tableset FOR
      WITH temt AS (SELECT
                      c."AppID",
                      a."PersonID",
                      "FirstName",
                      "LastName",
                      "PhoneNo",
                      "Email",
                      "Gender",
                      "MajorAbbr",
                      "IsLocal",
                      CV,
                      "EntranceYear",
                      "PrefCode",
                      c."Score",
                      "IsSuccessful"
                    FROM person a, student b, job_application c, major d
                    WHERE c."AppID" = id
                          AND c."StudentID" = a."PersonID"
                          AND a."PersonID" = b."PersonID"
                          AND b."MajorID" = d."MajorID")
      SELECT
        t."AppID",
        t."PersonID",
        "FirstName",
        "LastName",
        "PhoneNo",
        "Email",
        "Gender",
        "MajorAbbr",
        "IsLocal",
        CV,
        "EntranceYear",
        "PrefCode",
        t."Score",
        "IsSuccessful",
        e."Score",
        e."Remark"
      FROM (SELECT
              "AppID",
              "Score",
              "Remark"
            FROM JOB_INTERVIEW e, JOB_INTERVIEW_SESSION f
            WHERE f."JobID" = jobidaaa AND f."IvSessionID" = e."IvSessionID" AND e."AppID" = id) e
        RIGHT JOIN temt t ON t."AppID" = e."AppID";
    END;

  PROCEDURE SHOW_SUPERVISOR_JOB(
    userid   IN VARCHAR2,
    tableset OUT SYS_REFCURSOR)
  AS
    BEGIN
      OPEN tableset FOR
      SELECT
        a."JobID",
        b."Name",
        c.num
      FROM JOB_SUPERVISE a, job b, (
                                     WITH Numba AS (
                                         SELECT
                                           "JobID",
                                           count(*) AS num
                                         FROM job_application
                                         GROUP BY "JobID" )
                                     SELECT
                                       b."JobID",
                                       b."Name",
                                       c.num
                                     FROM job b
                                       LEFT JOIN Numba c ON b."JobID" = c."JobID") c
      WHERE a."SupervisorID" = userid AND a."JobID" = b."JobID"
            AND a."JobID" = c."JobID";
    END;

  PROCEDURE SHOW_SUPERVISOR_JOB_APP(
    id       IN NUMBER,
    tableset OUT SYS_REFCURSOR)
  AS
    BEGIN
      OPEN tableset FOR
      SELECT
        "AppID",
        a."StudentID",
        c."FirstName",
        c."LastName",
        "MajorAbbr",
        b."EntranceYear",
        "CV",
        "Score",
        "IsSuccessful"
      FROM JOB_APPLICATION a, STUDENT b, PERSON c, MAJOR d
      WHERE a."JobID" = id
            AND a."StudentID" = b."PersonID"
            AND a."StudentID" = c."PersonID"
            AND b."MajorID" = d."MajorID";
    END;

END SUPE_Access;
/

CREATE PROCEDURE AINTERSS(id IN NUMBER, ddate IN VARCHAR2, venue IN VARCHAR2, quota IN NUMBER, hours IN NUMBER)
IS
  BEGIN
    INSERT INTO JOB_INTERVIEW_SESSION ("IvSessionID", "JobID", "Date", "Venue", "Quota", "Hours")
    VALUES ("intSesSequence".nextval, id, to_date(ddate, 'YYYY-MM-DD HH24:MI:SS'), venue, quota, hours);
    COMMIT;
  END;
/

CREATE PROCEDURE ADDINTER(appid IN NUMBER, isid IN NUMBER)
IS
  BEGIN
    INSERT INTO JOB_INTERVIEW ("InterviewID", "AppID", "Score", "Remark", "IvSessionID")
    VALUES ("intSequence".nextval, appid, NULL, NULL, isid);
    COMMIT;
  END;
/

CREATE PROCEDURE INTERSS_CHECK(
  ISID  IN  NUMBER,
  JOBID IN  NUMBER,
  APPID IN  NUMBER,
  O_OUT OUT NUMBER
) IS
  BEGIN
    SELECT "InterviewID"
    INTO O_OUT
    FROM JOB_INTERVIEW
    WHERE "IvSessionID" IN (SELECT "IvSessionID"
                            FROM JOB_INTERVIEW_SESSION
                            WHERE "JobID" = JOBID) AND "AppID" = APPID;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    O_OUT := -1;
    WHEN OTHERS THEN
    RAISE;
  END;
/

CREATE PROCEDURE dinter(
  id IN NUMBER
)
IS
  BEGIN
    -- Delete is set to cascade, so all child will also be removed.
    DELETE JOB_INTERVIEW
    WHERE "InterviewID" = id;
    COMMIT;
  END;
/

CREATE PROCEDURE SHOW_JOB_CONTRACT(jobid IN NUMBER, tableset OUT SYS_REFCURSOR)
AS
  BEGIN
    OPEN tableset FOR
    WITH TEMT AS (SELECT
                    "AppID",
                    b."StudentID",
                    c."FirstName",
                    c."LastName"
                  FROM JOB_APPLICATION b, PERSON c
                  WHERE "JobID" = jobid
                        AND b."IsSuccessful" = 'Y' AND b."IsValid" = 'Y'
                        AND b."StudentID" = c."PersonID")
    SELECT
      "AppID",
      t."StudentID",
      "FirstName",
      "LastName",
      "IsActive",
      "StartDate",
      "EndDate",
      "HrSalary"
    FROM JOB_CONTRACT a RIGHT JOIN TEMT t ON a."StudentID" = t."StudentID";
  END;
/

CREATE PROCEDURE CONTRACT_CHECK(
  ID    IN  VARCHAR2,
  JOBID IN  NUMBER,
  O_OUT OUT NUMBER
) IS
  O_TEMP VARCHAR2(1000);
  BEGIN
    SELECT "StudentID"
    INTO O_TEMP
    FROM JOB_CONTRACT
    WHERE "StudentID" = id AND "JobID" = jobid;
    O_OUT := 0;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    O_OUT := 1;
    WHEN OTHERS THEN
    RAISE;
  END;
/

CREATE PROCEDURE SHOW_CONTRACT(id IN VARCHAR2, jobid IN NUMBER, tableset OUT SYS_REFCURSOR)
AS
  BEGIN
    OPEN tableset FOR
    WITH TEMT AS (SELECT
                    "AppID",
                    b."StudentID",
                    c."FirstName",
                    c."LastName"
                  FROM JOB_APPLICATION b, PERSON c
                  WHERE "JobID" = jobid
                        AND b."IsSuccessful" = 'Y' AND b."IsValid" = 'Y'
                        AND b."StudentID" = C."PersonID"
                        AND b."StudentID" = id)
    SELECT
      "AppID",
      t."StudentID",
      "FirstName",
      "LastName",
      "IsActive",
      "StartDate",
      "EndDate",
      "HrSalary",
      "Remark",
      "SupervisorID",
      "HrPerWeek",
      "Weeks",
      "CtrtNo"
    FROM JOB_CONTRACT a RIGHT JOIN TEMT t ON a."StudentID" = t."StudentID";
  END;
/

CREATE PROCEDURE SHOW_ANN(id IN VARCHAR2, jobid IN NUMBER, tableset OUT SYS_REFCURSOR)
AS
  BEGIN
    OPEN tableset FOR
    SELECT
      "AncID",
      "Message"
    FROM JOB_ANNOUNCEMENT
    WHERE "JobID" = jobid
          AND "SupervisorID" = id;
  END;
/

CREATE PROCEDURE SHOW_ONE_ANN(id IN VARCHAR2, tableset OUT SYS_REFCURSOR)
AS
  BEGIN
    OPEN tableset FOR
    SELECT "Message"
    FROM JOB_ANNOUNCEMENT
    WHERE "AncID" = id;
  END;
/

CREATE PROCEDURE SHOW_LR(id IN VARCHAR2, tableset OUT SYS_REFCURSOR)
AS
  BEGIN
    OPEN tableset FOR
    SELECT
      a."JobID",
      b."Name",
      "StudentID",
      "Reason",
      "StartDate",
      "EndDate",
      "IsApproved",
      "LeaveNo"
    FROM JOB_LEAVE a, JOB b
    WHERE a."SupervisorID" = id
          AND a."JobID" = b."JobID";
  END;
/

CREATE PROCEDURE APPROVE_LEAVE(id IN NUMBER, result IN VARCHAR2) AS
  BEGIN
    UPDATE JOB_LEAVE
    SET
      "IsApproved" = result
    WHERE "LeaveNo" = id;
    COMMIT;
  END;
/

CREATE PROCEDURE SHOW_LR_DETAIL(id IN VARCHAR2, tableset OUT SYS_REFCURSOR)
AS
  BEGIN
    OPEN tableset FOR
    SELECT
      a."JobID",
      b."Name",
      "StudentID",
      "Reason",
      "StartDate",
      "EndDate",
      "IsApproved"
    FROM JOB_LEAVE a, JOB b
    WHERE a."LeaveNo" = id
          AND a."JobID" = b."JobID";
  END;
/

CREATE PROCEDURE SHOW_RECORD(id IN NUMBER, tableset OUT SYS_REFCURSOR)
AS
  BEGIN
    OPEN tableset FOR
    WITH TEMT AS (SELECT *
                  FROM JOB_RECORD
                  WHERE "JobID" = id)
    SELECT
      T."RecordID",
      "JobID",
      "StudentID",
      "SupervisorID",
      "Date",
      T."Type",
      "Desc",
      "Payment",
      "IsValid",
      NUM
    FROM TEMT T LEFT JOIN (SELECT
                             "RecordID",
                             COUNT(*) AS NUM
                           FROM OBJECTION
                           GROUP BY "RecordID") A ON T."RecordID" = A."RecordID";
  END;
/


