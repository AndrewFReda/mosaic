class App.Views.UploadPictures extends Backbone.View
  template: JST['mosaics/upload_pictures']

  className: 'upload-form'

  initialize: ->
    @session = @model

  render: =>
    @$el.html(@template())
    @$('#file_upload').find("input:file").each(@setUpS3UploadHooks)
    this

  setUpS3UploadHooks: (i, el) =>
    fileInput = $(el)
    fileInput.fileupload(
      autoUpload: true
      url: "https://afr-mosaic.s3.amazonaws.com"

      add: (e, data) =>
        $.ajax
          # TODO: Dynamically create URL
          url: "/users/#{@session.id}/pictures"
          type: 'POST'
          dataType: 'json'
          data: { picture: { name: data.files[0].name, type: fileInput.data('picture-type') } }
          success: (retdata) ->
            # after we created our document in rails, it is going to send back JSON of they key,
            # policy, and signature.  We will put these into our form before it gets submitted to amazon.
            $('#file_upload').find('input[name=key]').val(retdata.key)
            $('#file_upload').find('input[name=policy]').val(retdata.policy)
            $('#file_upload').find('input[name=signature]').val(retdata.signature)
            $('#file_upload').find('input[name=ContentType]').val(retdata.content_type)
            $('#file_upload').find('input[name=AWSAccessKeyID]').val(retdata.access_key)
            data.submit() # Send to Amazon S3

      send: (e, data) ->
        console.log('send')

      fail: (e, data) ->
        console.log('fail')

      done: (event, data) ->
        console.log('done')
    )