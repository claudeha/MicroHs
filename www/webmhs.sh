#!/bin/sh
set -ev
npm -i
patch -p2 -N < require.js.patch
( cd node_modules/inherits/inherits_browser/ && ln -s ../inherits_browser.js )
( cd node_modules/process/ && ln -s browser.js process.js )
( mkdir -p node_modules/util/support/isBuffer/ && cd node_modules/util/support/isBuffer/ && ln -s ../isBufferBrowser.js )
EMCC_CFLAGS="-s ALLOW_MEMORY_GROWTH -s TOTAL_STACK=5MB -s NODERAWFS -s SINGLE_FILE -DUSE_SYSTEM_RAW" emmake make -C .. clean install EXEEXT=.js
( mcabal install transformers )
( git clone https://github.com/augustss/mtl.git || (cd mtl && git pull) )
( cd mtl && mcabal install )
( git clone https://github.com/haskell/containers.git || (cd containers && git pull) )
( cd containers/containers && mcabal install )
( git clone https://github.com/augustss/parsec.git || (cd parsec && git pull) )
( cd parsec && mcabal install )
( mcabal update && mcabal install colour )
( git clone -b topic-microhs-compat https://github.com/claudeha/Tidal.git || (cd Tidal && git pull) )
( cd Tidal/tidal-core && mcabal install )
EMCC_CFLAGS="-s ALLOW_MEMORY_GROWTH -s TOTAL_STACK=5MB -DUSE_SYSTEM_RAW" emmake make -C .. EXEEXT=.js www/mhs.html
python3 -m http.server 8080 &
firefox http://localhost:8080
