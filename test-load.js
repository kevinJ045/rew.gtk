const gi = require('node-gtk');
const GIRepository = gi.require('GIRepository', '2.0');

// Get the repository
const repo = GIRepository.Repository.getDefault();

// Get all loaded namespaces
const namespaces = repo.getLoadedNamespaces();

// List all available modules
console.log('Available modules:');
namespaces.forEach(namespace => {
  console.log(`- ${namespace}`);
});

function testLoad(namespace, version) {
  try {
    gi.require(namespace, version);
    console.log(`${namespace} ${version} loaded successfully`);
  } catch (e) {
    console.error(`Failed to load ${namespace} ${version}: ${e.message}`);
  }
}

console.log('Testing specific modules:');
testLoad('Gtk', '3.0');
testLoad('Gtk', '4.0');
testLoad('Gio', '2.0');
testLoad('WebKit2', '4.0');
