---
root: true
redirect_from: "/"
permalink: "/en/"
---

<div align="center">
  <h1><em>The Tidynomicon</em></h1>
  <h2><em>A Brief Introduction to R for Python Programmers</em></h2>
  <img src="{{'/figures/cthulhu.svg'|relative_url}}" width="300" />
  <p><em>"Speak not to me of madness, you who count from zero."</em></p>
</div>

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

## Who are these lessons for? {#s:index-personas}

Andrzej
:   completed a Master's in library science five years ago
    and has worked since then for a small consulting company.
    He learned Python by doing data science courses online,
    but has no formal training in programming.
    He just joined team that primarily uses R Markdown;
    these lessons will show him how to translate his understanding of Python to R.

Padma
:   has been building performance dashboards for a logistics company using Django and D3.
    The company has just hired some data scientists who use R,
    and who would like to rebuild some of those dashboards in Shiny.
    Padma isn't a statistician,
    but she's comfortable doing linear regression and basic time series analysis on web traffic,
    and would like to learn enough about R to tidy up the analysts' code and get it into production.

{% include links.md %}
