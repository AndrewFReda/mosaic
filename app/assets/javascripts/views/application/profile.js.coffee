class App.Views.Profile extends Backbone.View
  template: JST['application/profile']

  id: 'profile'

  events:
    'click .update': 'updateUser'

  initialize: ->
    @user = new App.Models.User({ id: @model.get('id') })
    @user.fetch()
    @listenTo(@user, 'change', @render)

  render: =>
    @$el.html(@template(user: @user))
    this

  updateUser: ->
    @$('#profile-body input').removeClass('textfield-error')

    if @$('#profile-new-password').val() == @$('#profile-new-password-confirmation').val()
      @user.url = '/users/' + @user.get('id')
      @user.set
        email: @$('#profile-email').val()
        password: @$('#profile-old-password').val()
        new_password: @$('#profile-new-password').val()
      @user.save(null,
        success: -> console.log('nice update')
        error: -> console.log('FAILURE')
      )
    else
      @$('#profile-new-password').addClass('textfield-error')
      @$('#profile-new-password-confirmation').addClass('textfield-error')