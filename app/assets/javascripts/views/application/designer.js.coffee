class App.Views.Designer extends Backbone.View
  template: JST['application/designer']

  id: 'designer'

  events:
    'click .begin-button': 'renderMosaicsCreate'

  render: =>
    @$el.html(@template())
    this

  renderMosaicsCreate: (e) =>
    @$('.begin-button').addClass('hidden')
    view = new App.Views.MosaicsCreate(model: @model)
    @$('#designer-body').html(view.render().el)