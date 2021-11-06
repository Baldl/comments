---
title: LM | Modelling Workflow
toc: true
header:
  image: /assets/images/unit04/streuobst.jpg
  image_description: "Streuobstwiesen"
  caption: "Image: ulrichstill [CC BY-SA 2.0 DE] via [wikimedia.org](https://commons.wikimedia.org/wiki/File:Tuebingen_Streuobstwiese.jpg)"
---


![image](../assets/images/unit04/workflow.png)
*Image: 

In this unit we want to predict houses in the south of marburg using a deep neural network, in this particular case unet. For this we use a DOP of Marburg as well as a vector file containing the outlines of the buildings for the extent of the DOP. Both files can be downloaded [here](http://85.214.102.111/geo_data/).

This entire example is based on the tutorial [Introduction to Deep Learning in R for the Analysis of UAV-based Remote Sensing Data]( https://av.tib.eu/media/49550) [CC BY 3.0 DE] by Christian Knoth. The scripts to this tutorial are available [here]( https://dachro.github.io/ogh_summer_school_2020/Tutorial_DL_UAV.html#introduction).

## EX | Create Masks 


In this exercise we will create a raster mask from vectordata containing the outlines of all buildings in our study area in the south of Marburg (figure below). For this purpose, both the raster mask and the DOP of the study area will be split from large raster (.tif) files into many smaller image files (.png).


## EX | Prepare your data

In this exercise we will split our image and mask files into a training, a validation and a test dataset. The training dataset will be artificially enhanced by data augmentation.

## EX | Unet


## EX | Predicting using Unet

## EX | How well does your model perform?

