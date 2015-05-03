class App.Views.Create extends Backbone.View
  template: JST['application/create']

  id: 'create'

  events:
    'click .begin': 'renderCompositionSelect'
    'click .next': 'renderBaseSelect'
    'click .create-btn': 'createMosaic'

  render: =>
    @$el.html(@template())
    this

  renderCompositionSelect: (e) ->
    view = new App.Views.SelectPictures(collection: @collection, type: 'composition')
    @$('.create-body').html(view.render().el)

  renderBaseSelect: (e) ->
    view = new App.Views.SelectPictures(collection: @collection, type: 'base')
    @$('.create-body').html(view.render().el)

  createMosaic: (e) ->