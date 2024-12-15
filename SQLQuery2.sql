CREATE TABLE Department (
	DepartmentID INT PRIMARY KEY,
	DepartmentName VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Designation (
	DesignationID INT PRIMARY KEY,
	DesignationName VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Person (
	PersonID INT PRIMARY KEY IDENTITY(101,1),
	FirstName VARCHAR(100) NOT NULL,
	LastName VARCHAR(100) NOT NULL,
	Salary DECIMAL(8, 2) NOT NULL,
	JoiningDate DATETIME NOT NULL,
	DepartmentID INT NULL,
	DesignationID INT NULL,
	FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
	FOREIGN KEY (DesignationID) REFERENCES Designation(DesignationID)
);

--Part – A
--1. Department, Designation & Person Table’s INSERT, UPDATE & DELETE Procedures.

--Department Table’s INSERT
CREATE OR ALTER PROCEDURE PR_INS_DEPARTMENT
	@DepartmentID INT,
	@DepartmentName VARCHAR(100)
AS 
BEGIN
	INSERT INTO Department(DepartmentID, DepartmentName) 
	VALUES (@DepartmentID, @DepartmentName)
END

EXECUTE PR_INS_DEPARTMENT 6, 'ELECTRONIC'
SELECT * FROM Department

--Department Table’s Update
CREATE OR ALTER PROCEDURE PR_UPDATE_DEPARTMENT
	@DepartmentID INT,
	@DepartmentName VARCHAR(100)
AS 
BEGIN
	UPDATE Department 
	SET DepartmentName = @DepartmentName
	WHERE DepartmentID = @DepartmentID
END

EXEC PR_UPDATE_DEPARTMENT 6, 'EE'

--Department Table’s Delete
CREATE OR ALTER PROCEDURE PR_DELETE_DEPARTMENT
	@DepartmentID INT
AS 
BEGIN
	DELETE FROM Department 
	WHERE DepartmentID = @DepartmentID
END

EXEC PR_DELETE_DEPARTMENT 6
SELECT * FROM Department

--DESIGNATION Table’s INSERT
CREATE OR ALTER PROCEDURE PR_INS_DESIGNATION
	@DesignationID INT,
	@DesignationName VARCHAR(100)
AS 
BEGIN
	INSERT INTO Designation(DesignationID, DesignationName) 
	VALUES (@DesignationID, @DesignationName)
END

EXEC PR_INS_DESIGNATION 16, 'SECRETRY'

--DESIGNATION Table’s UPDATE
CREATE OR ALTER PROCEDURE PR_UPDATE_DESIGNATION
	@DesignationID INT,
	@DesignationName VARCHAR(100)
AS 
BEGIN
	UPDATE Designation SET DesignationName = @DesignationName 
	WHERE DesignationID = @DesignationID
END

EXEC PR_UPDATE_DESIGNATION 16, 'ASSISTANT_MANAGER'
SELECT * FROM Designation

--DESIGNATION Table’s DELETE
CREATE OR ALTER PROCEDURE PR_DELETE_DESIGNATION
	@DesignationID INT
AS 
BEGIN
	DELETE FROM Designation
	WHERE DesignationID = @DesignationID
END

EXEC PR_DELETE_DESIGNATION 16
SELECT * FROM Designation

--PERSON Table’s INSERT
CREATE OR ALTER PROCEDURE PR_INS_PERSON
	@FirstName VARCHAR(100),
	@LastName VARCHAR(100),
	@Salary DECIMAL(8, 2),
	@JoiningDate DATETIME,
	@DepartmentID INT,
	@DesignationID INT
AS 
BEGIN
	INSERT INTO Person (
	FirstName,
	LastName,
	Salary,
	JoiningDate,
	DepartmentID,
	DesignationID
	) 
	VALUES (@FirstName,	@LastName, @Salary, @JoiningDate, @DepartmentID, @DesignationID )
END

EXEC PR_INS_PERSON 'VARUN', 'PATTANI', 150, '2017-6-3', 4, 13

--PERSON Table’s UPDATE
CREATE OR ALTER PROCEDURE PR_Update_PERSON
	@PersonID INT,
	@FirstName VARCHAR(100),
	@LastName VARCHAR(100),
	@Salary DECIMAL(8, 2),
	@JoiningDate DATETIME,
	@DepartmentID INT,
	@DesignationID INT
AS 
BEGIN
	UPDATE Person  
	SET FirstName = @FirstName,	
	LastName = @LastName, 
	Salary = @Salary, 
	JoiningDate = @JoiningDate,
	DepartmentID = @DepartmentID, 
	DesignationID = @DesignationID
	where PersonID = @PersonID
END

EXEC PR_Update_PERSON 101, 'BHUPENDRA', 'JOGI', 250, '2018-5-14', 1, 12
SELECT * FROM Person

--PERSON Table’s DELETE
CREATE OR ALTER PROCEDURE PR_DELETE_PERSON 
	@PersonID INT
AS 
BEGIN
	DELETE from Person where PersonID = @PersonID
END

EXEC PR_DELETE_PERSON 101
SELECT * FROM Person

--2. Department, Designation & Person Table’s SELECT BY PRIMARYKEY
--FOR PERSON
CREATE OR ALTER PROCEDURE PR_PERSON_SELECTBYPRIMARYKEY
	@PersonID INT
AS 
BEGIN
	SELECT * FROM PERSON WHERE PersonID = @PersonID
END

EXEC PR_PERSON_SELECTBYPRIMARYKEY 102

--FOR Department
CREATE OR ALTER PROCEDURE PR_DEPARTMENT_SELECTBYPRIMARYKEY
	@DepartmentID INT
AS 
BEGIN
	SELECT * FROM DEPARTMENT WHERE DepartmentID = @DepartmentID
END

EXEC PR_DEPARTMENT_SELECTBYPRIMARYKEY 1

--FOR Designation
CREATE OR ALTER PROCEDURE PR_DESIGNATION_SELECTBYPRIMARYKEY
	@DesignationID INT
AS 
BEGIN
	SELECT * FROM Designation WHERE DesignationID = @DesignationID
END

EXEC PR_DESIGNATION_SELECTBYPRIMARYKEY 13

--3. Department, Designation & Person Table’s 
--(If foreign key is available then do write join and take columns on select list)
CREATE OR ALTER PROCEDURE PR_JOIN_TABLES
AS 
BEGIN
	SELECT * FROM
	PERSON INNER JOIN Department ON
	PERSON.DepartmentID = Department.DepartmentID
	INNER JOIN Designation ON
	Designation.DesignationID = Person.DesignationID
END

EXEC PR_JOIN_TABLES

--4. Create a Procedure that shows details of the first 3 persons.
CREATE OR ALTER PROCEDURE PR_TOP3_PERSON
AS 
BEGIN
	SELECT TOP 3 * FROM
	PERSON INNER JOIN Department ON
	PERSON.DepartmentID = Department.DepartmentID
	INNER JOIN Designation ON
	Designation.DesignationID = Person.DesignationID
END

EXEC PR_TOP3_PERSON

--Part – B
--5. Create a Procedure that takes the department name as input and returns a table 
--with all workers working in that department.
CREATE OR ALTER PROCEDURE PR_GET_DEPT_WORKERS
@DepartmentName VARCHAR(50)
AS 
BEGIN
	SELECT FirstName, LastName FROM 
	PERSON INNER JOIN Department ON
	Person.DepartmentID = Department.DepartmentID
	WHERE DepartmentName = @DepartmentName
END

EXEC PR_GET_DEPT_WORKERS 'IT'

--6. Create Procedure that takes department name & designation name as input and returns 
--a table with worker’s first name, salary, joining date & department name.
CREATE OR ALTER PROCEDURE PR_PERSON_INFO
@DepartmentName Varchar (100),
@DesignationName Varchar (100)
AS 
BEGIN
	SELECT FirstName, Salary, JoiningDate, DepartmentName FROM
	PERSON INNER JOIN Department ON
	PERSON.DepartmentID = Department.DepartmentID
	INNER JOIN Designation ON
	Person.DesignationID = Designation.DesignationID
	WHERE DepartmentName = @DepartmentName AND DesignationName = @DesignationName
END

EXEC PR_PERSON_INFO 'IT', 'CEO'

--7. Create a Procedure that takes the first name as an input parameter and display all 
--the details of the worker with their department & designation name.
CREATE OR ALTER PROCEDURE PR_PERSON_DETAIL
@FirstName Varchar(100) 
AS 
BEGIN
	SELECT * FROM 
	Person INNER JOIN Department ON
	Person.DepartmentID = Department.DepartmentID
	INNER JOIN Designation ON
	Person.DesignationID = Designation.DesignationID
	WHERE person.FirstName = @FirstName
END

EXEC PR_PERSON_DETAIL 'Hardik'

--8. Create Procedure which displays department wise maximum, minimum & total salaries.
CREATE OR ALTER PROCEDURE PR_DEPT_WISE_SAL
AS
BEGIN
	SELECT MAX(SALARY) AS MAX_SAL, MIN(SALARY) AS MIN_SAL, SUM(SALARY) AS TOTAL_SAL
	FROM PERSON INNER JOIN DEPARTMENT ON 
	Person.DepartmentID = Department.DepartmentID
	GROUP BY DEPARTMENT.DepartmentID
END

EXEC PR_DEPT_WISE_SAL

--9. Create Procedure which displays designation wise average & total salaries.
CREATE OR ALTER PROCEDURE PR_DESIGNATION_WISE_SAL
@DESIGNATIONNAME VARCHAR(100)
AS
BEGIN
	SELECT AVG(SALARY) AS AVG_SAL, SUM(SALARY) AS TOTAL_SAL
	FROM PERSON INNER JOIN Designation ON
	Person.DesignationID = Designation.DesignationID
	WHERE DesignationName = @DESIGNATIONNAME
END

exec PR_DESIGNATION_WISE_SAL 'Clerk'

--Part – C
--10. Create Procedure that Accepts Department Name and Returns Person Count.
CREATE OR ALTER PROCEDURE PR_DEPT_PERSON_COUNT
@DEPARTMENTNAME VARCHAR(50)
AS
BEGIN
	SELECT DepartmentName, COUNT(PERSONID) AS PERSON_COUNT FROM 
	PERSON INNER JOIN Department ON
	Person.DepartmentID = Department.DepartmentID
	GROUP BY DepartmentName
	HAVING DepartmentName = @DEPARTMENTNAME
END

EXEC PR_DEPT_PERSON_COUNT 'IT'

--11. Create a procedure that takes a salary value as input and returns all workers with a 
--salary greater than input salary value along with their department and designation details.
CREATE OR ALTER PROCEDURE PR_MININUM_SAL_PERSON
@SALARY Decimal (8,2) 
AS
BEGIN
	SELECT Person.FirstName, Person.LastName, person.Salary, Department.DepartmentName, Designation.DesignationName FROM 
	PERSON INNER JOIN Department ON
	Person.DepartmentID = Department.DepartmentID
	INNER JOIN Designation ON
	Person.DesignationID = Designation.DesignationID
	WHERE Person.Salary > @SALARY
END

EXEC PR_MININUM_SAL_PERSON 17000

--12. Create a procedure to find the department(s) with the highest total salary among all departments.
CREATE OR ALTER PROCEDURE PR_DEPT_HIGHEST_SAL
AS 
BEGIN
	SELECT TOP 1 DepartmentName, SUM(SALARY) FROM 
	PERSON INNER JOIN Department ON
	Person.DepartmentID = Department.DepartmentID
	GROUP BY DepartmentName
	ORDER BY SUM(SALARY) DESC
END

EXEC PR_DEPT_HIGHEST_SAL

--13. Create a procedure that takes a designation name as input and returns a list of all workers 
--under that designation who joined within the last 10 years, along with their department.
CREATE OR ALTER PROCEDURE PR_FIND_BY_DESIGNATION
@DESIGNATIONNAME VARCHAR(50)
AS
BEGIN
	SELECT Person.PersonID, Person.FirstName, Person.LastName, Person.Salary, Person.JoiningDate,
	Department.DepartmentName, Designation.DesignationName FROM 
	Person INNER JOIN Department ON
	Person.DepartmentID = Department.DepartmentID
	INNER JOIN Designation ON
	Person.DesignationID = Designation.DesignationID
	WHERE DesignationName = @DESIGNATIONNAME AND
	DATEDIFF(YEAR, JoiningDate, GETDATE()) <= 10
END

EXEC PR_FIND_BY_DESIGNATION 'CEO'

--14. Create a procedure to list the number of workers in each department who do not have a designation
--assigned.
CREATE OR ALTER PROCEDURE PR_NO_DESIGNATION
AS
BEGIN
	SELECT Department.DepartmentName, COUNT(Person.PersonID) FROM 
	Person INNER JOIN Department ON
	Person.DepartmentID = Department.DepartmentID 
	LEFT JOIN Designation ON
	Person.DesignationID = Designation.DesignationID
	WHERE Designation.DesignationName IS NULL
	GROUP BY DEPARTMENT.DepartmentName
END

EXEC PR_NO_DESIGNATION

--15. Create a procedure to retrieve the details of workers in departments where the average salary is 
--above 12000.
CREATE OR ALTER PROCEDURE PR_DEPT_AVG_ABOVE12000
AS
BEGIN
	SELECT DepartmentName, AVG(SALARY) FROM
	Person INNER JOIN Department ON
	Person.DepartmentID = Department.DepartmentID
	GROUP BY DepartmentName
	HAVING AVG(SALARY) > 12000
END

EXEC PR_DEPT_AVG_ABOVE12000