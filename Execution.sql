
					-------------------functions------------------------------

------------- calculate exam result

select dbo.FN_CalculateExamResult('20250000000102',1)


select dbo.calculate_student_total_marks('20250000000102')

-------------------------get all students

select dbo.fn_getotallenrollmentstudent()

------------------------------check true false question

select dbo.fn_truefalsequestions(1,0)


					-------------------procedures------------------------------

execute assignExam '20250000000105',1,1

execute UpdateCourse 2,'2025-5-19','2025-5-27',3,5

execute CreateExam 1,1,2,2,2,'corrective','manual','01:00:00','02:00:00','2025-5-22'

execute CreateExam 1,1,2,2,2,'corrective','random','01:00:00','02:00:00','2025-5-22'

