---
title: LM | Deeply Good
toc: true
header:
  image: /assets/images/unit04/streuobst.jpg
  image_description: "Streuobstwiese"
  caption: "Image: ulrichstill [CC BY-SA 2.0 DE] via [wikimedia.org](https://commons.wikimedia.org/wiki/File:Tuebingen_Streuobstwiese.jpg)"
---


In this learning module we focus on the prediction of spatial structures. With the random forest model we could achieve good predictions on a pixel level. However, when we try to recognize spatial structures, not only the value of a single pixel is interesting, but also its neighbouring pixels. Deep learning neural networks are a suitable tool for recognizing such structures.
<!--more-->
## Deep Learning in a nutshell

If this is your first encounter with deep learning, here follows a brief introduction to the world of neurons. If you are already familiar with the concept of deep learning neural networks you can go directly to the [U-Net](#u-net) section.

<p align="center">
  <img width="300" height="300" src="../assets/images/unit04/deep_learning_image.png" alt="drawing">
</p>

Deep learning algorithms as well as random forest models belong to the machine learning tools. They are a special form of neural networks.
They are used especially frequently in image recognition.

{% include video id="RbcHiAYPbC0" provider="youtube" %}


## U-Net
In the following exercise we will use a U-Net convolutional neural network to recognize spatial structures. Originally, U-Net was developed to segment biomedical images. U-Net performs a semantic segmentation where each pixel is assigned to a class. For a short introduction have a look at the U-Net teaser:
[5 Minute Teaser Presentation of the U-net: Convolutional Networks for Biomedical Image Segmentation (5:03)](https://www.youtube.com/watch?v=81AvQQnpG4Q){:target="_blank"} 

## The Network Structure
In the example of a unet in the image below we can see that a 256x256 image with three layers is the input into the U-net. To this image a convolution (for example 3x3) is applied, sometimes even several times in succession. From there the downsampling starts, which is performed by a max-pooling. In this process, the spatial information becomes weaker, but the information content about what is being imaged becomes increasingly larger.In order to subsequently generate the information about the space, an upsampling with transposed convolution is applied.  For this, half of the neurons from the left side and the other half from the upsampling are used. The final step is a 1x1 convolution with gives the segmented output.

This and further information can be found in the paper on the unet algroithm: [Ronneberger et al. (2015) U-Net: Convolutional Networks for Biomedical Image Segmentation](https://arxiv.org/abs/1505.04597)

![image](../assets/images/unit04/Example_architecture_of_U-Net.png)
*Image: Example architecture of U-Net for producing k 256-by-256 image masks for a 256-by-256 RGB image. Mehrdad Yazdani [CC BY-SA 4.0] via [wikipedia.org](https://en.wikipedia.org/wiki/U-Net#/media/File:Example_architecture_of_U-Net_for_producing_k_256-by-256_image_masks_for_a_256-by-256_RGB_image.png)*


## Unit 4 slides

{% include pdf pdf="GeoAI-Unit04.pdf" %}