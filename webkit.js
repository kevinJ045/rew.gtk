const gi = require('node-gtk');
const Gtk = gi.require('Gtk', '3.0');
const WebKit = gi.require('WebKit2', '4.0');
const path = require('path');

gi.startLoop();
Gtk.init();

const win = new Gtk.Window({
  title: 'Web View Example'
});

win.on('destroy', () => Gtk.mainQuit());

const webview = new WebKit.WebView();

webview.userContentManager.connect('script-message-received::result', (message) => {
  console.log('Received message from JavaScript:', message);
});


webview.loadUri('file://'+path.join(__dirname, 'index.html'));

// Function to execute JavaScript in the WebView
function executeJavaScript(script) {
  r = webview.evaluateJavascript(
      script,
      -1,
      null,
    );
}
// 
webview.connect('load-changed', (loadEvent) => {
  if (loadEvent === WebKit.LoadEvent.FINISHED)
  executeJavaScript('window.webkit.messageHandlers.postMessage("Hello from native!");')
});

win.add(webview);

win.showAll();

Gtk.main();
