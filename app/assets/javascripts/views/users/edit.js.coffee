class App.Views.UsersEdit extends Backbone.View
  template: JST['users/edit']

  id: 'users-edit'

  initialize: ->
    @user = @model
    # Consider passing EventBus in constructor
    @listenTo(App.EventBus, 'update-user', @updateUser)

  render: =>
    @$el.html(@template(user: @model))
    this

  # TODO: Move into UsersEdit view after delegating click event
  updateUser: ->
    @$('input').removeClass('error')
    old_password = @$('.old-password')
    new_password = @$('.new-password')
    confirmation = @$('.new-password-confirmation')

    if new_password.val() != confirmation.val()
      new_password.addClass('error')
      confirmation.addClass('error')
    else
      @user.save({
          password: @$('.old-password').val()
          new_password: new_password.val()
        },
        success: (model, resp, opts) => 
          $('input').addClass('success')

        error: (model, resp, opts) =>
          if resp['status'] == 401
            $('.old-password').addClass('error')
      )
