#####################################
#     CREATE SCHEMA diabetes      #
#####################################
# DROP SCHEMA diabetes;
CREATE SCHEMA diabetes;
USE diabetes;

# Create patients table
CREATE TABLE patients (
	PRIMARY KEY (patient_id),
    patient_id TINYINT UNSIGNED AUTO_INCREMENT,
    first_name VARCHAR(15),
    last_name VARCHAR(15),
    gender TINYINT UNSIGNED,
    age TINYINT UNSIGNED,
    smoking TINYINT UNSIGNED,
    bmi FLOAT(4,2) UNSIGNED,
    medication_id TINYINT UNSIGNED
);

# Apply index to the patients table
CREATE UNIQUE INDEX idx_patients
	ON patients (first_name, last_name, gender);

CREATE INDEX idx_patients_bmi 
	ON patients(bmi);
    
# Create insulin_dosage table
CREATE TABLE insulin_dosage (
	PRIMARY KEY (insulin_id),
	insulin_id TINYINT UNSIGNED AUTO_INCREMENT,
    patient_id TINYINT UNSIGNED,
    insulin_date DATE,
    insulin_dosage FLOAT(4,2) UNSIGNED,
    insulin_type VARCHAR(15),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON UPDATE CASCADE
); 

# Apply index to insulin_dosage table
CREATE UNIQUE INDEX idx_insulin
	ON insulin_dosage(patient_id, insulin_date,insulin_type);

CREATE INDEX idx_insulin_dosage 
	ON insulin_dosage(insulin_dosage);

  
# Create blood_glucose table
CREATE TABLE blood_glucose(
	PRIMARY KEY (blood_glucose_id),
	blood_glucose_id TINYINT UNSIGNED AUTO_INCREMENT,
    patient_id TINYINT UNSIGNED,
    blood_glucose_date DATE,
    blood_glucose_value FLOAT(5,2) UNSIGNED,
    activity_level TINYINT UNSIGNED,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON UPDATE CASCADE
); 

# Apply index to the blood_glucose table
CREATE UNIQUE INDEX idx_glucose
	ON blood_glucose(patient_id, blood_glucose_date);

CREATE INDEX idx_glucose_value 
	ON blood_glucose(blood_glucose_value);


# Create medications table
CREATE TABLE medications(
	PRIMARY KEY (medication_id),
	medication_id TINYINT UNSIGNED AUTO_INCREMENT,
    medication_name VARCHAR(15)
); 

# Apply triggers to patients table to include only ages 18 and up; bmi in a normal range; and medication_id be the integers between 1 and 5(inclusive); and gender & smoking status be the binary variables of 0 and 1.
DELIMITER //
CREATE TRIGGER patients_trigger
		BEFORE INSERT ON patients
	FOR EACH ROW
BEGIN
	IF NEW.age < 18 THEN
			SIGNAL SQLSTATE 'HY000'
		SET MESSAGE_TEXT = 'Age must be 18 years or older';
	END IF;
	IF NEW.bmi < 15 OR NEW.bmi > 35 THEN
			SIGNAL SQLSTATE 'HY000'
         SET MESSAGE_TEXT = 'bmi must be between 15 and 35';
	END IF;
    IF NEW.gender NOT IN (0,1) THEN
			SIGNAL SQLSTATE 'HY000'
		SET MESSAGE_TEXT = 'Gender must be 0 or 1';
	END IF;
    IF NEW.smoking NOT IN (0,1) THEN
			SIGNAL SQLSTATE 'HY000'
		SET MESSAGE_TEXT = 'Smoking must be 0 or 1';
	END IF;
    IF NEW.medication_id NOT IN (1,2,3,4,5) THEN
			SIGNAL SQLSTATE 'HY000'
		SET MESSAGE_TEXT = 'Medication id must be integers between 1 and 5';
	END IF;
END //

# Add trigger to the insulin_dosage table to only include the following three date '2023-04-01', '2023-04-02', '2023-04-03'.
DELIMITER //
CREATE TRIGGER insulin_dosage_trigger
		BEFORE INSERT ON insulin_dosage
	FOR EACH ROW
BEGIN
	IF NEW.insulin_date NOT BETWEEN '2023-04-01' AND '2023-04-03' THEN
			SIGNAL SQLSTATE 'HY000'
		SET MESSAGE_TEXT = 'Date of taking insulin dosage must be between 2023/04/01 and 2023/04//03 ';
	END IF;
END //


# Apply trigger to the blood_glucose table to include blood glucose lower than 200 mg/DL; and activity level being integers that range from 1-5(inclusive)
DELIMITER //
CREATE TRIGGER blood_glucose_trigger
		BEFORE INSERT ON blood_glucose 
	FOR EACH ROW
BEGIN
	IF NEW.blood_glucose_value > 300 THEN
			SIGNAL SQLSTATE 'HY000'
		SET MESSAGE_TEXT = 'blood_glucose must be lower than 300 mg/DL';
	END IF;
	IF NEW.activity_level NOT IN (1,2,3,4,5) THEN 
			SIGNAL SQLSTATE 'HY000'
         SET MESSAGE_TEXT = 'activity_level must be an integer value between 1 and 5(inclusive)';
	END IF;
END //



#####################################
#             DATA ENTRY            #
#####################################

INSERT INTO patients (first_name, last_name, gender, age, smoking, bmi, medication_id)
	VALUES
	('John', 'Doe', 1, 45, 0, 25.5, 1),
	('Jane', 'Doe', 0, 32, 0, 21.7, 2),
	('Bob', 'Smith', 1, 58, 1, 29.4, 3),
	('Alice', 'Johnson', 0, 42, 0, 27.1, 4),
	('David', 'Lee', 1, 67, 1, 30.2, 5),
	('Emily', 'Chen', 0, 25, 0, 19.8, 3),
	('Michael', 'Wong', 1, 38, 0, 23.7, 2),
	('Catherine', 'Nguyen', 0, 52, 1, 31.6, 4),
	('Maria', 'Rodriguez', 0, 41, 0, 26.3, 1),
	('Chris', 'Johnson', 1, 36, 1, 27.8, 1),
	('Tina', 'Kim', 0, 48, 0, 22.5, 2),
	('Tom', 'Huang', 1, 54, 1, 32.5, 3),
	('Melissa', 'Taylor', 0, 31, 0, 20.3, 4),
	('William', 'Davis', 1, 63, 0, 26.6, 5);


INSERT INTO insulin_dosage (patient_id, insulin_date, insulin_dosage, insulin_type)
	VALUES 
    (1, '2023-04-01', 10.5, 'Rapid'),
    (1, '2023-04-02', 12.0, 'Long Acting'),
    (1, '2023-04-03', 9.5, 'Rapid'),
    (2, '2023-04-01', 8.0, 'Rapid'),
    (2, '2023-04-02', 7.5, 'Long Acting'),
    (2, '2023-04-03', 9.0, 'Rapid'),
    (3, '2023-04-01', 11.5, 'Long Acting'),
    (3, '2023-04-02', 8.5, 'Rapid'),
    (3, '2023-04-03', 10.0, 'Long Acting'),
    (4, '2023-04-01', 10.0, 'Rapid'),
    (4, '2023-04-02', 11.0, 'Long Acting'),
    (4, '2023-04-03', 9.0, 'Rapid'),
    (5, '2023-04-01', 12.5, 'Long Acting'),
    (5, '2023-04-02', 8.0, 'Rapid'),
    (5, '2023-04-03', 10.5, 'Long Acting'),
    (6, '2023-04-01', 9.0, 'Rapid'),
    (6, '2023-04-02', 11.5, 'Long Acting'),
    (6, '2023-04-03', 8.5, 'Rapid'),
    (7, '2023-04-01', 8.5, 'Rapid'),
    (7, '2023-04-02', 9.0, 'Long Acting'),
    (7, '2023-04-03', 10.0, 'Rapid');



INSERT INTO blood_glucose(patient_id, blood_glucose_date, blood_glucose_value, activity_level)
	VALUES 
	(1, '2022-01-01', 95.2, 2),
	(1, '2022-01-02', 98.4, 3),
	(1, '2022-01-03', 100.5, 1),
	(1, '2022-01-04', 89.6, 2),
	(1, '2022-01-05', 91.1, 1),
	(2, '2022-01-01', 112.8, 3),
	(2, '2022-01-02', 118.1, 2),
	(2, '2022-01-03', 101.9, 1),
	(2, '2022-01-04', 94.5, 2),
	(2, '2022-01-05', 102.6, 3),
	(3, '2022-01-01', 120.2, 2),
	(3, '2022-01-02', 122.8, 3),
	(3, '2022-01-03', 129.1, 2),
	(3, '2022-01-04', 130.4, 1),
	(3, '2022-01-05', 124.6, 3),
	(4, '2022-01-01', 82.7, 1),
	(4, '2022-01-02', 89.2, 2),
	(4, '2022-01-03', 91.8, 1),
	(4, '2022-01-04', 94.3, 3),
	(4, '2022-01-05', 88.6, 2);


# Import CSV into the medications table
LOAD DATA LOCAL INFILE '/Users/josie/Desktop/spring 2023/sql-p8180/final/medication.csv'
INTO TABLE medications
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(medication_id, medication_name);


#####################################
#            QUERIES.               #
#####################################

#1. Query that creates a view and incorporates at least one join.
#a. In a comment, explain what results you are trying to display and why it should be saved as a view.

# This view combines the information from the patients table and insulin_dosage table. It displays the patient ID, name, insulin dosage, and date of insulin administration. 
# It's useful to save this as a view because it simplifies the querying process and allows for easier and faster access to the combined data. For example, we can examine the potentioal relationship between insulin dosage and bmi; or insuline type and smoking status.
# This view can be used in subsequent queries without having to join the tables each time.

CREATE VIEW patient_insulin AS
	 SELECT p.patient_id, p.first_name, p.last_name, p.smoking, p.bmi,i.insulin_date, i.insulin_dosage, i.insulin_type
	 FROM patients p
		INNER JOIN insulin_dosage AS i
	 USING (patient_id);


#2. Query that creates a temporary table and incorporates at least one join and then queries it (must be different from view).
#a. In a comment, explain what results you are trying to display.

# I created a temporary table called patient_glucose_info which combines information from the patients table and blood_glucose table, showing the patient ID, name, blood glucose information, and activity level. 
# In this example, the query returns the candidates whose blood glucose value is greater than 110, doctors may find out the possible covariates that contribute to high blood glucose, such as smoking status and bmi.
# By using a temporary table, we can simplify the querying process and avoid having to join the two tables each time we run a query. 

CREATE TEMPORARY TABLE patient_glucose AS
	(SELECT p.patient_id, p.first_name, p.last_name, p.bmi, p.smoking, g.blood_glucose_value, g.activity_level
	 FROM patients AS p
		 INNER JOIN blood_glucose AS g
		 USING (patient_id));

SELECT *
	FROM patient_glucose
WHERE blood_glucose_value > 110;

#3. Query that creates a CTE and incorporates at least one join and then queries it (must be different from view/temporary table).
#a. In a comment, explain what results you are trying to display.

# I created a CTE to combine the information of insulin_dosage table and blood_glucose tables based on the same patient_id. As a reult, we can observe the potential associations between blood glucose and the insulin dosage applied to each patients.
# So I calculated the mean value of blood glucose and insuline dosage of each person from the CTE.

WITH CTE AS (
  SELECT 
    i.patient_id, i.insulin_date, i.insulin_dosage, g.blood_glucose_value
  FROM 
    insulin_dosage AS i
    INNER JOIN blood_glucose AS g 
    USING (patient_id)
)

SELECT patient_id, ROUND(AVG(blood_glucose_value),2) AS avg_blood_glucose, ROUND(AVG(insulin_dosage),2) AS avg_insulin_dosage
	FROM CTE
GROUP BY patient_id;


#4. Create a new table that pivots one of your tables from long to wide or wide to long.
#a. In a comment, explain what kind of analyses you would do with the new pivoted table.

# This query pivots the blood_glucose table from long to wide.
# As a result, the columns of the new table are insulin dosages of three different dates.
# The new pivoted table enhaced data analysis because it organized dosage_intake into columns that represent specific dates, so that we can easily compare the dosage across different days and identify the trends.

CREATE TABLE insulin_dosage_wide AS
	SELECT patient_id,
	   MAX(CASE WHEN insulin_date = '2023-04-01' THEN insulin_dosage END) AS insulin_day1,
	   MAX(CASE WHEN insulin_date = '2023-04-02' THEN insulin_dosage END) AS insulin_day2,
	   MAX(CASE WHEN insulin_date = '2023-04-03' THEN insulin_dosage END) AS insulin_day3
	FROM insulin_dosage
	GROUP BY patient_id;


#5. Query that incorporates a self-join.
#a. In a comment, explain what results you are trying to display.

# This query provides the average BMI and smoking rate for male and female patients in the "patients" table, and it groups the results by gender.
# The result displays the potential gender differences in body composition(bmi) and smoking behabior, which may provide insights into their effect on health status.

SELECT a.gender, ROUND(AVG(a.bmi),2) AS avg_bmi, AVG(a.smoking) AS smoking_rate
FROM patients AS a
	INNER JOIN patients AS b
    USING (gender)
GROUP BY a.gender;


#6. Query that incorporates a subquery to account for possible ties.
#a. In a comment, explain what results you are trying to display.
# This query returns the people with highest BMI, who is Tom Huang.

SELECT first_name, last_name
FROM patients
WHERE bmi = 
	(SELECT MAX(bmi)
	 FROM patients);

#7. Query that incorporates a UNION.
#a. In a comment, explain what results you are trying to display, and why you chose UNION or UNION ALL.
# I created a full join with the UNION, the resulting table displays all columns of information in insulin_dosage table and blood_glucose table.
# By using the UNION rather than UNION ALL, I chose to remove the duplicates and create a distinct list of rows in either of the two table, and the output is smaller and runs faster comparing with using UNION ALL.

SELECT *
FROM insulin_dosage AS a
	LEFT JOIN blood_glucose AS b
	USING (patient_id)
UNION 
SELECT *
FROM insulin_dosage AS a
	RIGHT JOIN blood_glucose AS b
	USING (patient_id)


#8. Query that adds an aggregated value with OVER() or OVER(PARTITION BY) and CASE WHEN() to compare the aggregated value to the value in each row.
#a. In a comment, explain what results you are trying to display, and why you chose OVER() or OVER(PARTITION BY).

# This query includes a new column called dosage_comparison that indicates whether the insulin_dosage of each observation is above or below the average.
# I selected OVER() rather than OVER(PARTITION BY()) becuase I want to compute the average insulin dosage across the entire observations instead of the average values for each smaller group.
SELECT *,
    CASE WHEN 
		insulin_dosage > avg_insulin_dosage THEN 'Above Average' 
        ELSE 'Below Average' 
	END AS dosage_comparison
FROM (
	SELECT *,
        AVG(insulin_dosage) OVER() AS avg_insulin_dosage
    FROM insulin_dosage
) AS derived;


#9. Query that ranks your data in some way.
#a. In a comment, explain what results you are trying to display, and why you chose RANK() or DENSE RANK().

# The output displays the patients ranked by their average blood glucose level, with the highest average first.
# I selected RANK() instead of DENSE RANK() becuase it will assign the same rank to patients with the same average blood glucose level, and then assign the next rank based on the next highest average. This allows for ties in the rankings, which can be useful when there are multiple patients with the same average blood glucose level.

SELECT p.first_name, p.last_name,
    AVG(bg.blood_glucose_value) AS avg_blood_glucose,
    RANK() OVER(ORDER BY AVG(bg.blood_glucose_value) DESC) AS glucose_rank
FROM patients AS p
	INNER JOIN blood_glucose AS bg
    USING (patient_id)
GROUP BY p.patient_id
ORDER BY glucose_rank;


#10. Query that answers a question of your choosing about your database – should incorporate at least one additional feature like a join, aggregate/non-aggregate/CASE function, window function, view/temporary table/CTE etc.
#a. In a comment, please include your question and the answer to the question.

# QUESTION: Are patients who smoke more likely to have higher blood glucose levels than patients who do not smoke?
# ANSWER: Yes, the average blood glucose of people who smoke and don't smoke are 125.42 and 96.75, suggesting patients who smoke more likely to have higher blood glucose levels
SELECT p.smoking, ROUND(AVG(b.blood_glucose_value),2) AS avg_blood_glucose
	FROM blood_glucose AS b
	INNER JOIN patients AS p
    ON b.patient_id = p.patient_id
GROUP BY p.smoking;




