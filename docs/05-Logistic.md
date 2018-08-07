# Logistic Regression in R

*Author: Christina Knudson*




## Goals

In this chapter, we will cover how to...

* Fit a logistic regression model in R.
* Interpret the model using odds.
* Test the significance of regression coefficients.
* Create and interpret confidence intervals.

R's **glm** (linear model) function will be the primary tool used in the chapter.



## Horseshoe Crab Data 

### Overview





### Load and Look at the Data


```r
library(glmbb)
data(crabs)
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



## Simple Linear Regression

### Fit the Model

Consider a logistic regression model of the form
\[
\log \left( \dfrac{p_i}{1-p_i} \right) = \beta_0 + \beta_1 x_i 
\]
where $p_i$ is the probability of ..., $x_i$ is ... (predictor), $\beta_0$ is the unknown regression intercept, and $\beta_1$ is the unknown regression slope. To fit the model, we can use the **glm** function

```r
mod <- glm(y ~ color, family = binomial, data = crabs)
```
The first input is the regression formula (Response ~ Predictor), and the second input is the data frame containing the variables in the regression formula. Note that *mod* is an object of class *glm*, which is a list containing information about the fit model. 

```r
class(mod)
```

```
## [1] "glm" "lm"
```

```r
names(mod)
```

```
##  [1] "coefficients"      "residuals"         "fitted.values"    
##  [4] "effects"           "R"                 "rank"             
##  [7] "qr"                "family"            "linear.predictors"
## [10] "deviance"          "aic"               "null.deviance"    
## [13] "iter"              "weights"           "prior.weights"    
## [16] "df.residual"       "df.null"           "y"                
## [19] "converged"         "boundary"          "model"            
## [22] "call"              "formula"           "terms"            
## [25] "data"              "offset"            "control"          
## [28] "method"            "contrasts"         "xlevels"
```
For example, the *$coefficients* element contains the estimated regression coefficients

```r
mod$coefficients
```

```
## (Intercept) colordarker  colorlight colormedium 
##   0.3677248  -1.1298648   0.7308875   0.6082852
```


### Inference Information

To obtain a more detailed summary of the fit model, use the **summary** function

```r
modsum <- summary(mod)
names(modsum)
```

```
##  [1] "call"           "terms"          "family"         "deviance"      
##  [5] "aic"            "contrasts"      "df.residual"    "null.deviance" 
##  [9] "df.null"        "iter"           "deviance.resid" "coefficients"  
## [13] "aliased"        "dispersion"     "df"             "cov.unscaled"  
## [17] "cov.scaled"
```

```r
modsum
```

```
## 
## Call:
## glm(formula = y ~ color, family = binomial, data = crabs)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.6651  -1.3370   0.7997   0.7997   1.5134  
## 
## Coefficients:
##             Estimate Std. Error z value Pr(>|z|)  
## (Intercept)   0.3677     0.3066   1.199   0.2304  
## colordarker  -1.1299     0.5509  -2.051   0.0403 *
## colorlight    0.7309     0.7338   0.996   0.3192  
## colormedium   0.6083     0.3834   1.587   0.1126  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 225.76  on 172  degrees of freedom
## Residual deviance: 212.06  on 169  degrees of freedom
## AIC: 220.06
## 
## Number of Fisher Scoring iterations: 4
```
Note that summarizing a *glm* object returns ...

Use the **confint** function to obtain confidence intervals for regression coefficients

```r
confint(mod)
```

```
## Waiting for profiling to be done...
```

```
##                  2.5 %      97.5 %
## (Intercept) -0.2267868  0.98434649
## colordarker -2.2582397 -0.07752474
## colorlight  -0.6283228  2.33592185
## colormedium -0.1479567  1.36129471
```
The 95% confidence interval for $\beta_1$ reveals that ...
