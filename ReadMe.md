##Course:Getting & Cleaning Data
##Course Id:getdata-013

##Course Project Background:
This project is to demonstrate the ability to collect, work with, and clean a data set.  In this project, we are given with data collected by accelerometers from the Samsung Galaxy S smartphone through companies such as FitBit, Nike, and Jawbone Up.  In this project we will need to create an R scrit called run_analysis.R that does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##File Descriptions:
1. run_analysis.R - main R script that contains the logic to process and output the result to a flat file.
2. activitydata.txt - tidy data output file from step5.
3. CodeBook.md - data dictionary file for activitydata.txt.
4. ReadMe.md - description file for the project.
5. data folder - folder contains downloaded data file set for the project.

##Logic workflow of the project:
1. load the necessary libary.
2. read in data files and store the result into variables. 
3. Provide meaningful names for the columns on variables that contains the read-in files.
4. Clean up the non-alphanumerical (except period mark) for all measurement names as well as converting them to lower case.
5. Merge the measurement data with activity names for both test set and training set.
6. Add a new static column called Test and Train for both set of data.
7. Merge subject Id data, measurement data, and the data for activity used for each measurement on both Test and Train set of data vertically.
8. Merge Test set and Train set data horozontally into MasterDataSet.
9. Subsetting the MasterDataSet by pulling out any measurement that contains either "mean" or "std" as well as the SubjectId and ActivityId columns into a variable called MeanAndStdOutput.
10. Call aggregate function and group by SubjectId and ActivityId to build the wide body tidy data set (called TidyDataSet).
11. Rename the SubjectId and ActivityId columns back after the aggregate call.
12. Finally, called write.table to output the result into a flat file named "activitydata.txt"
