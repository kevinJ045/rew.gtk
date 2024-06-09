


app.on 'ready', ctx -> 
  ctx
  	.root
  	.button 'hello'
  	.on 'click', bCtx ->
  		print 'hi'
  	.leave()
  	.navbar()
  	.button ''
  	.icon 'plus'
  	.leave()
