class App.Routers.MosaicsRouter extends Backbone.Router
  routes:
    '': 'registrationOrDashboard'

  # Show either dashboard or registration page depending on the session
  registrationOrDashboard: ->
    @session = new App.Models.Session()
    @session.fetch(
      success: @dashboard
      error: @registration
    )

  dashboard: (model, resp, opts) ->
    view = new App.Views.Dashboard(model: model)
    $('#container').html(view.render().el)

  registration: (model, resp, opts) ->
    view = new App.Views.Registration()
    $('#container').html(view.render().el)