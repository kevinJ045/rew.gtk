const gi = require('node-gtk');
const Gtk = gi.require('Gtk', '4.0');
const GLib = gi.require('GLib', '2.0');
const GL = gi.require('Gdk', '4.0').GL;

gi.startLoop();
Gtk.init();

// Shader source code
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

function compileShader(gl, source, type) {
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

function linkProgram(gl, vertexShader, fragmentShader) {
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

// Vertex data for the triangle
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
    const gl = glArea.getContext().getApi();

    // Compile shaders and link the program
    const vertexShader = compileShader(gl, vertexShaderSource, gl.VERTEX_SHADER);
    const fragmentShader = compileShader(gl, fragmentShaderSource, gl.FRAGMENT_SHADER);
    program = linkProgram(gl, vertexShader, fragmentShader);
    if (!program) return;

    // Create and bind VAO and VBO
    vao = gl.createVertexArray();
    gl.bindVertexArray(vao);

    vbo = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, vbo);
    gl.bufferData(gl.ARRAY_BUFFER, vertices, gl.STATIC_DRAW);

    // Link vertex attributes
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
    
    return true;  // Prevents further propagation
  });

  win.setChild(glArea);
  win.show();
});

app.run(null);
