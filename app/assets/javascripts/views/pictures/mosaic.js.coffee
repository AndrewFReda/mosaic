class App.Views.PicturesMosaic extends Backbone.View
  template: JST['pictures/mosaic']

  id: 'pictures-mosaic'

  events:
    'click .select-all': 'selectAllPictures'
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
    @$('#pictures-mosaic-picture-list').html(view.render().el)
    @addSubView('pictures-mosaic-picture-list', view)

  selectAllPictures: (e) ->
    _.forEach(@$('input[type=checkbox]'), (cb) -> $(cb)[0].checked = true)
    @$('.picture img').addClass('selected')

  renderBasePictures: (e) =>
    @selectedCompositionIDs = @getSelectedPictureIDs()
    @updateBaseHeader()
    @$('#pictures-mosaic-picture-list').addClass('radio-buttons')
    @collection.url = "/users/#{@model.id}/pictures?type=base"
    @collection.fetch({reset: true})

  updateBaseHeader: =>
    @$('.page-sub-title p').text('Select a picture that your mosaic will be based on:')
    @$('.glyphicon-arrow-right').switchClass('glyphicon-arrow-right', 'glyphicon-arrow-up')
    @$('.continue-button').switchClass('continue-button', 'create-button')
    @$('.select-all').addClass('hidden')
    @$('.create-button span').text('Create')

  getSelectedPictureIDs: =>
    selectedPictures = _.remove($('input[type=checkbox]'), 'checked')
    selectedIDs = _.map(selectedPictures, (n) -> return $(n).data('id') )

  createMosaic: (e) =>
    @selectedBaseID = @getSelectedPictureIDs()
    @picture = new App.Models.Picture()
    @picture.url = "/users/#{@model.get('id')}/pictures/mosaic"
    @picture.save({
        composition_picture_ids: @selectedCompositionIDs
        base_picture_id: @selectedBaseID
      }
      success: (model, resp, opts) ->
      error: (model, resp, opts) ->
    )