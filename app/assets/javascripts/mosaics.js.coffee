window.Mosaics =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: -> 
    new @Routers.MosaicsRouter
    Backbone.history.start(pushState: true)

window.App = window.Mosaics

$(document).ready ->
  Mosaics.initialize()
