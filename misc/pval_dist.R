---
title: "Examination of test statistics and p-values"
author: "Mark Ziemann & Anusuiya Bora"
date: "`r Sys.Date()`"
output:
  html_document:
    toc: true
    toc_float: true
    code_folding: hide
    fig_width: 5
    fig_height: 5
theme: cosmo
---

Source: https://github.com/markziemann/enrichment_recipe

## Introduction

The issue is that the 50% difference which we used as a classifier for
reproduction of pathway p-values is not great when p-values are very small.

One possible solution is to use the test statistics instead.
We can use the chi-squared test for this case, with repeated tests with
different hypothetical tests, to ascertain the relationship between p-values
and the test statistics.

## Running the chi-squared test

In the next chunk, we are running a set of chi-squred tests, starting off with
balanced data and making it progressively more skewed, which will degrease
p-values.

```{r,chi1}

l <- lapply(0:40, function(x) {
  tulip <- c(100+x, 100-x)
  res <- chisq.test(tulip, p = c(1/2, 1/2))
  c("stat"=res$stat,"p"=res$p.value)
})

res <- as.data.frame(do.call(rbind,l))
res$logp <- -log10(res$p)

```

Now we can make a plot of the relationship of the -log10(p-values) and the
test statistics.

```{r,plot1}

plot(res$logp,res$`stat.X-squared`)

```

## Testing the bounds

Now we'll test plus and minus 50% the of the test statistic value.

```{r,bound1}

bound=0.5

res$lower <- res$`stat.X-squared` - ( res$`stat.X-squared` * bound )
res$upper <- res$`stat.X-squared` + ( res$`stat.X-squared` * bound )

res

```

That looks good but the bounds can be quite wide, approximately two orders of
magnitude in either direction.

```{r,bound2}

bound=0.25

res$lower <- res$`stat.X-squared` - ( res$`stat.X-squared` * bound )
res$upper <- res$`stat.X-squared` + ( res$`stat.X-squared` * bound )

res

```

Now it is 1.3 orders of magnitude.

```{r,bound2}

bound=0.15

res$lower <- res$`stat.X-squared` - ( res$`stat.X-squared` * bound )
res$upper <- res$`stat.X-squared` + ( res$`stat.X-squared` * bound )

res

```
 
0.68 orders of magnitude. 


