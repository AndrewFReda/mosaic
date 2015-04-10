class App.Collections.Pictures extends Backbone.Collection
  url: '/users/:user_id/pictures'
  model: App.Models.Picture