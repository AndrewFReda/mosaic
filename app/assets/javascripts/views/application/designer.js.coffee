class App.Views.Designer extends Backbone.View
  template: JST['application/designer']

  id: 'designer'

  events:
    'click .begin-button': 'renderMosaicsCreate'

  render: =>
    @$el.html(@template())
    this

  renderMosaicsCreate: (e) ->
    view = new App.Views.MosaicsCreate()
    @$('#designer-body').html(view.render().el)