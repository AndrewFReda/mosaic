window.Mosaics =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: -> alert 'Hello from Backbone!'

window.App = window.Mosaics

$(document).ready ->
  Mosaics.initialize()
