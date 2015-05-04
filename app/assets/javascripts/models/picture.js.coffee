class App.Models.Picture extends Backbone.Model
  urlRoot: '/users/:user_id/pictures'

  name: 'picture'

  toJSON: ->
    data = {}
    data[@name] = _.clone(@attributes)
    data