---
layout: default
permalink: /
root: true
---

<div align="center">
  <h1><em>{{site.title}}</em></h1>
  <h2><em>A Brief Introduction to R for Python Programmers</em></h2>
  <img src="{{'/files/cthulhu.svg' | relative_url}}" width="300" />
  <p><em>"Speak not to me of madness, you who count from zero."</em></p>
</div>

{% include toc.html %}

## Introduction

Years ago,
Patrick Burns wrote *[The R Inferno][r-inferno]*,
a guide to R for those who think they are in hell.
Upon first encountering the language after two decades of using Python,
I thought Burns was an optimist---after all,
hell has rules.

I have since realized that R does too,
and that they are no more confusing or contradictory than those of other programming languages.
They only appear so because R draws on a tradition unfamiliar to those of us raised with derivatives of C.
Counting from one,
copying data rather than modifying it,
lazy evaluation:
to quote [the other bard][pratchett],
these are not mad, just differently sane.

Welcome, then, to a universe where the strange will become familiar,
and everything familiar, strange.
Welcome, thrice welcome, to R.

> **Contributing**
>
> Contributions of all kinds are very welcome:
> please see [this page](./contributing/) for how to help,
> and our [Code of Conduct](./conduct/) for our community standards.

## Setting Up

{% include setup.md %}

## Who You Are

**Padma**, 27, has been building performance dashboards for a logistics company using Django and D3.
The company has just hired some data scientists who use R,
and who would like to rebuild some of those dashboards in Shiny.
Padma isn't a statistician,
but she's comfortable doing linear regression and basic time series analysis on web traffic,
and would like to learn enough about R to tidy up the analysts' code and get it into production.

Derived constraints:

- Learners understand loops, conditionals, writing and calling functions, lists, and dictionaries,
  can load and use libraries,
  can use classes and objects,
  but have never used generic functions
  and are probably not comfortable with higher-order functions.
- Learners understand mean, variation, correlation, and other basic statistical concepts,
  but are not familiar with advanced machine learning tools.
- Learners are comfortable creating and interpreting plots of various kinds.
- Learners have experience with spreadsheets
  and with writing database queries that use filtering, aggregation, and joins,
  but have not designed database schemas.
- Learners are familiar with version control and unit testing.
- Learners currently use a text editor like Emacs or Sublime rather than an IDE.
- Learners are willing to spend an hour on the basics of the language,
  both because they understand the utility and as a safety blanket,
  but will then be impatient to start tackling real tasks.

Learner questions:

- What are R's basic data types and how do they compare to Python's?
- How do conditionals and loops work in R compared to Python?
- How do I define functions?
- How do I find and install libraries and get help on them?
- How do I store and manipulate tabular data?
- How do I filter, aggregate, and join datasets?
- How do I create plots?
- How do I write readable programs in R?
- How do I test R programs?
- How do I create packages that other people can install?
- How does object-oriented programming work in R?
- What other differences between Python and R am I likely to trip over?

{% include links.md %}
