class App.Views.Dashboard extends Backbone.View
  template: JST['mosaics/dashboard']

  initialize: ->

  render: =>
    @$el.html(@template())
    view = new App.Views.Mosaics(collection: @collection)
    @$('#dashboard-content').html(view.render().el)
    view = new App.Views.SideNav(collection: @collection)
    @$('#dashboard-side-nav').html(view.render().el)
    this