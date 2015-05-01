class App.Views.UploadPictures extends Backbone.View
  template: JST['mosaics/upload_pictures']

  className: 'upload-form'

  initialize: (options) ->
    @type = options.type
    @session = @model
    @listenTo(@collection, 'add', @renderPicture)

  render: =>
    @$el.html(@template())
    @$el.find('.file_upload').find("input:file").each(@setUpS3UploadHooks)
    @collection.forEach(@renderPicture)
    this

  renderPicture: (picture) =>
    if @type == picture.attributes['type']
      view = new App.Views.ShowThumbnail(model: picture, tagName: 'li', className: 'upload-picture-thumbnail')
      @$el.find('.upload-picture-list').append(view.render().el)

  setUpS3UploadHooks: (i, el) =>
    fileInput = $(el)
    fileInput.fileupload(
      autoUpload: true
      replaceFileInput: false
      url: "https://afr-mosaic.s3.amazonaws.com"

      # Each callback called once per file uploaded
      add: (e, data) =>
        # AJAX call to create Picture with Rails JSON API
        $.ajax
          url: "/users/#{@session.id}/pictures"
          type: 'POST'
          dataType: 'json'
          data: { picture: { name: data.files[0].name, type: @type } }
          success: (retdata) =>
            console.log(retdata)
            @picture = new App.Models.Picture(retdata.picture)
            # after we created our document in rails, it is going to send back JSON of the key,
            # policy, and signature.  We will put these into our form before it gets submitted to amazon.
            @$el.find('.file_upload').find('input[name=key]').val(retdata.s3_upload.key)
            @$el.find('.file_upload').find('input[name=policy]').val(retdata.s3_upload.policy)
            @$el.find('.file_upload').find('input[name=signature]').val(retdata.s3_upload.signature)
            @$el.find('.file_upload').find('input[name=ContentType]').val(retdata.s3_upload.content_type)
            @$el.find('.file_upload').find('input[name=AWSAccessKeyID]').val(retdata.s3_upload.access_key)
            data.submit() # Send to Amazon S3

      fail: (e, data) ->
        console.log('fail')

      done: (e, data) =>
        @collection.add @picture
    )