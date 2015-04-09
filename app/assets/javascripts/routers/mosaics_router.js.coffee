class App.Routers.MosaicsRouter extends Backbone.Router
  routes:
    '': 'index'

  index: ->
    user = new App.Models.User()
    view = new App.Views.Registration(model: user)
    $('#container').html(view.render().el)
