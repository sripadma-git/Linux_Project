```bash
#!/bin/bash

# ==========================================
# Linux Security Hardening Script
# ==========================================

echo "Starting Linux security hardening..."

# Secure application secrets
chmod 600 /root/app/secrets.env

# Secure SSH directory
chmod 700 /root/.ssh

# Secure SSH private key
chmod 600 /root/.ssh/id_rsa

# Set public key permissions
chmod 644 /root/.ssh/id_rsa.pub

# Create personal executable directory
mkdir -p /root/bin

# Create deploy-helper command
ln -sf /root/tools/deploy-helper.sh /root/bin/deploy-helper

# Configure persistent PATH
grep -qxF 'export PATH="$HOME/bin:$PATH"' /root/.bashrc || \
sed -i '1i export PATH="$HOME/bin:$PATH"' /root/.bashrc

# Configure deploy alias
grep -qE '^[[:space:]]*alias deploy=' /root/.bashrc || \
echo "alias deploy='deploy-helper'" >> /root/.bashrc

echo "Security hardening completed."
echo
echo "Verify with:"
echo "  ls -ld /root/.ssh"
echo "  ls -l /root/.ssh/"
echo "  ls -l /root/app/secrets.env"
echo "  source /root/.bashrc"
echo "  which deploy-helper"
echo "  deploy"
```
