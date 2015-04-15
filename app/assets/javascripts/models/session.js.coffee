class App.Models.Session extends Backbone.Model
  url: 'session'


  handleLoginSuccess: (model, resp, opts) =>
    view = new App.Views.Dashboard(model: model)
    $('#container').html(view.render().el)

  handleLoginFailure: (model, resp, opts) =>
    #@$('.user-email').addClass('error')
    #@$('.user-password').addClass('error')
    #@$('.user-password-confirmation').addClass('error')