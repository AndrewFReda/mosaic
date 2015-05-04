class App.Views.PicturesIndex extends Backbone.View

  className: 'picture-list'
  tagName: 'ul'

  intialize: ->
    @listenTo(@collection, 'add', @renderPicture)

  render: =>
    @collection.forEach(@renderPicture)
    this

  renderPicture: (picture) =>
    view = new App.Views.PicturesShow(model: picture, className: 'picture picture-thumbnail')
    @$el.append(view.render().el)