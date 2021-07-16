select *
from [dbo].[EmployeeDemographics]

select *
from [dbo].[employeesalary]

Insert into [dbo].[employeesalary] VALUES
(1010, null, 47000),
(NULL, 'Salesman', 43000)

select *
from [dbo].[EmployeeDemographics]
inner join [dbo].[employeesalary]
	on EmployeeDemographics.EmployeeID = employeesalary.employeeID

select *
from [dbo].[EmployeeDemographics]
full outer join [dbo].[employeesalary]
on EmployeeDemographics.EmployeeID = employeesalary.employeeID

select *
from [dbo].[EmployeeDemographics]
left outer join [dbo].[employeesalary]
	on EmployeeDemographics.EmployeeID = employeesalary.employeeID

select *
from [dbo].[EmployeeDemographics]
right outer join [dbo].[employeesalary]
	on EmployeeDemographics.EmployeeID = employeesalary.employeeID

select EmployeeDemographics.EmployeeID,firstname,LastName,jobtitle,salary
from [dbo].[EmployeeDemographics]
inner join [dbo].[employeesalary]
	on EmployeeDemographics.EmployeeID = employeesalary.employeeID

select EmployeeDemographics.EmployeeID,firstname,LastName,jobtitle,salary
from [dbo].[EmployeeDemographics]
right outer join [dbo].[employeesalary]
	on EmployeeDemographics.EmployeeID = employeesalary.employeeID

select employeesalary.EmployeeID,firstname,LastName,jobtitle,salary
from [dbo].[EmployeeDemographics]
left outer join [dbo].[employeesalary]
	on EmployeeDemographics.EmployeeID = employeesalary.employeeID

select  EmployeeDemographics.EmployeeID,firstname,LastName,salary
from [dbo].[EmployeeDemographics]
inner  join [dbo].[employeesalary]
on EmployeeDemographics.EmployeeID = employeesalary.employeeID

select  EmployeeDemographics.EmployeeID,firstname,LastName,salary
from [dbo].[EmployeeDemographics]
inner  join [dbo].[employeesalary]
on EmployeeDemographics.EmployeeID = employeesalary.employeeID
where FirstName <> 'michael'
order by salary desc

select  jobtitle,avg(salary)
from [dbo].[EmployeeDemographics]
inner  join [dbo].[employeesalary]
on EmployeeDemographics.EmployeeID = employeesalary.employeeID
where jobtitle = 'salesman'
group by jobtitle

Create Table WareHouseEmployeeDemographics 
(EmployeeID int, 
FirstName varchar(50), 
LastName varchar(50), 
Age int, 
Gender varchar(50)
)

Insert into WareHouseEmployeeDemographics VALUES
(1013, 'Darryl', 'Philbin', NULL, 'Male'),
(1050, 'Roy', 'Anderson', 31, 'Male'),
(1051, 'Hidetoshi', 'Hasagawa', 40, 'Male'),
(1052, 'Val', 'Johnson', 31, 'Female')

select * 
from [dbo].[EmployeeDemographics]
full outer join [dbo].[WareHouseEmployeeDemographics]
	on [dbo].[EmployeeDemographics].EmployeeID =
	[dbo].[WareHouseEmployeeDemographics].EmployeeID

select *
from [dbo].[EmployeeDemographics]
union
select *
from [dbo].[WareHouseEmployeeDemographics]

select *
from [dbo].[EmployeeDemographics]
union all
select *
from [dbo].[WareHouseEmployeeDemographics]
order by EmployeeID

select  firstname, lastname, age
from [dbo].[EmployeeDemographics]
where Age is not null 
order by Age

select  firstname, lastname, age,
CASE 
	when age > 30 then 'old'
	when age between 27 and 30 then 'young'
	else 'baby'
end
from [dbo].[EmployeeDemographics]
where Age is not null 
order by Age

select  firstname, lastname, age,
CASE 
	when age = 38 then 'stanley'
	when age > 30 then 'old'
	else 'baby'
end
from [dbo].[EmployeeDemographics]
where Age is not null 
order by Age

select firstname,lastname,jobtitle,salary,
case 
	when jobtitle = 'salesman' then salary + (salary * 0.10)
	when jobtitle = 'accountant' then salary + (salary * 0.10)
	when jobtitle = 'hr' then salary + (salary * 0.10)
	else salary + (salary * 0.03)
end as salaryafterraise
from [dbo].[EmployeeDemographics]
join [dbo].[employeesalary]
on [dbo].[EmployeeDemographics].EmployeeID = [dbo].[employeesalary].employeeID

select jobtitle,COUNT(jobtitle)
from [dbo].[EmployeeDemographics]
join [dbo].[employeesalary]
on [dbo].[EmployeeDemographics].EmployeeID = [dbo].[employeesalary].employeeID
group by jobtitle

select jobtitle,COUNT(jobtitle)
from [dbo].[EmployeeDemographics]
join [dbo].[employeesalary]
on [dbo].[EmployeeDemographics].EmployeeID = [dbo].[employeesalary].employeeID
group by jobtitle
having COUNT(jobtitle) > 1

select jobtitle,AVG(salary)
from [dbo].[EmployeeDemographics]
join [dbo].[employeesalary]
on [dbo].[EmployeeDemographics].EmployeeID = [dbo].[employeesalary].employeeID
group by jobtitle
having AVG(salary) > 45000
order by AVG(salary)

select *
from [dbo].[EmployeeDemographics]

update[dbo].[EmployeeDemographics]
set employeeid = 1012
where firstname = 'holly' and lastname = 'flax'

update[dbo].[EmployeeDemographics]
set Age = 31, Gender = 'female'
where firstname = 'holly' and lastname = 'flax'

select *
from [dbo].[EmployeeDemographics]
where EmployeeID = 1013

delete
from [dbo].[EmployeeDemographics]
where EmployeeID = 1013

select *
from [dbo].[employeesalary]

select *
from [dbo].[WareHouseEmployeeDemographics]

select * 
from  [dbo].[EmployeeDemographics] dem
join [dbo].[employeesalary] sal 
on dem.EmployeeID = sal.employeeID

select FirstName, LastName, Gender, salary
, COUNT(gender) over (partition by gender) as totalgender
from  [dbo].[EmployeeDemographics] dem
join [dbo].[employeesalary] sal 
on dem.EmployeeID = sal.employeeID

select  Gender,  COUNT(gender) 
from  [dbo].[EmployeeDemographics] dem
join [dbo].[employeesalary] sal 
on dem.EmployeeID = sal.employeeID
group by  Gender