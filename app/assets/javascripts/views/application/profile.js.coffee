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
    @addSubView('profile-body', view)

  updateUser: (e) =>
    App.EventBus.trigger('profile:update-user')