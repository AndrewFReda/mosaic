class App.Views.Profile extends Backbone.View
  template: JST['users/profile']

  className: 'profile'

  events:
    'click .save': 'updatePassword'

  initialize: ->
    @user = new App.Models.User( { id: @model.get('id') })
    @user.fetch()
    @listenTo(@user, 'change', @render)

  render: =>
    @$el.html(@template(user: @user))
    this

  updatePassword: ->
    @user.url = '/users/' + @user.get('id') + '/password'
    @user.set
      password: @$('#password').val()
      password_confirmation: @$('#password-confirmation').val()
      new_password: @$('#new-password').val()
    @user.save(null,
      success: -> console.log('nice update bro')
      error: -> console.log('FAILURE')
    )