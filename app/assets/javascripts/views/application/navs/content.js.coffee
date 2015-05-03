class App.Views.ContentNav extends Backbone.View
  template: JST['application/navs/content']

  events:
    'click .content-nav-item': 'toggleActiveNav'
    'click #content-nav-base': 'renderUploadBaseForm'
    'click #content-nav-composition': 'renderUploadCompositionForm'

  initialize: ->
    @session = @model

  render: ->
    @$el.html(@template())
    @$('#content-nav-composition').addClass('active')
    this

  toggleActiveNav: (e) ->
    @$('.content-nav-item').removeClass('active')
    @$(e.currentTarget).addClass('active')

  renderUploadBaseForm: ->
    view = new App.Views.PicturesCreate(model: @session, type: 'base')
    @renderContentBody(view)

  renderUploadCompositionForm: ->
    view = new App.Views.PicturesCreate(model: @session, type: 'composition')
    @renderContentBody(view)

  renderContentBody: (view) ->
    $('#content-body').html(view.render().el)