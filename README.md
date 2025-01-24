# E-Commerce Startup Customer Behavior Analysis

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

   ![marketing funnel](https://github.com/user-attachments/assets/5f9b1139-e953-4ac7-8af0-f264d0ce85c1)<br>

* awareness to interest conversion rate analysis<br>
  - conditional formatting to highlight conversion rate that are above average
   ![a-i conversion](https://github.com/user-attachments/assets/dc74e9bc-6067-4ec5-ac83-07284817de77)<br>

* identified the behavioral pattern during different time slots of the day 
* explored the possible reasons underlying the low conversion rate from awareness to like (item numbers of 'pageview' VS 'liked')
* purchase cohort customer analysis (cohort average active days, average re-purchase time)
* 'like' behavior pattern of high-purchase customers VS low-purchase customers
* conducted RFM analysis of customers (recency, frequency, monetary value) and visualization for continuous monitoring of customer composition
