class App.Views.Login extends Backbone.View
  template: JST['users/login']
    
  id: 'login-form'

  events:
    'click #login-button': 'login'

  render: =>
    @$el.html(@template())
    this

  login: ->
    @session = new App.Models.Session()
    @session.create
      email: @$('.email').val()
      password: @$('.password').val()

