class App.Views.Login extends Backbone.View
  template: JST['user/login']

  className: 'registration-form'
    
  events:
    'click #login-btn': 'login'

  initialize: ->
    @user = new App.Models.User()
    @collection = new App.Collections.Pictures()
    @user.url = '/users/login'

  render: =>
    @$el.html(@template())
    this

  login: ->
    @user.set
      email: @$('.user-email').val()
      password: @$('.user-password').val()
    @user.save(null, {
      success: @handleLoginSuccess, #@user.handleLoginSuccess
      error: @handleLoginFailure    #@user.handleLoginFailure
    })
    false

  handleLoginSuccess: (model, resp, opts) =>
    @collection.url = '/users/' + model.id + '/pictures/mosaics'
    @collection.fetch({ 
      success: (col, resp, opts) ->
        view = new App.Views.Dashboard(collection: col)
        $('#container').html(view.render().el)
      error: (col, resp, opts) ->
        #not sure
      })

  handleLoginFailure: (model, resp, opts) =>
    console.log('handleLoginFailure')