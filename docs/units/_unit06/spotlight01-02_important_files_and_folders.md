---
title: Important files and folders for your page
published: false
header:
  image: /assets/images/spotlight01/jekyll.png
  image_description: "Blick ins Lahntal mit Grünlandwirtschaft, Baustelle für Stromtrassen und Regenbogen."
  caption: "Foto: T. Nauss / CC0"
---



Example of a Jekyll files and folder structure that you can use for your project:

```yaml
└── docs
    ├── _data
    │  └── navigation.yml
    ├── _includes  
    ├── _pages
    ├── _site
    ├── assets
    │   ├── images
    │   └── pdf
    ├── units
    │	├── _unit01
    │	│	└── 01_00_example.md
    │   ├── _unit02
    │   └── ... 
    ├── _config.yml
    ├── Gemfile 
    ├── Gemfile.lock 
    └── index.md 
	
```

## Your Files


### _config.yml

The most important file for your webpage. If you change something there, you need to build the site again with "bundle exec jekyll serve" for changes to take effect.

In this file you set e.g.: 
* the url for your page. If this url is wrong, everything will become a mess. If you serve your page on github, include the GitHub url here.
* collections_dir: directory in /docs where Jekyll looks for pages to display. 
* :collections and :defaults - set the structure of your page. Make your collection content appear there, otherwiese they will not be displayed in the page.
  
### index.md

Creates the front page. This page usually contains on top a teaser image with a description and a button and some text or feature rows below.


### Gemfile

The gems, which will be used (and installed with "bundle install") for your site. Add more gems if needed.


### Gemfile.lock

If you want to fix a certain combination of Gems and versions there of, use this file. It assures (hopefully) that the page can be served independent of the local gem installation.


## Your Folders

### assets

Your media content for the page lives here (images, pdfs, videos, etc.)

### _data

Important things for controlling your page live here e.g.:
* navigation.yml: Can control the navigation for your page. 
	* main: navigation on the top of the page
    * docs: navigation on the left of the page

### _includes

Files controling how to include contents live here, e.g.
* masthead.html: controlls the appearance of the navigation panel on the top.
  
  
### _pages

Files, which are directly rendered to HTML and included somewhere in your page live here. Those pages will be directy included in the url of your page after the baseurl.

### _site

This is the folder where the compiled HTML files of your page live. If fact, this folder *is* the webpage, which will be displayed correctly if you set your paths and urls right (e.g. in the _config.yml file).


### units

This is the folder for the collections. The collections are defined in the _config.yml file. All files in folders will be compiled as content in the navigation of the collections of your page. This folder is called "units" here because of the background in teaching at the Lab of Environmental Informatics. Note that only folders will be displayed, which are refered to in the _config.yml file. Note also that the alphabetical order of the files and folders equals the order of appearance of content in the webpage. You can change this order in the _config.yml file (good luck).


**Notes**: The md. files are compiled by Jekyll to HTML for display in the webpage. For local serving: if you change files (and save them), the changes will directly be processed for updating the page. Do not forget to refresh the page in your browser for seeing the changes.
{: .notice--info}

