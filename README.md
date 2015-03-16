---
output: html_document
---

#Description of the cleaning and transformations, along with the script.
<br>

##PART 1 -- Create a tidy data for the first dataset ("observations.csv") 

For part 1 the instructions were to:
  Merges the training and the test sets to create one data set.
	Extracts only the measurements on the mean and standard deviation for each measurement. 
	Uses descriptive activity names to name the activities in the data set
	Appropriately labels the data set with descriptive variable names. 


To accomplish this I did the following:

1. Load the X, y, and subject data (Training and Test) into a totla of 6 data.frames
	I assumed that the files are in the working directory, but...since not sure if training and test files will be directly in working directory, or unzipped into folders, I test for existence and try both at the root level of the unzipped folder, as well as in the separate /train and /test folders for all 3 sets of files (X, y, subjects)

	X_train.txt
  X_test.txt
  y_train.txt
  y_test.txt
  subject_train.txt
  subject_test.txt

2. I then combine the training and test sets for each of X, y, subjects using rbind -- so now have 3 data.frames, one for X, y, and subject. 

3. I loaded the feature labels from features.txt

4. I used grep to get only those features that had "mean()" or "std()" in them. I needed to use the Parentheses in teh regular expression because I decided to exclude the columns that were not direct means of the measurements -- like "...meanFreq".  I then transformed this data.frame into a character vector, and also saved a vector of the indices of the desired columns in order to use below to select these cols form the dataset.

5. I cleaned up the variable names to remove the parens and replace the dashes with underscores (using gsub).

6. I used the resulting feature index vector to select only the desired cols from the dataset

7. I used the cleaned up list of features to apply as the names to the variables

8. I added the subject and activity (y) columns to the dataset as factor variables named "subject" and "activity"

9. I created descriptive character labels for the activity factor:  c(
```{r, echo=FALSE}
X_train$activity <- factor(X_train$activity, labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))
```	

10. I wrote out the resulting tidy dataset of observations to a file "observations.csv"

###
PART 2 -- Create a summary dataset of averages of reading for all subject-activity pairs.

1. I loaded the data.table library and loaded the data.frame from above into it.  This should allow it to be processed more efficiently.

2. I computed the averages using lapply inside the data.table command using code: 
```{r, echo=FALSE}
df_averages <- DT[, lapply(.SD,mean), by = "subject,activity"]
```	

3. I converted the data.table back into a data.frame

4. I created the names for the variables in the "averages" dataset by appending "_avg" to all of the variable names using the paste command:
	features_avg <- paste(features, "_avg", sep="")
	I also added 2 names for the grouping variables "subject" and "activity"

5. I wrote out the dataset into a file "subject_activity_averages.csv" using the write.table command:
```{r, echo=FALSE}
write.table(df_averages, file = "subject_activity_averages.csv", sep = ",", row.names=FALSE, col.names = TRUE)
#comment
```		
	
##Part 3 -- the script -- run_analysis.R

All of the transformations and cleaning are carried out in one script -- "run_analysis.R".  The final output is the csv file with the tidy dataset that was submitted -- "subject_activity_averages.csv". 

See script file in repo.

