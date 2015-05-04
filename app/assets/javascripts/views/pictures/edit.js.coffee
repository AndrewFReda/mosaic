class App.Views.PicturesEdit extends Backbone.View
  template: JST['pictures/edit']

  className: 'picture-edit-dialog'

  events:
    'click .edit-button': 'prepareEditForm'
    'click .update-button': 'updatePicture'
    'click .delete-button': 'deletePicture'

  intialize: ->

  render: =>
    @$el.html(@template(picture: @model))
    this

  prepareEditForm: (e) ->
    @$('.edit-button .glyphicon').switchClass('glyphicon-pencil', 'glyphicon-ok')
    @$('.edit-button .button-text').text('Update')
    @$('.edit-button').switchClass('edit-button', 'update-button')
    @$('.input-container').removeClass('hidden')

  # TODO: Update on S3 as well
  updatePicture: (e) ->
    @model.urlRoot = "users/#{@model.get('user_id')}/pictures"
    @model.set
      name: $('.edit-name').val()
    @model.save(null,
      success: (model, resp, opts) =>
        console.log('success')
        @$('input.edit-name').switchClass('error', 'success')
      
      error: (model, resp, opts) =>
        console.log('failure')
        @$('input.edit-name').switchClass('success', 'error')
    )

  # TODO: Delete off S3 as well
  deletePicture: (e) =>
    @model.urlRoot = "users/#{@model.get('user_id')}/pictures"
    @model.destroy({
      wait: true

      success: (model, resp, opts) =>
        @$el.dialog('close')

      error: (model, resp, opts) =>
        console.log('failure')
    })

