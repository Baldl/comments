---
title: LM | Randomly Good
toc: true
header:
  image: /assets/images/unit03/streuobst.jpg
  image_description: "Apples under tree"
  caption: "Image: manfredrichter via [pixabay.com](https://pixabay.com/de/photos/%C3%A4pfel-streuobst-obstbaum-apfelbaum-3684775/)"
 
---

Predicting spatial features with machine learning and random validation. 
Our goal is to determine areas containing buildings in the south of Marburg, Hesse. To accomplish this goal, we will use a machine learning approach together with DOPs (digital orthophoto) as well as the digitalized polygons with one class containing buildings, and the other class polygons covering everything else, we created in Unit 1.

<!--more-->

To do this, we want to create a model that is able to separate pixels that belong to a building from their surroundings. For this we need not only the bands of the DOP but also some indices calculated from them. You can simply use the ones we created in [Unit 1]( http://127.0.0.1:4000/geoAI//unit01/unit01-05_warm-up-r-spatial.html#step-4---calculate-rgb-indices). 

Our Area of Interest:
{% include media4 url="assets/images/unit03/marburg_dop.html" %} [Full screen version of the map]({{ site.baseurl }}assets/images/unit04/marburg_buildings.html){:target="_blank"}


## Random forest -- The basics
To accomplish this task, we will use a [random forest](https://en.wikipedia.org/wiki/Random_forest) machine learning approach. Random forests can be used for both regression or classification tasks, the latter of which is particularly relevant in environmental remote sensing. As with all other machine learning methods, the random forest model learns to recognize patterns and structures in the data on its own.

<p align="center">
  <img src = "../assets/images/unit03/Random_forest_diagram_complete.png">
</p>
*Image: Simplification of how random forest classifies data during training. Venkata Jagannath [CC BY-SA 4.0] via [wikipedia.org](https://commons.wikimedia.org/wiki/File:Random_forest_diagram_complete.png)*

The random forest algorithm learns about the data by building many decision trees -- hence, the name "forest". For classification tasks, as in the above diagram, the algorithm takes an instance from the training dataset and each tree (again, there are many) classifies that instance into a class. Ultimately, the instance is assigned to the class that is the outcome of the most trees. Of course, this is an oversimplified description of how random forest works. If you are interested in theory and math behind how the algorithm truly works, please see the paper by Breiman (linked below).

Since the random forest algorithm requires training data, it is a supervised learning method. This means that we, as users, must tell the algorithm what it is supposed to predict. In our case, in order for the algorithm to classify areas of buildings correctly, the training data must include and be labeled with different categories or land cover classifications (i.e., field, building, forest, water).

<p align="center">
  <img src="../assets/images/unit03/machine_learning.jpg">
</p>
*Image: Machine Learning. Chitra Sancheti [CC BY-SA 4.0] via [wikimedia.org](https://commons.wikimedia.org/wiki/File:Artificial_Intelligence_in_E-Commerce.jpg)*


We will also use a validation strategy to measure the quality of the model. We will use one of the most popular methods for validating models: cross-validation. The goal is to test how well the model generalizes on an independent data set. For example, if we perform a 5-fold cross-validation, the whole dataset available to the model is randomly split five times into a training and a validation dataset. Then the model is trained five times with the respective training data set and the quality of the model is determined with randomly selected validation data set.



{% include figure image_path="/assets/images/unit03/cross_validation.svg" alt="Leave-Location-Out Cross-validation" %}
*Image: Random cross-validation. Gufosowa [CC BY-SA 4.0] via [wikipedia.org](https://en.wikipedia.org/wiki/Cross-validation_(statistics)#/media/File:K-fold_cross_validation_EN.svg)*

{% include video id="Yh9KGcxT_O4" provider="youtube" %}

## Unit 3 slides
{% include pdf pdf="GeoAI-Unit03.pdf" %}

## Additional resources
Breiman, Leo (2001). "Random Forests". Machine Learning. 45 (1): 5-32. [https://doi.org/10.1023/A:1010933404324](https://doi.org/10.1023/A:1010933404324).

### Machine learning
Here are several videos that introduce the broad field of machine learning, in general, as well as the specific algorithm that we will use in this course: random forest. In addition to these videos, we encourage you to conduct independent research, as there are some great tutorials on the Internet.


A Gentle Introduction to Machine Learning (12:44):
{% include video id="Gv9_4yMHFhI" provider="youtube" %}
Decision Trees (17:21):
{% include video id="7VeUPuFGJHk" provider="youtube" %}
Decision Trees Part 2 - Feature Selection and Missing Data (5:15):
{% include video id="wpNl-JwwplA" provider="youtube" %}
Random Forests Part 1 - Building, Using and Evaluating (9:53):
{% include video id="J4Wdy0Wc_xQ" provider="youtube" %}
Random Forests Part 2 - Missing data and clustering (11:52):
{% include video id="sQ870aTKqiM" provider="youtube" %}
Random Forests in R (15:09):
{% include video id="6EXPYzbfLCE" provider="youtube" %}
Machine Learning Fundamentals - Cross Validation (6:04):
{% include video id="fSytzGwwBVw" provider="youtube" %}