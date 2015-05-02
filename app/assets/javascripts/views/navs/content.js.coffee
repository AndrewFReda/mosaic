class App.Views.ContentNav extends Backbone.View
  template: JST['navs/content']

  events:
    'click .content-nav-item': 'toggleActiveNav'
    'click #content-nav-base': 'renderUploadBase'
    'click #content-nav-composition': 'renderUploadComposition'

  initialize: ->
    @session = @model

  render: ->
    @$el.html(@template())
    @$('#content-nav-composition').addClass('active')
    this

  toggleActiveNav: (e) ->
    @$('.content-nav-item').removeClass('active')
    @$(e.currentTarget).addClass('active')

  renderContentBody: (view) ->
    $('#content-body').html(view.render().el)
    this

  renderUploadBase: ->
    view = new App.Views.UploadPictures(model: @session, collection: @collection, type: 'base')
    @renderContentBody(view)

  renderUploadComposition: ->
    view = new App.Views.UploadPictures(model: @session, collection: @collection, type: 'composition')
    @renderContentBody(view)