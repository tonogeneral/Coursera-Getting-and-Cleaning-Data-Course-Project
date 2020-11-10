#Project: Getting and Cleaning Data
#Author: Gabriel General
#Date: 10-11-2010



#1. Import the library that we are going to use

library(DBI)
library(RMySQL)
library(sqldf)
library(dplyr)
library(tidyr)
library(stringr)


#2. Detach the RMySQL package 

detach("package:RMySQL", unload=TRUE)




#3. Get Dataset from web

raiz <- "./"
DataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
DataFN <- "Dataset.zip"
DataFileName <- paste(raiz, "/", "Dataset.zip", sep = "")
dataDir <- "./HAR"


#4. If Directory doesn´t exist, create
if (!file.exists(raiz)) {
  dir.create(raiz)
  download.file(url = DataUrl, destfile = DataFileName)
}

#5. Unzip Datafile in Data Directory created

if (!file.exists(dataDir)) {
  dir.create(dataDir)
  unzip(zipfile = DataFileName, exdir = dataDir)
}






#6. Create DF with training values Y
training <- read.csv("./HAR/UCI HAR Dataset/train/y_train.txt", header = FALSE)
training <- tibble::rowid_to_column(training, "id")
names(training) <- c("id","activity")


#7. Create activity_Labels df and add a colomun with id and description of activity
activity_labels <- read.csv("./HAR/UCI HAR Dataset/activity_labels.txt", header = FALSE)
labels <- activity_labels %>%
  separate(V1, c("id", "desc"), " ")
labels$id <- as.integer(labels$id)

#8. Create a table with subject train
subject_train <- read.csv("./HAR/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_train <- tibble::rowid_to_column(subject_train, "id")
names(subject_train) <- c("id","subject")


#9. Create DF with training set values and labels
training_set <- read.csv("./HAR/UCI HAR Dataset/train/X_train.txt", header = FALSE)
etiquetas <- read.csv("./HAR/UCI HAR Dataset/train/y_train.txt", header = FALSE)


#10. Create a DF with data from training set and add columns and format mean data
dataset <- tibble::rowid_to_column(training_set, "id")
names(dataset) <- c("id","dataset")
dataset$mean_data <- rowMeans(read.table(text = dataset$dataset))
dataset$mean_data<-formatC(dataset$mean_data, format = "e", digits = 2)


#11. Get X training body accelaration signal. Calculate and format mean and standard deviation
tBodyAccX <- read.csv("./HAR/UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt", header = FALSE)
tBodyAccX  <- tibble::rowid_to_column(tBodyAccX, "id")
names(tBodyAccX) <- c("id","tBodyAccX")
tBodyAccX$meantBodyAccX <- rowMeans(read.table(text = tBodyAccX$tBodyAccX))
dat_tBodyAccX <- rowwise(read.table(text = tBodyAccX$tBodyAccX))
tBodyAccX$sdtBodyAccX<- apply(dat_tBodyAccX, 1, sd, na.rm = TRUE)
tBodyAccX$sdtBodyAccX<-formatC(tBodyAccX$sdtBodyAccX, format = "e", digits = 2)


#12. Get Y training body accelaration signal. Calculate and format mean and standard deviation
tBodyAccY <- read.csv("./HAR/UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt", header = FALSE)
tBodyAccY <- tibble::rowid_to_column(tBodyAccY, "id")
names(tBodyAccY) <- c("id","tBodyAccY")
tBodyAccY$meantBodyAccY <- rowMeans(read.table(text = tBodyAccY$tBodyAccY))
dat_tBodyAccY <- rowwise(read.table(text = tBodyAccY$tBodyAccY))
tBodyAccY$sdtBodyAccY<- apply(dat_tBodyAccY, 1, sd, na.rm = TRUE)
tBodyAccY$sdtBodyAccY<-formatC(tBodyAccY$sdtBodyAccY, format = "e", digits = 2)


#13. Get Z training body accelaration signal. Calculate and format mean and standard deviation
tBodyAccZ <- read.csv("./HAR/UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt", header = FALSE)
tBodyAccZ <- tibble::rowid_to_column(tBodyAccZ, "id")
names(tBodyAccZ) <- c("id","tBodyAccZ")
tBodyAccZ$meantBodyAccZ <- rowMeans(read.table(text = tBodyAccZ$tBodyAccZ))
dat_tBodyAccZ <- rowwise(read.table(text = tBodyAccZ$tBodyAccZ))
tBodyAccZ$sdtBodyAccZ<- apply(dat_tBodyAccZ, 1, sd, na.rm = TRUE)
tBodyAccZ$sdtBodyAccZ<-formatC(tBodyAccZ$sdtBodyAccZ, format = "e", digits = 2)


#14. Assign  df training from mysql queue joining tables by id

df <- sqldf("select training.id,training.activity,labels.desc,subject_train.subject,
            dataset.dataset,dataset.mean_data,
            tBodyAccX.tBodyAccX,tBodyAccX.meantBodyAccX,tBodyAccX.sdtBodyAccX,
            tBodyAccY.tBodyAccY,tBodyAccY.meantBodyAccY,tBodyAccY.sdtBodyAccY,
            tBodyAccZ.tBodyAccZ,tBodyAccZ.meantBodyAccZ,tBodyAccZ.sdtBodyAccZ
            from 
            training, labels, subject_train,
            dataset,
            tBodyAccX,tBodyAccY,tBodyAccZ 
            where 
            training.activity == labels.id and 
            training.id == subject_train.id and 
            training.id == dataset.id and
            training.id == tBodyAccX.id and 
            training.id == tBodyAccY.id and 
            training.id == tBodyAccZ.id")


#15. Get X angular velocity vector signal. Calculate and format mean and standard deviation

tBodyGyroX <- read.csv("./HAR/UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt", header = FALSE)
tBodyGyroX  <- tibble::rowid_to_column(tBodyGyroX, "id")
names(tBodyGyroX) <- c("id","tBodyGyroX")
tBodyGyroX$meantBodyGyroX <- rowMeans(read.table(text = tBodyGyroX$tBodyGyroX))
dat_tBodyGyroX <- rowwise(read.table(text = tBodyGyroX$tBodyGyroX))
tBodyGyroX$sdtBodyGyroX<- apply(dat_tBodyGyroX, 1, sd, na.rm = TRUE)
tBodyGyroX$sdtBodyGyroX<-formatC(tBodyGyroX$sdtBodyGyroX, format = "e", digits = 2)


#16. Get Y angular velocity vector signal. Calculate and format mean and standard deviation
tBodyGyroY <- read.csv("./HAR/UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt", header = FALSE)
tBodyGyroY <- tibble::rowid_to_column(tBodyGyroY, "id")
names(tBodyGyroY) <- c("id","tBodyGyroY")
tBodyGyroY$meantBodyGyroY <- rowMeans(read.table(text = tBodyGyroY$tBodyGyroY))
dat_tBodyGyroY <- rowwise(read.table(text = tBodyGyroY$tBodyGyroY))
tBodyGyroY$sdtBodyGyroY<- apply(dat_tBodyGyroY, 1, sd, na.rm = TRUE)
tBodyGyroY$sdtBodyGyroY<-formatC(tBodyGyroY$sdtBodyGyroY, format = "e", digits = 2)



#17. Get Z angular velocity vector signal. Calculate and format mean and standard deviation
tBodyGyroZ <- read.csv("./HAR/UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt", header = FALSE)
tBodyGyroZ <- tibble::rowid_to_column(tBodyGyroZ, "id")
names(tBodyGyroZ) <- c("id","tBodyGyroZ")
tBodyGyroZ$meantBodyGyroZ <- rowMeans(read.table(text = tBodyGyroZ$tBodyGyroZ))
dat_tBodyGyroZ <- rowwise(read.table(text = tBodyGyroZ$tBodyGyroZ))
tBodyGyroZ$sdtBodyGyroZ<- apply(dat_tBodyGyroZ, 1, sd, na.rm = TRUE)
tBodyGyroZ$sdtBodyGyroZ<-formatC(tBodyGyroZ$sdtBodyGyroZ, format = "e", digits = 2)


#18. Assign a df1 training from mysql queue joining tables by id

df1 <- sqldf("select df.id,df.activity,df.desc,df.subject,
             df.dataset,df.mean_data,
             df.tBodyAccX,df.meantBodyAccX,df.sdtBodyAccX,
             df.tBodyAccY,df.meantBodyAccY,df.sdtBodyAccY,
             df.tBodyAccZ,df.meantBodyAccZ,df.sdtBodyAccZ, 
             x.tBodyGyroX,x.meantBodyGyroX,x.sdtBodyGyroX,
             y.tBodyGyroY,y.meantBodyGyroY,y.sdtBodyGyroY,
             z.tBodyGyroZ,z.meantBodyGyroZ,z.sdtBodyGyroZ
             from df,tBodyGyroX x,tBodyGyroY y,tBodyGyroZ z 
             where 
             df.id == x.id and 
             df.id == y.id and 
             df.id == z.id ")





#19. Get X accelerator signal. Calculate and format mean and standard deviation

TotalBodyAccX <- read.csv("./HAR/UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt", header = FALSE)
TotalBodyAccX  <- tibble::rowid_to_column(TotalBodyAccX, "id")
names(TotalBodyAccX) <- c("id","TotalBodyAccX")
TotalBodyAccX$meanTotalBodyAccX <- rowMeans(read.table(text = TotalBodyAccX$TotalBodyAccX))
dat_TotalBodyAccX <- rowwise(read.table(text = TotalBodyAccX$TotalBodyAccX))
TotalBodyAccX$sdTotalBodyAccX<- apply(dat_TotalBodyAccX, 1, sd, na.rm = TRUE)
TotalBodyAccX$sdTotalBodyAccX<-formatC(TotalBodyAccX$sdTotalBodyAccX, format = "e", digits = 2)




#20. Get Y accelerator signal. Calculate and format mean and standard deviation
TotalBodyAccY <- read.csv("./HAR/UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt", header = FALSE)
TotalBodyAccY  <- tibble::rowid_to_column(TotalBodyAccY, "id")
names(TotalBodyAccY) <- c("id","TotalBodyAccY")
TotalBodyAccY$meanTotalBodyAccY <- rowMeans(read.table(text = TotalBodyAccY$TotalBodyAccY))
dat_TotalBodyAccY <- rowwise(read.table(text = TotalBodyAccY$TotalBodyAccY))
TotalBodyAccY$sdTotalBodyAccY<- apply(dat_TotalBodyAccY, 1, sd, na.rm = TRUE)
TotalBodyAccY$sdTotalBodyAccY<-formatC(TotalBodyAccY$sdTotalBodyAccY, format = "e", digits = 2)



#21. Get Z accelerator signal. Calculate and format mean and standard deviation
TotalBodyAccZ <- read.csv("./HAR/UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt", header = FALSE)
TotalBodyAccZ  <- tibble::rowid_to_column(TotalBodyAccZ, "id")
names(TotalBodyAccZ) <- c("id","TotalBodyAccZ")
TotalBodyAccZ$meanTotalBodyAccZ <- rowMeans(read.table(text = TotalBodyAccZ$TotalBodyAccZ))
dat_TotalBodyAccZ <- rowwise(read.table(text = TotalBodyAccZ$TotalBodyAccZ))
TotalBodyAccZ$sdTotalBodyAccZ<- apply(dat_TotalBodyAccZ, 1, sd, na.rm = TRUE)
TotalBodyAccZ$sdTotalBodyAccZ<-formatC(TotalBodyAccZ$sdTotalBodyAccZ, format = "e", digits = 2)


#22. Assign a df2 training from mysql queue joining tables by id

df2 <- sqldf("select df1.id,df1.activity,df1.desc,df1.subject,
             df1.dataset,df1.mean_data,
             df1.tBodyAccX,df1.meantBodyAccX,df1.sdtBodyAccX,
             df1.tBodyAccY,df1.meantBodyAccY,df1.sdtBodyAccY,
             df1.tBodyAccZ,df1.meantBodyAccZ,df1.sdtBodyAccZ, 
             df1.tBodyGyroX,df1.meantBodyGyroX,df1.sdtBodyGyroX,
             df1.tBodyGyroY,df1.meantBodyGyroY,df1.sdtBodyGyroY,
             df1.tBodyGyroZ,df1.meantBodyGyroZ,df1.sdtBodyGyroZ,
             x.TotalBodyAccX,x.meanTotalBodyAccX,x.sdTotalBodyAccX,
             y.TotalBodyAccY,y.meanTotalBodyAccY,y.sdTotalBodyAccY,
             z.TotalBodyAccZ,z.meanTotalBodyAccZ,z.sdTotalBodyAccZ
             from 
             df1,TotalBodyAccX x,TotalBodyAccY y,TotalBodyAccZ z 
             where 
             df1.id == x.id and 
             df1.id == y.id and 
             df1.id == z.id ")


#############################################################################
#TEST DATASET
############################################################################



#23. Create DF with training values Y
training <- read.csv("./HAR/UCI HAR Dataset/test/y_test.txt", header = FALSE)
training <- tibble::rowid_to_column(training, "id")
names(training) <- c("id","activity")



#24. Create activity_Labels and add a colomun with id and description of activity
activity_labels <- read.csv("./HAR/UCI HAR Dataset/activity_labels.txt", header = FALSE)
labels <- activity_labels %>%
  separate(V1, c("id", "desc"), " ")
labels$id <- as.integer(labels$id)



#25. Create a table with subject train
subject_train <- read.csv("./HAR/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
subject_train <- tibble::rowid_to_column(subject_train, "id")
names(subject_train) <- c("id","subject")


#26. Create DF with training set values and labels
training_set <- read.csv("./HAR/UCI HAR Dataset/test/X_test.txt", header = FALSE)
etiquetas <- read.csv("./HAR/UCI HAR Dataset/test/y_test.txt", header = FALSE)


#27. Create a DF with data from training set and add columns and format mean data
dataset <- tibble::rowid_to_column(training_set, "id")
names(dataset) <- c("id","dataset")
dataset$mean_data <- rowMeans(read.table(text = dataset$dataset))
dataset$mean_data<-formatC(dataset$mean_data, format = "e", digits = 2)


#28. Get X training body accelaration signal. Calculate and format mean and standard deviation
tBodyAccX <- read.csv("./HAR/UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt", header = FALSE)
tBodyAccX  <- tibble::rowid_to_column(tBodyAccX, "id")
names(tBodyAccX) <- c("id","tBodyAccX")
tBodyAccX$meantBodyAccX <- rowMeans(read.table(text = tBodyAccX$tBodyAccX))
dat_tBodyAccX <- rowwise(read.table(text = tBodyAccX$tBodyAccX))
tBodyAccX$sdtBodyAccX<- apply(dat_tBodyAccX, 1, sd, na.rm = TRUE)
tBodyAccX$sdtBodyAccX<-formatC(tBodyAccX$sdtBodyAccX, format = "e", digits = 2)


#29. Get Y training body accelaration signal. Calculate and format mean and standard deviation
tBodyAccY <- read.csv("./HAR/UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt", header = FALSE)
tBodyAccY <- tibble::rowid_to_column(tBodyAccY, "id")
names(tBodyAccY) <- c("id","tBodyAccY")
tBodyAccY$meantBodyAccY <- rowMeans(read.table(text = tBodyAccY$tBodyAccY))
dat_tBodyAccY <- rowwise(read.table(text = tBodyAccY$tBodyAccY))
tBodyAccY$sdtBodyAccY<- apply(dat_tBodyAccY, 1, sd, na.rm = TRUE)
tBodyAccY$sdtBodyAccY<-formatC(tBodyAccY$sdtBodyAccY, format = "e", digits = 2)



#30. Get Z training body accelaration signal. Calculate and format mean and standard deviation
tBodyAccZ <- read.csv("./HAR/UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt", header = FALSE)
tBodyAccZ <- tibble::rowid_to_column(tBodyAccZ, "id")
names(tBodyAccZ) <- c("id","tBodyAccZ")
tBodyAccZ$meantBodyAccZ <- rowMeans(read.table(text = tBodyAccZ$tBodyAccZ))
dat_tBodyAccZ <- rowwise(read.table(text = tBodyAccZ$tBodyAccZ))
tBodyAccZ$sdtBodyAccZ<- apply(dat_tBodyAccZ, 1, sd, na.rm = TRUE)
tBodyAccZ$sdtBodyAccZ<-formatC(tBodyAccZ$sdtBodyAccZ, format = "e", digits = 2)


#31. Assign test training from mysql queue joining tables by id

test <- sqldf("select training.id,training.activity,labels.desc,subject_train.subject,
            dataset.dataset,dataset.mean_data,
            tBodyAccX.tBodyAccX,tBodyAccX.meantBodyAccX,tBodyAccX.sdtBodyAccX,
            tBodyAccY.tBodyAccY,tBodyAccY.meantBodyAccY,tBodyAccY.sdtBodyAccY,
            tBodyAccZ.tBodyAccZ,tBodyAccZ.meantBodyAccZ,tBodyAccZ.sdtBodyAccZ
            from 
            training, labels, subject_train,
            dataset,
            tBodyAccX,tBodyAccY,tBodyAccZ 
            where 
            training.activity == labels.id and
            training.id == dataset.id and
            training.id == subject_train.id and 
            training.id == tBodyAccX.id and 
            training.id == tBodyAccY.id and 
            training.id == tBodyAccZ.id")


#32. Get X angular velocity vector signal. Calculate and format mean and standard deviation
tBodyGyroX <- read.csv("./HAR/UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt", header = FALSE)
tBodyGyroX  <- tibble::rowid_to_column(tBodyGyroX, "id")
names(tBodyGyroX) <- c("id","tBodyGyroX")
tBodyGyroX$meantBodyGyroX <- rowMeans(read.table(text = tBodyGyroX$tBodyGyroX))
dat_tBodyGyroX <- rowwise(read.table(text = tBodyGyroX$tBodyGyroX))
tBodyGyroX$sdtBodyGyroX<- apply(dat_tBodyGyroX, 1, sd, na.rm = TRUE)
tBodyGyroX$sdtBodyGyroX<-formatC(tBodyGyroX$sdtBodyGyroX, format = "e", digits = 2)


#33. Get Y angular velocity vector signal. Calculate and format mean and standard deviation
tBodyGyroY <- read.csv("./HAR/UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt", header = FALSE)
tBodyGyroY <- tibble::rowid_to_column(tBodyGyroY, "id")
names(tBodyGyroY) <- c("id","tBodyGyroY")
tBodyGyroY$meantBodyGyroY <- rowMeans(read.table(text = tBodyGyroY$tBodyGyroY))
dat_tBodyGyroY <- rowwise(read.table(text = tBodyGyroY$tBodyGyroY))
tBodyGyroY$sdtBodyGyroY<- apply(dat_tBodyGyroY, 1, sd, na.rm = TRUE)
tBodyGyroY$sdtBodyGyroY<-formatC(tBodyGyroY$sdtBodyGyroY, format = "e", digits = 2)



#34. Get Z angular velocity vector signal. Calculate and format mean and standard deviation
tBodyGyroZ <- read.csv("./HAR/UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt", header = FALSE)
tBodyGyroZ <- tibble::rowid_to_column(tBodyGyroZ, "id")
names(tBodyGyroZ) <- c("id","tBodyGyroZ")
tBodyGyroZ$meantBodyGyroZ <- rowMeans(read.table(text = tBodyGyroZ$tBodyGyroZ))
dat_tBodyGyroZ <- rowwise(read.table(text = tBodyGyroZ$tBodyGyroZ))
tBodyGyroZ$sdtBodyGyroZ<- apply(dat_tBodyGyroZ, 1, sd, na.rm = TRUE)
tBodyGyroZ$sdtBodyGyroZ<-formatC(tBodyGyroZ$sdtBodyGyroZ, format = "e", digits = 2)


#35. Assign test training from mysql queue joining tables by id
test1 <- sqldf("select t.id,t.activity,t.desc,t.subject,
             t.dataset,t.mean_data,
             t.tBodyAccX,t.meantBodyAccX,t.sdtBodyAccX,
             t.tBodyAccY,t.meantBodyAccY,t.sdtBodyAccY,
             t.tBodyAccZ,t.meantBodyAccZ,t.sdtBodyAccZ, 
             x.tBodyGyroX,x.meantBodyGyroX,x.sdtBodyGyroX,
             y.tBodyGyroY,y.meantBodyGyroY,y.sdtBodyGyroY,
             z.tBodyGyroZ,z.meantBodyGyroZ,z.sdtBodyGyroZ
             from test t,tBodyGyroX x,tBodyGyroY y,tBodyGyroZ z 
             where 
             t.id == x.id and 
             t.id == y.id and 
             t.id == z.id ")


#36. Get X accelerator signal. Calculate and format mean and standard deviation
TotalBodyAccX <- read.csv("./HAR/UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt", header = FALSE)
TotalBodyAccX  <- tibble::rowid_to_column(TotalBodyAccX, "id")
names(TotalBodyAccX) <- c("id","TotalBodyAccX")
TotalBodyAccX$meanTotalBodyAccX <- rowMeans(read.table(text = TotalBodyAccX$TotalBodyAccX))
dat_TotalBodyAccX <- rowwise(read.table(text = TotalBodyAccX$TotalBodyAccX))
TotalBodyAccX$sdTotalBodyAccX<- apply(dat_TotalBodyAccX, 1, sd, na.rm = TRUE)
TotalBodyAccX$sdTotalBodyAccX<-formatC(TotalBodyAccX$sdTotalBodyAccX, format = "e", digits = 2)


#37. Get Y accelerator signal. Calculate and format mean and standard deviation
TotalBodyAccY <- read.csv("./HAR/UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt", header = FALSE)
TotalBodyAccY  <- tibble::rowid_to_column(TotalBodyAccY, "id")
names(TotalBodyAccY) <- c("id","TotalBodyAccY")
TotalBodyAccY$meanTotalBodyAccY <- rowMeans(read.table(text = TotalBodyAccY$TotalBodyAccY))
dat_TotalBodyAccY <- rowwise(read.table(text = TotalBodyAccY$TotalBodyAccY))
TotalBodyAccY$sdTotalBodyAccY<- apply(dat_TotalBodyAccY, 1, sd, na.rm = TRUE)
TotalBodyAccY$sdTotalBodyAccY<-formatC(TotalBodyAccY$sdTotalBodyAccY, format = "e", digits = 2)


#38. Get Z accelerator signal. Calculate and format mean and standard deviation
TotalBodyAccZ <- read.csv("./HAR/UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt", header = FALSE)
TotalBodyAccZ  <- tibble::rowid_to_column(TotalBodyAccZ, "id")
names(TotalBodyAccZ) <- c("id","TotalBodyAccZ")
TotalBodyAccZ$meanTotalBodyAccZ <- rowMeans(read.table(text = TotalBodyAccZ$TotalBodyAccZ))
dat_TotalBodyAccZ <- rowwise(read.table(text = TotalBodyAccZ$TotalBodyAccZ))
TotalBodyAccZ$sdTotalBodyAccZ<- apply(dat_TotalBodyAccZ, 1, sd, na.rm = TRUE)
TotalBodyAccZ$sdTotalBodyAccZ<-formatC(TotalBodyAccZ$sdTotalBodyAccZ, format = "e", digits = 2)


#39. Assign test2 training from mysql queue joining tables by id
test2 <- sqldf("select t1.id,t1.activity,t1.desc,t1.subject,
             t1.dataset,t1.mean_data,
             t1.tBodyAccX,t1.meantBodyAccX,t1.sdtBodyAccX,
             t1.tBodyAccY,t1.meantBodyAccY,t1.sdtBodyAccY,
             t1.tBodyAccZ,t1.meantBodyAccZ,t1.sdtBodyAccZ, 
             t1.tBodyGyroX,t1.meantBodyGyroX,t1.sdtBodyGyroX,
             t1.tBodyGyroY,t1.meantBodyGyroY,t1.sdtBodyGyroY,
             t1.tBodyGyroZ,t1.meantBodyGyroZ,t1.sdtBodyGyroZ,
             x.TotalBodyAccX,x.meanTotalBodyAccX,x.sdTotalBodyAccX,
             y.TotalBodyAccY,y.meanTotalBodyAccY,y.sdTotalBodyAccY,
             z.TotalBodyAccZ,z.meanTotalBodyAccZ,z.sdTotalBodyAccZ
             from 
             test1 t1,TotalBodyAccX x,TotalBodyAccY y,TotalBodyAccZ z 
             where 
             t1.id == x.id and 
             t1.id == y.id and 
             t1.id == z.id ")



#40 Merge both dataframes by a mysql UNION sentence
total <- sqldf("select * from df2 union select * from test2")

names(total)
# 
# [1] "id"                "activity"          "desc"              "subject"           "dataset"          
# [6] "mean_data"         "tBodyAccX"         "meantBodyAccX"     "sdtBodyAccX"       "tBodyAccY"        
# [11] "meantBodyAccY"     "sdtBodyAccY"       "tBodyAccZ"         "meantBodyAccZ"     "sdtBodyAccZ"      
# [16] "tBodyGyroX"        "meantBodyGyroX"    "sdtBodyGyroX"      "tBodyGyroY"        "meantBodyGyroY"   
# [21] "sdtBodyGyroY"      "tBodyGyroZ"        "meantBodyGyroZ"    "sdtBodyGyroZ"      "TotalBodyAccX"    
# [26] "meanTotalBodyAccX" "sdTotalBodyAccX"   "TotalBodyAccY"     "meanTotalBodyAccY" "sdTotalBodyAccY"  
# [31] "TotalBodyAccZ"     "meanTotalBodyAccZ" "sdTotalBodyAccZ


#41. Create a txt file named tidyData1
write.table(total,file = "./HAR/UCI HAR Dataset/tidyData1.txt",row.names = FALSE)



#42. Get de mean data for each variable group by subject and activity
promedio <- sqldf("select subject,desc, mean_data,
            meantBodyAccX,meantBodyAccY,meantBodyAccZ,
            meantBodyGyroX,meantBodyGyroY,meantBodyGyroZ,
            meanTotalBodyAccX,meanTotalBodyAccY,meanTotalBodyAccZ
            from total
            group by subject, desc")

#Deleting Big files

unlink("./HAR",recursive = TRUE, force = FALSE, expand = TRUE)
unlink("./Dataset.zip")



#43. Create a txt file named tidyData2 with average results
write.table(promedio,file = "./tidyData2.txt",row.names = FALSE)

#44. Clean Global enviroment data
# rm(list= c("activity_labels","training","training_set","dat_tBodyAccX","dat_tBodyAccY","dat_tBodyAccZ","dat_tBodyGyroX",
#            "dat_tBodyGyroY","dat_tBodyGyroZ","dat_TotalBodyAccX","dat_TotalBodyAccY","dat_TotalBodyAccZ",
#            "dataset","df","df1","df2","etiquetas","labels","promedio","subject_train",
#            "tBodyAccX","tBodyAccY","tBodyAccZ","tBodyGyroX","tBodyGyroY","tBodyGyroZ",
#            "test","test1","test2","TotalBodyAccX","TotalBodyAccY","TotalBodyAccZ"))


