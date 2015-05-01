class App.Views.Registration extends Backbone.View
  template: JST['users/registration']

  events:
    'click .registration-nav-item': 'toggleActiveNav'
    'click #registration-nav-login': 'renderLogin'
    'click #registration-nav-sign-up': 'renderSignUp'
    
  render: =>
    @$el.html(@template())
    @renderLogin()
    @$('#registration-nav-login').addClass('active')
    this

  toggleActiveNav: (e) ->
    @$('.registration-nav-item').removeClass('active')
    $(e.currentTarget).addClass('active')
    false

  renderRegistrationForm: (view) ->
    @$('#registration-form').html(view.render().el)
    false

  renderLogin: ->
    view = new App.Views.Login()
    @renderRegistrationForm(view)

  renderSignUp: ->
    view = new App.Views.SignUp()
    @renderRegistrationForm(view)
