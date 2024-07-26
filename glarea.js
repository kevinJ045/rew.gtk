const gi = require('node-gtk');
const Gtk = gi.require('Gtk', '3.0');

Gtk.init();

const win = new Gtk.Window({
  type: Gtk.WindowType.TOPLEVEL,
  title: 'Gtk.GLArea Example',
});
win.setDefaultSize(800, 600);
win.on('destroy', () => Gtk.mainQuit());

const glArea = new Gtk.GLArea();

glArea.on('realize', () => {
  glArea.makeCurrent();

  console.log('done');
});

glArea.on('render', () => {
  const gl = glArea.getContext();

  gl.clearColor(0.0, 0.0, 0.0, 1.0);
  gl.clear(gl.COLOR_BUFFER_BIT);

  return true;
});

win.add(glArea);
win.showAll();

Gtk.main();
