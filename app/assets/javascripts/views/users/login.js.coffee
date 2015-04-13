class App.Views.Login extends Backbone.View
  template: JST['user/login']

  className: 'registration-form'
    
  events:
    'click #login-btn': 'login'

  render: =>
    @$el.html(@template())
    this

  login: ->
    @session = new App.Models.Session()
    @session.set
      email: @$('.user-email').val()
      password: @$('.user-password').val()
    @session.save(null, {
      success: @session.handleLoginSuccess
      error: @session.handleLoginFailure
    })
    false
