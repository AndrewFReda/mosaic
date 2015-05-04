class App.Views.Registration extends Backbone.View
  template: JST['application/registration']

  id: 'registration'
    
  render: =>
    @$el.html(@template())
    view = new App.Views.RegistrationNav()
    @$('#registration-nav').html(view.render().el)
    view = new App.Views.Login()
    @$('#registration-form').html(view.render().el)
    this