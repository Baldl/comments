---
title: Digitizing training areas
published: false
toc: true
header:
  image: /assets/images/spotlight01/field_outlines.png
  image_description: "Field outlines from QGIS documentation"
  caption: "Field outlines from [QGIS 3.16 documentation](https://docs.qgis.org/3.16/en/docs/training_manual/create_vector_data/create_new_vector.html#basic-ty-digitizing-polygons)"
---

Training areas are necessary for classifying objects and areas in remote sensing imagery. This spotlight provides a brief introduction into two different classification procedures and how to create training areas in GIS. 

<!--more-->


## Why we need training areas
Training areas are the basis of supervised classification. Creating training areas allows us, the user, to tell the computer what we see in an image. It transfers the knowledge that we have about individual objects in an image to a digital level. Once we have enough training areas, we can feed them into a machine learning algorithms to classify the remaining pixels of an image. This process is called supervised classification.

## Supervised vs. Unsupervised classification
### Unsupervised land-cover classification
An unsupervised land-cover classification uses unlabeled input data that is grouped into homogeneous classes. Once the classes have been computed, the user assigns a reasonable land-cover type to each class (if possible) *a posteriori*.

{% include figure image_path="/assets/images/spotlight01/unsupervised_classification.jpg" alt="Illustration of an unsupervised classification." %}

Such classifications generally require at least three steps:
1. Compiling a comprehensive input dataset containing one or more raster layers.
1. Classifying the unlabeled input dataset into *n* clusters based on the homogeneity of the pixel values. A typical classification model for this step is the k-means cluster algorithm.
1. Assigning land-cover types to the individual clusters by the remote sensing expert. The same land-cover type class can be assigned to more than one cluster.

The final step -- assigning land-cover types to the clusters -- requires some knowledge about the actual land-cover distribution in the respective observation area. If the selected land-cover types and the clusters do not match, one can change and extend the input dataset or use a different setting for the clustering algorithm or adjust the detail level of the land-cover typology.

### Supervised land-cover classification
A supervised land-cover classification uses a limited set of labeled training data to derive a model, which predicts the respective land-cover in the entire dataset. Hence, the land-cover types are defined *a priori* and the model tries to predict these types based on the similiarity between the properties of the training data and the rest of the dataset.

{% include figure image_path="/assets/images/spotlight01/supervised_classification.jpg" alt="Illustration of a supervised classification." %}

Such classifications generally require at least five steps:
1. Compiling a comprehensive input dataset containing one or more raster layers.
1. Selecting training areas, i.e. subsets of input datasets for which the remote sensing expert knows the land-cover type. Knowledge about the land cover can be derived e.g. from own or third party *in situ* observations, management information or other remote sensing products (e.g. high-resolution aerial images).
1. Training a model using the training areas. For validation purposes, the training areas are often further divided into one or more test and training samples to evaluate the performance of the model algorithm.
1. Applying the trained model to the entire dataset, i.e. predicting the land-cover type based on the similarity of the data at each location to the class properties of the training dataset.

Please note that all types of classifications require a thorough validation, which will be in the focus of upcoming course units.
{: .notice--info} 

The following illustration shows the steps of a supervised classification in more detail. The optional segmentation operations are mandatory for object-oriented classifications, which rely on the values of each individual raster cell in the input dataset in addition to considering the geometry of objects. To delineate individual objects, such as houses or tree crowns, remote sensing experts use segmentation algorithms, which consider the homogeneity of the pixel values within their spatial neighborhood. 

{% include figure image_path="/assets/images/spotlight01/supervised_classification_concept.jpg" alt="Illustration of a supervised classification." %}

## Creating vector layers in QGIS
QGIS is an open source GIS.

## Further resources
* [Digitizing training and test areas](http://wiki.awf.forst.uni-goettingen.de/wiki/index.php/Digitizing_training_and_test_areas) by the [Forest Inventory and Remote Sensing](https://www.uni-goettingen.de/en/67094.html) department at the University of Goettingen (Germany)
* [Digitizing polygons tutorial](https://docs.qgis.org/3.16/en/docs/training_manual/create_vector_data/create_new_vector.html#basic-ty-digitizing-polygons) in the QGIS 3.16 documentation
* [https://www2.geog.soton.ac.uk/users/trevesr/obs/rseo/supervised_classification.html](https://www2.geog.soton.ac.uk/users/trevesr/obs/rseo/supervised_classification.html)