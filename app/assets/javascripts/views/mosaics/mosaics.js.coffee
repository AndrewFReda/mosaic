class App.Views.Mosaics extends Backbone.View

  tagName: 'ul'
  className: 'mosaics'

  initialize: ->
    @session        = @model
    @collection     = new App.Collections.Pictures()
    @collection.url = '/users/' + @session.id + '/pictures'
    @listenTo(@collection, 'add', @renderMosaic)
    @collection.fetch()

  render: =>
    @collection.forEach(@renderMosaic)
    this

  renderMosaic: (mosaic) =>
    view = new App.Views.ShowPicture(model: mosaic, tagName: 'li', className: 'mosaic')
    @$el.append(view.render().el)