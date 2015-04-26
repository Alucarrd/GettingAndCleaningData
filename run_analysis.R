
# Set the correct working directory
#setwd("./DataScience/GettingAndCleaningData/CourseProject")

# Loading library
library(dplyr)


# Reading all the data files into varialbes
yTest <- read.table("./Data/UCI HAR Dataset/test/y_test.txt")
xTest <- read.table("./Data/UCI HAR Dataset/test/X_test.txt")
subjectTest <- read.table("./Data/UCI HAR Dataset/test/subject_test.txt")

yTrain <- read.table("./Data/UCI HAR Dataset/train/y_train.txt")
xTrain <- read.table("./Data/UCI HAR Dataset/train/X_train.txt")
subjectTrain <- read.table("./Data/UCI HAR Dataset/train/subject_train.txt")

ActivityLabel <- read.table("./Data/UCI HAR Dataset/activity_labels.txt")
Features <- read.table("./Data/UCI HAR Dataset/features.txt")

# Give columns to have more meaningful names
yTest <- dplyr::rename(yTest, ActivityId = V1)
yTrain <- dplyr::rename(yTrain, ActivityId = V1)
subjectTest <- dplyr::rename(subjectTest, SubjectId =V1)
subjectTrain <- dplyr::rename(subjectTrain, SubjectId =V1)
ActivityLabel <- dplyr::rename(ActivityLabel, ActivityId=V1, ActivityName=V2)
Features <- dplyr::rename(Features, FeatureId =V1, FeatureName = V2)


# Clean up the feature names a bit by replacing dash and comma to period mark and remove single quotations
Features$FeatureName <- gsub("-", ".", Features$FeatureName)
Features$FeatureName <- gsub(" ", "", Features$FeatureName)
Features$FeatureName <- gsub(",", ".", Features$FeatureName)
#Features$FeatureName <- gsub("\\()", ".", Features$FeatureName)
Features$FeatureName <- gsub("\\(", "", Features$FeatureName)
Features$FeatureName <- gsub("\\)", "", Features$FeatureName)
# Finally, convert the feature names to lower case
Features$FeatureName <- tolower(Features$FeatureName)

# Merge activity list with activity names
yTestNew = merge(yTest, ActivityLabel, by.x="ActivityId", by.y="ActivityId", all="TRUE")
yTrainNew = merge(yTrain, ActivityLabel, by.x="ActivityId", by.y="ActivityId", all="TRUE")

# Apply the updated feature names as the column names in the measurement file
colnames(xTest) <- Features[, 2]
colnames(xTrain) <- Features[, 2]

# Add static column TestType to Activity list.  That way, upon merge, TestType will show up at the front columns.
yTestNew$TestType="Test"
yTrainNew$TestType="Train"

# Merging data vertically
TestDataSet <- cbind(subjectTest, yTestNew)
TestDataSet <- cbind(TestDataSet, xTest)

TrainDataSet <- cbind(subjectTrain, yTrainNew)
TrainDataSet <- cbind(TrainDataSet, xTrain)

# Merging Testing and Training data set horizontally
MasterDataSet <- rbind(TestDataSet, TrainDataSet)

# Extract mean/std columns to a variable as Step2 requested but als
GrepPattern <-"mean|std"
MasterColNames <- names(MasterDataSet)
MasterColIndex <- grep(GrepPattern,MasterColNames )
MeanAndStdOutput <- cbind(MasterDataSet[, c(1,2)], MasterDataSet[,MasterColIndex])

# Time to take mean and group by SubjectId and ActivityId
TidyDataSet <- aggregate(MeanAndStdOutput[, c(3:ncol(MeanAndStdOutput))], list(MeanAndStdOutput$SubjectId, MeanAndStdOutput$ActivityId), mean)

# Rename the SubjectId and ActivityId back
TidyDataSet <- dplyr::rename(TidyDataSet, SubjectId=Group.1)
TidyDataSet <- dplyr::rename(TidyDataSet, ActivityId=Group.2)


# Output to file
write.table(file = "activitydata.txt", x = TidyDataSet, row.names = FALSE)

