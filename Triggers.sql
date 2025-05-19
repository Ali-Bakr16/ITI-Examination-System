CREATE OR ALTER TRIGGER DuplicatAssignExam
ON ExamStudentCourse
AFTER INSERT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM inserted i
        JOIN ExamStudentCourse esc
            ON esc.ExamID = i.ExamID
           AND esc.StudentID = i.StudentID
    )
    BEGIN
        PRINT 'YOU CAN NOT DUPLICATE EXAM'
        ROLLBACK
    END
END
-----------------------------------------------------

CREATE OR ALTER TRIGGER trg_PreventNegativeMarks   ---radwa
ON ExamStudentAnswer
instead of INSERT
AS
BEGIN
    
    IF EXISTS (
        SELECT 1 
        FROM inserted 
        WHERE Grade < 0
    )
    BEGIN
        RAISERROR ('Cannot insert or update a negative mark.', 16, 1);
        ROLLBACK;
        
    END
END; 

--------------------------------------------------------

CREATE OR ALTER TRIGGER TP_PreventStudentTakeExamAfterDuration  ---saher
ON examStudentAnswer
INSTEAD OF INSERT
AS
BEGIN
    -- Check if student exceeded maximum attempts for this exam
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN (
            SELECT StudentID, ExamID, COUNT(*) AS AttemptsCount
            FROM examStudentAnswer
            GROUP BY StudentID, ExamID
        ) AS attempts ON i.StudentID = attempts.StudentID AND i.ExamID = attempts.ExamID
        WHERE attempts.AttemptsCount >= 2
    )
    BEGIN
        RAISERROR('You have reached the maximum number of exam attempts.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Check if the current time is after exam end time
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Exam e ON i.ExamID = e.ExamID
        WHERE GETDATE() > DATEADD(SECOND, DATEDIFF(SECOND, '00:00:00', e.ExamEndTime), e.ExamDate)
    )
    BEGIN
        RAISERROR('Cannot submit answer after exam end time.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- If all checks passed, insert the new answers
    INSERT INTO examStudentAnswer (StudentID, ExamID, Grade, StuAnsID)
    SELECT StudentID, ExamID, Grade, StuAnsID
    FROM inserted;
END;



------------------------------------------------------

 create trigger tr_preventmodificationaftercorrect  ---mariam
on examstudentanswer
after update
as
begin
  if exists(
    select 1
    from inserted i
    join deleted d on i.StuAnsID=d.StuAnsID
    where d.Grade is not null
   )
  begin 
     raiserror('Update not allowed',16,1)
     rollback transaction;
  end

end;

-----------------------------------------------------

CREATE OR ALTER TRIGGER TP_PreventStudentTakeExamAfterDuration   ---saher
ON examStudentAnswer
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Exam e ON i.ExamID = e.ExamID
        WHERE GETDATE() > DATEADD(SECOND, DATEDIFF(SECOND, '00:00:00', e.ExamEndTime), e.ExamDate)
    )
    BEGIN
       RAISERROR('Cannot submit answer after exam end time.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        INSERT INTO ExamStudentAnswer (StudentID, ExamID, Grade, StuAnsID)
        SELECT StudentID, ExamID, Grade, StuAnsID
         FROM inserted;
    END
END;
