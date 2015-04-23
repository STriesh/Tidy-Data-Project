# Tidy-Data-Project
Tidy-Data-Project

---
title: "Project run_analysis.R"
author: "Saide"
date: "Sunday, April 19, 2015"
output: html_document
---

This README.txt file accompanies the R script Source File called "run_analysis.R""

Before running the source file make sure you supply at the prompt your prefered "Set As Working Directory".




that does the following: 

  (I.) Prompts user for "Set As Working Directory" 
  
  (II.) Downloads and unzips the raw data files, the associated directories, and their sub-directories
        to the base directory specified by the user above, from the link below:
    
      https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
      
      In the aftermath of downloading this zip file is named raw_data.
      
  (III.) Unzipping the raw_data will create the following directory tree:
       dir -> UcI HAR Dataset
         dir|_> train
          |        |_  y_train.txt
          |        |_  X-train.txt
          |        |_  subject_train.txt
          |     dir|_> Inertial Signals
          |                       |_ contains 9 files of raw data from which X-train.txt was formulated  
          |
          dir|_> test
          |        |_  y_test.txt
          |        |_  X-test.txtest
          |        |_  subject_train.txt
          |     dir|_> Inertial Signals
          |                       |_ contains 9 files of raw data from which X-test.txt was formulated  
          |    
          |_README.txt
          |Features.txt
          |Features.info.txt
          |activity_labels.txt
          


    1-  Merges the training and the test sets to create one data set.
        a.  - The Training data frame (X_train.txt); and the Test data frame (X_test.txt) 
              dimensions and content are identified.  These is matrices with 561 columns 
              and thousands of lines
        b.  - The Subject files (subject.train.txt & subject.test.txt) and the 
              associated Activities files(y.train.txt & y.test.txt) are identified. 
              These files account for row labels for 30 Subjects and 6 Activities that 
              files discussed in point 1-a.
        c.  - The Feature file will serve as the column labels for the 561 columns of for 
              analyzed data contained in point 1-a.
              
  
    2-  Extracts only the measurements on the mean and standard deviation for each measurement. 
        a. an initial tidy_data data frame was built by selecting only column labels that contained 
            mean() or std() in their title. 81 columns is in total.
    3-  Uses descriptive activity names to name the activities in the data set
        a. The activity_labels.txt was used to replace all numeric levels with the descriptive 
           activity name
    4-  Appropriately labels the data set with descriptive variable names.
        a. The descriptive variable names were given as follows:
            i. "Subject" is the first column's label and it represent data contained 
                in the subject.train.txt & subject.test.txt files that was column bound using cbin()
                to the Master_df
            ii. "Activity" is the second column's label and it represent data contained 
                in the (y.train.txt & y.test.txt) files that was column bound using cbin()
                to the Master_df
            iii. A correlation was made for the rest of the columns as specified by the 
                 features.txt file.  Original variable number begins the name and the label
                 contains all of the rest of the string of the feature name.
              iV. This first pass at producing tidy data gave rise to tidy_data data frame
    5-  From the data set in step 4, creates a second, independent tidy data set with the average of each 
        variable for each activity and each subject.
          a. used the aggregate() function in the dplyr package to facilitate sorting of 
            the Master_df data frame by Subject and then by Activity under each subject. This was the 
            2nd step in producing tidy data and the data frame is called tidy_data2
          b. Used two For loops in conduction with several self-formulated functions to achieve 
             the Tidy_Data_Final data frame
          c. The final independent tidy data frame was sorted and only complete.cases() were retained
          d. self formulated functions were used to summarize by Subject by Activity averages over \
              the 81 columns of mean()'s and std()'s
    
    IV. Functions
      1.  Subject_Activity_Temp_df <- function (df, Row_list,i,j )
          a.  used to produce the temporary data frames containing the combinations of subsets 
              by Subject, Activity so that they can be passed to Cal_Summary-Row for averaging 
              across the columns and then summarizing as one case in the Final Tidy Data 
              dataframe
          
      2.  Calc_Summary_Row<- function  (df)
          a.  Given any data frame it will average across Columns 3:nrow(df)
          b.  Returns a single row with the column averages
          
          
      3.  Update_Tidy_Data_Final <- function (df, summary_row,m)
          a. Given any data frame it will insert a row in it
          b. It inserts the row making it the firt row
            i. The existing rows all move down by one:
                --  if the df has one row, the inserted row
                    will be row 1 and the previous will be row 2
                --  if the df has two rows, the inserted row will
                    be row 1, old row 1 will be row 2, old row 2
                    will be row 3
                --  and so on...
      
      4.  Reduce_df_by_processed_Rows<- function (row_index_list,df)
          a. The slowest search is the first one
          b. Every time a combination of Subject, Activity is processed
             the df is reduced by the amount of rows processed
          c. The intention is to reduce time of loop that would process
              over 10K lines with each iteration over 180 iteration
          d. about 100 lines are removed each cycle so as more and more data is processed
              the search time reduced proportionately
              -- first time through loop 1029 records 
              -- second time through loop ~9900
              -- third time through loop ~9800
              -- etc.
              -- by the time it is at 179th cycle we are processing only about 100 lines
              
      5.  Formulate_row_index_list<- function (df,i,j,key)
          a. Takes data base and created the index of rows that are to
             be removed from cycle and processed for the Final Tidy Data df
      6.  Clean_Up<- function (df)
          a. Keeps only complete.cases()
          b. uses arrange() to sort Final Tidy Data df so that Subject 1 Activity 1
             is row 1 and Subject 30 Activity 6 is the 180th (last) line
      7. a. Submit script on GitHub
         b. Attach Tidy Data as txt file using write.table() with row.name=FALSE
             
    
