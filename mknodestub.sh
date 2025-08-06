#!/bin/sh
cat <<"EOF" > "${1}"
#!/bin/sh
ulimit -s unlimited
node --stack-size=1100100100 "${0}.js" "${@}"
EOF
chmod +x "${1}"
