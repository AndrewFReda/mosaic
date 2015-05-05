class App.Views.RegistrationNav extends Backbone.View
  template: JST['application/navs/registration']

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

  renderLogin: (e) ->
    App.EventBus.trigger('registration-nav:login')

  renderSignUp: (e) ->
    App.EventBus.trigger('registration-nav:sign-up')