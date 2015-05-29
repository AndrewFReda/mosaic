# Mosaics

## Overview
Mosaics lets users create mosaics from their own, personal photo library. The app is currently fully functional but needs improvements to provide a better user experience and decrease loading times.

### Front-End
----------------
The front end is a single-page Backbone app written in Coffeescript, HTML and CSS/SCSS. Its folder hierarchy and files are all served via the asset pipeline thanks to the _backone-on-rails gem_. Other front-end gems include: _jquery-rails_, _jquery-ui-rails_, _jquery-fileupload-rails_, _bootstrap-sass_ and _lodash-rails_. 

##### Code Walkthrough

The front-end app primarily lives in the _app/assets/javascripts_, _app/assets/stylesheets_ and _app/assets/templates_   folders. In _app/assets/stylesheets_, there are some individual stylesheets catered to specific pages as well as generic application-wide classes. In _app/assets/javascripts_, models including Picture, User and Session mimic classes on back-end. The views are split between views that display direct controller routes such as pictures#create, and views associated with actual pages or navs, such as the registration page. Finally, _app/assets/templates_ are generally written one-to-one matching identically named Views. These use basic JST templates.


### Back-End
----------------
The back end is a JSON API written in Ruby on Rails. It is currently supported by gems including: _aws-sdk_ and _paperclip_. The API is tested using RSpec with support from gems like _factory-girl_ and _simple-cov_. 

##### Code Walkthrough

Like most Rails APIs, the majority of the back-end logic lies in the _app/controllers_ and _app/models_ folders. There are two main controllers, PicturesController and UsersController, with a third to handle session management, dubbed SessionsController. These follow a typical RESTful architecure and associated routes with the exception a route on the PicturesController used to create a mosaic. I considered creating a separate MosaicsController to handle this scenario, but ultimately decided against it due to overall similarities with the rest of the picture routes. 

The bulk of business logic is split between models, delayed jobs and plain object oriented classes. Models like User and Picture are one-to-one matching with controllers, but Histogram on the other hand is not. These mainly include validations and getters/setters for different types of information. Next, the delayed job is written using Rails' new ActiveJob interface that is backed by Sidekiq. This allows the application to do the actual mosaic creation job into the background while the User continues to use the app. Finally there are the object oriented classes including one to create mosaics, one to act as a cache while creating mosaics and one to deal with validating the upload of images to S3 from the front-end. These classes work well to move logically organized chunks of code from the models to more intelligently encapusalate separate constructs.


### Future Updates
----------------
Future updates will range from improving direct content in the user interface (wording, typography, display) to improving the way (speed) mosaics are created. The biggest improvement I need to do right now is parallelizing the mosaic creation job. Since I need to crop and stitch together a large number of images, the process slows down at this bottle neck. Instead I can split a pictures into sections, send each section to a different job then stitch these sections back together. Unforunately I ran into the problem that Ruby is single threaded so I am currently exploring my options. I was hoping to find something without needing multiple unicorn workers.
