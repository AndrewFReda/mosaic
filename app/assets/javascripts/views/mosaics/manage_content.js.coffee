class App.Views.ManageContent extends Backbone.View
  template: JST['mosaics/manage_content']

  initialize: ->
    @session = @model

  render: =>
    @$el.html(@template())
    view = new App.Views.UploadPictures(model: @session)
    @$el.append(view.render().el)
    this