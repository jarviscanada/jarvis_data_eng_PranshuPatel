*>****************************************************************
*> Author: Pranshu Patel
*> Date: 23-05-2026
*> Purpose: Program that generates a report file with a course break
*> Tectonics: cobc
*>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGR0008.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT STUDENT-FILE ASSIGN TO "STUDENTS.dat"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS SEQUENTIAL
               RECORD KEY IS STU-ID
               FILE STATUS IS WS-STUDENT-STATUS.

           SELECT SORT-FILE ASSIGN TO "SORTWORK.tmp".

           SELECT REPORT-FILE ASSIGN TO "COURSE_REPORT.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD STUDENT-FILE.
       COPY "STUDENT.cpy".

       SD SORT-FILE.
       01 SORT-REC.
          05 SORT-ID           PIC 9(4).
          05 SORT-NAME         PIC X(25).
          05 SORT-BIRTHDAY     PIC 9(8).
          05 SORT-COURSE       PIC X(15).
          05 SORT-INSERT-DATE  PIC 9(8).
          05 SORT-UPDATE-DATE  PIC 9(8).

       FD REPORT-FILE.
       01 REPORT-LINE          PIC X(120).

       WORKING-STORAGE SECTION.

       01 WS-STUDENT-STATUS    PIC XX.

       01 WS-END-FILE          PIC X VALUE "N".
          88 END-OF-FILE       VALUE "Y".
          88 NOT-END-OF-FILE   VALUE "N".

       01 WS-END-SORT          PIC X VALUE "N".
          88 END-OF-SORT       VALUE "Y".
          88 NOT-END-OF-SORT   VALUE "N".

       01 WS-CURRENT-COURSE    PIC X(15) VALUE SPACES.
       01 WS-TOTAL-STUDENTS    PIC 9(4) VALUE 0.

       PROCEDURE DIVISION.

       MAIN-PARA.
           DISPLAY " "
           DISPLAY "PRGR0008 - COURSE BREAK REPORT"
           DISPLAY "GENERATING REPORT FILE..."
           DISPLAY " "

           SORT SORT-FILE
               ON ASCENDING KEY SORT-COURSE
               INPUT PROCEDURE IS INPUT-PROCEDURE
               OUTPUT PROCEDURE IS OUTPUT-PROCEDURE

           DISPLAY "REPORT CREATED SUCCESSFULLY."
           DISPLAY "FILE NAME: COURSE_REPORT.txt"
           DISPLAY "TOTAL STUDENTS IN REPORT: " WS-TOTAL-STUDENTS

           STOP RUN.

       INPUT-PROCEDURE.
           OPEN INPUT STUDENT-FILE

           IF WS-STUDENT-STATUS NOT = "00"
               DISPLAY "ERROR OPENING STUDENT FILE"
               DISPLAY "FILE STATUS: " WS-STUDENT-STATUS
               STOP RUN
           END-IF

           PERFORM READ-STUDENT-FILE

           PERFORM UNTIL END-OF-FILE
               MOVE STU-ID          TO SORT-ID
               MOVE STU-NAME        TO SORT-NAME
               MOVE STU-BIRTHDAY    TO SORT-BIRTHDAY
               MOVE STU-COURSE      TO SORT-COURSE
               MOVE STU-INSERT-DATE TO SORT-INSERT-DATE
               MOVE STU-UPDATE-DATE TO SORT-UPDATE-DATE

               RELEASE SORT-REC

               PERFORM READ-STUDENT-FILE
           END-PERFORM

           CLOSE STUDENT-FILE.

       OUTPUT-PROCEDURE.
           OPEN OUTPUT REPORT-FILE

           MOVE "------------------------------------------------------------" TO REPORT-LINE
           WRITE REPORT-LINE

           MOVE "                 C L A S S   R E P O R T" TO REPORT-LINE
           WRITE REPORT-LINE

           MOVE "------------------------------------------------------------" TO REPORT-LINE
           WRITE REPORT-LINE

           RETURN SORT-FILE
               AT END
                   SET END-OF-SORT TO TRUE
               NOT AT END
                   SET NOT-END-OF-SORT TO TRUE
           END-RETURN

           PERFORM UNTIL END-OF-SORT
               IF SORT-COURSE NOT = WS-CURRENT-COURSE
                   MOVE SORT-COURSE TO WS-CURRENT-COURSE
                   PERFORM WRITE-COURSE-HEADER
               END-IF

               PERFORM WRITE-STUDENT-LINE
               ADD 1 TO WS-TOTAL-STUDENTS

               RETURN SORT-FILE
                   AT END
                       SET END-OF-SORT TO TRUE
                   NOT AT END
                       SET NOT-END-OF-SORT TO TRUE
               END-RETURN
           END-PERFORM

           MOVE "------------------------------------------------------------" TO REPORT-LINE
           WRITE REPORT-LINE

           STRING "TOTAL STUDENTS : "
                  WS-TOTAL-STUDENTS
                  DELIMITED BY SIZE
                  INTO REPORT-LINE
           END-STRING
           WRITE REPORT-LINE

           CLOSE REPORT-FILE.

       READ-STUDENT-FILE.
           READ STUDENT-FILE NEXT RECORD
               AT END
                   SET END-OF-FILE TO TRUE
               NOT AT END
                   SET NOT-END-OF-FILE TO TRUE
           END-READ.

       WRITE-COURSE-HEADER.
           MOVE SPACES TO REPORT-LINE
           WRITE REPORT-LINE

           STRING "COURSE: "
                  WS-CURRENT-COURSE
                  DELIMITED BY SIZE
                  INTO REPORT-LINE
           END-STRING
           WRITE REPORT-LINE

           MOVE "------------------------------------------------------------" TO REPORT-LINE
           WRITE REPORT-LINE

           MOVE "ID    STUDENT NAME               BIRTHDAY   INSERT DATE   UPDATE DATE"
                TO REPORT-LINE
           WRITE REPORT-LINE

           MOVE "------------------------------------------------------------" TO REPORT-LINE
           WRITE REPORT-LINE.

       WRITE-STUDENT-LINE.
           MOVE SPACES TO REPORT-LINE

           STRING SORT-ID
                  "  "
                  SORT-NAME
                  "  "
                  SORT-BIRTHDAY
                  "  "
                  SORT-INSERT-DATE
                  "  "
                  SORT-UPDATE-DATE
                  DELIMITED BY SIZE
                  INTO REPORT-LINE
           END-STRING

           WRITE REPORT-LINE.
