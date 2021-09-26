--showing how many entries there are per in-country partner

DROP TABLE IF EXISTS Market_Share
CREATE TABLE Market_Share(Partner VARCHAR(50), Share DECIMAL(10,2))
GO

INSERT INTO Market_Share(Partner, Share)
SELECT In_Country_Partner, COUNT(*)
FROM coffee_data
WHERE In_Country_Partner IS NOT NULL
GROUP BY  In_Country_Partner

GO
UPDATE Market_Share SET Share = (Share/1331)*100
GO

select * from Market_Share

--showing how many kilograms were harvested each year


DROP TABLE IF EXISTS Kilograms_per_year
CREATE TABLE Kilograms_per_year( Yr SMALLINT, Kilograms NUMERIC(10,2))
GO

INSERT INTO Kilograms_per_year(Yr,  Kilograms)
SELECT  Harvest_Year,SUM(Bag_Weight * Number_Of_Bags)
FROM coffee_data
WHERE Harvest_Year IS NOT NULL
GROUP BY Harvest_Year 


 
--showing average taste attributes by country of origin


DROP TABLE IF EXISTS Flavor_Averages
CREATE TABLE Flavor_Averages( 
    country VARCHAR(50),
    avg_aroma FLOAT, 
    avg_flavor FLOAT, 
    avg_aftertaste FLOAT, 
    avg_acidity FLOAT, 
    avg_body FLOAT, 
    avg_balance FLOAT )
GO

INSERT INTO Flavor_Averages(country, avg_aroma, avg_flavor, avg_aftertaste, avg_acidity, avg_body, avg_balance)
SELECT Country_Of_Origin AS country,
       AVG(Aroma) AS avg_aroma,
       AVG(Flavor) AS avg_flavor,
       AVG(Aftertaste) AS avg_aftertaste,
       AVG(Acidity) AS avg_acidity,
       AVG(Body) AS avg_body,
       AVG(Balance) AS avg_balance
FROM coffee_data
GROUP BY Country_of_Origin


--checking whether the percentages of entries with altitude below 1000m or above 2000m are significant


SELECT (COUNT(CASE WHEN Altitude_Above < 1000 THEN 1 ELSE NULL END)*100/COUNT(*)) AS '% of entries below 1000m',
       (COUNT(CASE WHEN Altitude_Above > 2000 THEN 1 ELSE NULL END)*100/COUNT(*)) AS '% of entries above 2000m'
       FROM coffee_data



--showing number of entries within each altitude range that I defined with the help of observation and the queries above


DROP TABLE IF EXISTS Acidity_by_altitude
CREATE TABLE Acidity_by_altitude( Acidity FLOAT, Altitude_Above DECIMAL(10)
)
GO
INSERT INTO Acidity_by_altitude ( Acidity, Altitude_Above)
SELECT Acidity, Altitude_Above 
FROM coffee_data
WHERE Altitude_Above IS NOT NULL AND Acidity IS NOT NULL

      
SELECT * FROM Acidity_by_altitude
