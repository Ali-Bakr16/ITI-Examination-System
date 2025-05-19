CREATE OR ALTER PROCEDURE assignExam @studentID CHAR(14), @courseID INT, @examID INT  --ali
AS
BEGIN
	INSERT INTO ExamStudentCourse(ExamID,CourseID,StudentID)
	VALUES (@examID, @courseID, @studentID)
END


-----------------------------------------------------

CREATE OR ALTER PROCEDURE UpdateCourse @courseID INT,@courseStrartdate DATE, @courseEnddate DATE,@instructorID INT, @intakeid INT --ali
AS
BEGIN
	
	UPDATE CourseInstructor
	SET InstructorID = @instructorID
	WHERE CourseID = @courseID and IntakeID = @intakeid
	
	UPDATE course
	SET CourseStartDate = @courseStrartdate, CourseEndDate = @courseEnddate
	WHERE CourseID = @courseID 
END

------------------------------------------------------------

CREATE OR ALTER PROCEDURE CreateExam    --ali
						@InstructorID INT,
						@CourseID INT,
						@textnum INT,
						@mcqnum INT,
						@TFnum INT,
						@ExamType VARCHAR(20),
						@CreateWay VARCHAR(10),
						@StartTime TIME,
						@EndTime TIME,
						@ExamDate DATE
						

AS
BEGIN
	
	IF @CreateWay = 'manual'
	BEGIN
		SELECT Question
		FROM TextQuestion

		SELECT q.question, a.answer1, a.answer2
		FROM truefalsequestion q
		JOIN truefalseanswer a
		ON q.trfaid = a.trfaid
		
		SELECT q.Question_ID, a.Answer1, a.Answer2, a.Answer3, a. Answer4
		FROM McqQuestion q
		JOIN McqAnswer a
		ON a.McqID = q.McqID
	END

	ELSE IF @CreateWay = 'random'
	BEGIN
		INSERT INTO Exam (ExamStartTime,ExamEndTime,ExamDate,ExamType)
		VALUES (@StartTime, @EndTime,@ExamDate,@ExamType)

		declare @ExamID INT
		select @ExamID = ExamID
		FROM Exam 
		WHERE ExamStartTime = @StartTime and ExamEndTime = @EndTime and ExamDate = @ExamDate

		INSERT INTO ExamQuestion (Question,QuestID,ExamID)
		SELECT TOP(@textnum) Question, Question_ID, @ExamID
		FROM TextQuestion
		ORDER BY NEWID()
		INSERT INTO ExamQuestion (Question, QuestID, ExamID)
		SELECT TOP(@mcqnum) Question, Question_ID,@ExamID
		FROM McqQuestion
		ORDER BY NEWID()
		INSERT INTO ExamQuestion (Question, QuestID,ExamID)
		SELECT TOP(@TFnum) question,question_id, @ExamID
		FROM truefalsequestion
		ORDER BY NEWID()

		INSERT INTO ExamInstructorQuestion(InstructorID, ExamID)
		VALUES(@InstructorID, @ExamID)

		PRINT 'Exam Is Created Sccussfuly'
	END

END

select * from ExamQuestion
-----------------------------------------------------------------

CREATE OR ALTER PROCEDURE UpdateStudentDetails  --radwa
    @StudentID INT,
    @NewStudentFname NVARCHAR(50),
    @NewStudentLname NVARCHAR(50),
    @NewStudentEmail NVARCHAR(100),
    @NewStudentPhone NVARCHAR(15)
AS
BEGIN
    -- ??? ??? ??? ?????? ???? ?????? (?????? ??????)
    SET NOCOUNT ON;

    -- ??????? ??? ?????? ??????
    UPDATE Student
    SET 
        StudentFname = @NewStudentFname,
        StudentLname = @NewStudentLname,
        StudentEmail = @NewStudentEmail,
        StudentPhone = @NewStudentPhone
    WHERE StudentID = @StudentID;
END

----------------------------------------------------------------

CREATE or ALTER PROCEDURE CalculateTotalGrade  --radwa
    @StudentID INT
AS
BEGIN
    DECLARE @total_grade FLOAT 

    SELECT @total_grade = SUM(Grade)
    FROM ExamStudentAnswer
    WHERE StudentID = @StudentID;

    SELECT @total_grade AS TotalGrade;
END;


 ---------------------------------------------------------


create or alter procedure insertstudent   --mariam
@studentid char(14),@firstname varchar(20) , @lastname varchar(20),@dateofbirth date,@email varchar(70),
@phone char(11),@address varchar(20)
as
begin
insert into Student(StudentID,StudentFname,StudentLname,StudentDOB,StudentEmail,StudentPhone,StudentAddress)
values(@studentid,@firstname, @lastname ,@dateofbirth,@email,@phone,@address)
end;


----------------------------------------------------------------

CREATE PROCEDURE PS_UpdateExamSchedule  --saher
    @ExamID INT,
    @NewExamDate DATE,
    @NewStartTime TIME,
    @NewEndTime TIME
AS
BEGIN
    UPDATE Exam
    SET 
        ExamDate = @NewExamDate,
        ExamStartTime = @NewStartTime,
       ExamEndTime = @NewEndTime
    WHERE ExamID = @ExamID
END