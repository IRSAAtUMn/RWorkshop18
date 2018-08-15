# Logistic Regression in R

*Author: Christina Knudson*

## Introduction

The previous chapter covered linear regression, which models a Gaussian response variable. This chapter covers logistic regression, which is used to model a binary response variable. Here are some examples of binary responses:

* Whether or not a person wears a helmet while biking
* Whether or not a dog is adopted
* Whether or not a beer is given an award
* Whether or not a tree survives a storm


### Goals

In this chapter, we will cover how to...

* Fit a logistic regression model in R with quantitative and/or categorical predictors.
* Interpret logistic regression model.
* Calculate probabilities.
* Test the significance of regression coefficients.


R's **glm** (generalized linear model) function will be the primary tool used in the chapter.

### Horseshoe Crab Data 

Throughout this module, we will refer to the horseshoe crab data. Some female crabs attract many males while others do not attract any.  The males that cluster around a female are called "satellites." In order to understand what influences the presence of satellite crabs, researchers selected female crabs and collected data on the following characteristics:

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



## Model Basics

### Notation and Setup

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


### Fit a Logistic Regression Model

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




### Interpret the Model

To do some basic interpretation, let's focus on the predictor's coefficient: 0.4972. First, notice this is a **positive** number. This tells us that wider crabs have **higher** chances of having one or more satellites. If the predictor's coefficient were **zero**, there would be **no** linear relationship between the width of a female's shell and her log odds of having one or more satellites. If the predictor's coefficient were **negative**, then wider crabs would have **lower** chances of having one or more satellites.



### Calculate Probabilities

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









### Test a Regression Coefficient

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



##  Half-Time Exercises

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

Recall the beer data set introduced by Alicia Johnson and Nathaniel Helwig. Imagine that you have a friend with a rather black-and-white outlook. If a beer's rating is 90 or higher, your friend considers this beer good. Scores lower than 90 indicate the beer is not good, according to your friend's rule. We have added a binary variable (**Good**) to to represent your friend's classification strategy: **Good**  is 1 if the beer has a score of at least 90 and 0 otherwise.

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


## Beyond the Basics

### Interpret the Model (Again!)


We can look beyond just whether the predictor's coefficient ($\beta_1$) is positive or negative. Exponentiating both sides of the regression equation produces
\[
\dfrac{p_i}{1-p_i} = \exp\left( \beta_0 + \beta_1 x_i \right) = \exp\left( \beta_0 \right) \exp\left(  \beta_1 x_i \right). 
\]

To understand the relationship between our predictor and the log odds, let's see what happens when we increase $x_i$ by one unit. That is, let's replace $x_i$ with $x_i+1$.

\[
\dfrac{p_i}{1-p_i} =  \exp\left( \beta_0 \right) \exp\left(  \beta_1 (x_i+1) \right) = \exp\left( \beta_0 \right) \exp\left(  \beta_1 x_i \right)\exp\left(  \beta_1  \right). 
\]

That is, our odds for predictor value $x_i$ are $\exp\left( \beta_0 \right) \exp\left(  \beta_1 x_i \right)$ while the odds for predictor value $x_i+1$ are $\exp\left( \beta_0 \right) \exp\left(  \beta_1 x_i \right)\exp\left(  \beta_1  \right)$. These two odds differ by a factor of $\exp(\beta_1)$. That is, the ratio of the two odds is $\exp(\beta_1)$:
\[
\dfrac{\exp\left( \beta_0 \right) \exp\left(  \beta_1 x_i \right)\exp\left(  \beta_1  \right)}{\exp\left( \beta_0 \right) \exp\left(  \beta_1 x_i \right)} = \exp(\beta_1).
\]

Therefore, we can say that a one unit increase in the predictor is associated with a $\exp(\beta_1)$ multiplicative change in the odds. Let's try this with the horseshoe crab carapace width model. 

```r
exp(coef(mod))
```

```
##  (Intercept)        width 
## 4.326214e-06 1.644162e+00
```

A one centimeter increase in carapace width is associated with a 1.64 multiplicative change in the odds of having satellites. Alternatively, imagine two female crabs that have carapace widths that differ by exactly 1 cm. The odds of the larger crab having satellites is approximately 1.64 times the odds of the smaller crab having satellites.

### Incorporate a Categorical Predictor

Rather than using a quantitative predictor, we can use a categorical predictor. Let's try using the spine condition in our horseshoe crab data. Crabs were categorized according to whether they had two good spines (*good*), two worn or broken spines (*bad*), or one worn/broken spine and one good spine (*middle*).

We will fit the model using the following **glm** setup.


```r
spinemod <- glm(y ~ 0 + spine, data = crabs, family = binomial)
coef(spinemod)
```

```
##    spinebad   spinegood spinemiddle 
##   0.5955087   0.8602013  -0.1335314
```

This produces three log odds, one for each group (bad, good, and middle). If we eliminate the **0+**, we create a model with a reference group; this will compare the bad spine group to the other two groups.


```r
spinemod2 <- glm(y ~ spine, data = crabs, family = binomial)
coef(spinemod2)
```

```
## (Intercept)   spinegood spinemiddle 
##   0.5955087   0.2646926  -0.7290401
```

```r
exp(coef(spinemod2))
```

```
## (Intercept)   spinegood spinemiddle 
##   1.8139535   1.3030303   0.4823718
```

This model tells us that

* the  odds of satellites for a female with two bad spines is  1.8.
* the odds of satellites for a female with two good spines is 1.3 times the odds of satellites for a female with two bad spines.
* the odds of satellites for a female with one good spine and one bad spine is .48 times the odds of satellites for a female with two bad spines. 

Sometimes people have a hard time interpreting odds ratios below 1. In this case, it is useful to flip the ratio. 

```r
1/exp(coef(spinemod2))
```

```
## (Intercept)   spinegood spinemiddle 
##   0.5512821   0.7674419   2.0730897
```

Therefore, we can reword the third bullet to the following: the odds of satellites for a female with two bad spines is 2 times the odds of satellites for a female with one bad spine and one good spine.


### Incorporate Multiple Predictors

In the linear regression setting, you created models with multiple predictors. This is useful in the logistic regression setting as well. Let's create a model with both the female's carapace width and her weight. We expand our **glm** formula in the same way as you would expand the **lm** formula.


```r
multimod <- glm(y ~ weight + width, data = crabs, family = binomial)
coef(multimod)
```

```
##   (Intercept)        weight         width 
## -9.3547261192  0.0008337917  0.3067892044
```

This produces the following logistic regression equation:

\[
\log \left( \dfrac{p_i}{1-p_i} \right) = -9.35 + 0.0008337917 \; \text{weight}_i + 0.3067892044 \; \text{width}_i .
\]

Equivalently, our model could be written as

\[
\ \dfrac{p_i}{1-p_i}  = \exp(-9.35) \; \exp \left( 0.0008337917 \; \text{weight}_i \right) \; \exp \left( 0.3067892044 \; \text{width}_i \right) .
\]

The exponentiated regression coefficients tell us the following:

* Holding weight constant, a one centimeter increase in carapace width is associated with a 1.359 multiplicative change in the odds of having satellites.
* Holding carapace width constant, a one gram increase in weight is associated with a .000834 multiplicative change in the odds of having satellites.

Of course, a one gram increase in weight is practically imperceptible. Let's instead consider a 100 gram increase in weight.

```r
beta1 <- coef(multimod)[2]
exp(beta1 * 100)
```

```
##   weight 
## 1.086954
```
Holding carapace width constant, a one gram increase in weight is associated with a 1.0869539 multiplicative change in the odds of having satellites.

### Test a Regression Coefficient (Again!) 

We discussed how to test a regression coefficient for a logistic model with a single predictor. You learned how to test a regression coefficient in multiple linear regression. Now it is time to test a logistic regression coefficient in models with multiple predictors.

Let's test whether a logistic regression model with both carapace width and weight is better than a model with carapace width only. That is, we want to know whether the female's weight contributes to the model. Again, we check the summary and look at the row labeled **weight**.


```r
summary(multimod)
```

```
## 
## Call:
## glm(formula = y ~ weight + width, family = binomial, data = crabs)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.1127  -1.0344   0.5304   0.9006   1.7207  
## 
## Coefficients:
##               Estimate Std. Error z value Pr(>|z|)   
## (Intercept) -9.3547261  3.5280465  -2.652  0.00801 **
## weight       0.0008338  0.0006716   1.241  0.21445   
## width        0.3067892  0.1819473   1.686  0.09177 . 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 225.76  on 172  degrees of freedom
## Residual deviance: 192.89  on 170  degrees of freedom
## AIC: 198.89
## 
## Number of Fisher Scoring iterations: 4
```

The p-value is reported as 0.21445. This is larger than any standard significance level. Therefore, we should remove the female's weight from the model as it does not contribute a significant amount of information, after accounting for the female's carapace width. We can state our conclusion more formally: after accounting for the female's carapace width, we find no significant linear relationship between the female's weight and her log odds of having satellites.

## More Exercises

### Crabs, Revisited

Use the output below to determine whether, after accounting for the female's weight, there is a linear relationship between carapace width and the log odds of satellites.

### Beer, Revisited

Create a logistic regression for the log odds of a beer being "Good" using both ABV and IBU as predictors. 

* Holding IBU constant, are beers with higher ABVs **more** or **less** likely to be "Good"?
* After accounting for a beer's IBU, is there a relationship between ABV and a beer's log odds of being "Good"? Compare your p-value to a significance level of .1.

### State Colors, Revisited

Use **IncomeBracket** to model the log odds of a state being red.

* Find the odds of a high income state being red.
* Fill in the blank: the odds of a high income state being red are ____ times the odds of a low income state being red.

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

Next, we create our model with both ABV and IBU. 

```r
beermod2 <- glm(Good ~ ABV + IBU, family = binomial, data = beer)
coef(beermod2)
```

```
##  (Intercept)          ABV          IBU 
## -9.307699299  1.308989140  0.008248125
```

```r
summary(beermod2)
```

```
## 
## Call:
## glm(formula = Good ~ ABV + IBU, family = binomial, data = beer)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.2930  -0.7759  -0.4435   0.7678   2.1315  
## 
## Coefficients:
##              Estimate Std. Error z value Pr(>|z|)  
## (Intercept) -9.307699   3.678245  -2.530   0.0114 *
## ABV          1.308989   0.721717   1.814   0.0697 .
## IBU          0.008248   0.025139   0.328   0.7428  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 51.564  on 43  degrees of freedom
## Residual deviance: 42.000  on 41  degrees of freedom
## AIC: 48
## 
## Number of Fisher Scoring iterations: 5
```
The coefficient on ABV is positive: this tells us that, after accounting for IBU, beers with higher ABV are more likely to be "Good." The p-value for this regression coefficient is $.0697 < .1$, therefore we can conclude that, even after accounting for IBU, there is a significant linear relationship between a beers ABV and its log odds of being "Good."

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


```r
lowhighmod <- glm(Red ~ IncomeBracket, data = election, family = binomial)
exp(coef(lowhighmod))
```

```
##      (Intercept) IncomeBracketlow 
##        0.6197836        1.8217084
```
The odds of a high income state being red is about .62. The odds of a low income state being red are about 1.82 times the odds of a high income state being red. That is, low income states are more likely to be red than high income states.
