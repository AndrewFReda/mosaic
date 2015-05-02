class App.Views.SideNav extends Backbone.View
  template: JST['navs/side_nav']

  id: 'side-nav'

  events:
    'click .side-nav-item': 'toggleActiveNav'
    'click #side-nav-mosaics': 'renderMosaics'
    'click #side-nav-create': 'renderCreate'
    'click #side-nav-content': 'renderContent'
    'click #side-nav-profile': 'renderProfile'
    
  initialize: ->
    @session = @model

  render: ->
    @$el.html(@template())
    @$('#side-nav-mosaics').addClass('active')
    this

  toggleActiveNav: (e) ->
    @$('.side-nav-item').removeClass('active')
    @$(e.currentTarget).addClass('active')
    false

  renderDashboardBody: (view) ->
    $('#dashboard-body').html(view.render().el)
    false

  renderMosaics: (e) ->
    view = new App.Views.Mosaics(model: @session)
    @renderDashboardBody(view)

  renderCreate: (e) ->
    view = new App.Views.Create()
    @renderDashboardBody(view)

  renderContent: (e) ->
    view = new App.Views.Content(model: @session)
    @renderDashboardBody(view)

  renderProfile: (e) ->
    view = new App.Views.Profile(model: @session)
    @renderDashboardBody(view)