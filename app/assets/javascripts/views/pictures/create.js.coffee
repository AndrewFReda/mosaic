class App.Views.PicturesCreate extends Backbone.View
  template: JST['pictures/create']

  className: 'upload-form'

  initialize: (options) ->
    @session = @model
    @type    = options.type
    @collection     = new App.Collections.Pictures()
    @collection.url = "/users/#{@session.id}/pictures?type=#{@type}"
    # Render upload form after pictures have been loaded to avoid duplicate rendering
    @listenToOnce(@collection, 'reset', @renderPictures)
    @collection.fetch({reset: true})

  render: =>
    @$el.html(@template())
    @setUpS3UploadHooks(@$('.file-upload input:file'))
    this

  renderPictures: (collection) =>
    view = new App.Views.PicturesIndex(collection: @collection, subViewAction: 'edit')
    @$('.upload-picture-list').html(view.render().el)
    @addSubView('upload-picture-list', view)

  setUpS3UploadHooks: (el) =>
    fileInput = $(el)
    @pictures = []
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
          success: (response) =>
            # Create picture model in order to add it to collection after upload
            @pictures.push new App.Models.Picture(response.picture)
            @uploadToS3(data, response)

      done: (e, data) =>
        # Find which Picture uploaded then add to @collection
        picture = _.remove(@pictures, (p) -> (p.get('name') == data.files[0].name))
        @collection.add(picture[0])

      fail: (e, data) =>
        # TODO: Handle Failure
        console.log('fail')
    )

  uploadToS3: (data, response) =>
    # After creating our document in rails, we send back JSON of the key, policy
    #  and signature.  We must put these into our form before submitting to S3.
    @$('.file-upload input[name=key]').val(response.s3_upload.key)
    @$('.file-upload input[name=policy]').val(response.s3_upload.policy)
    @$('.file-upload input[name=signature]').val(response.s3_upload.signature)
    @$('.file-upload input[name=ContentType]').val(response.s3_upload.content_type)
    @$('.file-upload input[name=AWSAccessKeyID]').val(response.s3_upload.access_key)
    # Send to Amazon S3
    data.submit()