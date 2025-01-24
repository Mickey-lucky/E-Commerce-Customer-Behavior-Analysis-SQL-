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
   ![delete duplicates](https://github.com/user-attachments/assets/9af07a2f-123e-4f7b-b571-c1c2c2a28943)
  
* Unix timestamp conversion and extract date&hour 
* 4 behavior types (pageview, favorite, cart, buy) in one column organized into 3 types in the respective column: awareness(pageview), like(favourite&cart), purchase(buy) 

## EDA
* aggregated number of three types of behavior for calculation of conversion rate of each step
* identified the behavioral pattern during different time slots of the day 
* explored the possible reasons underlying the low conversion rate from awareness to like (item numbers of 'pageview' VS 'liked')
* purchase cohort customer analysis (cohort average active days, average re-purchase time)
* 'like' behavior pattern of high-purchase customers VS low-purchase customers
* conducted RFM analysis of customers (recency, frequency, monetary value) and visualization for continuous monitoring of customer composition
