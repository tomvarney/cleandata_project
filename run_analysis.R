
#setwd("~/R/rdata/UCI HAR Dataset")

#get the X data Training and Test

#ASSUMES that the files are in the working directory, but...
#not sure if training and test files will be directly in working directory, or unzipped into folders
# so try each one to see which ....
if (file.exists("X_train.txt"))
{
  X_train <- read.table("X_train.txt", quote="\"")
} else
{
  X_train <- read.table("train/X_train.txt", quote="\"")
}

if (file.exists("X_test.txt"))
{
  X_test <- read.table("X_test.txt", quote="\"")
} else
{
  X_test <- read.table("test/X_test.txt", quote="\"")
}


#get the labels Training and Test
if (file.exists("y_train.txt"))
{
  y_train <- read.table("y_train.txt", quote="\"")
} else
{
  y_train <- read.table("train/y_train.txt", quote="\"")
}

if (file.exists("y_test.txt"))
{
  y_test <- read.table("y_test.txt", quote="\"")
} else
{
  y_test <- read.table("test/y_test.txt", quote="\"")
}


#get the subjects Training and Test
if (file.exists("subject_train.txt"))
{
  subject_train <- read.table("subject_train.txt", quote="\"")
} else
{
  subject_train <- read.table("train/subject_train.txt", quote="\"")
}

if (file.exists("subject_test.txt"))
{
  subject_test <- read.table("subject_test.txt", quote="\"")
} else
{
  subject_test <- read.table("test/subject_test.txt", quote="\"")
}


#combine the training and test sets for each of X, y, subjects
X_train <- rbind(X_train, X_test)
y_train <- rbind(y_train, y_test)
subject_train <- rbind(subject_train, subject_test)
#######

#get the feature labels
features <- read.table("~/R/rdata/UCI HAR Dataset/features.txt", quote="\"")

#find only the columns that end in "mean()" or "std()"  
#(I decided to exclude the ones that were not direct means of the measurement -- like "...meanFreq")
featuresToKeep <- grep("(mean\\()|(std\\()", features$V2)
features <- features[featuresToKeep,][2]
features <- as.character(features$V2)

#clean up the variable names to remove the parens and replace the dashes with underscores
features <- gsub("\\(|\\)","",features)
features <- gsub("-","_",features)

#select only the desired cols from the dataset
X_train <- X_train[featuresToKeep]


#apply the names to the variables
names(X_train) <- features
X_train$subject <- as.factor(subject_train[[1]])
X_train$activity <- as.factor(y_train[[1]])

#create charater labels for the activity factor
X_train$activity <- factor(X_train$activity, labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

#check the resulting structure
str(X_train)

#write out the finished dataset
#suppress the writing out of thisfile
#write.table(X_train, file = "observations.csv", sep = ",", row.names=FALSE, col.names = TRUE)

######################################################
#create data set of averages by subject and activity

#create data.table for speed/efficiency
library(data.table)
DT <- data.table(X_train)

#compute the averages using lapply inside the data.table command
df_averages <- DT[, lapply(.SD,mean), by = "subject,activity"]

#convert back to dataframe
df_averages <- as.data.frame(df_averages)

#get the names for the avg dataset -- append "_avg" to all of the variable names
features_avg <- paste(features, "_avg", sep="")
features_avg <- c("subject", "activity", features_avg)
names(df_averages) <- features_avg

#take a look at the new dataset
head(df_averages)
str(df_averages)

#write it out
write.table(df_averages, file = "subject_activity_averages.csv", sep = ",", row.names=FALSE, col.names = TRUE)








