*>****************************************************************
*> Author: Pranshu Patel
*> Date: 23-05-2026
*> Purpose: Program that updates a student record
*> Tectonics: cobc
*>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGU0003.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT STUDENT-FILE ASSIGN TO "STUDENTS.dat"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS STU-ID
               FILE STATUS IS WS-STUDENT-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD STUDENT-FILE.
       COPY "STUDENT.cpy".

       WORKING-STORAGE SECTION.

       01 WS-STUDENT-STATUS       PIC XX.
       01 WS-ENTERED-ID           PIC 9(4).

       01 WS-NEW-NAME             PIC X(25).
       01 WS-NEW-BIRTHDAY         PIC X(8).
       01 WS-NEW-COURSE           PIC X(15).

       01 WS-CURRENT-DATE.
          05 WS-YEAR              PIC 9(4).
          05 WS-MONTH             PIC 9(2).
          05 WS-DAY               PIC 9(2).

       PROCEDURE DIVISION.

       MAIN-PARA.
           DISPLAY " "
           DISPLAY "+---------------------------------+"
           DISPLAY "|   U P D A T E   S T U D E N T   |"
           DISPLAY "+---------------------------------+"
           DISPLAY " "

           ACCEPT WS-CURRENT-DATE FROM DATE YYYYMMDD

           DISPLAY "ENTER THE 4 DIGIT STUDENT ID >> "
           ACCEPT WS-ENTERED-ID

           MOVE WS-ENTERED-ID TO STU-ID

           OPEN I-O STUDENT-FILE

           IF WS-STUDENT-STATUS NOT = "00"
               DISPLAY "ERROR OPENING STUDENT FILE"
               DISPLAY "FILE STATUS: " WS-STUDENT-STATUS
               STOP RUN
           END-IF

           READ STUDENT-FILE
               KEY IS STU-ID
               INVALID KEY
                   DISPLAY " "
                   DISPLAY "STUDENT NOT FOUND."
                   DISPLAY "FILE STATUS: " WS-STUDENT-STATUS
                   CLOSE STUDENT-FILE
                   STOP RUN
               NOT INVALID KEY
                   DISPLAY " "
                   DISPLAY "<--- STUDENT TO BE UPDATED --->"
                   PERFORM DISPLAY-STUDENT-RECORD
           END-READ

           DISPLAY " "
           DISPLAY "ENTER THE DETAILS TO BE CHANGED"

           DISPLAY "NEW STUDENT NAME - PRESS ENTER TO SKIP >> "
           ACCEPT WS-NEW-NAME

           DISPLAY "NEW BIRTHDAY YYYYMMDD - PRESS ENTER TO SKIP >> "
           ACCEPT WS-NEW-BIRTHDAY

           DISPLAY "NEW COURSE NAME - PRESS ENTER TO SKIP >> "
           ACCEPT WS-NEW-COURSE

           IF WS-NEW-NAME NOT = SPACES
               MOVE WS-NEW-NAME TO STU-NAME
           END-IF

           IF WS-NEW-BIRTHDAY NOT = SPACES
               MOVE WS-NEW-BIRTHDAY TO STU-BIRTHDAY
           END-IF

           IF WS-NEW-COURSE NOT = SPACES
               MOVE WS-NEW-COURSE TO STU-COURSE
           END-IF

           MOVE WS-CURRENT-DATE TO STU-UPDATE-DATE

           REWRITE STUDENT-REC
               INVALID KEY
                   DISPLAY "ERROR UPDATING STUDENT"
                   DISPLAY "FILE STATUS: " WS-STUDENT-STATUS
               NOT INVALID KEY
                   DISPLAY " "
                   DISPLAY "<--- UPDATED STUDENT DETAILS --->"
                   PERFORM DISPLAY-STUDENT-RECORD
           END-REWRITE

           CLOSE STUDENT-FILE

           STOP RUN.

       DISPLAY-STUDENT-RECORD.
           DISPLAY "------------------------------------------------------------"
           DISPLAY "ID   STUDENT NAME              BIRTHDAY   COURSE"
           DISPLAY "     INSERT DATE   UPDATE DATE"
           DISPLAY "------------------------------------------------------------"
           DISPLAY STU-ID "  "
                   STU-NAME "  "
                   STU-BIRTHDAY "  "
                   STU-COURSE
           DISPLAY "     "
                   STU-INSERT-DATE "      "
                   STU-UPDATE-DATE
           DISPLAY "------------------------------------------------------------".
