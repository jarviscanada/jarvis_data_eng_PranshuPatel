## Introduction

The Student Registration System is a menu-driven COBOL application designed to manage student records using file handling concepts. The project allows users to generate a student data file, insert new student records, update existing records, delete records, query student information, and generate reports.

The system follows a mainframe-style application structure where each major operation is handled by a separate COBOL program. A main menu program is used to connect all modules and provide a simple user interface for selecting different operations.

Since this project was developed locally using OpenCobolIDE and GnuCOBOL, COBOL indexed files were used to simulate VSAM KSDS behavior. The student ID acts as the primary key, allowing key-based operations such as reading, writing, updating, and deleting records.

## Project Implementation

The project is divided into multiple COBOL programs, where each program is responsible for one specific operation.

### Main Menu Program

`PRGMENU.cbl` displays the main menu and allows the user to select an option from 1 to 9. Based on the selected option, it calls the required COBOL program.

Menu options include:

- Generate student indexed file
- Insert student data
- Update student data
- Delete student data
- Query all students
- Query student by ID
- Query students by date of inclusion
- Generate course-wise report
- Exit the system

### Student File Generation

`PRGV0001.cbl` reads the initial sequential student file and creates an indexed student data file. This program loads the starting student records into the system.

The input file contains student details such as:

- Student ID
- Student name
- Birthday
- Course

While loading the data, the program also adds the insert date and initializes the update date as zero.

### Insert Student Record

`PRGI0002.cbl` allows the user to add a new student record. The program asks for the student's name, birthday, and course. It then finds the highest existing student ID and generates the next available ID automatically.

The new record is written into the indexed file using the `WRITE` operation.

### Update Student Record

`PRGU0003.cbl` allows the user to update an existing student record by entering the student ID. The program first searches for the student using the key. If the record is found, the user can update the name, birthday, or course.

The updated data is saved back to the file using the `REWRITE` operation, and the update date is set to the current system date.

### Delete Student Record

`PRGD0004.cbl` allows the user to delete a student record by entering the student ID. Before deleting, the program displays the student details and asks for confirmation.

If the user confirms, the record is removed from the indexed file using the `DELETE` operation.

### Query All Students

`PRGQ0005.cbl` reads all student records from the indexed file and displays them in a class report format. It also shows the total number of students.

This program uses sequential reading to go through all records one by one.

### Query Student by ID

`PRGQ0006.cbl` allows the user to search for a specific student by entering the student ID. The program uses key-based reading to directly find the matching record.

If the student exists, the details are displayed. Otherwise, the program displays a student-not-found message.

### Query Students by Date of Inclusion

`PRGQ0007.cbl` allows the user to search for students based on their insert date. The program reads all records sequentially and displays only the students whose insert date matches the entered date.

This helps identify which students were added on a specific day.

### Course Break Report

`PRGR0008.cbl` generates a course-wise report file. The program reads all student records, sorts them by course, and writes the output into a report file named `COURSE_REPORT.txt`.

The report groups students under their respective courses and displays student details such as ID, name, birthday, insert date, and update date.

### Common Copybook

`STUDENT.cpy` is used as a common record layout for the student file. It defines the structure of each student record, including:

- Student ID
- Student name
- Birthday
- Course
- Insert date
- Update date

Using a copybook helps avoid repeating the same record structure in every program and makes the project easier to maintain.

### File Handling Logic

The project uses COBOL indexed file handling to simulate VSAM-style processing. The student ID is used as the record key.

Important COBOL file operations used in this project include:

- `WRITE` to insert a record
- `READ` to search a record
- `REWRITE` to update a record
- `DELETE` to remove a record
- `READ NEXT` to process records sequentially
- `SORT` to generate the course-wise report

## Future Improvements

The project can be improved further by adding stronger validation and more user-friendly features.

Possible future improvements include:

- Add validation for birthday format to ensure the user enters a valid `YYYYMMDD` date.
- Prevent duplicate or invalid student information from being inserted.
- Add better error handling for file status codes.
- Improve the report format to make it more aligned and professional.
- Add search functionality by course name.
- Add a separate backup file before deleting or updating records.
- Add screen-clearing logic between menu options for better readability.
- Add a date-break report in addition to the existing course-break report.
- Convert the project to run in a real mainframe environment using VSAM and JCL.
- Add more comments in the code to make it easier for beginners to understand.

## Conclusion

This project helped demonstrate core COBOL file processing concepts in a practical way. It covers menu-driven programming, copybooks, indexed files, record layouts, CRUD operations, sequential reading, sorting, and report generation.

The system is a strong beginner-level mainframe-style COBOL project because it shows how business applications manage records using structured COBOL programs and file-based processing.
"""
