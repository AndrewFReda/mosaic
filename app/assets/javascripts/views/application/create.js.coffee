class App.Views.Create extends Backbone.View
  template: JST['application/create']

  id: 'create'

  render: =>
    @$el.html(@template())
    this