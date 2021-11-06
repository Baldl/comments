--- 
title: LM | Proximity and relationships 
toc: true
header:
  image: /assets/images/01-splash.jpg
  image_description: "Dr. John Snow's map"
  caption: "Map: [**Dr. John Snow**](https://en.wikipedia.org/wiki/John_Snow) [Wellcome Library via wikimedia](https://w.wiki/QtV)"
---

## The first law of geography in heterogeneous spaces
We return to Tobler's First Law (TFL), which, in a way, made geographic history with the proximity concept. But it should also be noted that this simplification was postulated primarily due to the weak performance of 1970s-era computers. However, as can be deduced from everyday observation, the relationship of things (geo-objects) in space is usually more complex than just a function of distance. Therefore, there has been an intense and lively discussion about the usefulness of TFL in the spatial sciences (see e.g. [Goodchild 2004](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1467-8306.2004.09402008.x)).

This raises some central questions: How can spatial concepts be adequately mapped? When are neighborly relationships regular and continuous, when are they irregular or discrete, and when do they have no meaning at all?

It is easier to answer these questions with a little background knowledge about the spatial representation of real-world features and processes.


## Distance and data representation
The analysis of spatio-temporal processes, as we saw in the cholera example, reaches far back into the past. The use of quantitative methods, especially statistical methods, is of considerable importance for describing and explaining spatial patterns (e.g. landscape ecology). The central concept on which these methods are based is that of proximity, or location in relation to each other.

Let's take a closer look at proximity, which is mentioned frequently. What exactly is it? How can proximity/neighborliness be expressed in such a way that the space becomes meaningful?

In general, spatial relationships are described in terms of neighborhoods (positional) and distances (metric). In spatial analysis or prediction, however, it is important to be able to name the spatial **influence**, i.e. the evaluation or weighting of this relationship, either qualitatively or quantitatively. Tobler did this for a specific objective by stating that "near" is more important than "far".
But what about in other cases? The challenge is that spatial influence can only be measured directly in exceptional cases. There are many ways to estimate it, however. 


### Neighborhood
Neighborhood is perhaps the most important concept. Higher dimensional geo-objects can be considered neighboring if they *touch* each other, e.g. neighboring countries. For zero-dimensional objects (points), the most common approach is to use distance in combination with a number of points to determine neighborhood.


### Distance
Proximity or neighborhood analyses are often concerned with areas of influence or catchment areas, i.e. spatial patterns of effects or processes.

This section discusses some methods for calculating distances between spatial objects. Because of the different ways of discretizing space, we must make the -- already familiar -- distinction between vector and raster data models.

Initially, it is often useful to work without spatially restrictive conditions in a first analysis, e.g. when this information is missing. The term "proximity" inherently implies a certain imprecision. Qualitative terms that can be used for this are: "near", "far" or "in the neighborhood of". Representation and data-driven analysis require these terms to be objectified and operationalized. So, this metric must be based on a distance concept, e.g. Euclidean distance or travel times. In a second interpretative step, we must decide which units define this type of proximity. In terms of the objective of a question, there are only suitable and less-suitable measures; there is no correct or incorrect. Therefore, it is critical to define a meaningful neighborhood relationship for the objects under investigation.

### Have a try
This interactive application gives you an idea of the different concepts of neighborhood and distance. 
Please note that *rook* is a neighborhood of 4 and *queen* is a neighborhood of 8 around a given point. For simplicity, the set of darts is a regular grid of 1 km<sup>2</sup> cell size in Marburg-Biedenkopf, a district in Hesse (Germany).

Please also note that the k-nearest neighbors in a regular grid result in a spiral circular structure.
Irregular polygons or points generate much more complex neighborhood structures, especially if they receive additional weight from further variables with spatial influence.


<iframe width="600" height="1080" src="https://gisma.shinyapps.io/proximity/" frameborder="0"> </iframe>


## Further Reading
Ana Petrovic - [Multiscale spatial contexts and neighbourhood effects](https://journals.open.tudelft.nl/abe/article/view/5194/4710)

Diaz, S., Pascual, U., Stenseke, M. et al. (2018) Assessing nature's contributions to people. Science Vol. 359, Issue 6373, 270-272. [https://doi.org/10.1126/science.aap8826](https://doi.org/10.1126/science.aap8826)

Manning, P., van der Plas, F., Soliveres, S. et al. (2018) Redefining ecosystem multifunctionality. Nat Ecol Evol 2, 427-436. [https://doi.org/10.1038/s41559-017-0461-7](https://doi.org/10.1038/s41559-017-0461-7)

Tobler, W. (2004) On the First Law of Geography: A Reply, Annals of the Association of American Geographers, 94:2, 304-310: [https://doi.org/10.1111/j.1467-8306.2004.09402009.x](https://doi.org/10.1111/j.1467-8306.2004.09402009.x)

## Assignment
Choose one of the articles from the further reading section. Your assignment is to summarize the essence of the article in approximately one half page (5-8 sentences) for your own understanding.

<div class="tenor-gif-embed" data-postid="21779286" data-share-method="host" data-aspect-ratio="1.78771" data-width="100%"><a href="https://tenor.com/view/adam-savage-mythbusters-science-write-it-down-gif-21779286">Adam Savage Mythbusters GIF</a>from <a href="https://tenor.com/search/adam+savage-gifs">Adam Savage GIFs</a></div> <script type="text/javascript" async src="https://tenor.com/embed.js"></script>