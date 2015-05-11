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

# Shared View Management Code
Backbone.View.prototype.addSubView = (key, view) ->
  @subViews = @subViews || {}
  @subViews[key].close() if @subViews[key]
  @subViews[key] = view
  
Backbone.View.prototype.close = () ->
  @el.remove()
  @stopListening()
  @removeSubViews() if @removeSubViews

Backbone.View.prototype.removeSubViews = () ->
  _.forEach(_.values(@subViews), (subView) -> subView.close())

$(document).ready ->
  Mosaics.initialize()