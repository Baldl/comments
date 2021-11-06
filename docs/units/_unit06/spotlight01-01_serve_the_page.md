---
title: Serve the page
published: false
toc: true
header:
  image: /assets/images/spotlight01/jekyll.png
  image_description: ""
  caption: "Foto: T. Nauss / CC0"
---

Start creating your page locally with Jekyll and then push it to GitHub to create a GitHub page.
<!--more-->

## Locally

Switch to the /docs folder on your command promt and run:
```console
C:/my_repository/docs> bundle exec jekyll serve
```

You will get an output similar to this:


```console
Configuration file: C:/my_repository/docs/_config.yml
            Source: C:/my_repository/docs
       Destination: C:/my_repository/docs/_site
 Incremental build: disabled. Enable with --incremental
      Generating...
      Remote Theme: Using theme geomoer/moer-jekyll-theme
       Jekyll Feed: Generating feed for posts
   GitHub Metadata: No GitHub API authentication could be found. Some fields may be missing or have incorrect data.
                    done in 7.142 seconds.
 Auto-regeneration: enabled for 'C:/my_repository/docs'
  JekyllAdmin mode: production
    Server address: http://127.0.0.1:4000/my-great-page//
  Server running... press ctrl-c to stop.
      Remote Theme: Using theme geomoer/moer-jekyll-theme
       Jekyll Feed: Generating feed for posts
                    ...done in 3.3533171 seconds.

```

If you received no errors you can open the page in a browser following the Server address given in the terminal. If you do receive error messages you can have a look at the [Jekyll Troubleshooting](https://jekyllrb.com/docs/troubleshooting/), which includes common installation and running problems that occure with Jekyll.


## On GitHub

![image](../assets/images/spotlight01/gitHubPages.jpg)

* Push your local changes to GitHub (if any).
* Use your browser and navigate to the settings of your GitHub repo and turn on "GitHub Pages" under "pages" on the left. 
	* Select the master branch as source and /docs as folder
* The url for your GitHub page can also be found there.
* Note that pushed changed will take a while to be processed by GitHub and will not instantly be availaby globally (this might take 1-5 minutes).


