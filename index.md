---
title       : San Franisco crime data analysis with Shiny
subtitle    : 
author      : Przemyslaw Zientala
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [quiz, bootstrap]            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Motivation

1. Crime is a **serious social problem**
2. **Data-driven approaches** are very useful for discovering crime patterns
3. **Interactive data visualization** tools are heavily used to **aid law enforcement** authorities make informed decisions
4. Interactive, easy-to-use and quickly modifiable **Shiny web apps** are perfect for such tasks

--- &radio

## **Warm-up question**

Is Shiny useful and cool?

1. _Yes!_
2. _Of course._
3. _It's obvious._
4. _Why did you even ask?_

*** .hint Really?
*** .explanation Is that even needed?

--- .class #id

## Using the app...

... is dead simple. Simply:

1. select desired options
2. press 'Execute'
3. **Analyse and enjoy!**

## *It's as easy as*

```r
2 + 2
```

```
## [1] 4
```

(That's the number of tabs in the app! Yay! [well, apart from "nitty-gritty", but who reads that])

--- .class #id

## Future of the app

Now that the power of Shiny has been discovered by me, the project will be regularly updated in the future, so **make sure to visit the project from time to time!**

What's ahead:
* Making the app more interactive
      + Add more options
      + Create a dashboard
* Making the visualizations prettier
      + Use d3.js (or "rCharts" - implementation)
* Classifying crime type
      + Build an ML model and output relevant statistics and predictions
