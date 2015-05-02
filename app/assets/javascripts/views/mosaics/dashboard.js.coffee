class App.Views.Dashboard extends Backbone.View
  template: JST['mosaics/dashboard']

  id: 'dashboard'

  events:
    'click #sign-out': 'signOut'

  initialize: ->
    @session = @model

  render: =>
    @$el.html(@template())
    view = new App.Views.SideNav(model: @session)
    @$('#dashboard-side-nav').html(view.render().el)
    view = new App.Views.Mosaics(model: @session)
    @$('#dashboard-body').html(view.render().el)
    this

  signOut: ->
    @session.destroy
      success: ->
        view = new App.Views.Registration()
        $('#container').html(view.render().el)
      error: ->
        # handle error
    false