Getting and Cleaning Data - Course Project
==========================================

* This is my course project for Getting Data Cleaning Course.
* Contains the runAnalysis.R Script, that do the following


1. Download the zip file from the web and if it does not already exist, create in the working directory.
2. Get the labels and subject for every file. 
3. Read, Get and transform the data from train and test folders calculating the mean and standard deviation for each variable.
4. Create dataframes with results for Test ans Train datasets using sqldf queues merging  the dataframes created by UNION sentence.
4. Extract data by selected columns(from step 3), and merge x, y(activity) group by subject and activity.
5. Generate 'tidydataset2.txt' file that consists of the average (mean) of each variable for each subject and each activity.
