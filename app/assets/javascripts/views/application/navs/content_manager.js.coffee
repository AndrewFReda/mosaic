class App.Views.ContentManagerNav extends Backbone.View
  template: JST['application/navs/content_manager']

  events:
    'click .content-manager-nav-item': 'toggleActiveNav'
    'click #content-manager-nav-base': 'renderUploadBaseForm'
    'click #content-manager-nav-composition': 'renderUploadCompositionForm'

  initialize: ->
    @session = @model

  render: ->
    @$el.html(@template())
    @$('#content-manager-nav-composition').addClass('active')
    this

  toggleActiveNav: (e) ->
    @$('.content-manager-nav-item').removeClass('active')
    @$(e.currentTarget).addClass('active')

  renderUploadBaseForm: ->
    view = new App.Views.PicturesCreate(model: @session, type: 'base')
    @renderContentManagerBody(view)

  renderUploadCompositionForm: ->
    view = new App.Views.PicturesCreate(model: @session, type: 'composition')
    @renderContentManagerBody(view)

  renderContentManagerBody: (view) ->
    $('#content-manager-body').html(view.render().el)