-----Factbook: Faculty and Staff(internal) as of Jan 28th 2026 
-----This SQL Code uses union to combine different year tables from the same schema. 
-----There will be a repition of code by different years. 


SELECT
employee_cid,
count(employee_cid) as headcount_employee, 
sum(fte_employee_total) as fte_employee, 
substring(employee_as_of_date, 1, 4) as year,
case 
when soc_code_primary like '11%' 
     and ehra_type_desc like 'SAAO%'
     then 'Administrator' 
else '' end as admin_indic, 

case 
when soc_code_primary in ('251000') 
     and jcat_code_primary not like '9%' 
     and substring(jcat_code_primary,1,3) not in ('212') 
     then 'Faculty'
when soc_code_primary in ('254020') 
     and jcat_code_primary not like '9%' 
     and ehra_type = 'L' 
     then 'Faculty' 
else '' end as faculty_indic, 
case 
when faculty_indic = 'Faculty ' then
(case 
when soc_code_primary in ('251000') 
     and jcat_code_primary not like '9%' 
     and employee_tenure_status_code in ('T','N') 
     and substring(jcat_code_primary,1,3) not in ('212') 
     then 'Faculty, Tenure/Tenure-Track' 
when soc_code_primary in ('251000') 
     and jcat_code_primary not like '9%' 
     and employee_tenure_status_code not in ('T','N') 

     and substring(jcat_code_primary,1,3) not in ('212') 
     then 'Faculty, Professional'
when soc_code_primary in ('254020') 
     and jcat_code_primary not like '9%' 
     and ehra_type = 'L' 
     then 'Faculty, Professional'
else '' end) end as faculty_type, 

case 
when faculty_indic != 'Faculty ' then
COALESCE(case 
when soc_code_primary like '11%' 
     and ehra_type_desc like 'SAAO%'  
     then 'Administrators' 
when appointment_type_code = 'GT' 
     then 'Graduate Assistant'
when appointment_type_code = 'PD' 
     or jcat_code_primary like '90%' 
     then 'Postdoctoral Scholar'
when employee_type = 'E' 
     or employee_type like 'C%' 
     then 'EHRA' 
when employee_type = 'S' 
     then 'SHRA' 
else 'Other, Staff' end)   end as staff_type,

Case
 when fte_employee_total >= 0.75
 then 'Full Time'
 else 'Part Time' end as FT_PT_indic, 
 
 CASE
 when faculty_indic='Faculty' then FT_PT_indic
 end as Faculty_FT_PT, 
 
 CASE
 when faculty_indic='Faculty' then employee_tenure_status
 end as Faculty_tenure, 
CASE 
when faculty_indic='Faculty' then 'Faculty'
when admin_indic='Administrator' then 'Administrator'
else staff_type
end AS Faculty_Staff_All, 

case
when faculty_indic='Faculty' then academic_rank
end AS faculty_academic_rank,
	case  
					when employee_age <= 29 then '29 and under'
					when employee_age between 30 and 39  then '30-39'
					when employee_age  between 40 and 49 then '40-49'
					when employee_age between 50 and 59 then '50-59'
					when employee_age  between 60 and 69 then '60-69'
					when employee_age>=70 then '70 and above'
					else  ' ' end as Employee_Age, 
					soc_category_code_ipeds,
soc_category_ipeds,
soc_code_primary,
jcat_code_primary || '-' || jcat_primary as  JCAT_code,
					
					jcat_code_special_desc_code || '-' || jcat_code_special_desc as JCAT_Special,
LEFT(empl_home_department_code, 2) AS TwoDigit,
RIGHT(empl_home_department_code, 4) AS FourDigit,
(empl_home_department_code || '-' || empl_home_department) as OUC, (ehra_type|| '-' ||ehra_type_desc) as EHRA, 
empl_highest_degree_level,empl_highest_degree,
appointment_type as Employee_NCSU, employee_status, employee_type


FROM ncsu_hr.hrdm_2024_pdf_cmp_mv
WHERE empl_exclude_from_ipeds_flag='N'
GROUP BY employee_cid,
Employee_as_of_date, 
soc_code_primary,
ehra_type_desc,
jcat_code_primary,
ehra_type,
employee_tenure_status_code,
appointment_type_code,
employee_type,
fte_employee_total,
employee_tenure_status,
academic_rank, Employee_Age,soc_category_code_ipeds,
soc_category_ipeds,
TwoDigit, FourDigit, OUC,
jcat_code_primary,
jcat_primary, 
jcat_code_special_desc_code, 
jcat_code_special_desc, EHRA,ehra_type,empl_highest_degree_level,appointment_type,Employee_NCSU,employee_status, employee_type,empl_highest_degree



union 



SELECT
employee_cid,
count(employee_cid) as headcount_employee, 
sum(fte_employee_total) as fte_employee, 
substring(employee_as_of_date, 1, 4) as year,
case 
when soc_code_primary like '11%' 
     and ehra_type_desc like 'SAAO%'
     then 'Administrator' 
else '' end as admin_indic, 

case 
when soc_code_primary in ('251000') 
     and jcat_code_primary not like '9%' 
     and substring(jcat_code_primary,1,3) not in ('212') 
     then 'Faculty'
when soc_code_primary in ('254020') 
     and jcat_code_primary not like '9%' 
     and ehra_type = 'L' 
     then 'Faculty' 
else '' end as faculty_indic, 
case 
when faculty_indic = 'Faculty ' then
(case 
when soc_code_primary in ('251000') 
     and jcat_code_primary not like '9%' 
     and employee_tenure_status_code in ('T','N') 
     and substring(jcat_code_primary,1,3) not in ('212') 
     then 'Faculty, Tenure/Tenure-Track' 
when soc_code_primary in ('251000') 
     and jcat_code_primary not like '9%' 
     and employee_tenure_status_code not in ('T','N') 

     and substring(jcat_code_primary,1,3) not in ('212') 
     then 'Faculty, Professional'
when soc_code_primary in ('254020') 
     and jcat_code_primary not like '9%' 
     and ehra_type = 'L' 
     then 'Faculty, Professional'
else '' end) end as faculty_type, 

case 
when faculty_indic != 'Faculty ' then
COALESCE(case 
when soc_code_primary like '11%' 
     and ehra_type_desc like 'SAAO%'  
     then 'Administrators' 
when appointment_type_code = 'GT' 
     then 'Graduate Assistant'
when appointment_type_code = 'PD' 
     or jcat_code_primary like '90%' 
     then 'Postdoctoral Scholar'
when employee_type = 'E' 
     or employee_type like 'C%' 
     then 'EHRA' 
when employee_type = 'S' 
     then 'SHRA' 
else 'Other, Staff' end)   end as staff_type,

Case
 when fte_employee_total >= 0.75
 then 'Full Time'
 else 'Part Time' end as FT_PT_indic, 
 
 CASE
 when faculty_indic='Faculty' then FT_PT_indic
 end as Faculty_FT_PT, 
 
 CASE
 when faculty_indic='Faculty' then employee_tenure_status
 end as Faculty_tenure, 
CASE 
when faculty_indic='Faculty' then 'Faculty'
when admin_indic='Administrator' then 'Administrator'
else staff_type
end AS Faculty_Staff_All, 

case
when faculty_indic='Faculty' then academic_rank
end AS faculty_academic_rank,
	case  
					when employee_age <= 29 then '29 and under'
					when employee_age between 30 and 39  then '30-39'
					when employee_age  between 40 and 49 then '40-49'
					when employee_age between 50 and 59 then '50-59'
					when employee_age  between 60 and 69 then '60-69'
					when employee_age>=70 then '70 and above'
					else  ' ' end as Employee_Age, 
					soc_category_code_ipeds,
soc_category_ipeds,
soc_code_primary,
jcat_code_primary || '-' || jcat_primary as  JCAT_code,
					
					jcat_code_special_desc_code || '-' || jcat_code_special_desc as JCAT_Special,
LEFT(empl_home_department_code, 2) AS TwoDigit,
RIGHT(empl_home_department_code, 4) AS FourDigit,
(empl_home_department_code || '-' || empl_home_department) as OUC, (ehra_type|| '-' ||ehra_type_desc) as EHRA, 
empl_highest_degree_level,empl_highest_degree,
appointment_type as Employee_NCSU, employee_status, employee_type


FROM ncsu_hr.hrdm_2023_pdf_cmp_mv
WHERE empl_exclude_from_ipeds_flag='N'
GROUP BY employee_cid,
Employee_as_of_date, 
soc_code_primary,
ehra_type_desc,
jcat_code_primary,
ehra_type,
employee_tenure_status_code,
appointment_type_code,
employee_type,
fte_employee_total,
employee_tenure_status,
academic_rank, Employee_Age,soc_category_code_ipeds,
soc_category_ipeds,
TwoDigit, FourDigit, OUC,
jcat_code_primary,
jcat_primary, 
jcat_code_special_desc_code, 
jcat_code_special_desc, EHRA,ehra_type,empl_highest_degree_level,appointment_type,Employee_NCSU,employee_status, employee_type,empl_highest_degree


union 

SELECT
employee_cid,
count(employee_cid) as headcount_employee, 
sum(fte_employee_total) as fte_employee, 
substring(employee_as_of_date, 1, 4) as year,
case 
when soc_code_primary like '11%' 
     and ehra_type_desc like 'SAAO%'
     then 'Administrator' 
else '' end as admin_indic, 

case 
when soc_code_primary in ('251000') 
     and jcat_code_primary not like '9%' 
     and substring(jcat_code_primary,1,3) not in ('212') 
     then 'Faculty'
when soc_code_primary in ('254020') 
     and jcat_code_primary not like '9%' 
     and ehra_type = 'L' 
     then 'Faculty' 
else '' end as faculty_indic, 
case 
when faculty_indic = 'Faculty ' then
(case 
when soc_code_primary in ('251000') 
     and jcat_code_primary not like '9%' 
     and employee_tenure_status_code in ('T','N') 
     and substring(jcat_code_primary,1,3) not in ('212') 
     then 'Faculty, Tenure/Tenure-Track' 
when soc_code_primary in ('251000') 
     and jcat_code_primary not like '9%' 
     and employee_tenure_status_code not in ('T','N') 

     and substring(jcat_code_primary,1,3) not in ('212') 
     then 'Faculty, Professional'
when soc_code_primary in ('254020') 
     and jcat_code_primary not like '9%' 
     and ehra_type = 'L' 
     then 'Faculty, Professional'
else '' end) end as faculty_type, 

case 
when faculty_indic != 'Faculty ' then
COALESCE(case 
when soc_code_primary like '11%' 
     and ehra_type_desc like 'SAAO%'  
     then 'Administrators' 
when appointment_type_code = 'GT' 
     then 'Graduate Assistant'
when appointment_type_code = 'PD' 
     or jcat_code_primary like '90%' 
     then 'Postdoctoral Scholar'
when employee_type = 'E' 
     or employee_type like 'C%' 
     then 'EHRA' 
when employee_type = 'S' 
     then 'SHRA' 
else 'Other, Staff' end)   end as staff_type,

Case
 when fte_employee_total >= 0.75
 then 'Full Time'
 else 'Part Time' end as FT_PT_indic, 
 
 CASE
 when faculty_indic='Faculty' then FT_PT_indic
 end as Faculty_FT_PT, 
 
 CASE
 when faculty_indic='Faculty' then employee_tenure_status
 end as Faculty_tenure, 
CASE 
when faculty_indic='Faculty' then 'Faculty'
when admin_indic='Administrator' then 'Administrator'
else staff_type
end AS Faculty_Staff_All, 

case
when faculty_indic='Faculty' then academic_rank
end AS faculty_academic_rank,
	case  
					when employee_age <= 29 then '29 and under'
					when employee_age between 30 and 39  then '30-39'
					when employee_age  between 40 and 49 then '40-49'
					when employee_age between 50 and 59 then '50-59'
					when employee_age  between 60 and 69 then '60-69'
					when employee_age>=70 then '70 and above'
					else  ' ' end as Employee_Age, 
					soc_category_code_ipeds,
soc_category_ipeds,
soc_code_primary,
jcat_code_primary || '-' || jcat_primary as  JCAT_code,
					
					jcat_code_special_desc_code || '-' || jcat_code_special_desc as JCAT_Special,
LEFT(empl_home_department_code, 2) AS TwoDigit,
RIGHT(empl_home_department_code, 4) AS FourDigit,
(empl_home_department_code || '-' || empl_home_department) as OUC, (ehra_type|| '-' ||ehra_type_desc) as EHRA, 
empl_highest_degree_level,empl_highest_degree,
appointment_type as Employee_NCSU, employee_status, employee_type


FROM ncsu_hr.hrdm_2022_pdf_cmp_mv
WHERE empl_exclude_from_ipeds_flag='N'
GROUP BY employee_cid,
Employee_as_of_date, 
soc_code_primary,
ehra_type_desc,
jcat_code_primary,
ehra_type,
employee_tenure_status_code,
appointment_type_code,
employee_type,
fte_employee_total,
employee_tenure_status,
academic_rank, Employee_Age,soc_category_code_ipeds,
soc_category_ipeds,
TwoDigit, FourDigit, OUC,
jcat_code_primary,
jcat_primary, 
jcat_code_special_desc_code, 
jcat_code_special_desc, EHRA,ehra_type,empl_highest_degree_level,appointment_type,Employee_NCSU,employee_status, employee_type,empl_highest_degree


union 



SELECT
employee_cid,
count(employee_cid) as headcount_employee, 
sum(fte_employee_total) as fte_employee, 
substring(employee_as_of_date, 1, 4) as year,
case 
when soc_code_primary like '11%' 
     and ehra_type_desc like 'SAAO%'
     then 'Administrator' 
else '' end as admin_indic, 

case 
when soc_code_primary in ('251000') 
     and jcat_code_primary not like '9%' 
     and substring(jcat_code_primary,1,3) not in ('212') 
     then 'Faculty'
when soc_code_primary in ('254020') 
     and jcat_code_primary not like '9%' 
     and ehra_type = 'L' 
     then 'Faculty' 
else '' end as faculty_indic, 
case 
when faculty_indic = 'Faculty ' then
(case 
when soc_code_primary in ('251000') 
     and jcat_code_primary not like '9%' 
     and employee_tenure_status_code in ('T','N') 
     and substring(jcat_code_primary,1,3) not in ('212') 
     then 'Faculty, Tenure/Tenure-Track' 
when soc_code_primary in ('251000') 
     and jcat_code_primary not like '9%' 
     and employee_tenure_status_code not in ('T','N') 

     and substring(jcat_code_primary,1,3) not in ('212') 
     then 'Faculty, Professional'
when soc_code_primary in ('254020') 
     and jcat_code_primary not like '9%' 
     and ehra_type = 'L' 
     then 'Faculty, Professional'
else '' end) end as faculty_type, 

case 
when faculty_indic != 'Faculty ' then
COALESCE(case 
when soc_code_primary like '11%' 
     and ehra_type_desc like 'SAAO%'  
     then 'Administrators' 
when appointment_type_code = 'GT' 
     then 'Graduate Assistant'
when appointment_type_code = 'PD' 
     or jcat_code_primary like '90%' 
     then 'Postdoctoral Scholar'
when employee_type = 'E' 
     or employee_type like 'C%' 
     then 'EHRA' 
when employee_type = 'S' 
     then 'SHRA' 
else 'Other, Staff' end)   end as staff_type,

Case
 when fte_employee_total >= 0.75
 then 'Full Time'
 else 'Part Time' end as FT_PT_indic, 
 
 CASE
 when faculty_indic='Faculty' then FT_PT_indic
 end as Faculty_FT_PT, 
 
 CASE
 when faculty_indic='Faculty' then employee_tenure_status
 end as Faculty_tenure, 
CASE 
when faculty_indic='Faculty' then 'Faculty'
when admin_indic='Administrator' then 'Administrator'
else staff_type
end AS Faculty_Staff_All, 

case
when faculty_indic='Faculty' then academic_rank
end AS faculty_academic_rank,
	case  
					when employee_age <= 29 then '29 and under'
					when employee_age between 30 and 39  then '30-39'
					when employee_age  between 40 and 49 then '40-49'
					when employee_age between 50 and 59 then '50-59'
					when employee_age  between 60 and 69 then '60-69'
					when employee_age>=70 then '70 and above'
					else  ' ' end as Employee_Age, 
					soc_category_code_ipeds,
soc_category_ipeds,
soc_code_primary,
jcat_code_primary || '-' || jcat_primary as  JCAT_code,
					
					jcat_code_special_desc_code || '-' || jcat_code_special_desc as JCAT_Special,
LEFT(empl_home_department_code, 2) AS TwoDigit,
RIGHT(empl_home_department_code, 4) AS FourDigit,
(empl_home_department_code || '-' || empl_home_department) as OUC, (ehra_type|| '-' ||ehra_type_desc) as EHRA, 
empl_highest_degree_level,empl_highest_degree,
appointment_type as Employee_NCSU, employee_status, employee_type


FROM ncsu_hr.hrdm_2021_pdf_cmp_mv
WHERE empl_exclude_from_ipeds_flag='N'
GROUP BY employee_cid,
Employee_as_of_date, 
soc_code_primary,
ehra_type_desc,
jcat_code_primary,
ehra_type,
employee_tenure_status_code,
appointment_type_code,
employee_type,
fte_employee_total,
employee_tenure_status,
academic_rank, Employee_Age,soc_category_code_ipeds,
soc_category_ipeds,
TwoDigit, FourDigit, OUC,
jcat_code_primary,
jcat_primary, 
jcat_code_special_desc_code, 
jcat_code_special_desc, EHRA,ehra_type,empl_highest_degree_level,appointment_type,Employee_NCSU,employee_status, employee_type,empl_highest_degree



union 

SELECT
employee_cid,
count(employee_cid) as headcount_employee, 
sum(fte_employee_total) as fte_employee, 
substring(employee_as_of_date, 1, 4) as year,
case 
when soc_code_primary like '11%' 
     and ehra_type_desc like 'SAAO%'
     then 'Administrator' 
else '' end as admin_indic, 

case 
when soc_code_primary in ('251000') 
     and jcat_code_primary not like '9%' 
     and substring(jcat_code_primary,1,3) not in ('212') 
     then 'Faculty'
when soc_code_primary in ('254020') 
     and jcat_code_primary not like '9%' 
     and ehra_type = 'L' 
     then 'Faculty' 
else '' end as faculty_indic, 
case 
when faculty_indic = 'Faculty ' then
(case 
when soc_code_primary in ('251000') 
     and jcat_code_primary not like '9%' 
     and employee_tenure_status_code in ('T','N') 
     and substring(jcat_code_primary,1,3) not in ('212') 
     then 'Faculty, Tenure/Tenure-Track' 
when soc_code_primary in ('251000') 
     and jcat_code_primary not like '9%' 
     and employee_tenure_status_code not in ('T','N') 

     and substring(jcat_code_primary,1,3) not in ('212') 
     then 'Faculty, Professional'
when soc_code_primary in ('254020') 
     and jcat_code_primary not like '9%' 
     and ehra_type = 'L' 
     then 'Faculty, Professional'
else '' end) end as faculty_type, 

case 
when faculty_indic != 'Faculty ' then
COALESCE(case 
when soc_code_primary like '11%' 
     and ehra_type_desc like 'SAAO%'  
     then 'Administrators' 
when appointment_type_code = 'GT' 
     then 'Graduate Assistant'
when appointment_type_code = 'PD' 
     or jcat_code_primary like '90%' 
     then 'Postdoctoral Scholar'
when employee_type = 'E' 
     or employee_type like 'C%' 
     then 'EHRA' 
when employee_type = 'S' 
     then 'SHRA' 
else 'Other, Staff' end)   end as staff_type,

Case
 when fte_employee_total >= 0.75
 then 'Full Time'
 else 'Part Time' end as FT_PT_indic, 
 
 CASE
 when faculty_indic='Faculty' then FT_PT_indic
 end as Faculty_FT_PT, 
 
 CASE
 when faculty_indic='Faculty' then employee_tenure_status
 end as Faculty_tenure, 
CASE 
when faculty_indic='Faculty' then 'Faculty'
when admin_indic='Administrator' then 'Administrator'
else staff_type
end AS Faculty_Staff_All, 

case
when faculty_indic='Faculty' then academic_rank
end AS faculty_academic_rank,
	case  
					when employee_age <= 29 then '29 and under'
					when employee_age between 30 and 39  then '30-39'
					when employee_age  between 40 and 49 then '40-49'
					when employee_age between 50 and 59 then '50-59'
					when employee_age  between 60 and 69 then '60-69'
					when employee_age>=70 then '70 and above'
					else  ' ' end as Employee_Age, 
					soc_category_code_ipeds,
soc_category_ipeds,
soc_code_primary,
jcat_code_primary || '-' || jcat_primary as  JCAT_code,
					
					jcat_code_special_desc_code || '-' || jcat_code_special_desc as JCAT_Special,
LEFT(empl_home_department_code, 2) AS TwoDigit,
RIGHT(empl_home_department_code, 4) AS FourDigit,
(empl_home_department_code || '-' || empl_home_department) as OUC, (ehra_type|| '-' ||ehra_type_desc) as EHRA, 
empl_highest_degree_level,empl_highest_degree,
appointment_type as Employee_NCSU, employee_status, employee_type


FROM ncsu_hr.hrdm_2020_pdf_cmp_mv
WHERE empl_exclude_from_ipeds_flag='N'
GROUP BY employee_cid,
Employee_as_of_date, 
soc_code_primary,
ehra_type_desc,
jcat_code_primary,
ehra_type,
employee_tenure_status_code,
appointment_type_code,
employee_type,
fte_employee_total,
employee_tenure_status,
academic_rank, Employee_Age,soc_category_code_ipeds,
soc_category_ipeds,
TwoDigit, FourDigit, OUC,
jcat_code_primary,
jcat_primary, 
jcat_code_special_desc_code, 
jcat_code_special_desc, EHRA,ehra_type,empl_highest_degree_level,appointment_type,Employee_NCSU,employee_status, employee_type,empl_highest_degree

