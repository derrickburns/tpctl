#!/bin/sh -e

wget -q -O artifact.sh 'https://raw.githubusercontent.com/tidepool-org/tools/master/artifact/artifact.sh'
chmod +x artifact.sh

./artifact.sh
