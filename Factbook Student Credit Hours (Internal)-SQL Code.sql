


------SQL code used for Factbook : Student Credit Hours(Internal as of Jan 28, 2026



SELECT
    q1.*,
    q2.*
FROM
(
    -------------------------------------------------------------------
    -- QUERY 1 (full, with all calculated fields)
    -------------------------------------------------------------------
    SELECT
        SDM.student_cid,
        SDM.snapshot_id,
        SDM.career,
        SDM.career_code_inst,
        SDM.course_level,
        SDM.credit_hours,
        SDM.course_abbreviation,
        SDM.section_number,
        SDM.section_fiscal_year,
        SDM.delivery_method_code,
        SDM.exclude_from_ipeds_enrl_flag,
        SDM.major_1_degree_code_inst,
        SDM.major_1_degree_level_code,
        SDM.residency,
        SDM.sect_term,
        SDM.sect_term_academic_year,
        SUBSTRING(SDM.sect_term_code, 1, 4) AS term_year,
        SDM.sect_term_code,
        SDM.snapshot_term,
        SDM.snapshot_type,
        SDM.section_college_code,
        SDM.section_department_code,
        SDM.major_1_api_program_code,
        SDM.major_1_api_program,

        CASE 
            WHEN SDM.student_age < 18 THEN 'Below 18'
            WHEN SDM.student_age BETWEEN 18 AND 21 THEN '18-21'
            WHEN SDM.student_age BETWEEN 22 AND 25 THEN '22-25'
            WHEN SDM.student_age BETWEEN 26 AND 30 THEN '26-30'
            WHEN SDM.student_age BETWEEN 31 AND 40 THEN '31-40'
            WHEN SDM.student_age BETWEEN 41 AND 64 THEN '41-64'
            WHEN SDM.student_age >= 65 THEN '65 and above'
            ELSE 'Unknown'
        END AS Age,

        CASE 
            WHEN SDM.student_age < 18 THEN 1
            WHEN SDM.student_age BETWEEN 18 AND 21 THEN 2
            WHEN SDM.student_age BETWEEN 22 AND 25 THEN 3
            WHEN SDM.student_age BETWEEN 26 AND 30 THEN 4
            WHEN SDM.student_age BETWEEN 31 AND 40 THEN 5
            WHEN SDM.student_age BETWEEN 41 AND 64 THEN 6
            WHEN SDM.student_age >= 65 THEN 7
            ELSE 8
        END AS AgeBracketSort,

        CASE    
            WHEN SUBSTRING(SDM.sect_term_code, 5, 1) = '6' THEN SDM.sect_term 
            ELSE '' 
        END AS Fall,

        CASE 
            WHEN SUBSTRING(SDM.sect_term_code, 5, 1) = '1' THEN SDM.sect_term 
            ELSE '' 
        END AS Spring,

        CASE 
            WHEN SUBSTRING(SDM.sect_term_code, 5, 1) = '7' THEN SDM.sect_term 
            ELSE '' 
        END AS Summer_I,

        CASE 
            WHEN SUBSTRING(SDM.sect_term_code, 5, 1) = '8' THEN SDM.sect_term 
            ELSE '' 
        END AS Summer_II,

        CASE 
            WHEN SDM.residency_code = 'I' THEN 'Resident'
            WHEN SDM.residency_code = 'O' THEN 'Nonresident'
            ELSE 'Other' 
        END AS calc_residency,

        CASE
            WHEN SDM.delivery_method_code IN ('06','05','08') THEN 'Online'
            WHEN SDM.delivery_method_code IN ('09','10') THEN 'Hybrid'
            WHEN SDM.delivery_method_code = '01' THEN 'Face-to-Face'
            ELSE 'Other'
        END AS calc_delivery_method,

        CASE    
            WHEN SDM.stdnt_race_ipeds_code = '1' THEN 'Nonresident alien'   
            WHEN SDM.stdnt_race_ipeds_code = '2' THEN 'Race and ethnicity unknown'    
            WHEN SDM.stdnt_race_ipeds_code = '3' THEN 'Hispanic/Latino'    
            WHEN SDM.stdnt_race_ipeds_code = '4' THEN 'American Indian or Alaska Native'    
            WHEN SDM.stdnt_race_ipeds_code = '5' THEN 'Asian'    
            WHEN SDM.stdnt_race_ipeds_code = '6' THEN 'Black or African American'    
            WHEN SDM.stdnt_race_ipeds_code = '7' THEN 'Native Hawaiian or Other Pacific Islander'    
            WHEN SDM.stdnt_race_ipeds_code = '8' THEN 'White'    
            WHEN SDM.stdnt_race_ipeds_code = '9' THEN 'Two or more races'    
            ELSE 'Race and ethnicity unknown'      
        END AS Ethnicity,

        CASE SDM.student_gender_ipeds
            WHEN 'F' THEN 'Female'
            WHEN 'M' THEN 'Male'
            ELSE 'Unknown'
        END AS student_gender_ipeds,

        SDM.student_age,

        COALESCE(SDM.section_college_code || ' - ' || SDM.section_college) AS Course_owning_College,
        COALESCE(SDM.section_department_code || ' - ' || SDM.section_department) AS Course_owning_Department,
        COALESCE(SDM.major_1_college_code || ' - ' || SDM.major_1_college) AS Student_College,
        COALESCE(SDM.major_1_department_code || ' - ' || SDM.major_1_department) AS Student_Department,

        CASE
            WHEN SUBSTRING(SDM.sect_term_code,5,1) IN ('8','6') 
                THEN ('FY ' || SUBSTRING(SDM.sect_term_code ,1,4) || '-' || (SUBSTRING(SDM.sect_term_code ,1,4)::INT+1))
            ELSE ('FY ' || (SUBSTRING(SDM.sect_term_code ,1,4)::INT-1) || '-' || SUBSTRING(SDM.sect_term_code ,1,4))
        END AS calc_FY,

        CASE
            WHEN SDM.career_code_inst = 'AGI' THEN 'Associate''s'
            WHEN SDM.major_1_degree_code_inst LIKE 'B%' 
                 OR (SDM.major_1_degree_code_inst = 'NA' AND SDM.major_1_degree_level_code = '3') THEN 'Bachelor''s'
            WHEN SDM.major_1_degree_code_inst IN ('CTU','CTA') THEN 'Undergraduate Certificate'
            WHEN SDM.career_code_inst = 'UGRD' AND SDM.major_1_degree_code_inst IN ('NA','L') THEN 'Undergraduate Non-Degree'
            WHEN SDM.major_1_degree_code_inst LIKE 'M%' THEN 'Master''s'
            WHEN SDM.major_1_degree_code_inst IN ('PHD','EDD') THEN 'Doctoral-Research/Scholarship'
            WHEN SDM.major_1_degree_code_inst IN ('DDES') OR SDM.career_code_inst = 'VETM' THEN 'Doctoral-Professional Practice'
            WHEN SDM.major_1_degree_code_inst = 'CTG' THEN 'Graduate Certificate'
            WHEN SDM.career_code_inst = 'GRAD' AND SDM.major_1_degree_code_inst IN ('NA','L') THEN 'Graduate Non-Degree'
            ELSE SDM.major_1_degree_level 
        END AS calc_Degree_level,

        CASE
            WHEN SDM.course_level IN ('Agricultural Institute', 'Lower Division Undergraduate', 'Upper Division Undergraduate')
                THEN 'Undergraduate'
            ELSE SDM.course_level 
        END AS calc_course_level,

        'AY ' || SDM.sect_term_academic_year AS calc_AY,
        'CY ' || SUBSTRING(SDM.sect_term_code, 1, 4) AS calc_CY, 

        CY.INDIC_CY_complete,
        FY.INDIC_FY_complete, 
        AY.INDIC_AY_complete

    FROM ncsu.sdm_enrollment_mv SDM

    JOIN
    (
        SELECT 
            sect_term_academic_year,
            CASE 
                WHEN MAX(CASE WHEN SUBSTRING(sect_term_code, 5, 1) = '6' THEN 1 ELSE 0 END) = 1
                 AND MAX(CASE WHEN SUBSTRING(sect_term_code, 5, 1) = '1' THEN 1 ELSE 0 END) = 1
                 AND MAX(CASE WHEN SUBSTRING(sect_term_code, 5, 1) = '7' THEN 1 ELSE 0 END) = 1
                 AND MAX(CASE WHEN SUBSTRING(sect_term_code, 5, 1) = '8' THEN 1 ELSE 0 END) = 1 
                THEN 'Complete'
                ELSE 'Incomplete'
            END AS INDIC_AY_complete
        FROM ncsu.sdm_enrollment_mv 
        GROUP BY sect_term_academic_year
    ) AS AY
        ON SDM.sect_term_academic_year = AY.sect_term_academic_year

    JOIN
    (
        SELECT 
            'CY ' || SUBSTRING(sect_term_code, 1, 4) AS calc_CY,
            CASE 
                WHEN MAX(CASE WHEN SUBSTRING(sect_term_code, 5, 1) = '6' THEN 1 ELSE 0 END) = 1
                 AND MAX(CASE WHEN SUBSTRING(sect_term_code, 5, 1) = '1' THEN 1 ELSE 0 END) = 1
                 AND MAX(CASE WHEN SUBSTRING(sect_term_code, 5, 1) = '7' THEN 1 ELSE 0 END) = 1
                 AND MAX(CASE WHEN SUBSTRING(sect_term_code, 5, 1) = '8' THEN 1 ELSE 0 END) = 1 
                THEN 'Complete'
                ELSE 'Incomplete'
            END AS INDIC_CY_complete
        FROM ncsu.sdm_enrollment_mv 
        GROUP BY calc_CY
    ) AS CY
        ON 'CY ' || SUBSTRING(SDM.sect_term_code, 1, 4) = CY.calc_CY

    JOIN
    (
        SELECT 
            CASE
                WHEN SUBSTRING(sect_term_code,5,1) IN ('8','6') 
                    THEN ('FY ' || SUBSTRING(sect_term_code ,1,4) || '-' || (SUBSTRING(sect_term_code ,1,4)::INT+1))
                ELSE ('FY ' || (SUBSTRING(sect_term_code ,1,4)::INT-1) || '-' || SUBSTRING(sect_term_code ,1,4))
            END AS calc_FY,
            CASE 
                WHEN MAX(CASE WHEN SUBSTRING(sect_term_code, 5, 1) = '6' THEN 1 ELSE 0 END) = 1
                 AND MAX(CASE WHEN SUBSTRING(sect_term_code, 5, 1) = '1' THEN 1 ELSE 0 END) = 1
                 AND MAX(CASE WHEN SUBSTRING(sect_term_code, 5, 1) = '7' THEN 1 ELSE 0 END) = 1
                 AND MAX(CASE WHEN SUBSTRING(sect_term_code, 5, 1) = '8' THEN 1 ELSE 0 END) = 1 
                THEN 'Complete'
                ELSE 'Incomplete'
            END AS INDIC_FY_complete 
        FROM ncsu.sdm_enrollment_mv 
        GROUP BY calc_FY
    ) AS FY
        ON CASE
               WHEN SUBSTRING(SDM.sect_term_code,5,1) IN ('8','6') 
                   THEN ('FY ' || SUBSTRING(SDM.sect_term_code ,1,4) || '-' || (SUBSTRING(SDM.sect_term_code ,1,4)::INT+1))
               ELSE ('FY ' || (SUBSTRING(SDM.sect_term_code ,1,4)::INT-1) || '-' || SUBSTRING(SDM.sect_term_code ,1,4))
           END = FY.calc_FY

    WHERE SDM.snapshot_type='Census'
      AND SUBSTRING(SDM.sect_term_code, 1, 4)::INT >= EXTRACT(YEAR FROM CURRENT_DATE) - 6
) q1

INNER JOIN
(
    -------------------------------------------------------------------
    -- QUERY 2
    -------------------------------------------------------------------
    SELECT  
        student_cid,
        snapshot_term_code,
        student_cid || snapshot_term_code AS StudentTermKey,
        stdnt_race_ipeds,
        student_gender_ipeds,
        class_level,
        enrollment_status,
        enrollment_status_code,
        student_type_inst,
        student_fte,
        enrollment_status_code_ipeds,
        enrollment_status_ipeds,
        student_full_part_time
    FROM ncsu.sdm_career_mv
    WHERE snapshot_type = 'Census'
      AND CAST(LEFT(snapshot_term_code, 4) AS INT) >= EXTRACT(YEAR FROM CURRENT_DATE) - 6
) q2
    ON q1.student_cid     = q2.student_cid
   AND q1.sect_term_code = q2.snapshot_term_code;
