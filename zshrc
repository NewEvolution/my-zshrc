#
# Personal aliases and such
#

alias cls='clear'
alias zsource='source ~/.zshrc'

# Webserver stuff

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

alias webstart="startweb"

function joinweb() {
  if [ -z "$1" ]; then
    PORT=8000
  else
    PORT=$1
  fi
  SCREENNAME=webserver$PORT
  screen -r $SCREENNAME
}

function stopweb() {
  if [ -z "$1" ]; then
    PORT=8000
  else
    PORT=$1
  fi
  SCREENNAME=webserver$PORT
  screen -S $SCREENNAME -p 0 -X stuff $'\003'
}

alias webstop="stopweb"

# Git stuff

alias gpom="git push origin master"
alias gs="git status"
alias gpo="git push origin"

function github() {
  if [ -z "$1" ]; then
    echo 'usage: github <new-repo-name> [<nss>]'
  else
    mkdir $1
    cd $1
    echo "#$1" > README.md
    if [ -z "$2" ]; then; else
      mkdir javascripts
      mkdir styles
      mkdir sass
      echo "bower_components" > .gitignore
      echo "node_modules" >> .gitignore
      echo ".sass-cache" >> .gitignore
      cp ~/workspace/template/index.html ./
      cp ~/workspace/template/favicon.ico ./
      cp ~/workspace/template/Gruntfile.js ./
      cp ~/workspace/template/package.json ./
      cp ~/workspace/template/main.js ./javascripts/
      touch sass/main.scss javascripts/script.js
      npm install
      bower init
      bower install jquery --save
      bower install bootstrap --save
      bower install require-handlebars-plugin --save
      bower install requirejs --save
    fi
    git init
    git add .
    git commit -m "Initial commit"
    remoterepo $1
    git remote add origin git@github.com:NewEvolution/$1
    git push -u origin master
    if [ -z "$2" ]; then; else
      startweb
      stt
      grunt
    fi
  fi
}
