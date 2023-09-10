#!/bin/bash

case "$OSTYPE" in
    solaris*) echo "Solaris" ;;
    darwin*)  echo "OSX" ;; 
    linux*)   echo "Linux" ;;
    bsd*)     echo "BSD" ;;
    msys*)    echo "Windows" ;;
    cygwin*)  echo "Windows" ;;
    *)        echo "Unknown operating system: $OSTYPE" ;;
esac
