---
title: "Markdown"
output: github_document
---

```


Getting and Cleaning Data - Course Project
==========================================

#Project: Getting and Cleaning Data
#Author: Gabriel General
#Date: 10-11-2010

## Modifications

* Select, split, convert and calculate the mean and standard deviation for each variable.
* Do the same thing to Test and Training data.
* Create two Dataset with Subject, Activity, Description, Variable and measurement (Test and Training)
* Merge both dataset using UNION MySQL Sentence creating an unified dataset
* Useing descriptive activity names to name the activities in the data set
* Appropriately labeling the data set with descriptive variable names.
* Creating a second, independent tidy data set with the average of each variable for each activity and each subject.


# Descriptions

## Identififiers
The first two columns - Subject and Description oh Activity - are Identifiers.
* Subject: the ID of the Subject
* Activity: the Name of the Activity performed by the subject when measurements were taken

## Measurements
As mentioned above,the variables remaining are just the calculatd means from data got from Test ans Training files.

* meantBodyAccX
* meantBodyAccY
* meantBodyAccZ
* meantBodyGyroX
* meantBodyGyroY
* meantBodyGyroZ
* meanTotalBodyAccX
* meanTotalBodyAccY
* meanTotalBodyAccZ
