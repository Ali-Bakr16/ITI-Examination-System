CREATE OR ALTER FUNCTION FN_CalculateExamResult  ---saher
(
    @StudentID char(14),
    @ExamID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT

    SELECT @Result = SUM(esa.Grade)
    FROM ExamStudentAnswer esa
    JOIN StudentAnswer sa ON esa.StuAnsID = esa.StuAnsID
    WHERE esa.StudentID = @StudentID
      AND esa.ExamID = @ExamID
      AND sa.IsCorrect = 1

    RETURN @Result
END


	------------------------------------------------------------------------------


CREATE OR ALTER FUNCTION calculate_student_total_marks (@student_id CHAR(14)) ---radwa
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total_marks DECIMAL(10,2) = 0;

    SELECT @total_marks = ISNULL(SUM(EXA.Grade), 0)
    FROM studentanswer SA
    JOIN ExamStudentAnswer EXA ON EXA.StuAnsID = SA.stuans
    JOIN Exam E ON E.ExamID = EXA.ExamID

    WHERE EXA.StudentID = @student_id;

    RETURN @total_marks
END



------------------------------------------------------

create OR ALTER function fn_getotallenrollmentstudent() ---mariam
returns int
as
begin
  declare @total int;
  select @total=count(StudentID)
  from Student;
  return @total;
end;


---------------------------------------------------------

create OR ALTER function fn_truefalsequestions(@questionID int,@UserAnswer bit) --mariam
returns int
as
begin
declare @grade int;
select @grade =
       case
	   WHEN CorrectAnswer = @UserAnswer THEN 1
            ELSE 0
        END
    FROM TrueFalseQuestion
    WHERE question_id = @QuestionID;

    RETURN ISNULL(@Grade, 0); 
END;