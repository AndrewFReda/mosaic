class App.Views.content extends Backbone.View
  template: JST['mosaics/content']

  events:
    'click .content-nav-item': 'toggleActiveNav'
    'click #content-nav-base': 'renderUploadBase'
    'click #content-nav-composition': 'renderUploadComposition'

  initialize: ->
    @session = @model
    @collection     = new App.Collections.Pictures()
    @collection.url = '/users/' + @session.id + '/pictures'
    @collection.fetch()

  render: =>
    @$el.html(@template())
    @renderUploadComposition()
    @$('#content-nav-composition').addClass('active')
    this

  toggleActiveNav: (e) ->
    @$('.content-nav-item').removeClass('active')
    $(e.currentTarget).addClass('active')
    false

  rendercontentBody: (view) ->
    @$('#content-body').html(view.render().el)
    false

  renderUploadBase: ->
    view = new App.Views.UploadPictures(model: @session, collection: @collection, type: 'base')
    @rendercontentBody(view)

  renderUploadComposition: ->
    view = new App.Views.UploadPictures(model: @session, collection: @collection, type: 'composition')
    @rendercontentBody(view)