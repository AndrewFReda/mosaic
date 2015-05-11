class App.Views.ContentManager extends Backbone.View
  template: JST['application/content_manager']

  id: 'content-manager'

  initialize: ->
    @session = @model
    @listenTo(App.EventBus, 'content-manager-nav:base', @renderUploadBaseForm)
    @listenTo(App.EventBus, 'content-manager-nav:composition', @renderUploadCompositionForm)

  render: =>
    @$el.html(@template())
    view = new App.Views.ContentManagerNav(model: @session)
    @addSubView('content-manager-nav', view)
    @$('#content-manager-nav').html(view.render().el)
    @renderUploadCompositionForm()
    this

  renderUploadBaseForm: ->
    view = new App.Views.PicturesCreate(model: @session, type: 'base')
    @renderContentManagerBody(view)

  renderUploadCompositionForm: ->
    view = new App.Views.PicturesCreate(model: @session, type: 'composition')
    @renderContentManagerBody(view)

  renderContentManagerBody: (view) ->
    @$('#content-manager-body').html(view.render().el)
    @addSubView('content-manager-body', view)