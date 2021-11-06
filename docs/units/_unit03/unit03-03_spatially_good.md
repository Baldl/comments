---
title: LM | Spatially Good
toc: true
header:
  image: /assets/images/unit03/streuobst.jpg
  image_description: "Apples under tree"
  caption: "Image: manfredrichter via [pixabay.com](https://pixabay.com/de/photos/%C3%A4pfel-streuobst-obstbaum-apfelbaum-3684775/)"
 
---

Resilient spatial predictions using appropriate selection and validation strategies.

<!--more-->

In spatial forecasting, there are some special features that must be taken into account when selecting methods. Spatial data cannot be treated like other data sets. As we saw in Unit 1, proximity does not necessarily have anything to do with context. Nevertheless, proximity is an important issue when we try to validate spatial models. 

In the last exercise, we created a random forest model and validated it using a standard 10-fold random cross-validation (CV). For this type of CV, the dataset was split randomly. Even though this type of CV is standard in many studies, this process ignores where exactly the pixels were once in space when it selects the validation and training datasets. This can result in pixels from a polygon being used for both training and validation. But is it bad if pixels from the same polygon are in the training and validation datasets? 

Yes, because this leads to the data being spatially autocorrelated. What does spatial autocorrelation mean? It means that the dataset that should be used to validate the model is too similar to the training dataset, and that the model will be estimated to be significantly better than it actually is (see e.g. [Ploton et al. 2020]( https://www.nature.com/articles/s41467-020-18321-y)).

So we need a spatial validation model that is better suited for spatial data. To tackle this problem, we will swap the random CV with a spatial CV, namely [Leave-Location-Out (LLO)](https://cran.r-project.org/web/packages/CAST/vignettes/CAST-intro.html#target-oriented-validation). 


{% include figure image_path="/assets/images/unit03/llo_cv.png" alt="Leave-Location-Out Cross-validation" %}
*Image: Concept of random and spatial cross-validation (CV): A total dataset (here: 9 different data points represented by different shapes) is split into k folds (here: k=3). Models are then repeatedly trained by always leaving one of the folds out and use it for model validation and not for model training. Random CV means that the data are randomly split into folds. Spatial CV means that the data are split into folds according to spatial location (e.g. a spatial cluster or a spatial block, here represented by unique color). Figure modified from Meyer et al. (2018) and Kuhn & Johnson (2013). Meyer, Hanna & Reudenbach, Christoph & Wöllauer, Stephan & Nauss, Thomas. (2019). Importance of spatial predictor variable selection in machine learning applications -- Moving from data reproduction to spatial prediction. Meyer H, Reudenbach C, Wöllauer S, Nauss T (2019) [CC BY-NC-SA 4.0] via [researchgate.net](https://www.researchgate.net/figure/Concept-of-random-and-spatial-cross-validation-CV-A-total-dataset-here-9-different_fig3_335318909)*



The function `CreateSpacetimeFolds` from the R package [CAST]( https://cran.r-project.org/web/packages/CAST/CAST.pdf) implements LLO CV. To do this, the pixels are grouped in a dataframe according to the polygon, in which they are located, so that only whole locations (polygons) are used for either validation **or** training. Ultimately, this prevents us from assuming that the model is better than it actually is.

LLO CV removes spatial autocorrelation, which is critical to finding out how accurate our model is. But we also want efficient models, so we will also perform a spatial variable selection. Variable selection is a process that selects only the most relevant predictors from all of our variables and disregards all of the rest. For the spatial variable selection, we will use another function from the same package: forward feature selection (FFS). In a nutshell, FFS trains models using every possible combination of 2 predictors and keeps the model with the best performance. Then, it continues to add additional variables (3, 4, 5, etc.) until the performance stops improving. Read more about FFS [here](https://www.rdocumentation.org/packages/CAST/versions/0.2.0/topics/ffs)).

Please familiarize yourself with LLO and FFS by reading the corresponding article.


## Further reading
Meyer H, Reudenbach C, Hengl T, Katurji M, Nauss T (2018) Improving performance of spatio-temporal machine learning models using forward feature selection and target-oriented validation. Environmental Modelling & Software 101: 1-9. [https://doi.org/10.1016/j.envsoft.2017.12.001](https://www.sciencedirect.com/science/article/abs/pii/S1364815217310976).

Meyer H, Reudenbach C, Wöllauer S, Nauss T (2019) Importance of spatial predictor variable selection in machine learning applications -- Moving from data reproduction to spatial prediction. Ecological Modelling 411: 108815.[https://dx.doi.org/https://doi.org/10.1016/j.ecolmodel.2019.108815 ](https://www.sciencedirect.com/science/article/abs/pii/S0304380019303230#!)

## Still have questions?
We highly recommend the following talk, which addresses the issues in more detail:

* Hanna Meyer: ["Machine-learning based modelling of spatial and spatio-temporal data"](https://www.youtube.com/watch?v=QGjdS1igq78&t=2676s) (53:24)