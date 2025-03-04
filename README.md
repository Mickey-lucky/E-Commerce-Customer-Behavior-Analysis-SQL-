# E-Commerce Startup Customer Behavior Analysis (SQL)

## Introduction 
The project requirement comes from the User Operations Department of an E-commerce company. Compared to acquiring new customers, maintaining and operating existing ones costs less and may yield higher conversion rates.They are looking for data analysts to mine user APP behavior data, form data-driven conclusions, and then provide a set of strategy recommendations that can enhance operational efficiency and empower business growth.The project utilized marketing funnel analysis methodology to analyze e-commerce retail customer behavior data. It aims to explore the conversion rate of each behavior step and uncover the intricacy behind it to provide insight for marketing strategy optimization. 

## Tools & Language used 
MySQL Workbench & Excel & SQL


## Data Wrangling
* check and delete duplicated records (using window function row_number)
  - disable MySql safe mode: set SQL_SAFE_UPDATES = 0
  - add primary key column: id

   ![check duplicates](https://github.com/user-attachments/assets/9dfc99c2-ed93-4c33-a21c-233ee8bacb50)<br>
   ![delete duplicates](https://github.com/user-attachments/assets/9af07a2f-123e-4f7b-b571-c1c2c2a28943)<br>
   - check if there is missing value<br>
   ![delete missing value](https://github.com/user-attachments/assets/08c1deb4-8007-492a-800c-96b96151362b)<br>
  
* Unix timestamp conversion and extract date&hour
   - add new columns: dates, datetime and hour
   ![timestamp conversion](https://github.com/user-attachments/assets/d4ca87e4-1311-46ef-8d63-fb474383ff8d)<br>
    
  
* 4 behavior types (pageview, favorite, cart, buy) organized into 3 columns: awareness(pageview), like(favourite&cart), purchase(buy) 
   - create view for organized new table<br>
   ![create view](https://github.com/user-attachments/assets/51f577b5-08e7-43ca-af20-1c22c52672de)<br><br><br>

## EDA
* aggregated number of three types of behavior for calculation of conversion rate of each step
   ![aggregatedtypes of behavior](https://github.com/user-attachments/assets/0eb4a127-13a5-4b31-a858-93ad7692139d)<br>
* marketing funnel conversion rate as a whole <br>
   ![marketing funnel](https://github.com/user-attachments/assets/5f9b1139-e953-4ac7-8af0-f264d0ce85c1)<br>
   - insights: conversion rate from awareness to interest is relatively low as compared against the other two 

* awareness to interest conversion rate during different time slots of the day<br>
  - conditional formatting to highlight conversion rate that are above average
   ![a-i conversion](https://github.com/user-attachments/assets/dc74e9bc-6067-4ec5-ac83-07284817de77)<br>
  

* explored the possible reasons underlying the low conversion rate from awareness to like (item numbers of 'pageview' VS 'liked')
* Insights: only 66 items overlap between the two metrics, indicating the displayed merchandize may not be well received or aligned with user preference<br>
  ![pageview & like](https://github.com/user-attachments/assets/27f9a8e6-c1fc-4556-b8db-3a54de1149ce)<br>
  ![pageview & like](https://github.com/user-attachments/assets/8ad9e18e-bfb7-44cc-a743-21ec60235187)<br>

 
* purchase cohort customer analysis -- due to limited time record, this datasets may not be suited for cohort analysis<br>

* 'like'- "buy" behavior pattern of high-purchase customers VS low-purchase customers
* Insights: the two groups customers have similiar like- purchase conversion rate, but low purchase customer have significantly higher pageview and like behavior by average
  ![high & low purchase](https://github.com/user-attachments/assets/aa7300a8-8421-4a7b-9e09-43e9664672d6)<br>
  ![high & low purchase](https://github.com/user-attachments/assets/3786d85e-d3b0-4e33-8d20-6115cc231a66)<br>
  ![high & low purchase](https://github.com/user-attachments/assets/18a78b95-cafd-49b9-a994-024459ce6ec5)<br>
  
* conducted RFM analysis of customers (recency, frequency, monetary value) and visualization for continuous monitoring of customer composition
  ![RFM](https://github.com/user-attachments/assets/a1eb94e8-9765-484a-807d-370adef8cd12)<br>
  ![RFM](https://github.com/user-attachments/assets/dc39b6e1-d43d-4512-91b0-d1c6ce762be5)<br>
  ![RFM](https://github.com/user-attachments/assets/f5d56f25-ec01-4257-8dec-58f920ac6373)<br>
  ![RFM](https://github.com/user-attachments/assets/827be5cd-85a7-4297-8d41-8e2c817b74c8)<br>
