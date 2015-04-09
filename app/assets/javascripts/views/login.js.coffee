class App.Views.Login extends Backbone.View
  template: JST['user/login']

  className: 'registration-form'
    
  events:
    'click #login-btn': 'login'

  render: =>
    @$el.html(@template())
    this

  login: ->
    @model.set
      email: @$('.user-email').val()
      password: @$('.user-password').val()
    @model.save()
    false
