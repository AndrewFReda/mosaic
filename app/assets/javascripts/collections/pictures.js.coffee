class App.Collections.Pictures extends Backbone.Collection
  url: '/users/:user_id/pictures'
  model: App.Models.Picture

  toJSON: ->
    data = {}
    data[@name] = _.clone(@attributes)
    data