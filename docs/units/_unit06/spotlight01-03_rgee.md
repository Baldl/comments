---
title: How to get Google Earth Engine data in R
published: false
toc: true
header:
  image: /assets/images/spotlight01/jekyll.png
  image_description: "Blick ins Lahntal mit Grünlandwirtschaft, Baustelle für Stromtrassen und Regenbogen."
  caption: "Foto: T. Nauss / CC0"
---

Access a powerful cloud computing platform with the `rgee` package 

<!--more-->

Google Earth Engine is a powerful geospatial data tool. It has access to a wide array of global and regional datasets stored in the cloud and it allows you to build your own data analysis algorithms. Google makes this data available in it's [Earth Engine Data Catalog](https://developers.google.com/earth-engine/datasets/).
Unfortunately, the easiest way to use data from Google Earth Engine in R is rather complicated. A few useful tools make this paradox possible and they are described below.


## Requirements

* Google account with Earth Engine activated
* Python >= v3.5
* EarthEngine Python API

### Depends

* `reticulate`
* `R6`
* `processx`

### How to sign up
Sign up at [earthengine.google.com/signup](earthengine.google.com/signup).

### How to install
We install `rgee`, just like any other package, by running:
```r
install.packages("rgee")
```
Now, this is where things start to get more complicated. Because the Google Earth Engine API is written for Python, R users must rely on the `reticulate` package to be able to port the R commands into Python. 
"When an Earth Engine request is created in R, `reticulate` will transform this piece into Python. Once the Python code is generated, the Earth Engine Python API converts the request to a JSON format. Finally, the request is received by the GEE platform through a Web REST API. The response will follow the same path." -- the [Github repo](https://github.com/r-spatial/rgee#how-does-rgee-work).

[https://cran.r-project.org/web/packages/rgee/vignettes/rgee01.html#6_Installation](https://cran.r-project.org/web/packages/rgee/vignettes/rgee01.html#6_Installation)

### How to use
Every session, the Earth Engine R API must be authenticated and initialized. This means that after we load the `rgee` package, we call the function `ee_Initialize()`. 

```r
library(rgee)
ee_Initialize()
```

Note that every `rgee` function begins with the prefix "ee_"
{: .notice--info}

## Further resources
For more information about `rgee`, please consult the package's [Github repo](https://github.com/r-spatial/rgee).

The following vignettes may also be useful:
[Introduction and installation guide](https://cran.r-project.org/web/packages/rgee/vignettes/rgee01.html)
[Considerations](https://cran.r-project.org/web/packages/rgee/vignettes/rgee02.html)
[Best practices](https://cran.r-project.org/web/packages/rgee/vignettes/rgee03.html)
