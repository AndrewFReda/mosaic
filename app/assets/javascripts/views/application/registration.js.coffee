class App.Views.Registration extends Backbone.View
  template: JST['application/registration']

  id: 'registration'

  initialize: ->
    @listenTo(App.EventBus, 'registration-nav:login', @renderLogin)
    @listenTo(App.EventBus, 'registration-nav:sign-up', @renderSignUp)
    
  render: =>
    @$el.html(@template())
    view = new App.Views.RegistrationNav()
    @$('#registration-nav').html(view.render().el)
    @addSubView('registration-nav', view)
    @renderLogin()
    this

  renderLogin: (e) ->
    view = new App.Views.Login()
    @renderRegistrationForm(view)

  renderSignUp: (e) ->
    view = new App.Views.SignUp()
    @renderRegistrationForm(view)

  renderRegistrationForm: (view) ->
    @$('#registration-form').html(view.render().el)
    @addSubView('registration-form', view)