# E-Commerce Customer Behavior Analysis

## Introduction 
The project utilized marketing funnel analysis techniques to analyze e-commerce retail customer behavior data. It aims to explore the conversion rate of each behavior step and uncover the intricacy behind it to provide insight for marketing strategy optimization. 

## Tools used 
MySQL & Excel


## Data Cleaning and Wrangling
* deleted duplicated records
* Unix timestamp conversion and extract date&hour 
* 4 behavior types (pageview, favorite, cart, buy) in one column organized into 3 types in the respective column: awareness(pageview), like(favourite&cart), purchase(buy) 

## EDA
* aggregated number of three types of behavior for calculation of conversion rate of each step
* identified the behavioral pattern during different time slots of the day 
* explored the possible reasons underlying the low conversion rate from awareness to like (item numbers of viewed VS liked)
* purchase cohort customer analysis (cohort average active days, average re-purchase time)
* 'like' behavior pattern of high-purchase customers VS low-purchase customers
* conducted RFM analysis of customers (recency, frequency, monetary value) and visualization for continuous monitoring of customer composition
