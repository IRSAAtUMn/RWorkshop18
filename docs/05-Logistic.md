# Logistic Regression in R

*Author: Christina Knudson*

## Introduction

The previous chapter covered linear regression, which models a Gaussian response variable. This chapter covers logistic regression, which is used to model a binary response variable. Here are some examples of binary responses:

* Whether or not a person wears a helmet while biking
* Whether or not a dog is adopted
* Whether or not a beer is given an award
* Whether or not a tree survives a storm


## Goals

In this chapter, we will cover how to...

* Fit a logistic regression model in R.
* Interpret the model.
* Calculate probabilities.
* Test the significance of regression coefficients.

R's **glm** (generalized linear model) function will be the primary tool used in the chapter.


## Model Basics

Recall that  a simple linear regression model has the following form:
\[
\hat{y}_i = \beta_0 + \beta_1 x_i 
\]
where  $x_i$ is  the predictor, $\beta_0$ is the unknown regression intercept,  $\beta_1$ is the unknown regression slope, and $\hat{y}_i$ is the predicted response given $x_i$. 

In order to model a binary response variable, we need to introduce $p_i$, the probability of something happening. For example, this might be the probability of a person wearing a helmet, the probability of a dog being adopted, or the probability of a beer winning an award. Then our logistic regression model has the following form:
\[
\log \left( \dfrac{p_i}{1-p_i} \right) = \beta_0 + \beta_1 x_i .
\]

Recall that we estimated $\beta_0$ and $\beta_1$ to characterize the linear relationship between $x_i$ and $y_i$ in the simple linear regression setting. In the logistic regression setting, we will  estimate $\beta_0$ and $\beta_1$ in order to understand the relationship between $x_i$ and $p_i$.

As a final introductory note, we define the odds as $\dfrac{p_i}{1-p_i}$.

## Horseshoe Crab Data 

Some females attract many males while others are unable to attract any. In this example, the females we study are horseshoe crabs. The males that cluster around a female are called "satellites." In order to understand what influences the presence of satellite crabs, researchers selected female crabs and collected data on the following characteristics:

* the color of her shell
* the condition of her spine
* the width of her carapace shell (in centimeters)
* the number of male satellites
* the weight of the female (in grams)

In today's example, we will use the width of a female's shell to predict the probability of her having one or more satellites. Let's start by loading the data. 


```r
crabs <- read.csv("http://www.cknudson.com/data/crabs.csv")
head(crabs)
```

```
##    color spine width satell weight y
## 1 medium   bad  28.3      8   3050 1
## 2   dark   bad  22.5      0   1550 0
## 3  light  good  26.0      9   2300 1
## 4   dark   bad  24.8      0   2100 0
## 5   dark   bad  26.0      4   2600 1
## 6 medium   bad  23.8      0   2100 0
```

You can learn more about this data set [here](http://users.stat.ufl.edu/~aa/cda/data.html).


## Fit a Logistic Regression Model

To fit a logistic regression model, we can use the **glm** function:

```r
mod <- glm(y ~ width, family = binomial, data = crabs)
```
The first input is the regression formula (Response ~ Predictor),  the second input indicates we have a binary response, and the third input is the data frame. To find the regression coefficients (i.e. the estimates of $\beta_0$ and $\beta_1$), we can use the **coef** command

```r
coef(mod)
```

```
## (Intercept)       width 
## -12.3508177   0.4972306
```

We can now enter these estimates into our logistic regression equation, just as we did in the simple linear regression setting. Our logistic regression equation is 
\[
\log \left( \dfrac{p_i}{1-p_i} \right) = 12.3508 + 0.4972 \; \text{width}_i, 
\]
where $\text{width}_i$ is the width of a female crab's carapace shell and  $p_i$ is her probability of having one or more satellites.




## Interpret the Model ##

To do some basic interpretation, let's focus on the predictor's coefficient: 0.4972. First, notice this is a **positive** number. This tells us that wider crabs have **higher** chances of having one or more satellites. If the predictor's coefficient were **zero**, there would be **no** linear relationship between the width of a female's shell and her log odds of having one or more satellites. If the predictor's coefficient were **negative**, then wider crabs would have **lower** chances of having one or more satellites.




## Calculate Probabilities ##

Let's use our model for a female crab with a carapace shell that is 25 centimeters in width. (Note: this crab's shell width is within the range of our data set.) We start by simply substituting  this crab's width into our regression equation:
\begin{align*}
\log \left( \dfrac{p_i}{1-p_i} \right) &= -12.3508 + 0.4972 \; \text{width}_i \\
 &= -12.3508 + 0.4972 * 25 \\
 &= 0.0792.
\end{align*}
We could say that the log odds of a 25 cm female having satellites is about 0.0792, but let's make this more interpretable to everyday humans by translating this to a probability. We use a little algebra to solve for $p_i$:

\begin{align*}
\log \left( \dfrac{p_i}{1-p_i} \right) &= 0.0792 \\
\Rightarrow \left( \dfrac{p_i}{1-p_i} \right) &= \exp(0.0792) \\
\Rightarrow p_i &= \dfrac{\exp(0.0792)}{1+\exp(0.0792)} \\
&= 0.5198
\end{align*}

Here is our interpretation: the probability of a 25 cm wide female crab having one of more satellites is about 0.5198.









## Test a Regression Coefficient ##

An essential question in regression is "Does this predictor actually help us predict the response?" In other words, we want to know whether there really  is a relationship between our predictor and our response. 

In the context of the crabs, we want to know whether the carapace width really does have a  linear relationship with the log odds of satellites. 

* The null hypothesis is that her carapace width has no linear relationship to her log odds of having satellites. 
* The alternative hypothesis is that her carapace width has a linear relationship to her log odds of having satellites. 

Remember: we assume there is *no* relationship until we find evidence that there *is* a relationship. That is, we assume that carapace width is unrelated to the probability of satellites; in order to say the carapace width is related to the probability of satellites, we need evidence. This evidence comes in the form of a statistical test.



The results of this test are reported in the **summary** command, which was introduced in the linear regression setting. Below is the summary for our crab model.


```r
summary(mod)
```

```
## 
## Call:
## glm(formula = y ~ width, family = binomial, data = crabs)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.0281  -1.0458   0.5480   0.9066   1.6942  
## 
## Coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -12.3508     2.6287  -4.698 2.62e-06 ***
## width         0.4972     0.1017   4.887 1.02e-06 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 225.76  on 172  degrees of freedom
## Residual deviance: 194.45  on 171  degrees of freedom
## AIC: 198.45
## 
## Number of Fisher Scoring iterations: 4
```


Although the summary provides many details about our model, we  focus for now on the coefficients table in the center of the summary output. Recall that our model has two regression coefficients: the intercept $\beta_0$ and the slope $\beta_1$. The first row of the coefficients table displays information for $\beta_0$ and the second row displays information for $\beta_1$. The columns of the coefficients table provide the estimates of our regression coefficients, their standard errors (smaller standard errors indicate higher certainty), test statistics (for testing whether the regression coefficients differ from zero), and the p-values associated with the test statistics.

In order to answer our question ("Does this predictor actually help us predict the response?"), we focus on $\beta_1$, the regression coefficient on the predictor.   (Recall that if $\beta_1 = 0$, then the log odds have no linear relationship with the predictor.) We find the test results in te two right-most columns and the second row in the the coefficients table of the summary. These entries show us that our test statistic is 4.887 and our p-value is 1.02e-06 (or $1.02 \times 10^{-6}$). We compare our p-value to a "significance level" (such as $0.05$); **because our p-value is smaller than our significance level, we have evidence that the log odds of satellites have a significant linear relationship with the carapace width.**



##  Practice Problems

### Female Horseshoe Crab Weight

Continue using the  horseshoe crab data to investigate the relationship between a female's weight and the log odds of her having satellites.

* Create a logistic regression using the female's weight as the predictor and whether she has satellites as the response variable. 
* Write down the regression equation.
* Do heavier females having higher or lower chances of  having satellites?
* Consider a female weighing 2000 grams. What is the probability that she has one or more satellites?
* Is there a linear relationship between  a female crab's weight and her log odds of satellites? Find the p-value and use a significance level of $0.05$.

### Boundary Water Blowdown

The Boundary Water Canoe Area experienced wind speeds over 90 miles per hour on July 4, 1999. As a result, many trees were blown down. The data set below contains information on the diameter of each tree (**D**) and whether the tree died (**y**). **y** is 1 if the tree died and 0 if the tree survived. You can learn more about this data set [here](https://www.rdocumentation.org/packages/alr4/versions/1.0.5/topics/Blowdown).


```r
blowdown <- read.csv("http://www.cknudson.com/data/blowdown.csv")
```

Use this data set to understand the relationship between a tree's diameter and its log odds of death.

* Create a logistic regression using the tree's diameter the predictor and whether it died as the response variable. 
* Write down the regression equation.
* Did thicker trees having higher or lower chances of dying?
* Consider a tree 20 cm in diameter. What is the probability that it died?
* Is there a linear relationship between  the tree's diameter and its log odds of dying? Find the p-value and use a significance level of $0.05$.



### Beer

Recall the beer data set introduced by Nathaniel Helwig. Imagine that you have a friend with a rather black-and-white outlook. If a beer's rating is 90 or higher, your friend considers this beer good. Scores lower than 90 indicate the beer is not good, according to your friend's rule. We have added a binary variable (**Good**) to to represent your friend's classification strategy: **Good**  is 1 if the beer has a score of at least 90 and 0 otherwise.

* Use logistic regression to decide whether beers with higher **ABV** (alcohol by volume) are more likely to be "Good."
* Choose your favorite beer off the list and calculate its probability of having a score of at least 90.


```r
beer <- read.csv("http://www.cknudson.com/data/MNbeer.csv")
```


### State Colors

Recall the election data set introduced by Alicia Johnson. The variable **Red** has been added to the data set to indicate whether the state's color is red (1 if red, 0 otherwise). 

* Is per capita income related to whether a state is red?
* If a state has a high per capita income, is it more or less likely to be red?


```r
election <- read.csv("https://www.macalester.edu/~ajohns24/data/IMAdata1.csv")
election$Red <- as.numeric(election$StateColor == "red")
```

## Partial Solutions

### Crab Weight

We create the model and look at the summary to find the p-value for the coefficient on weight The p-value is small ($1.45 \times 10^{-6}$) so we can conclude that a female crab's weight **does** have a significant linear relationship with the log odds of her having one or more satellites.


```r
weightmod <- glm(y ~ weight, family = binomial, data = crabs)
summary(weightmod)
```

```
## 
## Call:
## glm(formula = y ~ weight, family = binomial, data = crabs)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.1108  -1.0749   0.5426   0.9122   1.6285  
## 
## Coefficients:
##               Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -3.6947264  0.8801975  -4.198 2.70e-05 ***
## weight       0.0018151  0.0003767   4.819 1.45e-06 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 225.76  on 172  degrees of freedom
## Residual deviance: 195.74  on 171  degrees of freedom
## AIC: 199.74
## 
## Number of Fisher Scoring iterations: 4
```

Now we can use our regression equation to calculate the probability of a 2000 gram female having one or more satellites.

```r
logodds <- sum(coef(weightmod) * c(1, 2000))
exp(logodds)/(1+exp(logodds))
```

```
## [1] 0.4838963
```
The probability of a 2000 gram female having satellites is about half (.48).

### Boundary Water Blowdown

We create the model, isolate the coefficients, and find the summary using the code below.

```r
treemod <- glm(y ~ D, data = blowdown, family = binomial)
coef(treemod)
```

```
## (Intercept)           D 
## -1.70211206  0.09755846
```

```r
summary(treemod)
```

```
## 
## Call:
## glm(formula = y ~ D, family = binomial, data = blowdown)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -3.6309  -0.9616  -0.7211   1.1495   1.7172  
## 
## Coefficients:
##              Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -1.702112   0.082798  -20.56   <2e-16 ***
## D            0.097558   0.004846   20.13   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 5057.9  on 3665  degrees of freedom
## Residual deviance: 4555.6  on 3664  degrees of freedom
## AIC: 4559.6
## 
## Number of Fisher Scoring iterations: 4
```

First, the coefficient on the diameter is positive. This tells us that larger trees were more likely to die. Moreover, the relationship between a trees diameter and its log odds of death is statistically significant: the p-value is quite small (smaller than $2 \times 10^{-16}$). 

Finally, the probability of death for a tree that was 20 cm in diameter is calculated below.

```r
(logodds <- coef(treemod) %*% c(1, 20))
```

```
##           [,1]
## [1,] 0.2490571
```

```r
exp(logodds)/(1+exp(logodds))
```

```
##           [,1]
## [1,] 0.5619444
```


### Beer
We create the model and look at the summary to find the p-value for the coefficient on ABV. The p-value is small ($0.00747$) so we can conclude that ABV **does** have a significant linear relationship with the log odds of a beer earning a score of at least 90.


```r
beermod <- glm(Good ~ ABV, family = binomial, data = beer)
summary(beermod)
```

```
## 
## Call:
## glm(formula = Good ~ ABV, family = binomial, data = beer)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.3847  -0.8206  -0.4663   0.7230   2.1320  
## 
## Coefficients:
##             Estimate Std. Error z value Pr(>|z|)   
## (Intercept)  -9.7881     3.3959  -2.882  0.00395 **
## ABV           1.4662     0.5481   2.675  0.00747 **
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 51.564  on 43  degrees of freedom
## Residual deviance: 42.108  on 42  degrees of freedom
## AIC: 46.108
## 
## Number of Fisher Scoring iterations: 5
```


### State Colors
We create the model and look at the summary to find the p-value for the coefficient on per capita income. The p-value is very small (smaller than $2.2 \times 10^{-16}$) so we can conclude that per capita income **does** have a significant linear relationship with the log odds of a state being red.

```r
electionmod <- glm(Red ~  per_capita_income, family = binomial, data = election)
summary(electionmod)
```

```
## 
## Call:
## glm(formula = Red ~ per_capita_income, family = binomial, data = election)
## 
## Deviance Residuals: 
##    Min      1Q  Median      3Q     Max  
## -1.617  -1.146  -0.753   1.157   2.073  
## 
## Coefficients:
##                     Estimate Std. Error z value Pr(>|z|)    
## (Intercept)        1.649e+00  1.722e-01   9.575   <2e-16 ***
## per_capita_income -7.339e-05  7.214e-06 -10.173   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 4352.6  on 3142  degrees of freedom
## Residual deviance: 4237.1  on 3141  degrees of freedom
## AIC: 4241.1
## 
## Number of Fisher Scoring iterations: 4
```

