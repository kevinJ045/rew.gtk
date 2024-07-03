import { appOptions } from "./src/models/config.coffee"
import { createUiApp } from "./src/modules/app.coffee"

UI = Usage::create 'gui', (options, cb) ->
  if Array.isArray options
    options = { with: options, gtk: '4.0' }
  if typeof options is "function" and not cb
    cb = options
    options = { gtk: '4.0' }
  cb createUiApp appOptions options
  

UI.init = (options) -> createUiApp appOptions options

module.exports = if Object.keys(imports.assert).find((i) -> Object.keys(appOptions()).includes(i)) then UI.init(imports.assert) else UI