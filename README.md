# 📊 Career Transitions Analysis Project

Comprehensive data analytics project analyzing global career transitions using SQL, Excel, and Power BI. It explores transition pathways, salary trends, satisfaction levels, training impacts, and personal barriers — supported by a relational database and real-world business logic.

---

## 🎯 Project Objectives

- Identify patterns in career transitions by role, industry, and demographics.
- Measure salary growth, training effectiveness, and job satisfaction before/after transitions.
- Explore key reasons and barriers to switching careers using ranked metrics.
- Build interactive dashboards and professional reports with reusable SQL components.

---

## 🛠 Tools & Technologies Used

| Tool / Technology | Purpose |
|-------------------|---------|
| **SQL Server** | Database creation, table creation, analysis, stored procedures, views |
| **Excel** | Initial data cleaning, formatting, and issue tracking |
| **Power BI** | KPI visualizations and interactive dashboard |
| **Git & GitHub** | Version control, documentation, and portfolio showcase |

---

## 🗂️ Dataset Overview

This project is based on **real-world career change research**, structured into simulated but messy datasets for hands-on analysis. Data is drawn and modeled from sources like:

- HiringLab (Indeed), LinkedIn Pulse
- U.S. Department of Labor dashboards
- Novoresume, Apollo Technical, CareerShifters
- UQ Study, BrainManager, and more

### Tables in the Project

| Table                | Description |
|----------------------|-------------|
| `tblDemographics`    | Participant profile (age, gender, education, country, previous industry) |
| `tblTransitions`     | Each career move (from → to role/industry, time, date) |
| `tblIncome_History`  | Salary before/after transition, % increase |
| `tblSatisfaction`    | Job satisfaction scores before/after |
| `tblTrainings_Certs` | Training, hours, provider, certification earned |
| `tblBarriers`        | Barriers faced, severity, barrier text |
| `tblReasons`         | Reason types, reason comment |

All tables are normalized and connected via `person_id` and `transition_id`.

---

## 📂 File Structure

```
Career-Transitions-Data-Analysis/
│
├── Cleaned_data/
│   └── CSV/
│   ├──Barriers.csv
│   ├──Demographics.csv
│   ├──Income_History.csv
│   ├──Reasons.csv
│   ├──Satisfaction.csv
│   ├──Trainings_Certs.csv
│   ├── Transitions.csv
│
├── SQL/
│   ├── DatabaseCreation.sql
│   ├── TableCreation.sql
│   ├── LoadScripts.sql
│   ├── Important Metrics.sql
│   ├── StoredProcedure.sql
│   ├── Views.sql
│
├── PowerBI/
│   └── CareerTransitionDashboard.pbix
│
├── Cleaning_logs/
│   └──Cleaning_Log_Template.xlsx
│
|── Images/
|   └── Dashboard Screenshots/
|       |── Screenshot 1.png
|       |── Screenshot 2.png
|
├── README.md
```

---

## 🔍 SQL Concepts Demonstrated

✅ Complex Joins  
✅ Aggregations & Grouping  
✅ CTEs & Subqueries  
✅ Window Functions (`RANK()`, `ROW_NUMBER()`)  
✅ CASE Statements  
✅ Stored Procedures with Parameters  
✅ Views for BI reporting  
✅ Data type casting & formatting  
✅ STRING_AGG for combining categories  

---

## 🧼 Data Cleaning (Excel)

All source tables were intentionally structured to mimic real-world data challenges, including inconsistencies, missing values, and formatting issues — allowing for practical demonstration of data cleaning and transformation skills.

Key cleaning steps included:

- Removing duplicates
- Handling missing values
- Standardizing country, industry, and role naming
- Fixing inconsistent text cases (UPPER vs lower)
- Tracking changes in a cleaning log template


---

## 📈 Power BI Dashboard

The Power BI dashboard brings the story to life:

- 📊 Career transitions by age group, gender, and country
- 📅 Trends in career switching over time by gender
- 🧭 Industry-to-industry career transition pathways
- 📌 Top reasons and barriers for switching careers
- 🎓 Certification-wise average salary increase
- 💼 Avg salary increase by destination industry
- 😊 Satisfaction gain after switching industries
- 🔍 Slicers for country, gender, and age group
- 📎 KPI cards for total participants, transitions, avg transition time, and salary change %

<img src="Images/Dashboard Screenshots/Screenshot 1.png" alt="Screetshot1" width="600" height="auto">
<img src="Images/Dashboard Screenshots/Screenshot 2.png" alt="Screetshot2" width="600" height="auto">

---

## 💡 Sample Insights

-👥 Participants aged 50–59 had the highest number of career transitions, followed closely by those aged 40–49.
- 📈 Career transitions have steadily increased since 2016, especially among female participants.
- 🌍 India, the United States, and Germany contributed the most career changers.
- 💼 Healthcare, Finance, and Technology were among the most frequent destination industries.
- 🎯 Relocation, career growth, and passion were the top 3 reasons for switching careers.
- 🚧 Age-related bias and financial constraints were the most common barriers.
- 🎓 Certifications like IBM Data Science and Udemy Bootcamps showed the highest salary impact.
- 💰 Hospitallity, E-commerce, and Finance industries led in average salary increase post-transition.
- 😊 Finance and Manufacturing transitions led to the greatest satisfaction gains.

---

## 📜 Data Sources & Generation

> 🔎 **Data was modeled using real-world reports and dashboards from public sources**, but structured into simulated datasets to replicate real-world complexity.

**Reference sources include**:  
- HiringLab Career Mobility Reports  
- DOL Occupational Transitions Dashboard  
- LinkedIn Pulse (Job change trends)  
- Apollo Technical, CareerShifters, Novoresume  
- UQ Study Career Stats & BrainManager

This method gave me the opportunity to:
- Build a messy but realistic data warehouse
- Practice real data cleaning, transformation, and loading
- Perform business-ready analytics from scratch

---

## 👩‍💻 About the Author

**Manveer Kaur**  
Aspiring Data Analyst with a multidisciplinary background in Chemistry, International Business, Marketing, and Human Resources.
Proficient in SQL, Power BI, and Excel, with hands-on experience in end-to-end data projects.
Known for a strong attention to detail, a passion for transforming messy data into meaningful insights, and the ability to tell compelling data-driven stories.

📫 LinkedIn: [Manveer Kaur](https://www.linkedin.com/in/manveer-kaur-1a7399176/)  
📧 Email: manveerk15@gmail.com 
🌍 Location: Canada

---




