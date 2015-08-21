# Webserver stuff

# This function starts the webserver in the current directory at port 8000
# if 8000 is taken, it uses the next available port.  The port the server
# is started on is echoed back to the terminal.
function startweb() {
  COUNTER=8000
  PORTCHECK=$(netstat -an | grep $COUNTER | grep -ic listen)
  while [ ${PORTCHECK} != 0 ]; do
    COUNTER=$(($COUNTER + 1))
    PORTCHECK=$(netstat -an | grep $COUNTER | grep -ic listen)
  done
  SCREENNAME="webserver$COUNTER"
  echo $SCREENNAME
  screen -dmS $SCREENNAME python -m SimpleHTTPServer $COUNTER
}

# This function connects to the detatched screen session containing the webserver
# started by startweb.  It can take one argument, that being the port of the webserver
# if no port is given it uses 8000 by default.  Calling this without specifying a port
# when there is more than one webserver running will result in an error.
function joinweb() {
  if [ -z "$1" ]; then
    PORT=8000
  else
    PORT=$1
  fi
  SCREENNAME=webserver$PORT
  screen -r $SCREENNAME
}

# This function stops the webserver on the detatched screen session containing the webserver
# started by startweb.  It can take one argument, that being the port of the webserver
# if no port is given it uses 8000 by default.  Calling this without specifying a port
# when there is more than one webserver running will result in an error.
function stopweb() {
  if [ -z "$1" ]; then
    PORT=8000
  else
    PORT=$1
  fi
  SCREENNAME=webserver$PORT
  screen -S $SCREENNAME -p 0 -X stuff $'\003'
}


# Git stuff - some aliases for the most commonly done things in Git that aren't
# already provided by the oh-my-zsh git plugin.

alias gpom="git push origin master"
alias gs="git status"
alias gpo="git push origin"
alias gam="ga .; gcmsg $1"

# Initializes a new directory to have all the bower & NPM stuff, called
# in the github function below as well.
function siteinit () {
  npm install
  cp ~/workspace/template/bower.json ./
  bower install
}

# Same as above, but explicitly creates and adds all the dependencies
# to bower.json instead of copying in a premade one.
function rawsiteinit () {
  npm install
  bower init
  bower install jquery --save
  bower install jquery-ui --save
  bower install bootstrap --save
  bower install require-handlebars-plugin --save
  bower install requirejs --save
  bower install lodash --save
  bower install firebase --save
  bower install q#1.0.1 --save
}

# The mother of all functions.  This can take 2 arguments, and requires one.
# The first argument is the name of the directory and github repository you want to make.
# The second argument can be anything, and having a second argument at all runs the setup
# routine of copying in all the NSS default formatted HTML, SASS, directories, etc.
# Note that my paths to the templates directory are hard-coded into this function, and
# WILL NOT match up to the template directory as supplied in this git repo.  You will need
# to stick that template directory someplace and modify the "~/workspace/template" paths
# as needed to match your directory layout.
function github() {
  if [ -z "$1" ]; then #if you screw up the command, echo back how to use it
    echo 'usage: github <new-repo-name> [<nss>]'
  else
    mkdir $1 #make a directory named what we want it
    cd $1 #go into that directory
    echo "#$1" > README.md #copy the name of the directory/github repo into the README
    if [ -z "$2" ]; then; else #if we want the NSS site init...
      mkdir javascripts
      mkdir styles
      mkdir sass
      mkdir templates
      mkdir lib
      echo "bower_components" > .gitignore #flesh out our .gitignore
      echo "node_modules" >> .gitignore
      echo ".sass-cache" >> .gitignore
      cp ~/workspace/template/index.html ./ #copy in all the default templates
      cp ~/workspace/template/favicon.ico ./
      cp ~/workspace/template/Gruntfile.js ./lib/
      cp ~/workspace/template/package.json ./lib/
      cp ~/workspace/template/main.js ./javascripts/
      cp ~/workspace/template/dependencies.js ./javascripts/
      touch sass/main.scss #initialise the sass main file
      cd lib
      siteinit #do all the fun stuff above setting up bower/nmp etc.
      cd ..
    fi
    git init #make the whole thing a git repo
    git add .
    git commit -m "Initial commit"
    remoterepo $1 #this is the custom executible script that sets up your github repo
    git remote add origin https://github.com/YOUR-GIT-USERNAME-GOES-HERE/$1.git #this will need to be modified for you!!!!!!
    git push -u origin master
    if [ -z "$2" ]; then; else #if we're doing the NSS thing...
      startweb #start the webserver
      stt #open this whole directory in sublimetext (needs the sublime oh-my-zsh plugin)
      cd lib #go into lib
      grunt #get grunt running
    fi
  fi
}

