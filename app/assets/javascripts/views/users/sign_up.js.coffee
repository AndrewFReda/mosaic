class App.Views.SignUp extends Backbone.View
  template: JST['users/sign_up']

  id: 'sign-up-form'

  events:
    'click #sign-up-button': 'signUp'

  render: =>
    @$el.html(@template())
    this

  signUp: ->
    @user = new App.Models.User()
    @user.set
      email: @$('.email').val(),
      password: @$('.password').val(),
      password_confirmation: @$('.password-confirmation').val()
    @user.save(null,
      success: @handleSignUpSuccess,
      error: @handleSignUpFailure
    )
    false

  handleSignUpSuccess: (model, resp, opts) =>
    @session = new App.Models.Session()
    @session.create
      email: model.get('email')
      password: model.get('password')


  handleSignUpFailure: (model, resp, opts) =>
    @$('input').removeClass('error')
    if resp['status'] == 401
      @$('.password').addClass('error')
      @$('.password-confirmation').addClass('error')
    else
      @$('.email').addClass('error')