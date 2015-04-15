class App.Views.ManageContent extends Backbone.View
  template: JST['mosaics/manage_content']

  render: =>
    @$el.html(@template())
    this