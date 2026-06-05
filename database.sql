/* ===========================
   SAMPLE DATA
=========================== */

INSERT INTO Department VALUES
(1,'Computer Science','Block A'),
(2,'Software Engineering','Block B'),
(3,'Information Technology','Block C'),
(4,'Electrical Engineering','Block D'),
(5,'Business Administration','Block E');

INSERT INTO Student VALUES
(101,'Ali Khan','ali101@gmail.com','2003-01-15','03001234567'),
(102,'Ahmed Raza','ahmed102@gmail.com','2002-05-10','03011234567'),
(103,'Sara Ahmed','sara103@gmail.com','2003-07-12','03021234567'),
(104,'Ayesha Noor','ayesha104@gmail.com','2004-02-18','03031234567'),
(105,'Usman Tariq','usman105@gmail.com','2002-11-11','03041234567'),
(106,'Fatima Ali','fatima106@gmail.com','2003-03-15','03051234567'),
(107,'Bilal Khan','bilal107@gmail.com','2003-08-25','03061234567'),
(108,'Hina Malik','hina108@gmail.com','2002-09-14','03071234567'),
(109,'Hamza Shah','hamza109@gmail.com','2003-10-19','03081234567'),
(110,'Zara Iqbal','zara110@gmail.com','2004-01-01','03091234567');

INSERT INTO UndergraduateStudent VALUES
(101,3),
(102,5),
(103,4),
(104,2),
(105,6);

INSERT INTO GraduateStudent VALUES
(106,'Artificial Intelligence'),
(107,'Cyber Security'),
(108,'Data Science'),
(109,'Machine Learning'),
(110,'Cloud Computing');

INSERT INTO Instructor VALUES
(1,'Dr. Hassan','hassan@uni.edu',120000,1),
(2,'Dr. Ahmed','ahmed@uni.edu',125000,1),
(3,'Dr. Sara','sara@uni.edu',118000,2),
(4,'Dr. Bilal','bilal@uni.edu',130000,3),
(5,'Dr. Ayesha','ayesha@uni.edu',122000,4);

INSERT INTO Course VALUES
(1,'Database Systems',3,1),
(2,'Data Structures',3,1),
(3,'Operating Systems',3,1),
(4,'Software Engineering',3,2),
(5,'Web Development',3,2),
(6,'Networking',3,3),
(7,'Digital Logic',3,4),
(8,'Marketing',3,5);

INSERT INTO Section VALUES
(1,'Spring',2026,'A101',1,1),
(2,'Spring',2026,'A102',2,2),
(3,'Spring',2026,'B201',3,1),
(4,'Spring',2026,'B202',4,3),
(5,'Spring',2026,'C301',5,4),
(6,'Spring',2026,'C302',6,5);

INSERT INTO Enrollment VALUES
(1,101,1,'2026-01-10','A'),
(2,102,1,'2026-01-10','B'),
(3,103,2,'2026-01-10','A'),
(4,104,2,'2026-01-10','B'),
(5,105,3,'2026-01-10','A'),
(6,106,3,'2026-01-10','B'),
(7,107,4,'2026-01-10','A'),
(8,108,4,'2026-01-10','C'),
(9,109,5,'2026-01-10','A'),
(10,110,5,'2026-01-10','B');

INSERT INTO Payment VALUES
(1,101,50000,'2026-01-15','Paid'),
(2,102,55000,'2026-01-15','Paid'),
(3,103,45000,'2026-01-15','Pending'),
(4,104,60000,'2026-01-15','Paid'),
(5,105,40000,'2026-01-15','Pending'),
(6,106,65000,'2026-01-15','Paid'),
(7,107,50000,'2026-01-15','Paid'),
(8,108,35000,'2026-01-15','Cancelled'),
(9,109,70000,'2026-01-15','Paid'),
(10,110,55000,'2026-01-15','Paid');

/* ===========================
   TRIGGER
=========================== */

CREATE TRIGGER trg_payment_audit
ON Payment
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog(StudentID, ActionType)
    SELECT StudentID,'Payment Added'
    FROM inserted;
END;

/* ===========================
   VIEWS
=========================== */

CREATE VIEW StudentCourseView AS
SELECT
s.StudentID,
s.Name,
c.CourseName,
sec.Semester
FROM Student s
JOIN Enrollment e ON s.StudentID=e.StudentID
JOIN Section sec ON e.SectionID=sec.SectionID
JOIN Course c ON sec.CourseID=c.CourseID;

CREATE VIEW DepartmentInstructorView AS
SELECT
d.DepartmentName,
i.Name,
i.Email
FROM Department d
JOIN Instructor i
ON d.DepartmentID=i.DepartmentID;

/* ===========================
   JOIN QUERY 1
=========================== */

SELECT
s.Name,
c.CourseName,
i.Name AS Instructor
FROM Student s
JOIN Enrollment e ON s.StudentID=e.StudentID
JOIN Section sec ON e.SectionID=sec.SectionID
JOIN Course c ON sec.CourseID=c.CourseID
JOIN Instructor i ON sec.InstructorID=i.InstructorID;

/* ===========================
   JOIN QUERY 2
=========================== */

SELECT
d.DepartmentName,
c.CourseName,
i.Name
FROM Department d
JOIN Course c ON d.DepartmentID=c.DepartmentID
JOIN Section sec ON c.CourseID=sec.CourseID
JOIN Instructor i ON sec.InstructorID=i.InstructorID;

/* ===========================
   AGGREGATE QUERY 1
=========================== */

SELECT
Status,
COUNT(*) AS TotalPayments,
SUM(Amount) AS TotalRevenue
FROM Payment
GROUP BY Status;

/* ===========================
   AGGREGATE QUERY 2
=========================== */

SELECT
StudentID,
AVG(Amount) AS AverageFee
FROM Payment
GROUP BY StudentID
HAVING AVG(Amount) > 50000;

/* ===========================
   SUBQUERY 1
=========================== */

SELECT Name
FROM Student
WHERE StudentID IN
(
SELECT StudentID
FROM Payment
WHERE Amount > 50000
);

/* ===========================
   SUBQUERY 2
=========================== */

SELECT Name
FROM Instructor i
WHERE EXISTS
(
SELECT *
FROM Section s
WHERE s.InstructorID=i.InstructorID
);