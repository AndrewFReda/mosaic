class App.Views.PicturesShow extends Backbone.View
  template: JST['pictures/show']

  tagName: 'li'

  events:
    'click': 'renderEditDialog'

  initialize: ->
    @listenTo(@model, 'destroy', @removeView)

  render: ->
    @$el.html(@template(model: @model))
    this

  renderEditDialog: (e) =>
    view = new App.Views.PicturesEdit(model: @model)
    $(view.render().el).dialog(
      resizable: false
      show: 'slideDown'
      modal: true
      width: 500

      open: ->

      close: ->
        $(this).remove()
    )

  removeView: (e) ->
    @el.remove()