class App.Views.SideNav extends Backbone.View
  template: JST['mosaics/side_nav']

  tagName: 'ul'
  className: 'side-nav'

  events:
    'click .side-nav-item': 'removeActiveNavs'
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
    $(e.currentTarget).addClass('active')
    view = new App.Views.Mosaics(model: @session)
    $('#dashboard-content').html(view.render().el)

  createMosaics: (e) ->
    $(e.currentTarget).addClass('active')
    view = new App.Views.CreateMosaic()
    $('#dashboard-content').html(view.render().el)

  manageContent: (e) ->
    $(e.currentTarget).addClass('active')
    view = new App.Views.ManageContent()
    $('#dashboard-content').html(view.render().el)

  manageProfile: (e) ->
    $(e.currentTarget).addClass('active')
    view = new App.Views.Profile(model: @session)
    $('#dashboard-content').html(view.render().el)

  removeActiveNavs: (e) ->
    @$('.side-nav-item').removeClass('active')