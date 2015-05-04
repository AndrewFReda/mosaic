class App.Views.UsersEdit extends Backbone.View
  template: JST['users/edit']

  render: =>
    @$el.html(@template(user: @model))
    this