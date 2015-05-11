class App.Views.Gallery extends Backbone.View
  template: JST['application/gallery']

  id: 'gallery'

  initialize: ->
    @session = @model
    @collection     = new App.Collections.Pictures()
    @collection.url = "/users/#{@session.id}/pictures?type=mosaic"
    # Render upload form after pictures have been loaded to avoid duplicate rendering
    @listenToOnce(@collection, 'reset', @renderPictures)
    @collection.fetch({reset: true})

  render: ->
    @$el.html(@template())
    this

  renderPictures: (collection) ->
    view = new App.Views.PicturesIndex(collection: @collection, subViewAction: 'edit')
    @$('#gallery-picture-list').html(view.render().el)
    @addSubView('gallery-picture-list', view)