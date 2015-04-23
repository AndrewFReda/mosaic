class App.Models.User extends Backbone.Model
  # TODO: figure out why this isn't inherited from Collection
  urlRoot: '/users'

  name: 'user'

  toJSON: ->
    data = {}
    data[@name] = _.clone(@attributes)
    data