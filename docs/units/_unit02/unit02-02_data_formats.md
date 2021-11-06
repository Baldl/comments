---
title: LM | Data Formats
toc: true
header:
  image: /assets/images/unit02/31031723265_0890cd9547_o.jpg
  image_description: "Cloudscape Over the Philippine Sea"
  caption: "Image: [NASA's Marshall Space Flight Center](https://www.nasa.gov/centers/marshall/home/index.html) [CC BY-NC 2.0] via [flickr.com](https://www.flickr.com/photos/nasamarshall/31031723265/)"
---

Features and differences of spatial data collected in the field or acquired by remote sensing systems.
<!--more-->

## Spatial data models
Reality is too complex to be fully represented by data. Models are a basis for reducing complexity. A data model is created through the abstraction of individual objects (entities) and their properties (attributes). In this abstraction process, objects of the same type are bundled (e.g. rivers, roads, urban areas). The spatial data world (including GIS) has implemented two different data models for this purpose -- the raster model and the vector model. Both models can be used to represent continuous properties and discrete (geo-) objects in principle. In practice, however, continuous data is usually represented by the raster model and discrete data by the vector model.

## R packages for spatial data

This blog post -- [Conversions between different spatial classes in R](https://geocompr.github.io/post/2021/spatial-classes-conversion/) -- explains some of the recent developments in spatial data manipulation in R as well as how to convert between them. This post mentions many different packages -- `sp`, `sf`, `raster`, `terra` and `stars` -- but what is the difference and what do we use them for?

### Vector data
The package `sp` has been maintained since the early 2000s, but largely replaced by the functionality in `sf`. [sf](https://r-spatial.github.io/sf/), which is short for [simple features](https://r-spatial.github.io/sf/articles/sf1.html), is useful for working with point & polygon data in `R`.

### Raster data
Much like the `sp` and `sf` combination for vector data, the packages for working with raster data have also evolved. For working with this data model, the older package `raster` is slowly being replaced by newer options. One such option -- the `terra` package -- is still quite new. Despite being lauded as faster and easier to work with, it still cannot entirely replace `raster` because it does not support all of the same functionality. Another option, `stars` is designed to work with spatial data cubes -- data that combines both continuous spatial data and time. The package is maintained by the same author as the `sf` package. See the CRAN pages of [raster](https://cran.r-project.org/web/packages/raster/index.html),  [terra](https://cran.r-project.org/web/packages/terra/index.html) and [stars](https://cran.r-project.org/web/packages/stars/index.html) for more details.

With multiple options for working with both types of spatial data models, which one should you choose to work with? And why are there multiple packages?

Put simply, the landscape is constantly changing. Developers must maintain their software by adding new functionality and adjusting when the software on which their own packages depend changes. Combined with an overall greater interest in working with spatial data in R and a growing community of developers, there are many reasons that it is difficult to stay up-to-date. In the case of the packages for working with raster data, the newer `terra` package was explicitly designed to replace `raster`. This is described in greater detail in this [r-bloggers post](https://www.r-bloggers.com/2021/05/a-comparison-of-terra-and-raster-packages/). In other cases, the packages serve different use cases, which is why they co-exist.

## Unit 2 slides

{% include pdf pdf="GeoAI-Unit02.pdf" %}

## Additional resources
* Why R? Webinar: [Recent changes in R spatial and how to be ready for them](https://geocompr.github.io/post/2020/whyr_webinar004/) (April 2020)
* Blog post ["Conversions between different spatial classes in R"](https://geocompr.github.io/post/2021/spatial-classes-conversion/) (June 2021)
