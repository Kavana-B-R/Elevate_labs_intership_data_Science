CREATE DATABASE IF NOT EXISTS titanic_db;
USE titanic_db;

CREATE TABLE IF NOT EXISTS titanic_data (
    PassengerId INT,
    Survived INT,
    Pclass INT,
    Name VARCHAR(100),
    Sex VARCHAR(10),
    Age DECIMAL(4,1),
    SibSp INT,
    Parch INT,
    Fare DECIMAL(10,2),
    Embarked VARCHAR(5)
);

SELECT * FROM titanic_data
LIMIT 10;

SELECT COUNT(*) AS total_passengers
FROM titanic_data;

SELECT *
FROM titanic_data
WHERE Survived = 1;

SELECT *
FROM titanic_data
WHERE Sex = 'female';

SELECT PassengerId, Name, Fare
FROM titanic_data
ORDER BY Fare DESC
LIMIT 10;

SELECT Sex,
       COUNT(*) AS total_passengers,
       SUM(Survived) AS survived_count
FROM titanic_data
GROUP BY Sex;

SELECT Pclass,
       AVG(Fare) AS average_fare
FROM titanic_data
GROUP BY Pclass;

SELECT Pclass,
       AVG(Fare) AS average_fare
FROM titanic_data
GROUP BY Pclass
HAVING AVG(Fare) > 30;

SELECT *
FROM titanic_data
WHERE Age BETWEEN 20 AND 40;

SELECT PassengerId, Name
FROM titanic_data
WHERE Name LIKE 'A%';

SELECT Pclass,
       COUNT(*) AS total_passengers,
       SUM(Survived) AS survived_count,
       ROUND(SUM(Survived) * 100.0 / COUNT(*), 2) AS survival_rate_percent
FROM titanic_data
GROUP BY Pclass;

SELECT Sex,
       COUNT(*) AS total_passengers,
       SUM(Survived) AS survived_passengers,
       ROUND(SUM(Survived) * 100.0 / COUNT(*), 2) AS survival_rate_percent
FROM titanic_data
GROUP BY Sex;
