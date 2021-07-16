with cte_employee as
(select firstname,lastname,gender,salary
,COUNT(gender)over (partition by gender) as totalgender
,AVG(salary)over (partition by gender) as avgsalary
from  [dbo].[EmployeeDemographics] emp
join [dbo].[employeesalary] sal
on emp.EmployeeID = sal.employeeID
where salary > '45000'
)
select *
from cte_employee


with cte_employee as
(select firstname,lastname,gender,salary
,COUNT(gender)over (partition by gender) as totalgender
,AVG(salary)over (partition by gender) as avgsalary
from  [dbo].[EmployeeDemographics] emp
join [dbo].[employeesalary] sal
on emp.EmployeeID = sal.employeeID
where salary > '45000'
)

select firstname,avgsalary
from cte_employee



Create table #temp_employee2 (
EmployeeID int,
JobTitle varchar(100),
Salary int
)

Select * From #temp_employee2

Insert into #temp_employee2 values (
'1001', 'HR', '45000'
)

Insert into #temp_employee2 
SELECT * 
From EmployeeSalary

Select * From #temp_employee2


Create table #temp_employee3 (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)

Insert into #temp_employee3
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM EmployeeDemographics emp
JOIN EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
group by JobTitle

Select * 
From #temp_employee3

SELECT AvgAge * AvgSalary
from #temp_employee3

CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired')

Select *
From EmployeeErrors

-- Using Trim, LTRIM, RTRIM

Select EmployeeID, TRIM(employeeID) AS IDTRIM
FROM EmployeeErrors 

Select EmployeeID, RTRIM(employeeID) as IDRTRIM
FROM EmployeeErrors 

Select EmployeeID, LTRIM(employeeID) as IDLTRIM
FROM EmployeeErrors 

-- Using Replace

Select LastName, REPLACE(LastName, '- Fired', '') as LastNameFixed
FROM EmployeeErrors

-- Using Substring

Select Substring(err.FirstName,1,3), Substring(dem.FirstName,1,3), Substring(err.LastName,1,3), Substring(dem.LastName,1,3)
FROM EmployeeErrors err
JOIN EmployeeDemographics dem
	on Substring(err.FirstName,1,3) = Substring(dem.FirstName,1,3)
	and Substring(err.LastName,1,3) = Substring(dem.LastName,1,3)

-- Using UPPER and lower

Select firstname, LOWER(firstname)
from EmployeeErrors

Select Firstname, UPPER(FirstName)
from EmployeeErrors


CREATE PROCEDURE Temp_Employee
AS
DROP TABLE IF EXISTS #temp_employee
Create table #temp_employee (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)


Insert into #temp_employee
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM EmployeeDemographics emp
JOIN EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
group by JobTitle

Select * 
From #temp_employee
GO;

Select EmployeeID, JobTitle, Salary
From EmployeeSalary

-- Subquery in Select

Select EmployeeID, Salary, (Select AVG(Salary) From EmployeeSalary) as AllAvgSalary
From EmployeeSalary

-- How to do it with Partition By
Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
From EmployeeSalary

-- Why Group By doesn't work
Select EmployeeID, Salary, AVG(Salary) as AllAvgSalary
From EmployeeSalary
Group By EmployeeID, Salary
order by EmployeeID


-- Subquery in From

Select a.EmployeeID, AllAvgSalary
From 
	(Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
	 From EmployeeSalary) a
Order by a.EmployeeID


-- Subquery in Where


Select EmployeeID, JobTitle, Salary
From EmployeeSalary
where EmployeeID in (
	Select EmployeeID 
	From EmployeeDemographics
	where Age > 30)