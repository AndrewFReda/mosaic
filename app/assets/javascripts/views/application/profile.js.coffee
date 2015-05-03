class App.Views.Profile extends Backbone.View
  template: JST['application/profile']

  id: 'profile'

  events:
    'click .update': 'updateUser'

  initialize: ->
    @user = new App.Models.User({ id: @model.get('id') })
    @user.url = "/users/#{@user.get('id')}"
    @user.fetch()
    @listenTo(@user, 'change', @render)

  render: =>
    @$el.html(@template(user: @user))
    this

  updateUser: ->
    @$('#profile-body input').removeClass('error')
    old_password = @$('#profile-old-password')
    new_password = @$('#profile-new-password')
    confirmation = @$('#profile-new-password-confirmation')

    if new_password.val() != confirmation.val()
      new_password.addClass('error')
      confirmation.addClass('error')
    else
      @user.save({
          password: @$('#profile-old-password').val()
          new_password: new_password.val()
        },
        success: (model, resp, opts) => 
          $('#profile-body input').addClass('success')

        error: (model, resp, opts) =>
          if resp['status'] == 401
            $('#profile-old-password').addClass('error')
      )