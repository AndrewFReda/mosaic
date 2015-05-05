# Mosaics

## Overview

Mosaics is a project I've been working on recently to let users create mosaics from their own, personal photo library. The app is currently fully functional but needs improvements to provide a better user experience and decrease loading times. I will provide a basic overview of the app here, but I will go into further detail in person.

### Front-End
----------------
The front end is a single-page Backbone app written in Coffeescript, HTML and CSS/SCSS. Its folder hierarchy and files are all served via the asset pipeline thanks to the _backone-on-rails gem_. Other front-end gems include: _jquery-rails_, _jquery-ui-rails_, _jquery-fileupload-rails_, _bootstrap-sass_ and _lodash-rails_. 

##### Code Walkthrough

The front-end app primarily lives in the _app/assets/javascripts_, _app/assets/stylesheets_ and _app/assets/templates_   folders. Stylesheets are straight forward, including some individual stylesheets catered to specific pages as well as generic application-wide classes. In javascripts, models including Picture, User and Session mimic classes on back-end. The views are split between views that display direct controller routes such as pictures#create, and views associated with actual pages or navs, such as the registration page. Finally, templates are generally written one-to-one matching identically named Views. These use basic JST templates.



### Back-End
----------------
The back end is a JSON API written in Ruby on Rails. It is currently supported by gems including: _aws-sdk_ and _paperclip_. The API is tested using RSpec with support from gems like _factory-girl_ and _simple-cov_. 


##### Code Walkthrough

Like most Rails APIs, the majority of the back-end logic lies in the _app/controllers_ and _app/models_ folders. There are two main controllers, PicturesController and UsersController, with a third to handle session management dubbed SessionsController. These follow a typical RESTful architecure and associated routes with the exception of one route used to create a mosaic on the PicturesController. I considered creating a separate MosaicsController to handle this scenario, but ultimately decided against it due to overall similarities with the rest of the picture routes. Models do not match one-to-one with controllers however. While some are ActiveRecord backed classes like User, Picture, Histogram, others are backed by ActiveModel and not persisted to the database such as Mosaic and S3Upload. Though the Histogram model is currently fairly basic, it was created primarily as a means to encapsulate all current and future complexities related to analyzing an image.

### Future Updates
----------------
Future updates will range from improving direct content in the user interface (wording, typography, display) to improving the way (speed) mosaics are created. On the front-end, I plan to provide a major update to styles as well as adding oauth authentication through services like GMail and Facebook. On the back-end, I plan to integrate Sidekiq (or potentially another background processing gem) to break up some of the app's more time and memory-intensive operations. This will primarily effect the endpoint to create new mosaics.
