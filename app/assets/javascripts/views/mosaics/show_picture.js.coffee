class App.Views.ShowPicture extends Backbone.View
  template: JST['mosaics/show_picture']

  render: ->
    @$el.html(@template(model: @model))
    this