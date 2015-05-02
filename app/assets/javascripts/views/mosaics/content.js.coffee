class App.Views.Content extends Backbone.View
  template: JST['mosaics/content']

  id: 'content'

  initialize: ->
    @session = @model
    @collection = new App.Collections.Pictures()
    @collection.url = '/users/' + @session.id + '/pictures'
    @collection.fetch()

  render: =>
    @$el.html(@template())
    view = new App.Views.ContentNav(model: @session, collection: @collection)
    @$('#content-nav').html(view.render().el)
    view = new App.Views.UploadPictures(model: @session, collection: @collection, type: 'composition')
    @$('#content-body').html(view.render().el)
    this