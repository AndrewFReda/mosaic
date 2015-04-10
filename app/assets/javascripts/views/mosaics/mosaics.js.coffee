class App.Views.Mosaics extends Backbone.View

  tagName: 'ul'
  className: 'mosaics'

  render: =>
    @collection.forEach(@renderMosaic)
    this

  renderMosaic: (mosaic) =>
    view = new App.Views.ShowPicture(model: mosaic, tagName: 'li', className: 'mosaic')
    @$el.append(view.render().el)