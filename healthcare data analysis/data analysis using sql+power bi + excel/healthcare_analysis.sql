use health_care;
DELETE FROM cod_table
WHERE Patient_ID = 'Patient ID';
describe cod_table;
select * from cod_table;

ALTER TABLE cod_table
MODIFY COLUMN Patient_ID int;

ALTER TABLE cod_table
MODIFY COLUMN Age int,
MODIFY COLUMN Duration_of_Symptoms_months int,
MODIFY COLUMN Y_BOCS_Score_Obsessions int,
MODIFY COLUMN Y_BOCS_Score_Compulsions int;

-- Convert the existing VARCHAR values to dates and update the column
UPDATE cod_table
SET OCD_Diagnosis_Date = DATE_ADD('1900-01-01', INTERVAL (CAST(OCD_Diagnosis_Date AS UNSIGNED) - 1) DAY);

ALTER TABLE cod_table
MODIFY COLUMN OCD_Diagnosis_Date date;

-- count and pct of female and male that have ocd and average obsession score by gender
with data as (
SELECT Gender,
       COUNT(Patient_ID) AS patient_count,
       ROUND(AVG(Y_BOCS_Score_Obsessions), 2) AS avg_obs_scr
FROM cod_table
GROUP BY Gender
ORDER BY patient_count
)
select
	sum(case when Gender = 'Female' then patient_count else 0 end) as count_female,
	sum(case when Gender = 'Male' then patient_count else 0 end) as count_male,
	round((sum(case when Gender = 'Female' then patient_count else 0 end)/
	(sum(case when Gender = 'Female' then patient_count else 0 end)+
		sum(case when Gender = 'Male' then patient_count else 0 end))*100),2) as female_pct,
	round((sum(case when Gender = 'Male' then patient_count else 0 end)/
	(sum(case when Gender = 'Female' then patient_count else 0 end)+
		sum(case when Gender = 'Male' then patient_count else 0 end))*100),2) as male_pct
from data
;

SELECT Gender,
       COUNT(Patient_ID) AS patient_count,
       ROUND(AVG(Y_BOCS_Score_Obsessions), 2) AS avg_obs_scr
FROM cod_table
GROUP BY Gender
ORDER BY patient_count
;

-- count and average obsession by ethnicity that have cod

select Ethnicity,
count(Patient_ID) as Patient_count,
avg(Y_BOCS_Score_Obsessions) as obs_score
from cod_table
group by Ethnicity
order by Patient_count
;

-- number of people diag with ocd month over month
select 
date_format(OCD_Diagnosis_Date, '%Y-%m')as month,
count('Patient_ID') as patient_count
from cod_table
group by month
order by month
;

-- 9.	What is the most common obsession type (count) and its average obsession score
select
Obsession_Type,
count(Patient_ID)as patient_count,
round(avg(Y_BOCS_Score_Obsessions),2) as obs_scr
from cod_table
group by Obsession_Type
order by patient_count;

-- calculating most common compulsion type (count) and its average obsession score
select
Compulsion_Type,
count(Patient_ID)as patient_count,
round(avg(Y_BOCS_Score_Obsessions),2) as obs_scr
from cod_table
group by Compulsion_Type
order by patient_count;