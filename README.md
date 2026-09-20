# Ecommerce-Customer-Churn-Analysis
Project Overview

This project analyzes customer churn in an e-commerce dataset using MySQL.

The analysis focuses on data cleaning, data transformation, customer churn analysis, purchasing behavior, payment preferences, customer complaints, and customer returns.

Tools Used
MySQL
MySQL Workbench
GitHub
Dataset

The dataset contains customer information related to:

Customer churn
Tenure
Preferred payment mode
Preferred order category
Satisfaction score
Customer complaints
Order count
Cashback amount
Warehouse-to-home distance
Data Cleaning

The following cleaning operations were performed:

Missing values were imputed using the mean for selected numerical columns.
Missing values were imputed using the mode for Tenure, CouponUsed, and OrderCount.
Outliers in WarehouseToHome greater than 100 were removed.
Inconsistent values were standardized.
Payment mode values were standardized.
Data Transformation

The following transformations were performed:

Renamed PreferedOrderCat to PreferredOrderCat.
Renamed HourSpendOnApp to HoursSpentOnApp.
Created ComplaintReceived.
Created ChurnStatus.
Removed the original Churn and Complain columns.
Data Analysis

The project answers questions related to:

Active and churned customers
Average tenure and cashback of churned customers
Complaint percentage among churned customers
City tier and preferred order categories
Payment preferences
Order amount increase
Device usage
Coupon usage
Satisfaction scores
Cashback by order category
Warehouse distance categories
Customer order behavior
Customer Returns

A customer_returns table was created and joined with the customer churn table to identify return records for customers who churned and complained.
