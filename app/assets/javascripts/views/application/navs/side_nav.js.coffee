class App.Views.SideNav extends Backbone.View
  template: JST['application/navs/side_nav']

  id: 'side-nav'

  events:
    'click .side-nav-item': 'toggleActiveNav'
    'click #side-nav-gallery': 'renderGallery'
    'click #side-nav-designer': 'renderDesigner'
    'click #side-nav-content-manager': 'renderContentManager'
    'click #side-nav-profile': 'renderProfile'
    
  initialize: ->
    @session = @model

  render: ->
    @$el.html(@template())
    @$('#side-nav-gallery').addClass('active')
    this

  toggleActiveNav: (e) ->
    @$('.side-nav-item').removeClass('active')
    @$(e.currentTarget).addClass('active')

  renderGallery: (e) ->
    App.EventBus.trigger('side-nav:gallery')

  renderDesigner: (e) ->
    App.EventBus.trigger('side-nav:designer')

  renderContentManager: (e) ->
    App.EventBus.trigger('side-nav:content-manager')

  renderProfile: (e) ->
    App.EventBus.trigger('side-nav:profile')

  