{ App } = imp './main-old.coffee'

new App( gtk: '4.0' )
  .setup (ctx) ->
    ctx
      .window title: 'My GTK Window', width: 300, height: 200
        .box orientation: 'vertical', spacing: 10
          .button 'Button'
          .back 'button'
          .text 'Some text'
          .back 'text'
        .back 'box'
      .show()
  .run()