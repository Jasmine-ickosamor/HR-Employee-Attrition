Create database Project;
use project;
Create table HR_ATT(
Age	int,
Attrition text,	
Business_Travel	varchar(50),
Daily_Rate	smallint,
Department	varchar(250),
Distance_From_Home	int,
Education	int,
Education_Field	varchar(100),
Employee_Count	int,
Employee_Number	int,
Environment_Satisfaction smallint,
Gender Varchar(20),
Hourly_Rate	int,
Job_Involvement	smallint,
Job_Level smallint,
Job_Role varchar(200),
Job_Satisfaction smallint,
Marital_Status	varchar(50),
Monthly_Income	int,
Monthly_Rate	int,
Num_Companies_Worked int,	
Over_18 text,
Over_Time float,
Percent_Salary_Hike	float,
Performance_Rating	float,
Relationship_Satisfaction	varchar(20),
Standard_Hours int,
Stock_Option_Level	tinyint,
Total_Working_Years	smallint,
Training_Times_Last_Year	smallint,
Work_Life_Balance	smallint,
Years_At_Company	smallint,
Years_In_Current_Role	smallint,
Years_Since_Last_Promotion	smallint,
Years_With_CurrManager smallint
);

select * from hr_att;
alter table hr_att
modify column over_time text;

describe hr_att;
					
									-- BASIC ANALYSIS --
-- (1) AVERAGE MONTHLY INCOME OF EMPLOYEES GROUPED BY JOB ROLE
SELECT Job_role,
 avg(Monthly_income) AS AM_INCOME
from Hr_att 
group by Job_role;

-- (2) HOW MANY EMPLOYEES ARE IN EACH DEPARTMENT
Select department,
count(*) as Employees
from Hr_att
Group by Department;

-- (3) COUNT OF EMPLOYEES WHO WORK OVERTIME VS EMPLOYEES WHO DO NOT
Select Over_time,
Count(*) as OT
from Hr_att
Group by Over_time;

-- (4) AVERAGE DISTANCE FROM HOME OF EMPLOYEES WHO LEFT THE COMPANY (ATTRITION = YES)
select avg(distance_from_home) 
as AVDFH
from Hr_att
where Attrition = 'yes';

-- (5) HIGHEST AND LOWEST DAILY RATE PER BUSINESS TRAVEL CATEGORY
Select Business_travel,
max(daily_rate) as HDR,
min(daily_rate) as LDR
from Hr_att
group by Business_Travel;

									-- GROUPED ANALYSIS

-- WHAT IS THE AVERAGE YEARS AT COMPANY PER MARITAL STATUS AND GENDER
Select Marital_status,
avg(case when Gender = 'male' Then years_at_company end) as M_AYAC,
avg(case when Gender = 'female' Then years_at_company end) as F_AYAC
from hr_att
group by Marital_status;

-- GROUP EMPLOYEES BY EDUCATION FIELD & CALCULATE AVERAGE TOTAL WORKING HOURS
select Education_field,
avg(total_working_years) as Avg_TWY
from Hr_att
group by Education_field;

-- WHAT IS THE TOTAL NUMBER OF EMPLOYEES PER JOB LEVEL AND WORK LIFE BALANCE
SELECT
  Job_Level,
  SUM(CASE WHEN Work_Life_Balance = 1 THEN 1 ELSE 0 END) AS WLB_1,
  SUM(CASE WHEN Work_Life_Balance = 2 THEN 1 ELSE 0 END) AS WLB_2,
  SUM(CASE WHEN Work_Life_Balance = 3 THEN 1 ELSE 0 END) AS WLB_3,
  SUM(CASE WHEN Work_Life_Balance = 4 THEN 1 ELSE 0 END) AS WLB_4
FROM
  hr_att
GROUP BY
  Job_Level
ORDER BY
  Job_Level;

-- CALCULATE THE AVERAGE % SALARY HIKE PER PERFORMANCE RATING
Select Performance_rating,
avg(percent_salary_hike) as Avg_Psh
from Hr_att
group by performance_rating;

-- FIND THE TOTAL MONTHLY INCOME OF EMPLOYEES WITH STOCK OPTION LEVEL GREATER THAN 0, GROUPED BY DEPARTMENT
select department,
sum(monthly_income) as TMI
from hr_att
where stock_option_level > 0
group by department;

									-- FILTERED QUERY --
-- LIST ALL EMPLOYEES WHO HAVE MORE THAN 10 YEARS AT THE COMPANY AND HAVE NEVER BEEN PROMOTED (YEARS SINCE LAST PROMOTION = 0)
select * 
from hr_att
where years_at_company > 10
and years_since_last_promotion = 0;

-- WHICH EMPLOYEES HAVE MORE THAN 3 TRAINING TIMES LAST YEAR AND WORK LIFE BALANCE LESS THAN 2
select * 
from hr_att
where training_times_last_year > 3
and work_life_balance < 2;

-- FIND ALL EMPLOYEES WHOSE JOB SATISFACTION IS LESS THAN 3 AND WHO ARE IN SALES OR RESEARCH & DEVELOPMENT
SELECT *
FROM Hr_att
WHERE Job_Satisfaction < 3
  AND Department IN ('Sales', 'Research & Development');
  
-- SHOW DETAILS OF EMPLOYEES EARNING MORE THAN THE AVERAGE MONTHLY INCOME
select *
from hr_att
where monthly_income > (
						select avg(monthly_income)
                        from hr_att
);
								-- ANOTHER QUERY --
select avg(monthly_income) as AMI
from hr_att;   -- AMI = 6503

select * 
From hr_att
where monthly_income > 6503;

									-- TRENDS AND INSIGHTS --
-- WHAT IS THE CORRELATION BETWEEN JOB INVOLVEMENT AND PERFORMANCE RATING
select job_involvement,
avg(performance_rating) as APR
from hr_att
group by Job_involvement
order by job_involvement;

-- WHICH EDUCATION FIELD HAS THE HIGHEST ENVIRONMENT SATISFACTION
select education_field,
avg(environment_satisfaction) as AES
from hr_att
Group by Education_field
order by AES desc
limit 1;

-- WHAT IS THE DISTRIBUTION OF ATTRIBITION BY AGE GROUP
SELECT
  CASE
    WHEN Age < 30 THEN '<30'
    WHEN Age BETWEEN 30 AND 50 THEN '30-50'
    ELSE '>50'
  END AS Age_Group,
  Attrition,
  COUNT(*) AS Num_Employees
FROM
  hr_att
GROUP BY
  Age_Group,
  Attrition
ORDER BY
  Age_Group, Attrition;

-- COMPARE THE NUMBER OF EMPLOYEES WHO TRAVEL FREQUENTLY VS RARELY AND THEIR AVERAGE YEARS WITH CURR MANAGER
SELECT
  Business_Travel,
  COUNT(*) AS Num_E,
  ROUND(AVG(Years_With_CurrManager), 2) AS aycm
FROM
  hr_att
GROUP BY
  Business_Travel
ORDER BY
  Num_E DESC;
  
-- (5) FIND THE AVERAGE HOURLY RATE FOR EMPLOYEES WHO HAVE CHANGED COMPANIES MORE THAN TWICE
SELECT
  ROUND(AVG(Hourly_Rate), 2) AS Avg_HR
FROM
  hr_att
WHERE
  Num_Companies_Worked > 2;
  
											-- ADVANCED SUBQUERY --
  
  -- WHO ARE THE 5 HIGHEST EARNERS IN THE COMPANY BASED ON MONTHLY INCOME AND WHAT ARE THEIR JOB ROLES AND DEPARTMENTS
  SELECT
  Employee_Number, Job_Role, Department, Monthly_Income
FROM
  hr_att
ORDER BY
  Monthly_Income DESC
LIMIT 5;
  