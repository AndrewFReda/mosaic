class App.Views.PicturesShow extends Backbone.View
  template: JST['pictures/show']

  render: ->
    @$el.html(@template(model: @model))
    this