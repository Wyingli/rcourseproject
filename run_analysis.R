library(dplyr)
download.file(Url,destfile = "C:/Users/li/Documents/dt.zip")
unzip("dt.zip")
setwd("C:/Users/li/Documents/UCI HAR Dataset")
subject_train <- read.table("./train/subject_train.txt", header = FALSE)
subject_test<-read.table("./test/subject_test.txt", header = FALSE)
ActivityTest <- read.table("./test/y_test.txt", header = FALSE)
ActivityTrain <- read.table("./train/y_train.txt", header = FALSE)
FeaturesTest <- read.table("./test/X_test.txt", header = FALSE)
FeaturesTrain <- read.table("./train/X_train.txt", header = FALSE)
ActivityLabels <- read.table("./activity_labels.txt", header = FALSE)
FeaturesNames <- read.table("./features.txt", header = FALSE)
#Merge
FeaturesData <- rbind(FeaturesTest, FeaturesTrain)
SubjectData <- rbind(SubjectTest, SubjectTrain)
ActivityData <- rbind(ActivityTest, ActivityTrain)
#Renaming colums in ActivityData & ActivityLabels dataframes
names(ActivityData) <- "ActivityN"
names(ActivityLabels) <- c("ActivityN", "Activity")
Activity <- left_join(ActivityData, ActivityLabels, "ActivityN")[, 2]
#Rename SubjectData columns
names(SubjectData) <- "Subject"
#Rename FeaturesData columns using columns from FeaturesNames
names(FeaturesData) <- FeaturesNames$V2
#Create one large Dataset with only these variables: SubjectData,  Activity,  FeaturesData
DataSet <- cbind(SubjectData, Activity)
DataSet <- cbind(DataSet, FeaturesData)
#Rename the columns of the large dataset using more descriptive activity names
names(DataSet)<-gsub("^t", "time", names(DataSet))
names(DataSet)<-gsub("^f", "frequency", names(DataSet))
names(DataSet)<-gsub("Acc", "Accelerometer", names(DataSet))
names(DataSet)<-gsub("Gyro", "Gyroscope", names(DataSet))
names(DataSet)<-gsub("Mag", "Magnitude", names(DataSet))
names(DataSet)<-gsub("BodyBody", "Body", names(DataSet))
#Creating a tidy dataset
tidydata<-aggregate(.~Subject + Activity, DataSet, mean)
tidydata<-tidydata[order(tidydata$Subject,tidydata$Activity),]
write.table(tidydata,file="tidydata.txt",row.name=FALSE)