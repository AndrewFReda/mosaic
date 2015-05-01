class App.Views.SideNav extends Backbone.View
  template: JST['mosaics/side_nav']

  events:
    'click .side-nav-item': 'toggleActiveNav'
    'click #side-nav-view-mosaics': 'renderViewMosaics'
    'click #side-nav-create-mosaics': 'renderCreateMosaics'
    'click #side-nav-manage-content': 'renderManageContent'
    'click #side-nav-manage-profile': 'renderManageProfile'
    
  initialize: ->
    @session = @model

  render: ->
    @$el.html(@template())
    @$('#side-nav-view-mosaics').addClass('active')
    this

  toggleActiveNav: (e) ->
    @$('.side-nav-item').removeClass('active')
    $(e.currentTarget).addClass('active')
    false

  renderDashboardBody: (view) ->
    $('#dashboard-body').html(view.render().el)
    false

  renderViewMosaics: (e) ->
    view = new App.Views.Mosaics(model: @session)
    @renderDashboardBody(view)

  renderCreateMosaics: (e) ->
    view = new App.Views.CreateMosaic()
    @renderDashboardBody(view)

  renderManageContent: (e) ->
    view = new App.Views.ManageContent(model: @session)
    @renderDashboardBody(view)

  renderManageProfile: (e) ->
    view = new App.Views.Profile(model: @session)
    @renderDashboardBody(view)