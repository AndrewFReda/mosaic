class App.Views.UsersEdit extends Backbone.View
  template: JST['users/edit']

  id: 'users-edit'

  initialize: ->
    # Consider passing EventBus in constructor
    @listenTo(App.EventBus, 'updateUser', @updateUser)

  render: =>
    @$el.html(@template(user: @model))
    this

  # TODO: Move into UsersEdit view after delegating click event
  updateUser: ->
    @$('.users-edit input').removeClass('error')
    old_password = @$('.users-edit .old-password')
    new_password = @$('.users-edit .new-password')
    confirmation = @$('.users-edit .new-password-confirmation')

    if new_password.val() != confirmation.val()
      new_password.addClass('error')
      confirmation.addClass('error')
    else
      @user.save({
          password: @$('.users-edit .old-password').val()
          new_password: new_password.val()
        },
        success: (model, resp, opts) => 
          $('.users-edit input').addClass('success')

        error: (model, resp, opts) =>
          if resp['status'] == 401
            $('.users-edit .old-password').addClass('error')
      )
