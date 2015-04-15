class App.Views.SideNav extends Backbone.View
  template: JST['mosaics/side_nav']

  tagName: 'ul'
  className: 'side-nav'

  events:
    'click .side-nav-item': 'toggleActiveNav'
    'click #view-mosaics-nav': 'viewMosaics'
    'click #create-mosaics-nav': 'createMosaics'
    'click #manage-content-nav': 'manageContent'
    'click #manage-profile-nav': 'manageProfile'
    
  initialize: ->
    @session = @model

  render: ->
    @$el.html(@template())
    this

  viewMosaics: (e) ->
    view = new App.Views.Mosaics(model: @session)
    $('#dashboard-content').html(view.render().el)
    false

  createMosaics: (e) ->
    view = new App.Views.CreateMosaic()
    $('#dashboard-content').html(view.render().el)
    false

  manageContent: (e) ->
    view = new App.Views.ManageContent()
    $('#dashboard-content').html(view.render().el)
    false

  manageProfile: (e) ->
    view = new App.Views.Profile(model: @session)
    $('#dashboard-content').html(view.render().el)
    false

  toggleActiveNav: (e) ->
    @$('.side-nav-item').removeClass('active')
    $(e.currentTarget).addClass('active')
    false