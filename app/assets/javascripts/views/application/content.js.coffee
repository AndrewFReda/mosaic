class App.Views.Content extends Backbone.View
  template: JST['application/content']

  id: 'content'

  initialize: ->
    @session = @model

  render: =>
    @$el.html(@template())
    view = new App.Views.ContentNav(model: @session)
    @$('#content-nav').html(view.render().el)
    view = new App.Views.PicturesCreate(model: @session, type: 'composition')
    @$('#content-body').html(view.render().el)
    this

    