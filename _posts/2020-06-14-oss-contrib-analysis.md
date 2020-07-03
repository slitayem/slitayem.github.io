---
layout: post
title: "How do developers perceive the OSS quality and how often do they contribute?"
date: 2020-06-14
excerpt_separator: <!--more-->
---

<!-- ![](https://cdn.sstatic.net/Sites/stackoverflow/company/Img/logos/so/so-logo.png?v=9c558ec15d8a){:height="50%" width="50%"} -->
![oss](/img/blog/2020-06-14/open-source-software.png){:height="85%" width="85%" .center-image}

Several studies {% cite Finnegan2007HowPO %} {% cite bianco2010%} {% cite Lenarduzzi2019%} {% cite Lenarduzzi2020 %} have shown that the motivations to adopt OSS have changed over time towards a better perception of it. OSS has been experiencing an [increasing](https://techcrunch.com/2019/01/12/how-open-source-software-took-over-the-world/) interest particularly in [industry](https://techcrunch.com/2019/01/12/how-open-source-software-took-over-the-world/). This can be seen by [Microsoft\'s position](https://www.lightreading.com/enterprise-cloud/digital-transformation/how-microsoft-became-an-unlikely-open-source-champion/a/d-id/740691) change on OSS development over the past two decades.

Since 10 years stackoverflow have been publishing annual [Developer Survey](https://insights.stackoverflow.com/survey/) results always showing insightful key results. Digging deeper into the survey from 2019 let us know more about the Open Source Software (OSS) contributions as well as the developers perception of OSS quality.

We will answer to the following questions from the survey data:

* [How often do developers contribute to OSS?](#contrib_freq)
* [Do Hobyist developers contribute more often to OSS?](#hobbyist_dev)
* [Does OSS quality perception play a bias role towards OSS contribution?](#oss_quality_bias)
* [Are experienced developers contributing more frequently to OSS?](#experience)
* [Are developers contributing to the OSS earning more?](#salary)

The analysis notebook is available [here](https://github.com/slitayem/stackoverflow_survey_analysis).

Let's start with a quick overview of the data.
We see that most of the survey respondents are from the USA.

![](/img/blog/2020-06-14/top15_countries.png){:height="70%" width="70%" .center-image} 

More than 80% of the respondents are developers.

![](/img/blog/2020-06-14/developer_type.png){:height="70%" width="70%" .center-image} 

Most of the respondents are preceiving the OSS quality the same as or even of HIGHER quality than the closed source software.


![](/img/blog/2020-06-14/oss_perception_respondents.png){:height="80%" width="80%" .center-image}

<a name="contrib_freq"></a>
## How often do developers contribute to OSS?
36.3 % of the developers have never contributed to Open Source Software while 63.6 % contribute to the OSS. But we see that only only 12.4% contribute once a month or more often.

![](/img/blog/2020-06-14/oss_contribution_frequency.png){:height="70%" width="70%" .center-image} 

<a name="hobbyist_dev"></a>
## Do Hobyist developers contribute more often to OSS?

![](/img/blog/2020-06-14/hobbyist_oss_contribution.png){:height="70%" width="70%" .center-image} 

The analysis shows that the hobbyist developers contribute more often to the OSS than non hobbyist ones. But among the survey respondents 23K hobbyists (32% of the hobbyists) have never contributed to the OSS.

<a name="oss_quality_bias"></a>
## Does OSS quality perception play a bias role towards OSS contribution?
What if a bad OSS quality perception happens to be a blocker for OSS contribution. The respondents are then separated in two groups (hobbyists or not hobbyists). Then, respondents are grouped by the way they are perceiving OSS quality in addtion to the frequency of contribution to OSS.
The data analysis shows that developers contributing the least to OSS are the ones who are perceiving OSS as on average of lower quality than proprietary software and not developing as a hobby.

![](/img/blog/2020-06-14/oss_quality_perception.png){:height="90%" width="90%" .center-image} 

<a name="experience"></a>
## Are experienced developers contributing more frequently to OSS?
In the figure below, I was interested in checking the seniority level of developers contributing to OSS. For that, the survey respondents are grouped by years of experience ranges.

We notice that the more years of experiences developers gain the less they contribute to OSS.

![](/img/blog/2020-06-14/oss_experience_years_groups.png){:height="70%" width="70%" .center-image} 

<a name="salary"></a>
## Are developers contributing to the OSS earning more?
The respondents salary data shows significant skewness and kurtosis.

    Kurtosis 18551.71
    Skew 136

The salary distribution appears to be right-tailed. For a better interpretation of the data I removed the outliers massively skewing it. Then, only salaries less than `20 * salary median` are kept. The figure below shows the salary distribution after outliers removal from the data.

![](/img/blog/2020-06-14/salary_distribution.png){:height="70%" width="70%" .center-image}

The mean salary appears to be higher for respondents who are contributing more often for the OSS. The reason for that might be because developers are acquiring more experience and seniority not only by the number of years in working experience but also while contributing to more projects and learning from the OSS community. Much Open Source work is volunteered. But for some developers especially when contributions require significant time, [getting paid](https://opensource.guide/getting-paid/) to contribute to OSS is the only way they can participate. That might also be a reason for which OSS contributors are earning more than others.

![](/img/blog/2020-06-14/opensourcers_av_salary.png){:height="60%" width="60%" .center-image} 

# Conclusion
In this article, we took a look at the OSS contribution of developers according to Stack Overflow 2019 survey data. We checked developers perception of the OSS as well as wether they code as a hobby or not. That showed that developers coding as a hobby and having a good perception of OSS are more likely to contribute to OSS. Finally, we looked at the mean salary for each frequency of contribution group. We found that those who contributing more often to the OSS are more likely to earn a higher salary. The findings here are observational, not the result of a formal study.

References
------------------------

{% bibliography --cited  %}

