class App.Views.CreateMosaic extends Backbone.Views
  template: JST['mosaics/create_mosaic']

  render: =>
    @$el.html(@template())
    view = new App.Views.UploadPictures()
    @$el.append(view.render().el)
    this