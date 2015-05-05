class App.Views.Profile extends Backbone.View
  template: JST['application/profile']

  id: 'profile'

  events:
    'click .update-button': 'updateUser'

  initialize: ->
    @user = new App.Models.User({ id: @model.get('id') })
    @user.fetch(success: @renderUsersEdit)

  render: =>
    @$el.html(@template())
    this

  renderUsersEdit: (model) =>
    view = new App.Views.UsersEdit(model: @user)
    @$('#profile-body').html(view.render().el)

  # TODO: Move into UsersEdit view after delegating click event
  # Currently getting Zombie views when I attempt this though
  updateUser: (e) =>
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