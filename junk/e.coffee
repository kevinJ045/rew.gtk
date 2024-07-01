app.on 'ready', (ctx) ->
  ctx
    .root
    .button 'hello', style: { width: '100' }
      .on 'click', (bCtx) ->
        bCtx
        .parent
        .parent
        .text (ctx) -> 'added ' + ctx.find('text').length
        .leave()
    .leave()
    .navbar()
      .button ''
        .icon 'plus'
      .leave()
    .leave()
    .find('button#1')
    .remove()
    .button ''
    .text 'hhh'

