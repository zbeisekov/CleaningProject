# Peer-graded Assignment: Getting and Cleaning Data Course Project

## Instructions
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.
### Review criteria
1. The submitted data set is tidy.
2. The Github repo contains the required scripts.
3. GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other
4. relevant information.
5. The README that explains the analysis files is clear and understandable.
6. The work submitted for this project is the work of the student who submitted it.

### Getting and Cleaning Data Course Project
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Repository
1. [run_analysis.R](run_analysis.R) : R script to download and tidy the raw data set.
2. [tidy.csv](tidy.csv) : the tidy data set created by run_analysis.R
3. [CodeBook.md](CodeBook.md) : the code book describing variables in Tidy.txt
4. [README.md](README.md) : the summary of the solution

## Solution
### Prepare the environment
Ensure that we have all the required libraries set.
```
library(data.table)
library(dplyr)
```
Download the raw data set and read it.
```
fileName <- "Coursera_DS3_Final.zip"

# Checking if archieve already exists.
fileName <- "Coursera_DS3_Final.zip"

# Download only if needed
if (!file.exists(fileName)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    if (download.file(fileURL, fileName, method="curl") != 0) {
        stop("Cannot download file: ", fileName)
    }
}  

# Unzip only if needed
if (!file.exists("UCI HAR Dataset")) { 
    unzip(fileName) 
}
```
At this point you should have the raw data set downloaded to your working directory. It is safe to rerun the script, because no unnecessary operations will happen.

### Reading raw data
Reading features and activities, so we can use them as column names in the future.
```
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
```
Reading test data.
```
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
```
Reading train data.
```
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
```
### Tidying data
Step 1: Merges the training and the test sets to create one data set.
```
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
merged <- cbind(subject, Y, X)
```

Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.
```
tidy_data <- merged %>% select(subject, code, contains("mean."), contains("std."))
```

Step 3: Uses descriptive activity names to name the activities in the data set.
```
tidy_data$code <- activities$activity[tidy_data$code]
```

Step 4: Appropriately labels the data set with descriptive variable names.
```
tidy_data <- rename(tidy_data, activity = code)
names(tidy_data)<-gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data)<-gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data)<-gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data)<-gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data)<-gsub("^t", "Time", names(tidy_data))
names(tidy_data)<-gsub("^f", "Frequency", names(tidy_data))
names(tidy_data)<-gsub("tBody", "TimeBody", names(tidy_data))
names(tidy_data)<-gsub("\\.mean\\.+", "Mean", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("\\.std\\.+", "STD", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("angle", "Angle", names(tidy_data))
names(tidy_data)<-gsub("gravity", "Gravity", names(tidy_data))
names(tidy_data)<-gsub("\\.+", "", names(tidy_data))
```

Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
```
final <- tidy_data %>%
    group_by(subject, activity) %>%
    summarise_all(mean)
write.table(final, "Tidy.txt", row.name=FALSE)
```
