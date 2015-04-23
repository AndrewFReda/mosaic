class App.Views.ShowThumbnail extends Backbone.View
  template: JST['mosaics/show_thumbnail']

  render: ->
    @$el.html(@template(model: @model))
    this