      *>*****************************************************************
      *> Author: Pranshu Patel
      *> Date: 23-05-2026
      *> Purpose: Program that converts the initial sequential file into VSAM/indexed like file
      *> Tectonics: cobc
      *>*****************************************************************
              IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGV0001.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-FILE ASSIGN TO "STUDENTS.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT STUDENT-FILE ASSIGN TO "STUDENTS.dat"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS STU-ID
               FILE STATUS IS WS-STUDENT-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD INPUT-FILE.
       01 INPUT-LINE              PIC X(80).

       FD STUDENT-FILE.
       COPY "STUDENT.cpy".

       WORKING-STORAGE SECTION.

       01 WS-STUDENT-STATUS       PIC XX.
       01 WS-END-FILE             PIC X VALUE "N".
          88 END-OF-FILE          VALUE "Y".
          88 NOT-END-OF-FILE      VALUE "N".

       01 WS-CURRENT-DATE.
          05 WS-YEAR              PIC 9(4).
          05 WS-MONTH             PIC 9(2).
          05 WS-DAY               PIC 9(2).

       01 WS-INPUT-FIELDS.
          05 WS-IN-ID             PIC X(4).
          05 WS-IN-NAME           PIC X(25).
          05 WS-IN-BIRTHDAY       PIC X(8).
          05 WS-IN-COURSE         PIC X(15).

       PROCEDURE DIVISION.

       MAIN-PARA.
           DISPLAY "----------------------------------------".
           DISPLAY "PRGV0001 - GENERATE INDEXED STUDENT FILE".
           DISPLAY "----------------------------------------".

           ACCEPT WS-CURRENT-DATE FROM DATE YYYYMMDD.

           OPEN INPUT INPUT-FILE.
           OPEN OUTPUT STUDENT-FILE.

           PERFORM READ-INPUT-FILE.

           PERFORM UNTIL END-OF-FILE
               PERFORM SPLIT-INPUT-LINE
               PERFORM WRITE-STUDENT-RECORD
               PERFORM READ-INPUT-FILE
           END-PERFORM.

           CLOSE INPUT-FILE.
           CLOSE STUDENT-FILE.

           DISPLAY " ".
           DISPLAY "STUDENT INDEXED FILE CREATED SUCCESSFULLY."
           DISPLAY "FILE STATUS: " WS-STUDENT-STATUS.
           DISPLAY " ".

           STOP RUN.

       READ-INPUT-FILE.
           READ INPUT-FILE
               AT END
                   SET END-OF-FILE TO TRUE
               NOT AT END
                   SET NOT-END-OF-FILE TO TRUE
           END-READ.

       SPLIT-INPUT-LINE.
           UNSTRING INPUT-LINE
               DELIMITED BY ","
               INTO WS-IN-ID
                    WS-IN-NAME
                    WS-IN-BIRTHDAY
                    WS-IN-COURSE
           END-UNSTRING.

       WRITE-STUDENT-RECORD.
           MOVE WS-IN-ID            TO STU-ID.
           MOVE WS-IN-NAME          TO STU-NAME.
           MOVE WS-IN-BIRTHDAY      TO STU-BIRTHDAY.
           MOVE WS-IN-COURSE        TO STU-COURSE.
           MOVE WS-CURRENT-DATE     TO STU-INSERT-DATE.
           MOVE ZEROES              TO STU-UPDATE-DATE.

           WRITE STUDENT-REC
               INVALID KEY
                   DISPLAY "ERROR WRITING STUDENT ID: " STU-ID
                   DISPLAY "FILE STATUS: " WS-STUDENT-STATUS
               NOT INVALID KEY
                   DISPLAY "STUDENT WRITTEN: " STU-ID
           END-WRITE.
