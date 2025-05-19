CREATE OR ALTER VIEW ExamSchedule  --ali
AS
	SELECT t.TrackName 'Track Name',c.CourseName 'Course Name', e.ExamType 'Exam Type', e.ExamDate 'Date of Exam'
	FROM course c
	JOIN ExamStudentCourse esc
	ON C.CourseID = esc.CourseID
	JOIN Exam e
	ON esc.ExamID = e.ExamID
	JOIN TrackCourse tc
	ON tc.CourseID = c.CourseID
	join Track t
	ON t.TrackID = tc.TrackID
	WHERE e.ExamDate = GETDATE()

	----------------------------------------------------

create view studentexamresult as    ---mariam
select
s.studentid , s.studentfname+' '+s.studentlname as fullname ,
e.examid,e.examdate as examdate,
r.grade 
from
   Student s
join 
   ExamStudentCourse r on s.StudentID=r.StudentID
join 
   Exam e on r.ExamID=e.ExamID;

---------------------------------------------------------

create view studentcardinfo as     --mariam
select 
studentid,studentfname+' '+studentlname as fullname,
studentemail,studentphone,studentaddress,trackid,StudentDOB
from Student 

----------------------------------------------------

CREATE OR ALTER VIEW Failed_Students AS   ---radwa
SELECT 
    S.StudentID,
    S.StudentFname,
	S.StudentLname,
    E.ExamID,
    E.ExamType 
FROM 
    Student S
    JOIN ExamStudentAnswer EXA ON S.StudentID = EXA.StudentID
    JOIN Exam E ON EXA.ExamID = E.ExamID
    JOIN StudentAnswer SA ON EXA.StuAnsID = SA.stuans
WHERE 
    E.ExamType = 'CORRECTIVE';