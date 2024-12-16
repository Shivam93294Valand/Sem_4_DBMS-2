-- Create Departments Table
CREATE TABLE Departments (
	DepartmentID INT PRIMARY KEY,
	DepartmentName VARCHAR(100) NOT NULL UNIQUE,
	ManagerID INT NOT NULL,
	Location VARCHAR(100) NOT NULL
);

-- Create Employee Table
CREATE TABLE Employee (
	EmployeeID INT PRIMARY KEY,
	FirstName VARCHAR(100) NOT NULL,
	LastName VARCHAR(100) NOT NULL,
	DoB DATETIME NOT NULL,
	Gender VARCHAR(50) NOT NULL,
	HireDate DATETIME NOT NULL,
	DepartmentID INT NOT NULL,
	Salary DECIMAL(10, 2) NOT NULL,
	FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Create Projects Table
CREATE TABLE Projects (
	ProjectID INT PRIMARY KEY,
	ProjectName VARCHAR(100) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	DepartmentID INT NOT NULL,
	FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

INSERT INTO Departments (DepartmentID, DepartmentName, ManagerID, Location)
VALUES
	(1, 'IT', 101, 'New York'),
	(2, 'HR', 102, 'San Francisco'),
	(3, 'Finance', 103, 'Los Angeles'),
	(4, 'Admin', 104, 'Chicago'),
	(5, 'Marketing', 105, 'Miami');

INSERT INTO Employee (EmployeeID, FirstName, LastName, DoB, Gender, HireDate, DepartmentID, Salary)
VALUES
	(101, 'John', 'Doe', '1985-04-12', 'Male', '2010-06-15', 1, 75000.00),
	(102, 'Jane', 'Smith', '1990-08-24', 'Female', '2015-03-10', 2, 60000.00),
	(103, 'Robert', 'Brown', '1982-12-05', 'Male', '2008-09-25', 3, 82000.00),
	(104, 'Emily', 'Davis', '1988-11-11', 'Female', '2012-07-18', 4, 58000.00),
	(105, 'Michael', 'Wilson', '1992-02-02', 'Male', '2018-11-30', 5, 67000.00);

INSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate, DepartmentID)
VALUES
	(201, 'Project Alpha', '2022-01-01', '2022-12-31', 1),
	(202, 'Project Beta', '2023-03-15', '2024-03-14', 2),
	(203, 'Project Gamma', '2021-06-01', '2022-05-31', 3),
	(204, 'Project Delta', '2020-10-10', '2021-10-09', 4),
	(205, 'Project Epsilon', '2024-04-01', '2025-03-31', 5);

--Part – A
--1. Create Stored Procedure for Employee table As User enters either First Name or Last Name 
--and based on this you must give EmployeeID, DOB, Gender & Hiredate.
CREATE OR ALTER PROCEDURE PR_DATA_BYNAME
@NAME VARCHAR(50)
AS 
BEGIN
	SELECT Employee.EmployeeID, Employee.FirstName, Employee.LastName, Employee.DoB, Employee.Gender, Employee.HireDate FROM Employee
	WHERE FirstName = @NAME OR LastName = @NAME
END

EXEC PR_DATA_BYNAME 'Brown'

--2. Create a Procedure that will accept Department Name and based on that gives employees 
--list who belongs to that department. 
CREATE OR ALTER PROCEDURE PR_EMPLOYEE_DEPT_WISE
@DepartmentNAME VARCHAR(50)
AS
BEGIN
	SELECT Employee.FirstName, Employee.LastName FROM 
	EMPLOYEE INNER JOIN Departments ON
	Employee.DepartmentID = Departments.DepartmentID
	WHERE Departments.DepartmentName = @DepartmentNAME
END

EXEC PR_EMPLOYEE_DEPT_WISE 'IT'

--3. Create a Procedure that accepts Project Name & Department Name and based on that you 
--must give all the project related details.
CREATE OR ALTER PROCEDURE PR_PROJECT_DETAILS
@PROJECTNAME VARCHAR(50),
@DEPARTMENTNAME VARCHAR(50)
AS
BEGIN
	SELECT Projects.ProjectName, Departments.DepartmentName, Projects.StartDate, Projects.EndDate FROM
	Projects INNER JOIN Departments ON
	Projects.DepartmentID = Departments.DepartmentID
	WHERE Projects.ProjectName = @PROJECTNAME AND Departments.DepartmentName = @DEPARTMENTNAME
END

EXEC PR_PROJECT_DETAILS 'Project Gamma', 'Finance'

--4. Create a procedure that will accepts any integer and if salary is between provided integer, 
--then those employee list comes in output.
CREATE OR ALTER PROCEDURE PR_SALARY_FILTER
@N1 INT,
@N2 INT
AS
BEGIN
	SELECT Employee.FirstName + ' ' + Employee.LastName FROM Employee 
	WHERE Employee.Salary BETWEEN @N1 AND @N2
END

EXEC PR_SALARY_FILTER 55000, 65000 

--5. Create a Procedure that will accepts a date and gives all the employees who all are hired 
--on that date.
CREATE OR ALTER PROCEDURE PR_EMPLOYEE_BY_HIREDATE
@DATE DATE
AS
BEGIN
	SELECT Employee.FirstName + ' ' + Employee.LastName FROM Employee 
	WHERE Employee.HireDate = @DATE
END

EXEC PR_EMPLOYEE_BY_HIREDATE '2015-03-10'


--Part – B
--6. Create a Procedure that accepts Gender’s first letter only and based on that employee details
--will be served.
CREATE OR ALTER PROCEDURE PR_EMP_BY_GEMDER
@GENDER CHAR(1)
AS
BEGIN
	SELECT * FROM Employee 
	WHERE Gender LIKE @GENDER + '%'
END

EXEC PR_EMP_BY_GEMDER 'F'

--7. Create a Procedure that accepts First Name or Department Name as input and based on that employee
--data will come.
CREATE OR ALTER PROCEDURE PR_EMP_DATA_BYFNAME_AND_DEPT
@NAME VARCHAR(10),
@DEPT VARCHAR(10)
AS
BEGIN
	SELECT * FROM 
	Employee INNER JOIN Departments ON
	Employee.DepartmentID = Departments.DepartmentID
	WHERE FirstName = @NAME AND DepartmentName = @DEPT
END

EXEC PR_EMP_DATA_BYFNAME_AND_DEPT 'Emily', 'ADMIN'

--8. Create a procedure that will accepts location, if user enters a location any characters, then 
--he/she will get all the departments with all data. 
CREATE OR ALTER PROCEDURE PR_DEPARTMENTS_BY_LOCATION
@LOCATION VARCHAR(100) = NULL
AS
BEGIN
    IF @LOCATION IS NULL OR @LOCATION = ''
    BEGIN
        SELECT * FROM Departments;
    END
    ELSE
    BEGIN
        SELECT * FROM Departments
        WHERE Location LIKE @LOCATION + '%'; 
    END
END

EXEC PR_DEPARTMENTS_BY_LOCATION 'Los Angeles'


--Part – C
--9. Create a procedure that will accepts From Date & To Date and based on that he/she will retrieve 
--Project related data.
CREATE OR ALTER PROCEDURE PR_PROJECT_DATA_BYDATE
@FROMDATE DATE,
@TODATE DATE
AS
BEGIN
	SELECT ProjectID, ProjectName FROM Projects
	WHERE StartDate = @FROMDATE AND EndDate = @TODATE
END

EXEC PR_PROJECT_DATA_BYDATE '2023-03-15','2024-03-14'

--10. Create a procedure in which user will enter project name & location and based on that you must
--provide all data with Department Name, Manager Name with Project Name & Starting Ending Dates. 
CREATE OR ALTER PROCEDURE PR_DATA_BY_LOC_AND_PROJ_NAME
@PROJECTNAME VARCHAR(50),
@LOC VARCHAR(25)
AS
BEGIN
	SELECT Departments.DepartmentID, Employee.FirstName + ' ' + Employee.LastName AS MANAGER_NAME,
	Projects.ProjectName, Projects.StartDate, Projects.EndDate FROM
	Employee INNER JOIN Departments ON
	Employee.DepartmentID = Departments.DepartmentID 
	INNER JOIN Projects ON
	Projects.DepartmentID = Departments.DepartmentID
	WHERE Projects.ProjectName = @PROJECTNAME AND Departments.Location = @LOC
END

EXEC PR_DATA_BY_LOC_AND_PROJ_NAME 'Project Delta', 'Chicago'