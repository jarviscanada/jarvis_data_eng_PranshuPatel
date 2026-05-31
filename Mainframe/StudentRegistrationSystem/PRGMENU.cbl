*>****************************************************************
*> Author: Pranshu Patel
*> Date: 23-05-2026
*> Purpose: Program that displays the Main Menu with the options available
*> Tectonics: cobc
*>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGMENU.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01 WS-OPTION        PIC 9 VALUE 0.
       01 WS-CONTINUE      PIC X VALUE SPACE.

       PROCEDURE DIVISION.

       MAIN-PARA.
           PERFORM UNTIL WS-OPTION = 9

               PERFORM DISPLAY-MENU

               DISPLAY "ENTER YOUR OPTION >> "
               ACCEPT WS-OPTION

               EVALUATE WS-OPTION
                   WHEN 1
                       CALL "SYSTEM" USING "PRGV0001.exe"
                       PERFORM PRESS-ENTER

                   WHEN 2
                       CALL "SYSTEM" USING "PRGI0002.exe"
                       PERFORM PRESS-ENTER

                   WHEN 3
                       CALL "SYSTEM" USING "PRGU0003.exe"
                       PERFORM PRESS-ENTER

                   WHEN 4
                       CALL "SYSTEM" USING "PRGD0004.exe"
                       PERFORM PRESS-ENTER

                   WHEN 5
                       CALL "SYSTEM" USING "PRGQ0005.exe"
                       PERFORM PRESS-ENTER

                   WHEN 6
                       CALL "SYSTEM" USING "PRGQ0006.exe"
                       PERFORM PRESS-ENTER

                   WHEN 7
                       CALL "SYSTEM" USING "PRGQ0007.exe"
                       PERFORM PRESS-ENTER

                   WHEN 8
                       CALL "SYSTEM" USING "PRGR0008.exe"
                       PERFORM PRESS-ENTER

                   WHEN 9
                       DISPLAY " "
                       DISPLAY "EXITING STUDENT REGISTRATION SYSTEM..."
                       DISPLAY "THANK YOU."

                   WHEN OTHER
                       DISPLAY " "
                       DISPLAY "INVALID OPTION. PLEASE ENTER 1 TO 9."
                       PERFORM PRESS-ENTER
               END-EVALUATE

           END-PERFORM

           STOP RUN.

       DISPLAY-MENU.
           DISPLAY " "
           DISPLAY "+-----------------------------------+"
           DISPLAY "|          M A I N   M E N U        |"
           DISPLAY "+-----------------------------------+"
           DISPLAY "|               OPTIONS             |"
           DISPLAY "+-----------------------------------+"
           DISPLAY "|  1 - GENERATE VSAM FILE           |"
           DISPLAY "|  2 - INSERT STUDENT DATA          |"
           DISPLAY "|  3 - UPDATE STUDENT DATA          |"
           DISPLAY "|  4 - DELETE STUDENT DATA          |"
           DISPLAY "|  5 - CLASS QUERY ALL STUDENTS     |"
           DISPLAY "|  6 - QUERY STUDENT BY ID          |"
           DISPLAY "|  7 - QUERY BY DATE OF INCLUSION   |"
           DISPLAY "|  8 - REPORT FILE WITH COURSE BREAK|"
           DISPLAY "|  9 - EXIT                         |"
           DISPLAY "+-----------------------------------+"
           DISPLAY " ".

       PRESS-ENTER.
           DISPLAY " "
           DISPLAY "PRESS ENTER TO RETURN TO MAIN MENU..."
           ACCEPT WS-CONTINUE.
