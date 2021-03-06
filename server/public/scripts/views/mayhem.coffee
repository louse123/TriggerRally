define [
  'backbone-full'
  'cs!views/view'
  'jade!templates/mayhem'
  'cs!util/popup'
], (
  Backbone
  View
  template
  popup
) ->
  productId = 'mayhem'
  carId = 'Mayhem'

  class MayhemView extends View
    # className: 'overlay'
    template: template
    constructor: (@app, @client) -> super()

    initialize: ->
      @app.root.prefs.car = carId
      @listenTo @app.root, 'change:user', => @render()
      @listenTo @app.root, 'change:user.products', => @render()

    viewModel: ->
      products = @app.root.user?.products ? []
      purchased: 'packa' in products or productId in products
      user: @app.root.user

    afterRender: ->
      app = @app
      $buybutton = @$('a.buybutton')
      # TODO: Disable buy button on click.
      $buybutton.on 'click', ->
        if app.root.user.credits >= 400
          $.ajax
            url: @href
          .done ->
            app.root.user.fetch
              force: yes
        else
          app.showCreditPurchaseDialog()
        false
