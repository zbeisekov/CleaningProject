library(data.table)
library(dplyr)

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

# Properly reading all the raw data
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

# Step 1: Merges the training and the test sets to create one data set.
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
merged <- cbind(subject, y, x)

# Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.
tidy_data <- merged %>% select(subject, code, contains("mean."), contains("std."))

# Step 3: Uses descriptive activity names to name the activities in the data set.
tidy_data$code <- activities$activity[tidy_data$code]

# Step 4: Appropriately labels the data set with descriptive variable names.
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

# Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
final <- tidy_data %>%
    group_by(subject, activity) %>%
    summarise_all(mean)
write.table(final, "Tidy.txt", row.name=FALSE)






