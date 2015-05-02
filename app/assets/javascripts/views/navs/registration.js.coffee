class App.Views.RegistrationNav extends Backbone.View
  template: JST['navs/registration']

  events:
    'click .registration-nav-item': 'toggleActiveNav'
    'click #registration-nav-login': 'renderLogin'
    'click #registration-nav-sign-up': 'renderSignUp'
    
  render: =>
    @$el.html(@template())
    @$('#registration-nav-login').addClass('active')
    this

  toggleActiveNav: (e) ->
    @$('.registration-nav-item').removeClass('active')
    @$(e.currentTarget).addClass('active')

  renderRegistrationForm: (view) ->
    $('#registration-form').html(view.render().el)
    this

  renderLogin: (e) ->
    view = new App.Views.Login()
    @renderRegistrationForm(view)

  renderSignUp: (e) ->
    view = new App.Views.SignUp()
    @renderRegistrationForm(view)
