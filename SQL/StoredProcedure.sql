
--Participant Profile-Fetches infomation from all tables for each participant

CREATE PROCEDURE spParticipantProfile @PersonID INT = 0
AS
BEGIN
    SELECT 
        D.person_id, D.age, D.gender, D.country, D.education,
        T.from_role, T.to_role, T.from_industry, T.to_industry,
        I.salary_before, I.salary_after, I.pct_increase,
        S.sat_before, S.sat_after, S.sat_delta,
        STRING_AGG(TC.cert_name, ', ') AS Certifications,
        STRING_AGG(B.barrier_type, ', ') AS Barriers,
		STRING_AGG(R.reason_type, ', ') AS Reasons
    FROM tblDemographics D
    JOIN tblTransitions T ON D.person_id = T.person_id
    JOIN tblIncome_History I ON T.transition_id = I.transition_id
    JOIN tblSatisfaction S ON T.transition_id = S.transition_id
    LEFT JOIN tblTrainings_Certs TC ON D.person_id = TC.person_id
    LEFT JOIN tblBarriers B ON D.person_id = B.person_id
	LEFT JOIN tblReasons R ON D.person_id = R.person_id
    WHERE (@PersonID = 0 OR(@PersonID <> 0 AND D.person_id = @PersonID))
    GROUP BY D.person_id, D.age, D.gender, D.country, D.education,
             T.from_role, T.to_role, T.from_industry, T.to_industry,
             I.salary_before, I.salary_after, I.pct_increase,
             S.sat_before, S.sat_after, S.sat_delta;
END;


