class App.Views.SideNav extends Backbone.View
  template: JST['mosaics/side_nav']

  tagName: 'ul'
  className: 'side-nav'

  events:
    'click #view-mosaics-nav': 'viewMosaics'
    'click #create-mosaics-nav': 'createMosaics'
    'click #manage-content-nav': 'manageContent'
    'click #manage-profile-nav': 'manageProfile'
    
  initialize: ->
    @session = @model

  render: ->
    @$el.html(@template())
    this

  viewMosaics: ->
    view = new App.Views.Mosaics()
    $('#dashboard-content').html(view.render().el)

  createMosaics: ->
    view = new App.Views.CreateMosaic()
    $('#dashboard-content').html(view.render().el)

  manageContent: ->
    view = new App.Views.ManageContent()
    $('#dashboard-content').html(view.render().el)

  manageProfile: ->
    view = new App.Views.ManageProfile()
    $('#dashboard-content').html(view.render().el)