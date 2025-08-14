
--Salary and Satisfaction Performance by Industry
CREATE VIEW vwTransitionPerformance AS
SELECT 
    T.to_industry,
    COUNT(DISTINCT T.transition_id) AS TotalTransitions,
    CAST(AVG(I.pct_increase) AS DECIMAL (10,2)) AS AvgSalaryIncrease,
    CAST(AVG(CAST(S.sat_delta AS FLOAT))  AS DECIMAL (10,2)) AS AvgSatDelta
FROM tblTransitions T
JOIN tblIncome_History I ON T.transition_id = I.transition_id
JOIN tblSatisfaction S ON T.transition_id = S.transition_id
GROUP BY T.to_industry; 

--Salary Performance by Training Certificates and Providers

CREATE VIEW vwTrainingEfficiency AS
SELECT 
    TC.[provider],
    TC.cert_name,
    CAST(AVG(CAST(TC.hours AS FLOAT)) AS DECIMAL (10,2)) AS AvgHours,
     CAST(AVG(CAST(I.pct_increase AS FLOAT)) AS DECIMAL (10,2)) AS AvgSalaryGrowth,
    COUNT(TC.person_id) AS Participants
FROM tblTrainings_Certs TC
JOIN tblIncome_History I ON TC.transition_id = I.transition_id
GROUP BY TC.[provider], TC.cert_name;
