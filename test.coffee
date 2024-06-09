{ App } = imp './main.coffee'

new App( gtk: '4.0' )
  .setup (ctx) ->
    ctx
      .window title: 'My GTK Window', width: 300, height: 200
        .box orientation: 'vertical'
          .button 'Imabutt'
          .back 'button'
          .button 'bttt'
          .back 'button'
          .text 'hi'
          .back 'text'
        .back 'box'
      .show()
  .run()