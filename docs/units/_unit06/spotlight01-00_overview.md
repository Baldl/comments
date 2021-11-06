---
title: Jekyll and GitHub pages
published: false
toc: true
header:
  image: /assets/images/spotlight01/jekyll_github_pages.png
  image_description: "Cutout from  Measured carbon dioxide concentrations in Vancouver"
  caption: "Bild: [jekyll](https://jekyllrb.com/)"
---

Getting started with your own GitHub page using Jekyll and Minimal Mistakes. Creating GitHub pages using Jekyll allows you to quickly, easily and (hopefully) effortlessly build your own website, which you can use to present your results.

<!--more-->

# Prerequisites
Before you start creating your website check if the following requirements are met:


1. Install the latest version of the rubygems with devkit 64
	* [Ruby Installer](https://rubyinstaller.org/downloads/)
	* Restart the computer afterwards, just to make sure, especially if you are under Windows.

2. Install bundler from the terminal:

```console
C:your_repository> gem install bundler
```

* It does not matter in which path you execute it
* Close and restart the terminal to update the PATH Variables (otherwise the gem function is not available). If this does not work, restart the computer, especially if you are under Windows.

3. Check if you have all [other prerequisites for Jekyll](https://jekyllrb.com/docs/) installed
    
4. Get a "docs" folder in your GitHub repository, which follows the required Jekyll structure (assets, _data, _includes, _pages, etc.)
	* Check [here](https://jekyllrb.com/docs/structure/) for more details on the Jekyll structure
	* You can also use a [template](https://github.com/GeoMOER/moer-html-module-template)

5. Switch the directory in your terminal to "docs" folder and run "bundle install" there, for installing the required gems for your webpage.

```console
C:your_repository/docs> bundle install
```

* the gems will be installed in your local repository folder. If you want, and often you should want, exclude them from synchronizing with GitHub by adding the ".bundle" or "vendor" folders to your 	 file


