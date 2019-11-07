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