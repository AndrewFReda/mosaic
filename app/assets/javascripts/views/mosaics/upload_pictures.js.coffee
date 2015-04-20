class App.Views.UploadPictures extends Backbone.View
  template: JST['mosaics/upload_pictures']

  className: 'upload-form'

  initialize: ->
    @session = @model

  events:
    'click #file_upload button': 'upload'

  render: =>
    @$el.html(@template())
    @$('#file_upload').find("input:file").each(@setUpS3UploadHooks)
    this

  upload: (e) ->
    false


  setUpS3UploadHooks: (i, elem) =>
    fileInput = $(elem)
    fileInput.fileupload(
      forceIframeTransport: true    # IMPORTANT. You will get 405 Method Not Allowed if you don't add this.
      autoUpload: true

      # TODO: Dynamically create URL
      url: "https://s3.amazonaws.com/afr-mosaic/this@that.com/" + fileInput.data('picture-type')

      add: (event, data) ->
        console.log('add')
        data.submit()

      send: (e, data) ->
        console.log('send')

      fail: (e, data) ->
        console.log('fail')

      done: (event, data) ->
        console.log('done')
    )