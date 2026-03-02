#!/bin/bash
dnf update -y
dnf install -y httpd
systemctl enable httpd
systemctl start httpd
cat > /var/www/html/index.html <<'EOF'
<h1>Green Environment</h1>
EOF
