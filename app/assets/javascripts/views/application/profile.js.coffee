class App.Views.Profile extends Backbone.View
  template: JST['application/profile']

  id: 'profile'

  events:
    'click .update-button': 'updateUser'

  initialize: ->
    @user = new App.Models.User({ id: @model.get('id') })
    @listenTo(@user, 'change', @renderUsersEdit)
    @user.fetch()

  render: =>
    @$el.html(@template())
    this

  renderUsersEdit: (model) ->
    view = new App.Views.UsersEdit(model: @user)
    @$('#profile-body').html(view.render().el)

  updateUser: (e) ->
    App.EventBus.trigger 'updateUser'