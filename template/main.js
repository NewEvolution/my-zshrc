// Pull in all the various javascript libraries
requirejs.config({
  baseUrl: "./javascripts",
  paths: {
    "jquery": "../lib/bower_components/jquery/dist/jquery.min",
    "jquery-ui": "../lib/bower_components/jquery-ui/jquery-ui.min",
    "firebase": "../lib/bower_components/firebase/firebase",
    "lodash": "../lib/bower_components/lodash/lodash.min",
    "hbs": "../lib/bower_components/require-handlebars-plugin/hbs",
    "bootstrap": "../lib/bower_components/bootstrap/dist/js/bootstrap.min",
    "q": "../lib/bower_components/q/q"
  },
  shim: {
    "bootstrap": ["jquery"],
    "firebase": {
      exports: "Firebase"
    }
  }
});

// The main function requiring all our anciliary scripts
requirejs(["dependencies"], 
  function(dependencies){
});