---
title: EX | Unet
toc: true
header:
  image: /assets/images/unit04/streuobst.jpg
  image_description: "Streuobstwiesen"
  caption: "Image: ulrichstill [CC BY-SA 2.0 DE] via [wikimedia.org](https://commons.wikimedia.org/wiki/File:Tuebingen_Streuobstwiese.jpg)"
---

Deep learning and spatial patterns

<!--more-->

## U-net 

Now we are ready to define a unet. Don´t get frightened of by the length of this code section. Even if it might look scary at first glance the structure of the individual layers is actually quite repetitive.


```r

# 1 - U-net ####
#--------------#

get_unet_128 <- function(input_shape = c(128, 128, 3),
                         num_classes = 1) {
   
   inputs <- layer_input(shape = input_shape)
   # 128
   
   down1 <- inputs %>%
      layer_conv_2d(filters = 64, kernel_size = c(3, 3), padding = "same") %>%
      layer_batch_normalization() %>%
      layer_activation("relu") %>%
      layer_conv_2d(filters = 64, kernel_size = c(3, 3), padding = "same") %>%
      layer_batch_normalization() %>%
      layer_activation("relu")
   down1_pool <- down1 %>%
      layer_max_pooling_2d(pool_size = c(2, 2), strides = c(2, 2))
   # 64
   
   down2 <- down1_pool %>%
      layer_conv_2d(filters = 128, kernel_size = c(3, 3), padding = "same") %>%
      layer_batch_normalization() %>%
      layer_activation("relu") %>%
      layer_conv_2d(filters = 128, kernel_size = c(3, 3), padding = "same") %>%
      layer_batch_normalization() %>%
      layer_activation("relu")
   down2_pool <- down2 %>%
      layer_max_pooling_2d(pool_size = c(2, 2), strides = c(2, 2))
   # 32
   
   down3 <- down2_pool %>%
      layer_conv_2d(filters = 256, kernel_size = c(3, 3), padding = "same") %>%
      layer_batch_normalization() %>%
      layer_activation("relu") %>%
      layer_conv_2d(filters = 256, kernel_size = c(3, 3), padding = "same") %>%
      layer_batch_normalization() %>%
      layer_activation("relu")
   down3_pool <- down3 %>%
      layer_max_pooling_2d(pool_size = c(2, 2), strides = c(2, 2))
   # 16
   
   down4 <- down3_pool %>%
      layer_conv_2d(filters = 512, kernel_size = c(3, 3), padding = "same") %>%
      layer_batch_normalization() %>%
      layer_activation("relu") %>%
      layer_conv_2d(filters = 512, kernel_size = c(3, 3), padding = "same") %>%
      layer_batch_normalization() %>%
      layer_activation("relu")
   down4_pool <- down4 %>%
      layer_max_pooling_2d(pool_size = c(2, 2), strides = c(2, 2))
   #    # 8
   
   center <- down4_pool %>%
      layer_conv_2d(filters = 1024, kernel_size = c(3, 3), padding = "same") %>%
      layer_batch_normalization() %>%
      layer_activation("relu") %>%
      layer_conv_2d(filters = 1024, kernel_size = c(3, 3), padding = "same") %>%
      layer_batch_normalization() %>%
      layer_activation("relu")
   # center
   
   up4 <- center %>%
      layer_upsampling_2d(size = c(2, 2)) %>%
      {layer_concatenate(inputs = list(down4, .), axis = 3)} %>%
      layer_conv_2d(filters = 512, kernel_size = c(3, 3), padding = "same") %>%
      layer_batch_normalization() %>%
      layer_activation("relu") %>%
      layer_conv_2d(filters = 512, kernel_size = c(3, 3), padding = "same") %>%
      layer_batch_normalization() %>%
      layer_activation("relu") %>%
      layer_conv_2d(filters = 512, kernel_size = c(3, 3), padding = "same") %>%
      layer_batch_normalization() %>%
      layer_activation("relu")
   # 16
   
   up3 <- up4 %>%
      layer_upsampling_2d(size = c(2, 2)) %>%
      {layer_concatenate(inputs = list(down3, .), axis = 3)} %>%
      layer_conv_2d(filters = 256, kernel_size = c(3, 3), padding = "same") %>%
      layer_batch_normalization() %>%
      layer_activation("relu") %>%
      layer_conv_2d(filters = 256, kernel_size = c(3, 3), padding = "same") %>%
      layer_batch_normalization() %>%
      layer_activation("relu") %>%
      layer_conv_2d(filters = 256, kernel_size = c(3, 3), padding = "same") %>%
      layer_batch_normalization() %>%
      layer_activation("relu")
   # 32
   
   up2 <- up3 %>%
      layer_upsampling_2d(size = c(2, 2)) %>%
      {layer_concatenate(inputs = list(down2, .), axis = 3)} %>%
      layer_conv_2d(filters = 128, kernel_size = c(3, 3), padding = "same") %>%
      layer_batch_normalization() %>%
      layer_activation("relu") %>%
      layer_conv_2d(filters = 128, kernel_size = c(3, 3), padding = "same") %>%
      layer_batch_normalization() %>%
      layer_activation("relu") %>%
      layer_conv_2d(filters = 128, kernel_size = c(3, 3), padding = "same") %>%
      layer_batch_normalization() %>%
      layer_activation("relu")
   #    # 64
   
   up1 <- up2 %>%
      layer_upsampling_2d(size = c(2, 2)) %>%
      {layer_concatenate(inputs = list(down1, .), axis = 3)} %>%
      layer_conv_2d(filters = 64, kernel_size = c(3, 3), padding = "same") %>%
      layer_batch_normalization() %>%
      layer_activation("relu") %>%
      layer_conv_2d(filters = 64, kernel_size = c(3, 3), padding = "same") %>%
      layer_batch_normalization() %>%
      layer_activation("relu") %>%
      layer_conv_2d(filters = 64, kernel_size = c(3, 3), padding = "same") %>%
      layer_batch_normalization() %>%
      layer_activation("relu")
   # 128
   
   classify <- layer_conv_2d(up1,
                             filters = num_classes,
                             kernel_size = c(1, 1),
                             activation = "sigmoid")
   
   
   model <- keras_model(
      inputs = inputs,
      outputs = classify
   )
   
   return(model)
}


```

## Dice Coefficient


```r


# formula for dice coefficient
dice_coef <- function(y_true, y_pred, smooth = 1.0) {
   y_true_f <- k_flatten(y_true)
   y_pred_f <- k_flatten(y_pred)
   intersection <- k_sum(y_true_f * y_pred_f)
   result <- (2 * intersection + smooth) /
      (k_sum(y_true_f) + k_sum(y_pred_f) + smooth)
   return(result)
}

# and dice loss
bce_dice_loss <- function(y_true, y_pred) {
    result <- loss_binary_crossentropy(y_true, y_pred) +
       (1 - dice_coef(y_true, y_pred))
    return(result)
 }
 
```


## Model training

```r
unet_model <- get_unet_128()

unet_model %>% compile(
  optimizer = optimizer_rmsprop(learning_rate = 0.01),
  loss = bce_dice_loss,
  metrics = custom_metric("dice_coef", dice_coef)
) 

# fit/train the model
unet_model %>% fit(
  training_dataset,
  validation_data =validation_dataset,
  epochs = 10,
  verbose = 1
)


unet_model %>% save_model_hdf5(file.path(envrmt$path_models, "unet_buildings.hdf5"))
```

## Expected Output

