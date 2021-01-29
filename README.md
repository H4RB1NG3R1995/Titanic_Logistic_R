# Titanic_Logistic_R
To predict which passengers survived the Titanic tragedy using Logistic Regression Model

Overview:

The sinking of the RMS Titanic is one of the most infamous shipwrecks in history. On April 15, 1912, during her maiden voyage, the Titanic sank after colliding with an iceberg, killing 1502 out of 2224 passengers and crew. This sensational tragedy shocked the international community and led to better safety regulations for ships. One of the reasons that the shipwreck led to such loss of life was that there were not enough lifeboats for the passengers and crew. Although there was some element of luck involved in surviving the sinking, some groups of people were more likely to survive than others, such as women, children, and the upper-class.

About the dataset:
The dataset is pre-split into train and test datasets. The train dataset has 891 observations of 12 variables. The test dataset has 418 observations of 11 variables. The resson for this is that we have to predict the chance of survival of passengers from the train dataset by applying a Logistic Regression Model and then use the same model to predict the same on the test dataset.

The variables are explained as follows:
1. Survived: Survival (0 = No, 1 = Yes)
2. Pclass: Ticket class (1 = 1st, 2 = 2nd, 3 = 3rd)
3. Sex: Sex of passengers
4. Age: Age in years
5. SibSp: No. of siblings / spouses aboard the Titanic
6. Parch: No. of parents / children aboard the Titanic
7. Ticket: Ticket number
8. Fare: Passenger fare
9. Cabin: Cabin number
10. Embarked: Port of Embarkation (C = Cherbourg, Q = Queenstown, S = Southampton)

Problem Statement: In this problem, we have to complete the analysis of what sorts of people were likely to survive.

The moddel used is Binary Logistic Regression Model since it is a classification problem.

4 variables PassengerId, Cabin, Ticket, Name are dropped sice they are qualitative variables and also redundant from a business perspective.

Negatively Significant variables: Pclass2, Pclass3, Sexmale, Age, SibSp
Positively Significant variables: None

Interpretation: People belonging from a higher age group, passenger class 2 and 3, of gender male and having siblings and spouses were less likely to survive compared to people from other categories. 
