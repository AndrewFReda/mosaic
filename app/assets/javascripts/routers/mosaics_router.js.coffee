class App.Routers.MosaicsRouter extends Backbone.Router
  routes:
    '': 'index'
    #'': 'mosaics'

  index: ->
    view = new App.Views.Registration()
    $('#container').html(view.render().el)

  mosaics: ->
    view = new App.Views.Dashboard()
    $('#container').html(view.render().el)