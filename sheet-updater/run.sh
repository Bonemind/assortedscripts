#!/bin/sh
docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp ruby:2.4.0-alpine ruby main.rb
