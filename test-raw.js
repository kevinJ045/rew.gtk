const gi = require('node-gtk');
const Gtk = gi.require('Gtk', '4.0');
const GLib = gi.require('GLib', '2.0');
const Gdk = gi.require('Gdk', '4.0');

gi.startLoop();
Gtk.init();

const vertexShaderSource = `
  #version 330 core
  layout(location = 0) in vec3 aPos;
  void main()
  {
    gl_Position = vec4(aPos, 1.0);
  }
`;

const fragmentShaderSource = `
  #version 330 core
  out vec4 FragColor;
  void main()
  {
    FragColor = vec4(1.0, 0.5, 0.2, 1.0);
  }
`;

function createShader(gl, type, source) {
  const shader = gl.createShader(type);
  gl.shaderSource(shader, source);
  gl.compileShader(shader);
  if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
    console.error(gl.getShaderInfoLog(shader));
    gl.deleteShader(shader);
    return null;
  }
  return shader;
}

function createProgram(gl, vertexShader, fragmentShader) {
  const program = gl.createProgram();
  gl.attachShader(program, vertexShader);
  gl.attachShader(program, fragmentShader);
  gl.linkProgram(program);
  if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
    console.error(gl.getProgramInfoLog(program));
    gl.deleteProgram(program);
    return null;
  }
  return program;
}

const vertices = new Float32Array([
  -0.5, -0.5, 0.0,
   0.5, -0.5, 0.0,
   0.0,  0.5, 0.0
]);

const app = new Gtk.Application('com.example.GtkGLAreaExample', false);

app.on('activate', () => {
  const win = new Gtk.ApplicationWindow(app);
  win.setDefaultSize(400, 300);

  const glArea = new Gtk.GLArea();
  // glArea.setVExpand(true);
  // glArea.setHExpand(true);

  let program, vao, vbo;

  glArea.on('realize', () => {
    const gl = glArea.getContext();

    const vertexShader = createShader(gl, gl.VERTEX_SHADER, vertexShaderSource);
    const fragmentShader = createShader(gl, gl.FRAGMENT_SHADER, fragmentShaderSource);
    program = createProgram(gl, vertexShader, fragmentShader);
    if (!program) return;

    vao = gl.createVertexArray();
    gl.bindVertexArray(vao);

    vbo = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, vbo);
    gl.bufferData(gl.ARRAY_BUFFER, vertices, gl.STATIC_DRAW);

    const positionLocation = gl.getAttribLocation(program, 'aPos');
    gl.vertexAttribPointer(positionLocation, 3, gl.FLOAT, false, 3 * Float32Array.BYTES_PER_ELEMENT, 0);
    gl.enableVertexAttribArray(positionLocation);

    gl.bindVertexArray(null);
    gl.bindBuffer(gl.ARRAY_BUFFER, null);
  });

  glArea.on('render', () => {
    const gl = glArea.getContext();
    gl.clearColor(0.2, 0.3, 0.3, 1.0);
    gl.clear(gl.COLOR_BUFFER_BIT);

    gl.useProgram(program);
    gl.bindVertexArray(vao);
    gl.drawArrays(gl.TRIANGLES, 0, 3);
    gl.bindVertexArray(null);

    return true;
  });

  win.setChild(glArea);
  win.show();
});

app.run([]);
