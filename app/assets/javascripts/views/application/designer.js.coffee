class App.Views.Designer extends Backbone.View
  template: JST['application/designer']

  id: 'designer'

  events:
    'click .begin-button': 'renderPicturesMosaic'

  render: =>
    @$el.html(@template())
    this

  renderPicturesMosaic: (e) =>
    @$('.begin-button').addClass('hidden')
    view = new App.Views.PicturesMosaic(model: @model)
    @$('#designer-body').html(view.render().el)