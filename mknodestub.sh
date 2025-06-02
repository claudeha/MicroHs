#!/bin/sh
cat <<"EOF" > "${1}"
#!/bin/sh
node "${0}.js" "${@}"
EOF
chmod +x "${1}"
