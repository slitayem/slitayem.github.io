---
layout: post
title: "Customers churn prediction for Sparkify music service"
date: 2020-08-04
excerpt_separator: <!--more-->
---

{% include mathjax.html %}
![customer churn](/img/blog/2020-08-04/churn.png){:height="85%" width="85%" .center-image}

Generally, the ability to accurately predict future customer churn rates is [necessary](https://baremetrics.com/academy/churn-prediction-can-improve-business) for the business. It enables it to [secure](https://www.profitwell.com/blog/churn-prediction) valuable customers helping anticipate and prevent from churn trends.

Taking action to secure the customer’s time and attention, and bring it back to the product will increase engagement. And once product engagement is increased, the business will lose less customer.

> ## Churn kills businesses; prevention keeps them healthy

The article presents a Customer Churn Prediction Model project done in the context of [Udacity Data Science Nanodegree](https://www.udacity.com/course/data-scientist-nanodegree--nd025) Program.


# Business Understanding

We are assuming a hypothetical music streaming service (like spotify) called Sparkify.
The users of the service can use either the Premium or the Free Tier subscription. The premium plan with the monthly fees payment enables the use of the service without any advertisements between the songs.

At any point the users can do any of the following:

- Upgrade from the free tier to the Premium subscription
- Downgrade from the Premium subscription to the free tier.
- Drop their account and leave the service

![customer churn](/img/blog/2020-08-04/customers_attrition.png){:height="40%" width="30%" .center-image}

The aim here is to:

- analyse the data,
- extract insights helping to identify churn indicators
- and then build a Machine Learning model helping to identify potential churning customers.

The data analysis, feature engineering and model building was implemented using Apache Spark. This can be found [here](https://github.com/slitayem/sparkify_dsnd).

> The value of having a predictive model for customer attrition is mainly in identifying customer churn risk where we don't already know that a risk exists.

Retaining existing customers circumvents the costs of seeking new and potentially risky customers, and allows organizations to focus more accurately on the needs of the existing customers by building relationships.

# Data

The used data contains the user activity events logs happening in the service. Those contain visited pages, service upgrade or downgrade events, demographic information and events timestamps.

Here are the events key attributes

    |-- artist: artist name
    |-- auth: authentication status
    |-- gender
    |-- itemInSession: Number of items in the session
    |-- length: double (nullable = true)
    |-- level: users subscription level
    |-- page: svisited page
    |-- registration: registration date
    |-- ts: levent timestamp

The presented data analysis was performed on a subset of the data (~28K events records). The data timespan is 63 days.

# Data Cleaning

8346 Events with empty string as UserId were removed
# Data Exploration

## Churn indicators

We define churning customers as the users who either downgraded their subscription plan or canceled their account. In other words, a churned customer is one who visited one of the service pages `Cancellation Confirmation` or `Submit Downgrade`.

Following the above definition, the service churn rate is equal to `41%`

![account type](/img/blog/2020-08-04/account_type_churn.png){:height="55%" width="55%" .center-image}

**customers registered for a longer period of time are less likely to churn (Loyal/Engaged).**

![loyal customers](/img/blog/2020-08-04/loyal_customers.png){:height="75%" width="75%" .center-image}


Checking the service usage over the time before churn event, we observe that around 96% of the users have an account for at least 20 days.
![account age](/img/blog/2020-08-04/service_usage_age.png){:height="55%" width="55%" .center-image}

Now let's have a look at the serive pages visit. We observe that the `82%` of the events are for the page `NextSong`. Then to better visualize the pages visits count we decide to filter out the `NextSong page.

## Number of visits per page

![page visits](/img/blog/2020-08-04/page_visits.png){:height="75%" width="75%" .center-image}

It appears that most of the page visit counts can have an effect on the user engagement e.g Thumbs Down, Roll Advert, NextSong

## Service usage and user engagement
In general, if a customer regularly uses the service, there is nothing to worry about. If, on the other hand, the customer’s usage level drops off, there is a need to find out why it dropped and what to do about it.

So let's measure the service usage and engagement of the users.
### Number of items per session by user type

![](/img/blog/2020-08-04/avg_songs_churn.png){:.center-image}
Number of items per session is lightly higher for engaged users.This might be because the engaged users can find more songs they like to listen to in the service platform.
### Number of items per session by account level

![](/img/blog/2020-08-04/avg_songs_level.png){:.center-image}
This might be because the engaged users can find more songs they like to listen to in the service platform.
### Number of songs and number of sessions distribution per user
![](/img/blog/2020-08-04/nb_items_session.png){:height="60%" width="60%" .center-image} 

![](/img/blog/2020-08-04/nb_sessions_users.png){:height="60%" width="60%" .center-image} 

Number of items per session is higher for engaged users. This might be because the engaged users can find more songs they like to listen to in the service platform. Which is making them loyal to the service over time.
### Customers interactions on the service platform

![](/img/blog/2020-08-04/thumbs_up.png){:height="60%" width="60%" .center-image} 
![](/img/blog/2020-08-04/thumbs_down.png){:height="60%" width="60%" .center-image}

It appears that churning users have less interactions in regard of giving a Thumbs up or down to a song.

### Average number of songs over the last 20 days
![](/img/blog/2020-08-04/avg_songs_20days.png){:height="55%" width="55%" .center-image}
The number of songs for `churning` users is decreasing over the last 20 days of logged events in the service. This might be more discriminant when using more data.

# Feature engineering

During the data analysis step we could extract some indicators that could be used as features to distinguish between churning and engaged customers. Here is the list of all the used features for the model.

The final list of features I decided to incorporate into my ML models were:

    - Number of songs per day over the last 20 days (array of 20 values)
    - registration_days (label encoded)
    - Average daily session duration
    - Average monthly session duration
    - Number of errors events
    - Number of songs per session
    - Number of thumbs up
    - Number of thumbs down
    - Last level of the user (Paid or Free)
    - Number of unique artists the user listened to
    - Daily number of items per session over the last 20 days (array of 20 values)
    - User Account age in days: uage duration since first log event day

# Model training and evaluation

We tried out various models to see how they compare and perform.
We used 5-fold cross-validation to tune the hyper-parameters for each one of the models

    Logistic Regression
    Random Forest
    Gradient Boosted Trees

Given churned users are a fairly small subset, we decided to use F1 Score and accuracy metric to evalute the model performance and select the winning model in term of model performance.

> `F1-Score`: This is the harmonic mean of Precision and Recall. It balances the tradeoff between precision and recall.
<center>$$
F1-Score = 2 * \frac{precision . recall}{precision + recall}
$$</center>
<br>
`Accuracy`: Describes the proportion of correct classifications mostly used when all the classes are equally important.
<br><center>$$
Accuracy = \frac{TP + TN}{TP + FP + TN + FN}
$$</center>
<br>
where TP = True positive; FP = False positive; TN = True negative; FN = False negative


![](/img/blog/2020-08-04/model_evaluation.png){:height="60%" width="60%" .center-image}

Gradient Boosted Trees turned to be the winning model predicting how likely is a user to churn.
# Conclusion

Let’s take a step back and look at the whole journey.

We wanted to predict customers churn for a hypothetical music streaming service. That using Apache Spark in all the Machine Learning process steps.
We implemented a model to predict the  customer propensity to churn. For that we performed `data cleaning`.

We then performed multiple `data explorations` to see how various indicators can help in distinguishing between `Churned` and `Engaged` users. Then, we defined the customer churn indicator. Some categorical and numerical features were then extracted from the dataset. And we performed `feature engineering` to define the list of features that could be fed into the Machine Learning model.
We split the data into training and validation data sets. And as a final step of the whole ML process we did model training by trying out the three different models: Gradient Boosted Tree, Logistic Regression, and Random Forest. We used cross validation and grid search to fine tune the different models. Their `performance` got compared using the `F1 score`.

Gradient Boosted Trees turned to be the winning model in predicting how likely is a user to churn. We achieved about `70%` accuracy, and `0.7` F1 score.

# Next Steps

 Load a more substantial dataset to a clustered Spark environment and run the training process with train, test and validation datasets.

# Further reading about customers churn

- [Customer Churn Metrics](https://blog.hubspot.com/service/customer-retention-metrics)
- [Managing Customer Success to Reduce Churn](https://www.forentrepreneurs.com/customer-success/)
- [8 Advanced Tips for Never Losing SaaS Customers](https://neilpatel.com/blog/never-losing-saas-customers/)
- [How Churn Prediction Can Improve Your Business](https://baremetrics.com/academy/churn-prediction-can-improve-business)