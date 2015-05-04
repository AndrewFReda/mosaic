class App.Views.MosaicsCreate extends Backbone.View
  template: JST['mosaics/create']

  id: 'mosaics-create'

  events:
    'click .continue-button': 'renderBasePictures'
    'click .create-button': 'createMosaic'

  initialize: ->
    @collection     = new App.Collections.Pictures()
    @collection.url = "/users/#{@model.id}/pictures?type=composition"
    @listenTo(@collection, 'reset', @renderPictures)
    @collection.fetch({reset: true})

  render: =>
    @$el.html(@template())
    this

  renderPictures: (collection) =>
    view = new App.Views.PicturesIndex(model: @model, collection: @collection, subViewAction: 'select')
    @$('#mosaics-create-picture-list').html(view.render().el)

  renderBasePictures: (e) =>
    @selectedCompositionIDs = @getSelectedPictureIDs()
    @updateBaseHeader()
    @$('#mosaics-create-picture-list').addClass('radio-buttons')
    @collection.url = "/users/#{@model.id}/pictures?type=base"
    @collection.fetch({reset: true})

  updateBaseHeader: =>
    @$('.page-sub-title p').text('Select a picture that your mosaic will be based on:')
    @$('.glyphicon-arrow-right').switchClass('glyphicon-arrow-right', 'glyphicon-arrow-up')
    @$('.continue-button').switchClass('continue-button', 'create-button')
    @$('.create-button span').text('Create')

  getSelectedPictureIDs: =>
    selectedPictures = _.remove($('input[type=checkbox]'), 'checked')
    selectedIDs = _.map(selectedPictures, (n) -> return $(n).data('id') )

  createMosaic: (e) =>
    @selectedBaseID = @getSelectedPictureIDs()
    @picture = new App.Models.Picture()
    @picture.url = "/users/#{@model.get('id')}/pictures/mosaic"