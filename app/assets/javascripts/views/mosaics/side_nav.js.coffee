class App.Views.SideNav extends Backbone.View
  template: JST['mosaics/side_nav']

  tagName: 'ul'
  className: 'side-nav'

  events:
    'click #view-mosaics': 'viewMosaics'
    'click #create-mosaics': 'createMosaics'
    'click #manage-content': 'manageContent'
    'click #manage-profile': 'manageProfile'
    
  render: ->
    @$el.html(@template())
    this

  viewMosaics: ->
    view = new App.Views.Mosaics(collection: @collection)
    $('#dashboard-content').html(view.render().el)

  createMosaics: ->
    view = new App.Views.CreateMosaic(collection: @collection)
    $('#dashboard-content').html(view.render().el)

  manageContent: ->
    view = new App.Views.ManageContent(collection: @collection)
    $('#dashboard-content').html(view.render().el)

  manageProfile: ->
    view = new App.Views.ManageProfile(collection: @collection)
    $('#dashboard-content').html(view.render().el)