class App.Views.SignUp extends Backbone.View
  template: JST['user/sign_up']

  className: 'registration-form'

  events:
    'click #sign-up-btn': 'signUp'

  render: =>
    @$el.html(@template())
    this

  signUp: ->
    @model.set
      email: @$('.user-email').val()
      password: @$('.user-password').val()
      confirmation: @$('.user-password-confirmation').val()
    @model.save()
    false

    
