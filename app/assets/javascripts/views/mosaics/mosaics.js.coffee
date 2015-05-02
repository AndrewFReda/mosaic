class App.Views.Mosaics extends Backbone.View

  tagName: 'ul'
  id: 'mosaics'

  initialize: ->
    @session        = @model
    @collection     = new App.Collections.Pictures()
    @collection.url = '/users/' + @session.id + '/pictures?type=mosaic'
    @listenTo(@collection, 'add', @renderMosaic)
    @collection.fetch()

  render: =>
    @collection.forEach(@renderMosaic)
    this

  renderMosaic: (mosaic) =>
    view = new App.Views.ShowThumbnail(model: mosaic, tagName: 'li', className: 'mosaic')
    @$el.append(view.render().el)
    this