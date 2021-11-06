---
title: EX | How well does the model perform?
toc: true
header:
  image: /assets/images/unit04/streuobst.jpg
  image_description: "Streuobstwiesen"
  caption: "Image: ulrichstill [CC BY-SA 2.0 DE] via [wikimedia.org](https://commons.wikimedia.org/wiki/File:Tuebingen_Streuobstwiese.jpg)"
---


Deep learning and spatial patterns

<!--more-->

```r
# load u-net

unet_model <-
  load_model_tf(file.path(envrmt$path_models, "unet_buildings.hdf5"), compile = FALSE)


# also prepare testing data
testing_dataset <-
  prepare_ds(
    testing,
    train = FALSE,
    predict = FALSE,
    img_size = img_size,
    batch_size = batch_size
  )



# get sample of data from testing data
t_sample <-
  floor(runif(n = 5, min = 1, max = 12))  

# simple comparision of mask, image and prediction
for (i in t_sample) {
  png_path <- testing
  png_path <- png_path[i, ]
  
  img <- image_read(png_path[, 1])
  mask <- image_read(png_path[, 2])
  pred <-
    image_read(as.raster(predict(object = unet_model, testing_dataset)[i, , , ]))
  
  out <- image_append(c(
    image_annotate(mask,"Mask", size = 10, color = "black", boxcolor = "white"),
    image_annotate(img,"Original Image", size = 10, color = "black", boxcolor = "white"),
    image_annotate(pred,"Prediction", size = 10, color = "black", boxcolor = "white")
  ))
  
  plot(out)
  
}


```
## Expected Output