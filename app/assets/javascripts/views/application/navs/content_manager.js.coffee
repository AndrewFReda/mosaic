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
    App.EventBus.trigger('content-manager-nav:base')

  renderUploadCompositionForm: ->
    App.EventBus.trigger('content-manager-nav:composition')