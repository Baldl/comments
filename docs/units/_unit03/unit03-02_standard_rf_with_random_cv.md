---
title: EX | A randomly good model
toc: true
header:
  image: /assets/images/unit03/streuobst.jpg
  image_description: "Apples under tree"
  caption: "Image: manfredrichter via [pixabay.com](https://pixabay.com/de/photos/%C3%A4pfel-streuobst-obstbaum-apfelbaum-3684775/)"
 
---
Create a random forest model with random cross-validation.

## Read the data
In the first step, you need to import your previously prepared predictor variables (DOP and indices) as well as the building polygons. Combine all of your raster layers into one raster stack. Finally, make sure that each layer has a unique name. 

```r
# include set up script here
```




```r
# load rasterStack containing red, green, blue and NIR bands
rasterStack = raster::stack(file.path(envrmt$path_raw_data_aerial, "marburg_dop_rgbi.tif"))

# load the indices you calculated in the last exercise
indices = raster::stack(file.path(envrmt$path_unit03_aerial, "dop_indices.tif"))

# stack them all into one raster
rasterStack = raster::stack(rasterStack, indices)

# check that all names are unique
names(rasterStack)
``` 

At this point, it is also a good idea to check that the raster and polygons have the same Coordinate Reference System (CRS). A [CRS](https://en.wikipedia.org/wiki/Spatial_reference_system) is a set of parameters that determine how to display geographic coordinates (i.e. tell your computer how to represent the Earth and your data on your screen). Also, we need to make sure that each polygon has a unique ID. If the data does not include an ID number, add one.

```r
# now the vector data: use the sf package to load the file and check if the crs matches with the raster stack
pol = sf::read_sf(file.path(file.path(envrmt$path_raw_data_vector, "marburg_buildings_selfmade.gpkg")))
pol = sf::st_transform(pol, crs(rasterStack))

# add IDs to your polygons, if they don't have them
pol$OBJ_ID = 1:nrow(pol)
```
 
## Extract the data 
Next, we want to extract the values from the predictor raster stack for every pixel in the training polygons. You can think about the polygons like cookie cutters and the raster stack like several layers of cookie dough stacked on top of each other -- we want to cut the data out of each raster that corresponds to the polygon area, i.e. the buildings. The data gets formatted in a dataframe that we can merge with the original polygons, so that it returns the class information of the polygons.

```r
# to extract the data use raster::extract or the much faster package exactextractr
extr = exact_extract(rasterStack, pol, include_cols = c( "class",  "OBJ_ID"))
extr = extr[sapply(extr, is.data.frame)]
extr = do.call(rbind, extr)

saveRDS(extr, file.path(envrmt$path_model_training_data, "extraction.RDS"))
```

## Balancing
In some cases, you may want to use machine learning algorithms on data that is imbalanced. Imbalanced data occurs when the number of training polygons for one class is significantly larger (or smaller) than that of the other classes in the dataset. If we used imbalanced data, we may create a model that cannot properly predict for unknown data, because one class is either over- or underrepresented in the training data.
To counteract this, we will balance the data. To do so, we will use the dataframe with the extracted values for each pixel. First, we need to check how many pixel of each class are in our dataframe. Then, we downsample the larger class. This entails that we take a random sample of rows from the larger class that is equal to the number of rows in the smaller class. 

```r
extr = readRDS(file.path(envrmt$path_model_training_data, "extraction.RDS"))
extr = na.omit(extr)

buildings = extr[extr$class == "building",]
other = extr[extr$class == "other",]

nrow(buildings)
nrow(other)

# reduce the larger class by sampling the same amount of rows as are contained in the smaller class
set.seed(42)
other = other[sample(nrow(buildings)), ]

# combine the two dataframes
extr = rbind(other, buildings)
```

Then, we split the data into two sets: one for model training and the other for testing. We will use 80% of the data for training and 20% of the data for testing. We will use the function `createDataPartition` from the `caret` package for this task. This function is very useful, as it tries to maintain the ratio of each class in the datasets.

```r
trainIndex = caret::createDataPartition(extr$class, p = 0.8, list = FALSE)
training = extr[ trainIndex,]
testing = extr[ -trainIndex,]

saveRDS(training, file.path(envrmt$path_model_training_data, "extr_train.RDS"))
saveRDS(testing, file.path(envrmt$path_model_training_data, "extr_test.RDS"))
```

## Random Forest
Now we can finally start our first attempt to predict the buildings. As discussed before, we will use a simple random forest model with 10-fold cross-validation. Define your train control settings and use the `train` function from the package `caret` [(on CRAN)]( https://cran.r-project.org/web/packages/caret/index.html) to train your model. For an in-depth understanding of everything that this package is capable of, it is worth taking a look at the book [The caret Package](https://topepo.github.io/caret/).

```r
training = na.omit(training)
training$class <- as.factor(training$class)

# random forest
predictors = training[,3:10]
response = training[,"class"]
```

The first step here is to define your response and predictors. The response is just one column containing your class label, because we want to classify the rest of the image. The predictors are all of the columns with the information that we extracted from your raster stack. Be careful not to include anything else in your dataframe (e.g. the geometry).

Now, use the `caret` package to train a simple random forest model. Here, we use the method "rf" in the `train` function to do so. There are many other implementations of the random forest algorithm in `R` that you can explore, for example the `ranger` [package](https://cran.r-project.org/web/packages/ranger/index.html), which performs better. 

{% capture optional %}
### Optional

We also use the `expand.grid` function to do some [model tuning](https://en.wikipedia.org/wiki/Hyperparameter_optimization), as well. This might seem complicated, but put simply it returns a model with the parameters optimized for the best accuracy. 


```r
# create grid for tuning features
tgrid <- expand.grid(
  mtry = 2:4,
  splitrule = "gini",
  min.node.size = c(10, 20)
)
```
The function returns a “tuning grid” that contains several possible combinations of parameters for example:

||**mtry**|**splitrule**|**min.node.size**|
|1|2|gini|10|
|2|3|gini|10|
|3|4|gini|10|
|4|2|gini|20|
|5|3|gini|20|
|6|4|gini|20|

For each of this six parameter combinations one model gets trained. You can then determine which of the paramters performed best and use this as your final model. But be **careful** if you are using this method you are calculating not one but several models. The computation time will be a lot higher!
If you don´t want to tune your model set just one option for every parameter (e.g. mtry = 4).


{% endcapture %}
<div class="notice--info">
  {{ optional | markdownify }}
</div> 
 


```r
# create parallel cluster to increase computing speed
n_cores <- detectCores() - 1 
cl <- makeCluster(n_cores)
registerDoParallel(cl)


# control the parameters of the train function
ctrl <- trainControl(method="cv",
                     number = 10, #  number of folds
                     savePredictions = TRUE,
                     allowParallel = TRUE)

# train the model
model <- train(predictors,
               response,
               method = "ranger",
               trControl = ctrl,
               tuneGrid = tgrid,
               num.trees = 100,
               importance = TRUE)

# stop parallel cluster
stopCluster(cl)

# save the model
saveRDS(model, "model.RDS")
```

Congratulations, you have a fully developed random forest model! Now, you can predict the classifications for the whole study area. Take a closer look at the accuracy and Kappa values as well as the variable importance. What stands out to you about the values?

## Prediction
Since you probably want to admire your results now, it is worth bringing your model into the area by making a prediction on your predictor raster stack with your finished model.

```r
model <- readRDS(file.path(envrmt$models, "model.RDS"))

# use model to make a spatial prediction (SpatRaster)
prediction <- terra::predict(rasterStack, model, na.rm = TRUE)

# save prediction raster
terra::writeRaster(prediction, file.path(envrmt$prediction, paste0(species, "_pred.tif")), overwrite = TRUE)

# save SpatRaster as RDS
saveRDS(prediction, file.path(envrmt$prediction, paste0(species, "_pred.RDS")))
```

Your prediction might look something like the map below. As you can see, the model did not manage to distinguish the roofs of the houses from other sealed surfaces, such as roads and parking lots, even some of the fallow fields were classified as buildings. But the results of your model may look quite different. In general, however, the quality of a model depends to a large degree on its training areas, so try to use your classes to cover as wide a spectrum as possible.
{% include media4 url="assets/images/unit03/marburg_prediction.html" %} [Full screen version of the map]({{ site.baseurl }}assets/images/unit04/marburg_buildings.html){:target="_blank"}






## Validation
Finally, we need one more very important thing: a validation with independent data that has not been included in the model training. For this we use the 20% of the polygons that we left out at the beginning. Simply do the same extraction again as you did at the beginning for the training. Then a prediction is made for all pixels, and the predicted values are compared to the observed values in a matrix.

```r
model = readRDS(file.path(envrmt$models, paste0(model, "_ffs.RDS")))
predicted = stats::predict(object = mod, newdata = extr_val)
  
val_df = data.frame(ID = pull(extr_sub, idCol),
                      Observed = pull(extr_val, "class"), 
                      Predicted = predicted)
  
val_cm = confusionMatrix(table(val_df[,2:3]))
  
# output
saveRDS(val_cm, file.path(envrmt$validation, "confusionmatrix.RDS"))
```





{% capture Assignment-03-1 %}

## Assignment Unit-03-1

Add assignment
1. ...
2. ...

{% endcapture %}
<div class="notice--success">
  {{ Assignment-03-1 | markdownify }}
</div> 



## Comments?
<script src="https://gist.github.com/Baldl/81f25e80701c19d0bbd320a0114e2e50.js"></script>
