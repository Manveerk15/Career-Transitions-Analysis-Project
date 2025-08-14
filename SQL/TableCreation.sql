
--SQL DDL scripts for all CSV files to create tables


--Table Demographics
IF OBJECT_ID ('tblDemographics', 'U') IS NOT NULL
	DROP TABLE tblDemographics;
CREATE TABLE tblDemographics
(
	person_id INT NOT NULL  PRIMARY KEY,
	age SMALLINT,
	gender NVARCHAR(10),
	education NVARCHAR(100),
	country NVARCHAR(100),
	prev_industry NVARCHAR(100),
	career_break_flag BIT
);

--Table Transitions
IF OBJECT_ID ('tblTransitions', 'U') IS NOT NULL
	DROP TABLE tblTransitions;
CREATE TABLE tblTransitions
(
	transition_id INT PRIMARY KEY,
	person_id INT NOT NULL FOREIGN KEY REFERENCES tblDemographics(person_id),
	from_role NVARCHAR(100),
	to_role NVARCHAR(100),
	from_industry NVARCHAR(100),
	to_industry NVARCHAR(100),
	transition_date DATE,
	transition_time_months INT
);

--Table Barriers
IF OBJECT_ID ('tblBarriers', 'U') IS NOT NULL
	DROP TABLE tblBarriers;
CREATE TABLE tblBarriers
(
	barrier_id INT NOT NULL PRIMARY KEY,
	person_id INT NOT NULL FOREIGN KEY REFERENCES tblDemographics(person_id),
	transition_id INT NOT NULL FOREIGN KEY REFERENCES tblTransitions(transition_id),
	barrier_type NVARCHAR(255),
	barrier_text NVARCHAR(2000),
	severity_score SMALLINT
);

--Table Reasons
IF OBJECT_ID ('tblReasons', 'U') IS NOT NULL
	DROP TABLE tblReasons;
CREATE TABLE tblReasons
(
	reason_id INT PRIMARY KEY,
	person_id INT NOT NULL FOREIGN KEY REFERENCES tblDemographics(person_id),
	transition_id INT NOT NULL FOREIGN KEY REFERENCES tblTransitions(transition_id),
	reason_type  NVARCHAR(255),
	reason_comment NVARCHAR(2000),
	priority_rank INT
);

--Table Income History
IF OBJECT_ID ('tblIncome_History', 'U') IS NOT NULL
	DROP TABLE tblIncome_History;
CREATE TABLE tblIncome_History
(
	salary_id INT PRIMARY KEY,
	person_id INT NOT NULL FOREIGN KEY REFERENCES tblDemographics(person_id),
	transition_id INT NOT NULL FOREIGN KEY REFERENCES tblTransitions(transition_id),
	salary_before DECIMAL (10,2),
	salary_after DECIMAL (10,2),
	date_before DATE,
	date_after DATE,
	pct_increase DECIMAL(10,2)
);

--Table Satisfaction
IF OBJECT_ID ('tblSatisfaction', 'U') IS NOT NULL
	DROP TABLE tblSatisfaction;
CREATE TABLE tblSatisfaction
(
	sat_id INT PRIMARY KEY,
	person_id INT NOT NULL FOREIGN KEY REFERENCES tblDemographics(person_id),
	transition_id INT NOT NULL FOREIGN KEY REFERENCES tblTransitions(transition_id),
	sat_before SMALLINT,
	sat_after SMALLINT,
	sat_delta SMALLINT,
	notes NVARCHAR(2000)
);

--Table Tranings Certificates
IF OBJECT_ID ('tblTranings_Certs', 'U') IS NOT NULL
	DROP TABLE tblTranings_Certs;
CREATE TABLE tblTranings_Certs
(
	cert_id INT PRIMARY KEY,
	person_id INT NOT NULL FOREIGN KEY REFERENCES tblDemographics(person_id),
	transition_id INT NOT NULL FOREIGN KEY REFERENCES tblTransitions(transition_id),
	cert_name NVARCHAR(255),
	[provider] NVARCHAR(50),
	[hours] SMALLINT,
	completion_date DATE,
	is_industry_credential BIT
);