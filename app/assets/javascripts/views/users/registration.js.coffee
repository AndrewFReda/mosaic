class App.Views.Registration extends Backbone.View
  template: JST['users/registration']

  events:
    'click #login-nav': 'renderLogin'
    'click #sign-up-nav': 'renderSignUp'

  initialize: ->
    @login  = new App.Views.Login()
    @signUp = new App.Views.SignUp()

  render: =>
    @$el.html(@template())
    @renderLogin()
    this

  renderLogin: ->
    @$('#registration-forms').html(@login.render().el)
    @$('#sign-up-nav').removeClass('active')
    @$('#login-nav').addClass('active')

  renderSignUp: ->
    @$('#registration-forms').html(@signUp.render().el)
    @$('#login-nav').removeClass('active')
    @$('#sign-up-nav').addClass('active')