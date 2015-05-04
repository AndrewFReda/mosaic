window.Mosaics =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: -> 
    new @Routers.MosaicsRouter
    Backbone.history.start(pushState: true)

window.App = window.Mosaics
window.App.EventBus = _.extend({}, Backbone.Events)

$(document).ready ->
  Mosaics.initialize()
