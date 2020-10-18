# nG-BotClassifier

# Description 

The goal of this project is to build a bot classifier that outputs probabilistic scores wheter a participant of a nG survey is a bot or not. 

# Current Status 

## Descriptive Analysis

The first descriptive analysis shows that values for bots and non-bots in core variables are clearly different. For comparison, the age is also being shown here, at which this difference cannot be seen. quirk_count and feedback_count are variables that were derived from the quirk and feedback variables and count the sum of words in one answer. 

![Rplot03](https://user-images.githubusercontent.com/44944150/96366284-050cb080-1147-11eb-9ab5-42943e64a6a6.png)

## Feature selection

Descriptive analysis showed strong differences in variables related to meta information of the user. Besides choosing these variables as features other variables were choosen (for now) out of theoretical intutiotn as well. The variable "feedback" was used to create further features. Using the Bag-of-words approach, the 300 most common words in these feedback answers were created as unique numeric variables. Further methods of feature extraction in relation to the string variables are currently investigated.

## Class Imbalance 

A large challenge in this project is the high class imbalance in the target variable. Only 6 % of the instances in this data are labeled as bots and therefore training and testing the model is difficult. Class Imbalance was handled by creating synthetic data in the training set with SMOTE (Chawla, N. V. and Bowyer, K. W. and Hall, L. O. and Kegelmeyer, W. P., "{SMOTE}: synthetic minority over-sampling technique" , Journal of Artificial Intelligence Research, 2002, pp. 321--357). 

## Models

At the moment, models were trained (and tuned) with the following algorithms : KNN, XGB, ExtraTrees, C5.0. 

XGB (<i> parameters: nrounds = 50, max_depth = 3, eta = 0.4 gamma = 0, colsample_bytree = 0.8, min_child_weight = 1, subsample = 1 </i>) currently performs the best out of all these models with an <b> Accuracy of 96% </b>. The model surpassed the no information rate which was pretty high (0.941) because of class imbalance. The Sensitivity is 0.82 & Specificity is 0.97 which means that the model accurately could identify 97% of non-bots, 82% of bots. One has to keep in mind that the model did not have many cases of bots so the Sensitivity could increase with more data. 

```
          Reference
Prediction  No Yes
       No  340   4
       Yes  11  18
```

![Rplot05](https://user-images.githubusercontent.com/44944150/96371385-d0f2b900-1161-11eb-93b1-1cc5d2b4a257.png)

## Output

Below is the output of the model with the respective individual probabilites for identifying wheter the user was a bot or not (C1 (No) = Model says no, C2 (Yes) = Model says Yes; C3 (Actual_Label) = True label that was in the test set). One can see that the model performs quite well by providing mostly strong probabilites for yes or no. But what also can be seen is that the model has cases where it is completetly wrong (e.g. case 154). This could be improved with more data in the future. 
```
    No   Yes  Actual_Label
117 1.00 0.00           No
118 0.98 0.02           No
119 1.00 0.00           No
120 1.00 0.00           No
121 1.00 0.00           No
122 1.00 0.00           No
123 0.32 0.68          Yes
124 1.00 0.00           No
125 0.26 0.74          Yes
126 1.00 0.00           No
127 1.00 0.00           No
128 1.00 0.00           No
129 1.00 0.00           No
130 1.00 0.00           No
131 1.00 0.00           No
132 0.99 0.01           No
133 1.00 0.00           No
134 1.00 0.00           No
135 0.95 0.05           No
136 1.00 0.00           No
137 1.00 0.00           No
138 1.00 0.00           No
139 1.00 0.00           No
140 0.99 0.01           No
141 1.00 0.00           No
142 1.00 0.00           No
143 1.00 0.00           No
144 1.00 0.00           No
145 1.00 0.00           No
146 0.00 1.00          Yes
147 0.03 0.97          Yes
148 1.00 0.00           No
149 1.00 0.00           No
150 1.00 0.00           No
151 0.76 0.24           No
152 1.00 0.00           No
153 1.00 0.00           No
154 0.03 0.97           No
155 1.00 0.00           No
156 1.00 0.00           No
157 0.79 0.21           No
158 1.00 0.00           No
159 1.00 0.00           No
160 0.98 0.02           No
161 0.89 0.11           No
162 1.00 0.00           No
163 1.00 0.00           No
164 0.38 0.62          Yes
165 1.00 0.00           No
166 1.00 0.00           No
167 1.00 0.00           No
168 0.99 0.01           No


```

# Next Steps & further challenges 

While continuing to refine the model and think about further feature extraction in regards to the string variables, a next step is to think about the integration within the node.js framwork. 
- How do I integrate such a model within node.js?
- Should the model update itself with new data coming in? 
- How well does the model perform if we just use the text variable? 
- ...
