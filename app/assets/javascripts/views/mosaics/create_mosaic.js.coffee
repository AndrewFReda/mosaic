class App.Views.CreateMosaic extends Backbone.View
  template: JST['mosaics/create_mosaic']

  render: =>
    @$el.html(@template())
    this