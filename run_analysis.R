# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#load libraries
library(dplyr)

# Merges the training and the test sets to create one data set.
#Get all trainingdata and combine
X_train       <-read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
Y_train       <-  read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
subject_train <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)
train         <- do.call("cbind", list(X_train, Y_train, subject_train))
#Get all testingdata and combine
X_test        <-read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
Y_test        <-  read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
subject_test  <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)
test          <- do.call("cbind", list(X_train, Y_train, subject_train))
#MCombine the total train and test set in 1 dataframe
df <- rbind(train,test)

#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Get feature data 
features      <- read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
features$V2   <- tolower(features$V2)
mean_std_cols <- grep('mean|std', features$V2)

#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
df_select        <- df[, c(mean_std_cols, 562,563)]
names(df_select) <- tolower(c(features$V2[mean_std_cols], 'activity', 'subject'))
#get activity data
act <- read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

df_labelled <- merge(df_select, act, by.x = 'activity',by.y= 'V1')
df_labelled <- df_labelled[-1]

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
df_tidy   <- aggregate(df_labelled, by=list(subject=df_labelled$subject, activity = df_labelled$V2), mean)
write.table(df_tidy, "df_tidy.txt", sep="\t", row.names=FALSE)


