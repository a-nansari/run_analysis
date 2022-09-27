#Loading dplyr package

library(dplyr)

# Reading test data

TestSubject<-read.table(file.path("UCI HAR Dataset", "test", "subject_test.txt"))

TestValue<-read.table(file.path("UCI HAR Dataset", "test", "X_test.txt"))

TestActivity<-read.table(file.path("UCI HAR Dataset", "test", "y_test.txt"))

#Reading train data

TrainSubject<-read.table(file.path("UCI HAR Dataset", "train", "subject_train.txt"))

TrainValue<-read.table(file.path("UCI HAR Dataset", "train", "X_train.txt"))

TrainActivity<-read.table(file.path("UCI HAR Dataset", "train", "y_train.txt"))

# Merging test dataset

Test<-cbind(TestActivity, TestSubject, TestValue)

# Merging train dataset

Train<-cbind(TrainActivity, TrainSubject, TrainValue)

# Creating a key indicating the train and test datasets

Train$Group<-"train"

Test$Group<-"test"

# Merging datasets together

data<-rbind(Test, Train)

#Assigning the variables names

Features<-read.table(file.path("UCI HAR dataset", "features.txt"))

colnames(data)<-c("Activity", "Subjects", Features[,2] )

#extracting data containing mean and sD

mean<-grep("mean", colnames(data))

SD<-grep("std", colnames(data))

DataMeanSD<-data[,c(1,2,mean, SD, 564)]

#Naming activities

Activities<-read.table(file.path("UCI HAR dataset", "activity_labels.txt"))


DataMeanSD$Activity<-factor(DataMeanSD$Activity, levels=Activities[,1], labels =Activities[,2])

#Naming variables

colnames(DataMeanSD)<-gsub("std[\\(\\)-]", "Standard Deviation", colnames(DataMeanSD))
colnames(DataMeanSD)<-gsub("Standard Deviation)", "Standard Deviation", colnames(DataMeanSD))

colnames(DataMeanSD)<-gsub("mean[\\(\\)-]", "Mean", colnames(DataMeanSD))
colnames(DataMeanSD)<-gsub("Mean)", "Mean", colnames(DataMeanSD))

colnames(DataMeanSD)<-gsub("meanFreq[\\(\\)-]", "Mean Frequency", colnames(DataMeanSD))
colnames(DataMeanSD)<-gsub("Mean Frequency)", "Mean Frequency", colnames(DataMeanSD))

colnames(DataMeanSD)<-gsub("^t", "time ", colnames(DataMeanSD))

colnames(DataMeanSD)<-gsub("^f", "Frequency ", colnames(DataMeanSD))

colnames(DataMeanSD)<- gsub("Acc", " Accelerometer", colnames(DataMeanSD))

colnames(DataMeanSD)<- gsub("Gyro", " Gyroscope", colnames(DataMeanSD))

colnames(DataMeanSD)<- gsub("Jerk", " Jerk", colnames(DataMeanSD))

colnames(DataMeanSD)<- gsub("Mag", " Magnitude", colnames(DataMeanSD))

colnames(DataMeanSD)<-gsub("X$", "X Axis", colnames(DataMeanSD))
colnames(DataMeanSD)<-gsub("Y$", "Y Axis", colnames(DataMeanSD))
colnames(DataMeanSD)<-gsub("Z$", "Z Axis", colnames(DataMeanSD))

a<-colnames(DataMeanSD)
a[82]<-"Group"
colnames(DataMeanSD)<-a


###Calculating mean and sD

Mean<-DataMeanSD[,1:81]
Mean<-Mean %>% group_by(Activity, Subjects)
Means<-summarise_each(Mean, funs(mean))

### Creating files
write.table(Means, "Means.txt", row.names = FALSE)
write.table(DataMeanSD, "FinalData.csv")


