---
title: EX | Remote Sensing - classification hands on 
toc: true
header:
  image: /assets/images/unit02/31031723265_0890cd9547_o.jpg
  image_description: "Cloudscape Over the Philippine Sea"
  caption: "Image: [NASA's Marshall Space Flight Center](https://www.nasa.gov/centers/marshall/home/index.html) [CC BY-NC 2.0] via [flickr.com](https://www.flickr.com/photos/nasamarshall/31031723265/)"
---

Remote sensing is a core method in all spatial knowledge sciences. It is used to generate knowledge about the properties and processes of the Earth's surface and the atmosphere as well as in all microscale imaging techniques.

<!--more-->

In the geosciences, remote sensing is the only measurement technique that provides complete coverage of large spatial scales. Research also necessarily includes developing one's own methods, especially with respect to the processing chains, but also in the coupling of suitable and established methods.  

Change detection using satellite, aircraft and drone imagery is a central component of environmental informatics. Often this is used in conjunction with bio- and geophysical or human-induced processes for more in-depth understanding and the possibility to develop predictive models. Here, image analysis methods are central for extracting information that allows the underlying processes to be identified. An increasingly important aspect is the integration of Big Data analytics.

The growing and now already overwhelming flood of imagery and remote sensing data available needs to be readily accessed and used for both scientific knowledge gain and societal future challenges. We begin this practical application in this exercise.

## Assesment
Raw or original satellite images are not necessarily informative. Our eyes can interpret a true-color image rather easily, but a reliable and reproducible scientific interpretation requires other approaches. Moreover, image processing methods can derive additional, more specific information. We already learned about NDVI in the [R-spatial Warm Up](unit01-05_warm-up-r-spatial.html#step-4---calculate-rgb-indices). Deriving the surface albedo is also the physically based conversion of image signals into a physical quantity. 

Consequently, in order to obtain useful information about, e.g., land cover in an area, we need to analyze the data in a goal-directed manner. The best known and most common approach is to classify the images into categories of interest.

This exercise introduces you to the classification of satellite and aerial survey data in `R`. As such, it covers the following:

1. Preparing the work environment and loading the data
1. Using a variety of new packages and signature helper functions
1. Quick & dirty digtalization of training areas 
1. unsupervised/supervised classification 
  * k-means (via `RStoolbox`)
  * recursive partitioning and regression trees (via `rpart`)
  * random forest (via `caret`) 
  
This tutorial uses the Sentinel-2 imagery from the previous exercise. You may also use the digitized classes from the exercise before. Note, however, that this method can be used with virtually any data from earth observation satellites and aerial surveys. 

## Step 1 - Set up the script
You can either use the saved data from the previous unit or download and edit a new section for practice. In principle, however, the working environment is loaded first.
```r
#------------------------------------------------------------------------------
# Type: script
# Name: hands-on.R
# Author: Chris Reudenbach, creuden@gmail.com
# Description:  retrieves sentinel data 
#               defines AOI and performs classification tasks
# Dependencies: geoAI.R  
# Output: original sentinel tile 
#         AOI window of this tile (research_area)
#         unsupervised classification with kmeans (via RStoolbox)
#         supervised classification recursive partitioning and regression trees (via rpart)
#         random forest (via caret) 
#         superclust (automated random forest via RStoolbox)# Copyright: Chris Reudenbach 2021, GPL (>= 3)
# git clone https://github.com/gisma-courses/courses-scripts/geoAI.git
#------------------------------------------------------------------------------

# 0 - specific setup
#-----------------------------
library(envimaR)
appendpackagesToLoad = c("rprojroot","sen2R","terra","patchwork","ggplot2",
                         "mapedit","dplyr","mapview","tidyverse","rpart","rpart.plot",
                         "rasterVis","caret","forcats","RStoolbox","randomForest",
                         "e1071")

# add define project specific subfolders
appendProjectDirList = c("data/sentinel/",
                         "data/vector_data/",
                         "data/sentinel/S2/",
                         "data/sentinel/SAFE/",
                         "data/sentinel/research_area/")

source(file.path(envimaR::alternativeEnvi(root_folder = "~/edu/geoAI",
                                          alt_env_id = "COMPUTERNAME",
                                          alt_env_value = "PCRZP",
                                          alt_env_root_folder = "F:/BEN/edu"),
                 "src/geoAI_setup.R"))


# 2 - define variables
#---------------------

# subsetting the filename(s) of the interesting file(s)
fn_noext=xfun::sans_ext(basename(list.files(paste0(envrmt$path_research_area,"/BOA/"),pattern = "S2B2A")))
fn = basename(list.files(paste0(envrmt$path_research_area,"/BOA/"),pattern = "S2B2A"))

# creating a raster stack
stack=raster::stack(paste0(envrmt$path_research_area,"/BOA/",fn))


```
## Step 2 - Using helper functions and packages

In general, we could program almost everything ourselves using the basic `raster` / `terra` and `sp` / `sf` packages. However, this would require enormous effort on our part. `R` lives from its community and the 20,000+ tested packages that they have published. In addition, there are countless blogs and code snippets provided by users and developers. In this vein, it is certainly an art to find the "right" or most suitable material and make it usable. For the task that we want to accomplish, we will now use a variety of packages and some functions.

For didactic and understanding reasons we will use (somewhat arbitrarily) some helper functions from Sydney Goldstein's [blog](https://urbanspatial.github.io/classifying_satellite_imagery_in_R/), which deals with classifying satellite imagery. 

Please note that there are plenty of blogs and help out there ([rspatial - supervised   classification](https://rspatial.org/raster/rs/5-supclassification.html), [RPubs Tutorial](https://rpubs.com/ials2un/rf_landcover), Sydney's [blog](https://urbanspatial.github.io/classifying_satellite_imagery_in_R/), 
[supervised classification](https://www.r-exercises.com/2018/03/07/advanced-techniques-with-raster-data-part-2-supervised-classification/) or [pixel-based supervised classification](https://valentinitnelav.github.io/satellite-image-classification-r/)).
None of them is intended to be a scientific or content reference. It is like the author of the last blog, Valentin Stefan, says *"[...]Treat this content as a blog post and nothing more. It does not have the pretention to be an exhaustive exercise nor a replacement for your critical thinking.[...]"* 

This is simply an example of how a specific set of tools emerges from such sources (which are all more or less technically similar), which describe how something is done. This is a good starting point. After a lot of research and critical examination, this somehow emerged as the current state of the art within the community. So, please check if all libraries are available.
```r
 c("rprojroot","sen2R","terra","patchwork","ggplot2",
 "mapedit","dplyr","mapview","tidyverse","rpart","rpart.plot",
 "rasterVis","caret","forcats","RStoolbox","randomForest", "e1071")
```
## Step 3 - Capture training data 
The next step is optional but offers the possibility to quickly and effectively digitize some training areas without leaving the RStudio world. For larger tasks, it is essential to refer to the high comfort of the QGIS working environment as described in [EX Digitizing training areas](unit02-03_digitize_training_areas.html). For this exercise we use `mapedit`, a small but nice package that allows onscreen digitizing in Rstudio or in a browser. In combination with `mapview` it is really comfortable for fast-forward digitizing. Especially helpful is the comfortable way to produce true or false [color composites](https://custom-scripts.sentinel-hub.com/custom-scripts/sentinel-2/composites/). 

### Color composites for better training results

Just as a reminder, the following command creates a Sentinel true color composite. Combining them with a `+` gives you an object with both layers.

```r
# sentinel truecolor composite 
mapview::viewRGB(stack, r = 4, g = 3, b = 2) + mapview::viewRGB(stack, r = 8, g = 4, b = 3)
```

{% include media1 url="assets/images/unit02/cc.html" %}
[Full-screen version of the map]({{ site.baseurl }}/assets/images/unit02/cc.html){:target="_blank"} 
<figure>
  <figcaption>Sentinel-2 True Color Composite RGB (4, 3, 2), Date: 2021-06-13 Region Marburg Open Forest.
  Use the layer control to toggle the layers.
  True color composites assign the visible spectral channels red (B04), green (B03), and blue (B02) to the corresponding red, green, and blue color channels, respectively, resulting in a quasi-naturally "colored" image of the surface as it would be seen by a human sitting on the satellite.
  False color images are often produced with the near-infrared, red and green spectral channels. It is excellent for estimating vegetation because plants reflect near-infrared and green light while absorbing red light (the Red Edge Effect). Denser plant cover is darker red. Cities and open ground are gray or light brown, and water appears blue or black. 
  </figcaption>
</figure>


### Digitize fast forward training data

We specify that we want to classify four types of land cover: forest, fields, meadows and settlements.
Each class is digitized and typed in a single way. 

```r
fields <- mapview::viewRGB(stack, r = 8, g = 4, b = 3) %>% mapedit::editMap()
```
{% include figure image_path="/assets/images/unit01/fields.png" alt="The mapedit GUI. The digitization with mapedit is mostly self-explanatory and GUI-supported. After digitizing click on DONE." %}

Then proceed to the next step. This will assign the attributes *class* and *id*.
```r
fields <- train_area$finished$geometry %>% st_sf() %>% mutate(class = "fields", id = 2)
```

This is the full script for digitizing the training data.

```r
# note we can combine each of the Sentinel channels to derive a true or false color composite

# digitizing all areas with forest only
train_area <- mapview::viewRGB(stack, r = 8, g = 4, b = 3) %>% mapedit::editMap()
# add class (text) and id (integer number)
forest <- train_area$finished$geometry %>% st_sf() %>% mutate(class = "forest", id = 1)

# fields only
train_area <- mapview::viewRGB(stack, r = 4, g = 3, b = 2) %>% mapedit::editMap()
fields <- train_area$finished$geometry %>% st_sf() %>% mutate(class = "fields", id = 2)

# meadows only
train_area <- mapview::viewRGB(stack, r = 4, g = 3, b = 2) %>% mapedit::editMap()
meadows <- train_area$finished$geometry %>% st_sf() %>% mutate(class = "meadows", id = 3)

# settlements only
train_area <- mapview::viewRGB(stack, r = 8, g = 4, b = 3) %>% mapedit::editMap()
settlement <- train_area$finished$geometry %>% st_sf() %>% mutate(class = "settlement", id = 4)

# bind it together to one file
train_areas <- rbind(forest, fields, meadows, settlement)

# save results
saveRDS(train_areas, paste0(envrmt$path_sentinel,"train_areas.rds"))

``` 

## Step 4 - Classification 
There are numerous methods to classify data in feature space. In principle, these can be *unsupervised* or *supervised*.  In the case of unsupervised methods, the number of classes is usually specified and statistical methods are used to search for the best possible aggregation within the number of these classes in the feature space. 

#### Manipulating the training data 
First of all, we have to prepare the digitized data. This involves arranging the data for the variety of algorithms that we want to use.

```r
# first we have to project the data into the correct crs
tp = sf::st_transform(train_areas,crs = sf::st_crs(stack))
## next we extract the values from every band of the raster stack 
# we force the values to be returned as an data frame
# because extracting the raster way is very slow
DF <- raster::extract(stack, tp, df=TRUE) 
# we rename the layers for simplicity
names(DF) = c("id","band1","band2","band3","band4","band5","band6","band7","band8","band9","band10","band11")
# now we add the "class" category which we need later on for training
# it was dropped during extraction
DF_sf =st_as_sf(inner_join(DF,tp))
# finally we produce a simple data frame without geometry
DF2 = DF_sf
st_geometry(DF2)=NULL
```


### k-means clustering out of the box
The best known unsupervised classification techniques is `k-means` clustering, which could be called one of the simplest unsupervised machine learning algorithms.
In our example (applied for 4 classes and executed with `RStoolbox` for simplicity), it looks like this:

```r
## k-means via RStoolbox
prediction_kmeans = unsuperClass(stack, nSamples = 25000, nClasses = 4, nStarts = 25,
                                 nIter = 250, norm = TRUE, clusterMap = TRUE,
                                 algorithm = "MacQueen")
mapview(prediction_kmeans$map, col = c('darkgreen', 'burlywood', 'green', 'orange'))

```
{% include media1 url="assets/images/unit02/kmeans.html" %}
[Full-screen version of the map]({{ site.baseurl }}/assets/images/unit02/kmeans.html){:target="_blank"} 
<figure>
  <figcaption>k-means clustering based on Sentinel-2 channels 1-11, Date: 2021-06-13 Region Marburg Open Forest, As you can see and interactively compare without doing anything, it returns a classification that is visually pretty good. </figcaption>
</figure>

### Recursive Partitioning and Regression Trees
Our first supervised algorithm belongs to the family of non-linear classification algorithms, which is based on decision trees. Classification and Regression Trees (CART) split attributes (our training data) based on values that minimize a loss function, such as sum of squared errors. They are fast and rather efficient.

```r
# defining the model 
cart <- rpart(as.factor(DF2$class)~., data=DF2[,2:12], method = 'class')# the tree
rpart.plot(cart, box.palette = 0, main = "Classification Tree")
```
{% include figure image_path="/assets/images/unit02/cart_tree.png" alt="CART tree as derived from the upper model. You can see each split and the probabilities." %}

After calculating the model and checking the tree, we succeed with the prediction. That means the model is applied to the original data stack and the pixels are classified according to the tree splits.

```r
prediction_cart <- raster::predict(stack, cart, type='class', progress = 'text')  
mapview(prediction_cart,col.regions = c('darkgreen', 'burlywood', 'green', 'orange'))
```

{% include media1 url="assets/images/unit02/cart.html" %}
[Full-screen version of the map]({{ site.baseurl }}/assets/images/unit02/cart.html){:target="_blank"} 
<figure>
  <figcaption>CART classification based on Sentinel-2 channels 1-11, Date: 2021-06-13 Region Marburg Open Forest, As you can see and interactively compare, this is obviously more sophisticated than running a k-means clustering. It relies on the training data heavily. </figcaption>
</figure>

### Random forest decision trees
Random forest is a classification and regression method consisting of arbitrary uncorrelated decision trees. The decision trees are generated iteratively during a training (learning) process. For a classification, each (decision) tree in this forest of decision trees represents one decision. The class (e.g., fields) with the most individual trees decides the final classification. It is one of the most widely used methods of machine learning because it is robust, versatile and one of the most efficient ML methods.

```r
## random forest via caret
set.seed(123)
# split data into train and test data and take only a fraction of them
trainDat =  DF2[createDataPartition(DF2$id,list = FALSE,p = 0.25),]
# define a training control object for caret with cross-validation, 10 repeats
ctrlh = trainControl(method = "cv", 
                     number = 10, 
                     savePredictions = TRUE)
# train random forest via caret model 
cv_model = train(trainDat[,2:12],
                 trainDat[,13],
                 method = "rf",
                 metric = "Kappa",
                 trControl = ctrlh,
                 importance = TRUE)


prediction_rf  = predict(stack ,cv_model, progress = "text")
mapview(prediction_rf,col.regions = c('darkgreen', 'burlywood', 'green', 'orange'))

```

{% include media1 url="assets/images/unit02/rf.html" %}
[Full-screen version of the map]({{ site.baseurl }}/assets/images/unit02/rf.html){:target="_blank"} 
<figure>
  <figcaption> Random Forest classification based on Sentinel-2 channels 1-11, Date: 2021-06-13 Region Marburg Open Forest. As you can see and interactively compare, this out-of-the-box rf classification is better than CART. However, it is still rather poor because it depends heavily on the training data and, hence, must be tuned.</figcaption>
</figure>

### CART with *a priori* knowledge

We repeat the CART model, but this time we use an estimate of what proportion of each class that we expect. This knowledge is known as *a priori* knowledge. Let's see if we can improve the results. 
```r
# defining the model 
cart <- rpart(as.factor(DF2$class)~., data=DF2[,2:12], method = 'class',
              parms = list(prior = c(0.65,0.25,0.05,0.05)))# the tree
rpart.plot(cart, box.palette = 0, main = "Classification Tree")
```
{% include media1 url="assets/images/unit02/cart_priory.html" %}
[Full-screen version of the map]({{ site.baseurl }}/assets/images/unit02/cart_priory.html){:target="_blank"} 
<figure>
  <figcaption>CART classification based on Sentinel-2 channels 1-11, Date: 2021-06-13 Region Marburg Open Forest. As you can see, providing some *a priori* estimates yields better results </figcaption>
</figure>

What we see is that there is a lot to learn for accurate modeling, especially in how to deal with sampling of training data and tuning.

## Assignment Unit-2-2

Now that you have seen some of the basics, it's time to practice again on your own. The following tasks serve as an orientation framework within which you can practice in a targeted manner. Please read this [review of classification approaches in remote sensing](https://isgindia.org/wp-content/uploads/2017/04/016.pdf) and perform the following tasks:

{% capture Assignment-1-2 %}
1. If not already done, improve your training data and digitize the classes "buildings", "fields", "meadows","forest/trees/hedges" and "roads", 
1. Please apply the techniques described above on both the Sentinel-2 dataset and the airborne imagery dataset.
1. Read and work through the following [section](https://rspatial.org/raster/rs/5-supclassification.html). Please apply the evaluation and tuning part on the CART model described above. What is your finding with respect to model quality and improvement in comparison to the default  setting of the model and the unsupervised classification? Write a sentence (or two) that make suggestions for what we still need for a valid and optionally improved classification.

Again put your code and results in an `Rmarkdown` file and compile it to a PDF document for upload on ILIAS.

{% endcapture %}
<div class="notice--success">
  {{ Assignment-1-2 | markdownify }}
</div> 


## Where can I find more information?
For more information, you can look at the following resources: 

* [Straightforward overview RS and classification](https://gisgeography.com/image-classification-techniques-remote-sensing/)

* [Typical workflow](https://www.mdpi.com/2072-4292/9/10/1048)

## Comments?
<script src="https://gist.github.com/Baldl/2da3c6b15443b9a629af8246fd3a71b5.js"></script>