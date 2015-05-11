class App.Views.PicturesIndex extends Backbone.View

  className: 'picture-list'
  tagName: 'ul'

  initialize: (options) ->
    @subViewAction = options.subViewAction
    @listenTo(@collection, 'add', @renderPicture)

  render: =>
    @collection.forEach(@renderPicture)
    this

  renderPicture: (picture) =>
    view = new App.Views.PicturesShow(model: picture, className: 'picture', viewAction: @subViewAction)
    @addSubView("pictures-mosaic-picture-list-#{picture.id}", view)
    @$el.append(view.render().el)