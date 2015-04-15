class App.Views.UploadPictures extends Backbone.View
  template: JST['mosaics/upload_pictures']

  render: =>
    @$el.html(@template())
    this