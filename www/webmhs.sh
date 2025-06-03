#!/bin/bash
set -ev
npm install
patch -p2 -N < require.js.patch || echo "ignored"
( mkdir -p node_modules/inherits/inherits_browser/ && cd node_modules/inherits/inherits_browser/ && ln -fs ../inherits_browser.js )
( cd node_modules/process/ && ln -fs browser.js process.js )
( mkdir -p node_modules/util/support/isBuffer/ && cd node_modules/util/support/isBuffer/ && ln -fs ../isBufferBrowser.js )
( git clone https://github.com/emscripten-core/emsdk.git || (cd emsdk && git pull) )
( cd emsdk && ./emsdk install latest && ./emsdk activate latest )
. "$(pwd)/emsdk/emsdk_env.sh"
EMCC_CFLAGS="-s ALLOW_MEMORY_GROWTH -s TOTAL_STACK=5MB -s NODERAWFS -s SINGLE_FILE -DUSE_SYSTEM_RAW" emmake make -C .. clean install EXEEXT=.js
PATH="${PATH}:/home/web_user/.mcabal/bin"
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
