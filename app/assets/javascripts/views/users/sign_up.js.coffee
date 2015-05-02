class App.Views.SignUp extends Backbone.View
  template: JST['users/sign_up']

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
    @user.save(null,
      success: @handleSignUpSuccess, #@user.handleSignUpSuccess
      error: @handleSignUpFailure    #@user.handleSignUpFailure 
    )
    false

  handleSignUpSuccess: (model, resp, opts) =>
    @session = new App.Models.Session()
    @session.create
      email: model.get('email')
      password: model.get('password')


  handleSignUpFailure: (model, resp, opts) =>
    console.log('handleSignUpFailure')