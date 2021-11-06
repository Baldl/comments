---
title: EX | Spatial Prediction
toc: true
header:
  image: /assets/images/unit03/streuobst.jpg
  image_description: "Apples under tree"
  caption: "Image: manfredrichter via [pixabay.com](https://pixabay.com/de/photos/%C3%A4pfel-streuobst-obstbaum-apfelbaum-3684775/)"
 
---
Spatial prediction, right this time!


We will once again predict orchard meadows in Hesse. You can use the same prepared and balanced dataset as in the last exercise. 


You can read your extracted data in the same manner as before. But now we also need to define the column that contains information about which row belongs to which polygon (Polygon ID).
```r
training =  readRDS(file.path(envrmt$path_model_training_data, "extr_train.RDS")) 


training = na.omit(training)
training$class <- as.factor(training$class)
# random forest
predictors = training[,3:10]
response = training[,"class"]

```
## Leave-Location-out Cross-Validation

Use a Leave-location-Out cross-validation as spatial cross-validation. For this purpose, the pixels of all polygons are separated into folds, with the function CreateSpacetimeFolds, using their ID.


```r
# leave location out cross-validation
indices <- CreateSpacetimeFolds(training, 
                                spacevar = "OBJ_ID", 
                                k=10, 
                                class = "class")

```

The folds are then passed to the trainControl function as an index.

```r

set.seed(10)
ctrl <- trainControl(method="cv",
                     index = indices$index,
                     savePredictions=TRUE,
                     allowParallel = TRUE)


```

## Forward-Feature-Selection

Instead of using the train function of the caret package, now we use the ffs function from the [CAST package](https://cran.r-project.org/web/packages/CAST/index.html). We do not apply any model tuning, but you should expect that the prediction will take a long time, since the many predictor variables have to be trained with each other. 

```r
#Forward-Feature-Selection (FFS)

# no model tuning
tgrid <- expand.grid(mtry = 2,
                     splitrule = "gini",
                     min.node.size = 1)




#run ffs model with Leave-Location-out CV
#set.seed(10)

ffsmodel <- ffs(predictors,
                response,
                method = "ranger",
                trControl =ctrl,
                tuneGrid = tgrid,
                num.trees = 100,
                importance = "permutation")



ffsmodel
saveRDS(file.path(envrmt$path_unit03_models), "ffsmodel.RDS")


```

Now predict the tree species again and compare the results as well as the selected variables to the results you achieved with the traditional random forest model. What are differences, similarities and peculiarities? 


{% capture Assignment-03-2 %}

## Assignment Unit-03-2

Add assignment
1. ...
2. ...

{% endcapture %}
<div class="notice--success">
  {{ Assignment-03-2 | markdownify }}
</div> 


## Comments?
<script src="https://gist.github.com/Baldl/963583e6b3ec41369a1cc301a9515ed1.js"></script>