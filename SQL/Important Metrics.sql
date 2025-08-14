
-------------------**DEMOGRAPHICS KPI's**-------------------
--Total Number of Participants
SELECT COUNT(*) TotalParticipanats 
FROM tblDemographics;

--Participants Count By Gender
SELECT gender, COUNT(*) CountByGender
FROM tblDemographics
GROUP BY gender;

--Participants Count by Country
SELECT country, COUNT(*) CountByCountry
FROM tblDemographics
GROUP BY country
ORDER BY CountByCountry DESC;

--Average Age of Participants
SELECT AVG(age) AvgAge
FROM tblDemographics;

--Number of Participants from Each industry changing Career
SELECT prev_industry, COUNT(*) ParticipantCount
FROM tblDemographics
GROUP BY prev_industry
ORDER BY ParticipantCount DESC;

--Percentage of participants who had Career Break
SELECT	
	CAST(
	(
		(SELECT COUNT(career_break_flag) 
		FROM tblDemographics 
		WHERE career_break_flag = 1)
		/
	CAST(Count (career_break_flag)AS DECIMAL (10,2)) 
	*100)
	AS DECIMAL (10,2)) AS PercWithCareerBreak
FROM tblDemographics;

-------------------**TRANSITIONS KPI's**-------------------
--Total Transitions
SELECT COUNT(DISTINCT transition_id) TotalTransitions 
FROM tblTransitions;

--Total Transitions by Each Participant
SELECT person_id, COUNT(*) TotalTransitions 
FROM tblTransitions
GROUP BY person_id
ORDER BY person_id;

--Average Transition Duration by Months
SELECT AVG(transition_time_months) AvgTransitionTime
FROM tblTransitions;

--Average Transition Duration by Months by Destination Industry
SELECT to_industry, AVG(transition_time_months) AvgTransitionTime
FROM tblTransitions
GROUP BY to_industry
ORDER BY AvgTransitionTime DESC;


--Most Common From and To Role
	--From Role
	SELECT from_role, Count(*) TransitionCount
	FROM tblTransitions
	GROUP BY from_role
	ORDER BY TransitionCount DESC;

	--TO Role
	SELECT to_role, Count(*) TransitionCount
	FROM tblTransitions
	GROUP BY to_role
	ORDER BY TransitionCount DESC;

	--From and To Role
	SELECT from_role, to_role, Count(*) RoleTransCount
	FROM tblTransitions
	GROUP BY from_role, to_role
	ORDER BY RoleTransCount DESC;

--Most Common From and To Industry
SELECT from_industry, to_industry, Count(*) IndustryTransCount
	FROM tblTransitions
	GROUP BY from_industry, to_industry
	ORDER BY IndustryTransCount DESC;

--Number of Transitions occured Each Year
SELECT Year(transition_date) TransitionYear, Count(transition_id) TotalTransitions
FROM tblTransitions
GROUP BY Year(transition_date)
ORDER BY TotalTransitions DESC;

--Total Transitions by Age-group
SELECT 
	CASE 
		WHEN D.age BETWEEN 20 AND 29 THEN '20-29'
		WHEN D.age BETWEEN 30 AND 39 THEN '30-39'
		WHEN D.age BETWEEN 40 AND 49 THEN '40-49'
		WHEN D.age BETWEEN 50 AND 59 THEN '50-59'
		ELSE 'ABOVE 60'
	END AS AgeGroup,
	COUNT(T.transition_id) TotalTransitions
FROM tblDemographics D 
LEFT JOIN tblTransitions T ON D.person_id = T.person_id
GROUP BY CASE 
		WHEN D.age BETWEEN 20 AND 29 THEN '20-29'
		WHEN D.age BETWEEN 30 AND 39 THEN '30-39'
		WHEN D.age BETWEEN 40 AND 49 THEN '40-49'
		WHEN D.age BETWEEN 50 AND 59 THEN '50-59'
		ELSE 'ABOVE 60'
	END;

--OR

;WITH cte_age_group
AS
(
SELECT 
	CASE 
		WHEN age BETWEEN 20 AND 29 THEN '20-29'
		WHEN age BETWEEN 30 AND 39 THEN '30-39'
		WHEN age BETWEEN 40 AND 49 THEN '40-49'
		WHEN age BETWEEN 50 AND 59 THEN '50-59'
		ELSE 'ABOVE 60'
	END AS AgeGroup, person_id 
FROM tblDemographics
)
SELECT C.AgeGroup, COUNT(T.transition_id) TotalTransitions
FROM cte_age_group C
LEFT JOIN tblTransitions T ON C.person_id = T.person_id
GROUP BY C.AgeGroup;


--Countries with Highest number of Cross-Industry Transitions
;WITH cte_cross_transitions
 AS 
	(
		SELECT D.person_id, D.country, T.from_industry, T.to_industry
		FROM tblDemographics D
		JOIN tblTransitions T ON D.person_id = T.person_id
		WHERE T.from_industry <> T.to_industry
	)
SELECT CT.country, Count(*) TransitionCount
FROM cte_cross_transitions CT
GROUP BY CT.country
ORDER BY TransitionCount DESC;

--Percentage of Participants who changed Industry
SELECT 
    ROUND((CAST(SUM(CASE WHEN from_industry <> to_industry THEN 1 ELSE 0 END) AS FLOAT) 
         / COUNT(*)) * 100, 2) AS PercentageChangedIndustry
FROM tblTransitions;

-------------------**INCOME KPI's**-------------------
--Average salary before and after Career Transition
SELECT CAST(AVG(salary_before) AS DECIMAL(10,2)) AvgInitialSalary, 
	CAST(AVG(salary_after) AS DECIMAL (10,2)) AvgFinalSalary
FROM tblIncome_History;

--Average Percentage Salary Increase
SELECT CAST(AVG(pct_increase) AS DECIMAL(10,2)) AvgPctIncrease
FROM tblIncome_History;

--Percentage of Participants with Salary Increase
SELECT (CAST((SELECT Cast(COUNT(*) AS DECIMAL(10,2) )
				FROM tblIncome_History
				WHERE salary_after > salary_before)/
		CAST(Count(*) AS DECIMAL (10,2))*100 AS DECIMAL (10,2))) AS PercWithInc 
FROM tblIncome_History;

--Percentage of Transitions with Salary Increase
SELECT
	CAST(
		(
			SELECT CAST(COUNT(transition_id) AS DECIMAL (10,2))
			FROM tblIncome_History
			WHERE salary_after > salary_before
		)/
	CAST(COUNT(transition_id)AS DECIMAL (10,2))
	 AS DECIMAL (10,2))*100 AS TransWithSalInc
FROM tblIncome_History;

--Average Salary Before/After by Education Level
;WITH cte_sal_by_educ
 AS
	(
		 SELECT D.person_id, D.education, IH.salary_before, IH.salary_after
		 FROM tblDemographics D
		 JOIN tblIncome_History IH ON D.person_id = IH.person_id
	 )

SELECT 
	CS.education, 
	CAST(AVG(CAST(CS.salary_before AS DECIMAL (10,2)))AS DECIMAL (10,2)) AvgSalBeforeTransition, 
	CAST(AVG(CAST (CS.salary_after AS DECIMAL (10,2)))AS DECIMAL (10,2)) AvgSalAfterTransition
FROM cte_sal_by_educ CS
GROUP BY CS.education
ORDER BY CS.education ;

--Salary Comparison of Career breakers and Non-breakers after Transition
;WITH cte_career_brk_salary
 AS
	(
		SELECT D.person_id, D.career_break_flag, IH.salary_after
		FROM tblDemographics D
		Join tblIncome_History IH ON D.person_id = IH.person_id
	)
SELECT  
	CASE
		WHEN CCB.career_break_flag = 1 THEN 'Career Breakers' 
		ELSE 'Non-Breakers'
		END AS TransitionerType,
	CAST(AVG(CAST(CCB.salary_after AS DECIMAL (10,2))) AS DECIMAL (10,2)) AS AvgSalAfterBreak
FROM cte_career_brk_salary CCB
WHERE CCB.career_break_flag IS NOT NULL
GROUP BY  CCB.career_break_flag
ORDER BY AvgSalAfterBreak DESC;


-------------------**SATISFACTION KPI's**-------------------
--Average Satisfaction Before and After Career Transition
SELECT 
	Cast(AVG(Cast(sat_before AS DECIMAL(10,2)))AS DECIMAL(10,2)) AvgSatBefore, 
	Cast(AVG(Cast(sat_after AS DECIMAL(10,2)))AS DECIMAL(10,2)) AvgSatAfter
FROM tblSatisfaction;

--Percentage of Participants with Satisfaction Improvement after Career Transition
SELECT (CAST((SELECT Cast(COUNT(*) AS DECIMAL(10,2) )
				FROM tblSatisfaction
				WHERE sat_after > sat_before)/
		CAST(Count(*) AS DECIMAL (10,2))*100 AS DECIMAL (10,2))) AS SatImprovementPerc 
FROM tblSatisfaction;

--Satisfaction of Participants after Transition with Severe Barriers
SELECT 
	S.person_id, S.sat_delta, 
	CAST(AVG(CAST(B.severity_score AS DECIMAL (10,2)))AS DECIMAL (10,2)) AvgSeverityScore
FROM tblSatisfaction S
Join tblBarriers B ON S.person_id = B.person_id
GROUP BY S.sat_delta, S.person_id
Having CAST(AVG(CAST(B.severity_score AS DECIMAL (10,2)))AS DECIMAL (10,2)) >3
ORDER BY  AvgSeverityScore DESC;


-------------------**TRAINING CERTIFICATIONS KPI's**-------------------
--Average Training Hours per Person
SELECT person_id, Avg(hours) AvgTrainingHours, 
		CASE
			WHEN Avg(hours) <30 THEN 'Short-Term Training'
			WHEN Avg(hours) >30 AND  Avg(hours) <60 THEN 'Mid-Range Training'
			WHEN Avg(hours) >60 AND Avg(hours)<90 THEN 'Extensive Training'
			ELSE 'Intensive Training'
		END AS TrainingHoursCategory
FROM tblTrainings_Certs
GROUP BY person_id
ORDER BY person_id;

--Average Training Hours per Certification
SELECT cert_name, Avg(hours) AvgTrainingHours
FROM tblTrainings_Certs
GROUP BY cert_name;

--Top 3 Certification Providers
SELECT TOP 3 [provider], COUNT(cert_id) TotalCerts
FROM tblTrainings_Certs
GROUP BY [provider]
ORDER BY TotalCerts DESC;

--Number of participants who completed atleast One Certification

SELECT COUNT(DISTINCT D.person_id) AS CertHolderCount
FROM tblDemographics D
JOIN tblTrainings_Certs TC ON D.person_id = TC.person_id;

--Salary comparison of participants with Industry-recognized Certificates and non-industry recognized certifications
;WITH cte_cert_type
 AS 
 (
	SELECT 
		DISTINCT TC.person_id,
		MAX(CASE 
			WHEN TC.is_industry_credential = 1
			THEN 'Industry-Recognized'
			ELSE 'Not Industry-Recognized'
		END) AS CertificateCredentials,
		AVG(CAST(IH.salary_after AS DECIMAL(10,2))) AvgSalary
	FROM tblTrainings_Certs TC
	JOIN tblIncome_History IH ON TC.person_id = IH.person_id
	GROUP  BY TC.person_id
 )
SELECT 
	CCT.CertificateCredentials, 
	CAST(AVG(CAST(CCT.AvgSalary AS DECIMAL(10,2)))AS DECIMAL(10,2)) AvgSalaryAfterCertificate
FROM cte_cert_type CCT
GROUP BY CCT.CertificateCredentials;

--Correlation between Training hours and Salary Increase
;WITH cte_training_salry_inc
AS
	(
		SELECT DISTINCT 
			TC. person_id,
			TC.[hours] TrainingHours, 
			IH.pct_increase SalaryIncPercent 
		FROM tblTrainings_Certs TC
		JOIN tblIncome_History IH ON TC.person_id = IH.person_id
	)
SELECT 
	TrainingHours,
	CAST (AVG(CAST(SalaryIncPercent AS DECIMAL(10,2))) AS DECIMAL(10,2)) AvgSalInc,
	COUNT(*) DataPoints
FROM cte_training_salry_inc
GROUP BY TrainingHours
ORDER BY TrainingHours;  --Signifies No direct Correlation


 -------------------**Barriers KPI's**-------------------
 -- Three Most Common Barrier Types
 SELECT TOP 3 barrier_type, Count(barrier_type) BarrierCount
 FROM tblBarriers
 GROUP BY barrier_type
 ORDER BY BarrierCount DESC;

 --Average Severity Score
 SELECT Cast(Avg(Cast(severity_score AS DECIMAL (10,2))) AS DECIMAL (10,2)) AvgSeverityScore
 FROM tblBarriers;

 --Percentage of Participants with Severe Barriers
 SELECT 
 CAST(
	(
		(SELECT  Count(severity_score)
		FROM tblBarriers WHERE severity_score >=4)
	/
	CAST(Count(severity_score) AS DECIMAL (10,2)) 
	) *100 
AS DECIMAL (10,2)) AS PercWithSevereBarriers
 FROM tblBarriers;

 --Count of people who faced more than one Barrier
 SELECT 
	 COUNT(DISTINCT person_id) PartsWithMultipleBarriers, 
	 COUNT(barrier_id) TotalPartsFacingBarriers
 FROM tblBarriers;

 --Avg Severity Scores reported by Gender
SELECT 
	D.gender Gender, 
	CAST(AVG(CAST(B.severity_score AS DECIMAL (10,2)))  AS DECIMAL (10,2)) AvgSeverityScore
FROM tblBarriers B
JOIN tblDemographics D ON B.person_id = D.person_id
GROUP BY D.gender;

--Top 3 Barriers Faced by each Country
;WITH cte_country_barrier
AS
(
 SELECT D.country, B.barrier_type, COUNT(D.person_id)PerCount,
		ROW_NUMBER() OVER (PARTITION BY D.country ORDER BY COUNT(D.person_id)DESC) RowRank
 From tblDemographics D
 JOIN tblBarriers B ON D.person_id = B.person_id
 GROUP BY  D.country, B.barrier_type
 
 )
SELECT country, STRING_AGG( barrier_type, ', ') Barriers
FROM cte_country_barrier 
WHERE RowRank <4
GROUP BY country;

  -------------------**Reasons KPI's**-------------------
  --Top Five Reaons for Career Change
  SELECT TOP 5 reason_type, COUNT(reason_type) AS ReasonCount
  FROM tblReasons
  GROUP BY reason_type
  Order BY ReasonCount DESC;

  --Common Reasons given by Participants based on Previous Industry
  ;WITH cte_industry_reasons
  AS
  (
	  SELECT D.prev_industry, R.reason_type, COUNT(D.person_id) PerCount, 
			ROW_NUMBER() OVER (PARTITION BY D.prev_industry ORDER BY COUNT(D.person_id)DESC) ReasonRank
	  FROM tblReasons R
	  JOIN tblDemographics D ON R.person_id = D.person_id
	  GROUP BY D.prev_industry, R.reason_type
  )
  SELECT prev_industry, STRING_AGG(reason_type, ', ') Reasons
  FROM cte_industry_reasons
  WHERE ReasonRank > 6
  GROUP BY prev_industry;


