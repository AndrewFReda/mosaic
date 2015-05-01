class App.Views.ManageContent extends Backbone.View
  template: JST['mosaics/manage_content']

  events:
    'click .manage-content-nav-item': 'toggleActiveNav'
    'click #manage-content-nav-base': 'renderUploadBase'
    'click #manage-content-nav-composition': 'renderUploadComposition'

  initialize: ->
    @session = @model
    @collection     = new App.Collections.Pictures()
    @collection.url = '/users/' + @session.id + '/pictures'
    @collection.fetch()

  render: =>
    @$el.html(@template())
    @renderUploadComposition()
    @$('#manage-content-nav-composition').addClass('active')
    this

  toggleActiveNav: (e) ->
    @$('.manage-content-nav-item').removeClass('active')
    $(e.currentTarget).addClass('active')
    false

  renderManageContentBody: (view) ->
    @$('#manage-content-body').html(view.render().el)
    false

  renderUploadBase: ->
    view = new App.Views.UploadPictures(model: @session, collection: @collection, type: 'base')
    @renderManageContentBody(view)

  renderUploadComposition: ->
    view = new App.Views.UploadPictures(model: @session, collection: @collection, type: 'composition')
    @renderManageContentBody(view)