# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# 1. Merges the training and the test sets to create one data set.
activityDB <- cbind(read.table("./UCI HAR Dataset/test/X_test.txt"), read.table("./UCI HAR Dataset/test/subject_test.txt"))
activityDB <- rbind(activityDB, cbind(read.table("./UCI HAR Dataset/train/X_train.txt"), read.table("./UCI HAR Dataset/train/subject_train.txt")))

# Now we have a dataframe
#str(activityDB)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# The columns containing requested data: 1, 2, 3, 4, 5, 6, 41, 42, 43, 44, 45, 46, 81, 82, 83, 84, 85, 86, 121, 122, 123, 124, 125, 126, 161, 162, 163, 164, 165, 166
# Note that only column on the time domain are extracted
s <- ncol(activityDB)
filteredDB <- activityDB[,c(1:6,41:46,81:86,121:126,161:166,s)]
str(filteredDB)

# 3. Uses descriptive activity names to name the activities in the data set
# The classes can be found in Y_...txt, the activity names can be found in 

# Load activity names
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Load classes
activityClasses <- read.table("./UCI HAR Dataset/test/y_test.txt")
activityClasses <- rbind(activityClasses, read.table("./UCI HAR Dataset/train/y_train.txt"))

# Loop over all the class vector, creating a new vector with activity names
activityList <- character()

for (a in activityClasses$V1) {
  activity <- as.character(activityLabels$V2[a])
  activityList <- c(activityList, activity)
}

# append this column to the dataframe
filteredDB <- cbind(filteredDB, activityList)
#str(filteredDB)

# 4. Appropriately labels the data set with descriptive variable names. 
# Taking the variable names from the features.txt file
# The columns containing requested data: 1, 2, 3, 4, 5, 6, 41, 42, 43, 44, 45, 46, 81, 82, 83, 84, 85, 86, 121, 122, 123, 124, 125, 126, 161, 162, 163, 164, 165, 166
colnames(filteredDB) <- c("tBodyAcc-mean()-X",
                          "tBodyAcc-mean()-Y",
                          "tBodyAcc-mean()-Z",
                          "tBodyAcc-std()-X",
                          "tBodyAcc-std()-Y",
                          "tBodyAcc-std()-Z",
                          "tGravityAcc-mean()-X",
                          "tGravityAcc-mean()-Y",
                          "tGravityAcc-mean()-Z",
                          "tGravityAcc-std()-X",
                          "tGravityAcc-std()-Y",
                          "tGravityAcc-std()-Z",
                          "tBodyAccJerk-mean()-X",
                          "tBodyAccJerk-mean()-Y",
                          "tBodyAccJerk-mean()-Z",
                          "tBodyAccJerk-std()-X",
                          "tBodyAccJerk-std()-Y",
                          "tBodyAccJerk-std()-Z",
                          "tBodyGyro-mean()-X",
                          "tBodyGyro-mean()-Y",
                          "tBodyGyro-mean()-Z",
                          "tBodyGyro-std()-X",
                          "tBodyGyro-std()-Y",
                          "tBodyGyro-std()-Z",
                          "tBodyGyroJerk-mean()-X",
                          "tBodyGyroJerk-mean()-Y",
                          "tBodyGyroJerk-mean()-Z",
                          "tBodyGyroJerk-std()-X",
                          "tBodyGyroJerk-std()-Y",
                          "tBodyGyroJerk-std()-Z",
                          "Subject",
                          "Activity")

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# Group by Subject and Activity and summarise mean the columns
library(dplyr)
filteredDB_grouped <- group_by(filteredDB, Subject, Activity)
tidyDB <- filteredDB_grouped %>% summarise_each(funs(mean))

# Write the final result to a file
write.table(tidyDB, "tidyDB.txt", row.names=FALSE)