class App.Views.SignUp extends Backbone.View
  template: JST['user/sign_up']

  className: 'registration-form'

  events:
    'click #sign-up-btn': 'signUp'

  render: =>
    @$el.html(@template())
    this

  signUp: ->
    @user = new App.Models.User()
    @user.set
      email: @$('.user-email').val(),
      password: @$('.user-password').val(),
      password_confirmation: @$('.user-password-confirmation').val()
    @user.save(null, {
      success: @handleSignUpSuccess, #@user.handleSignUpSuccess
      error: @handleSignUpFailure    #@user.handleSignUpFailure 
    })
    false

  handleSignUpSuccess: (model, resp, opts) =>
    view = new App.Views.Dashboard(collection: @collection)
    $('#container').html(view.render().el)

  handleSignUpFailure: (model, resp, opts) =>
    console.log('handleSignUpFailure')