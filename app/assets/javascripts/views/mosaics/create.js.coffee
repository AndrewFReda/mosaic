class App.Views.Create extends Backbone.View
  template: JST['mosaics/create']

  render: =>
    @$el.html(@template())
    this