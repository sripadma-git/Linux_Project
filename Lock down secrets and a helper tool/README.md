# 🔐 Linux Security Hardening — Secrets, SSH & PATH

> Harden a Linux server by securing sensitive files, protecting SSH key material, configuring a persistent PATH, and creating a convenient deployment helper alias.

![Linux](https://img.shields.io/badge/Linux-Administration-black?logo=linux)
![Bash](https://img.shields.io/badge/Bash-Scripting-4EAA25?logo=gnubash\&logoColor=white)
![Security](https://img.shields.io/badge/Security-Hardening-red)
![SSH](https://img.shields.io/badge/SSH-Key%20Security-blue)

---

## 📌 Project Overview

A Linux server was handed over with several basic security and usability problems:

* A secrets file was readable by everyone.
* The SSH directory had overly permissive access.
* The SSH private key was readable by other users.
* A public key had incorrect permissions.
* A deployment helper could only be executed using its full path.
* The helper was not available through the normal `PATH`.
* No convenient `deploy` alias existed.

This project fixes those issues using standard Linux permissions, Bash configuration, and PATH management.

---

# 🎯 Objectives

The project has four main objectives:

```text
┌─────────────────────────────────────┐
│       Linux Server Hardening        │
├─────────────────────────────────────┤
│                                     │
│  🔒 Secure secrets                  │
│  🔑 Protect SSH keys                │
│  🛠️ Configure helper command        │
│  ⚡ Create deploy alias              │
│                                     │
└─────────────────────────────────────┘
```

---

# 🧩 Problem Statement

The initial server contains:

```text
/root/app/secrets.env
/root/.ssh/
/root/.ssh/id_rsa
/root/.ssh/id_rsa.pub
/root/tools/deploy-helper.sh
```

The permissions are intentionally insecure.

For example:

```text
secrets.env → 644
.ssh        → 755
id_rsa      → 644
```

This means files containing sensitive information can potentially be accessed by users who should not have access.

The goal is to apply the **principle of least privilege**:

> Give users and processes only the permissions they actually need.

---

# 🔐 Permission Model

Linux permissions are represented using:

```text
r = read
w = write
x = execute / enter directory
```

Permissions are divided into:

```text
owner | group | others
```

For example:

```text
-rw-------
```

means:

```text
Owner  → read + write
Group  → no access
Others → no access
```

---

# 🛡️ Required Permissions

| Resource        | Required Mode | Meaning                       |
| --------------- | ------------: | ----------------------------- |
| `secrets.env`   |         `600` | Owner read/write only         |
| `.ssh/`         |         `700` | Owner read/write/enter only   |
| `id_rsa`        |         `600` | Owner read/write only         |
| `id_rsa.pub`    |         `644` | Owner read/write, others read |
| `deploy-helper` |    executable | Can be executed as a command  |

---

# 🔍 Before Hardening

The initial permissions look like:

```bash
ls -l /root/app/secrets.env
ls -ld /root/.ssh
ls -l /root/.ssh/id_rsa
ls -l /root/.ssh/id_rsa.pub
```

The intentionally insecure configuration includes:

```text
secrets.env → 644
.ssh        → 755
id_rsa      → 644
id_rsa.pub  → 644
```

The important problem is the private key:

```text
id_rsa
```

A private SSH key should not be readable by other users.

---

# 🔧 Hardening the Server

## 1. Secure the secrets file

```bash
chmod 600 /root/app/secrets.env
```

Result:

```text
-rw-------
```

Only the owner can read or modify it.

---

## 2. Secure the `.ssh` directory

```bash
chmod 700 /root/.ssh
```

Result:

```text
drwx------
```

Only the owner can access the directory.

---

## 3. Secure the private SSH key

```bash
chmod 600 /root/.ssh/id_rsa
```

Result:

```text
-rw-------
```

Only the owner can read or write the private key.

---

## 4. Set public key permissions

```bash
chmod 644 /root/.ssh/id_rsa.pub
```

Result:

```text
-rw-r--r--
```

The owner can read/write it, while others can read it.

---

# 🛠️ Make the Deployment Helper Available

The helper currently exists at:

```text
/root/tools/deploy-helper.sh
```

Without configuration, it must be executed using:

```bash
/root/tools/deploy-helper.sh
```

The objective is to run:

```bash
deploy-helper
```

from any directory.

---

# 📂 Create a Personal Binary Directory

Create:

```bash
mkdir -p /root/bin
```

Then create a symlink:

```bash
ln -sf /root/tools/deploy-helper.sh /root/bin/deploy-helper
```

Now:

```text
/root/bin/deploy-helper
        │
        ▼
/root/tools/deploy-helper.sh
```

The `.sh` extension is intentionally removed from the command name.

---

# 🌎 Configure PATH

Add `/root/bin` to the root user's PATH:

```bash
export PATH="$HOME/bin:$PATH"
```

To make this persistent across new Bash sessions, add it to:

```text
/root/.bashrc
```

The resulting configuration allows:

```bash
deploy-helper
```

to work without specifying its full path.

---

# ⚡ Create the `deploy` Alias

Add:

```bash
alias deploy='deploy-helper'
```

Now both commands execute the same helper:

```bash
deploy-helper
```

and:

```bash
deploy
```

---

# 🧪 Verification

## Check file permissions

```bash
ls -l /root/app/secrets.env
```

Expected:

```text
-rw------- ... /root/app/secrets.env
```

Check SSH directory:

```bash
ls -ld /root/.ssh
```

Expected:

```text
drwx------ ... /root/.ssh
```

Check private key:

```bash
ls -l /root/.ssh/id_rsa
```

Expected:

```text
-rw------- ... /root/.ssh/id_rsa
```

Check public key:

```bash
ls -l /root/.ssh/id_rsa.pub
```

Expected:

```text
-rw-r--r-- ... /root/.ssh/id_rsa.pub
```

---

# 🧪 Verify `deploy-helper`

Start a new shell:

```bash
bash
```

Check:

```bash
which deploy-helper
```

Expected:

```text
/root/bin/deploy-helper
```

Run:

```bash
deploy-helper
```

Expected:

```text
deploying esc bash app
```

---

# ⚡ Verify the Alias

Load the updated Bash configuration:

```bash
source /root/.bashrc
```

Check:

```bash
alias deploy
```

Expected:

```text
alias deploy='deploy-helper'
```

Run:

```bash
deploy
```

Expected:

```text
deploying esc bash app
```

---

# 🧠 What I Learned

This project demonstrates several important Linux administration concepts.

### File Permissions

Understanding:

```text
600
644
700
```

and when each permission model should be used.

### SSH Security

Understanding why:

```text
Private key → restricted
Public key  → less restricted
.ssh        → restricted
```

### PATH

Understanding how Linux finds executable commands.

Instead of:

```bash
/root/tools/deploy-helper.sh
```

we can configure:

```bash
deploy-helper
```

### Symlinks

Using:

```bash
ln -sf
```

to expose an existing executable under another command name.

### Bash Configuration

Using:

```text
/root/.bashrc
```

to persist shell configuration such as:

```bash
PATH
aliases
```

### Principle of Least Privilege

The central security principle is:

> **Users should have only the permissions they need.**

---

# 🔄 Before vs After

## ❌ Before

```text
secrets.env → 644
.ssh        → 755
id_rsa      → 644

deploy-helper
      ↓
full path required
```

## ✅ After

```text
secrets.env → 600
.ssh        → 700
id_rsa      → 600
id_rsa.pub  → 644

/root/bin/deploy-helper
      ↓
PATH
      ↓
deploy-helper
      ↓
deploy
```

---

# 🚀 Production Improvements

This lab uses a simple setup, but a production implementation could be extended with:

* [ ] Automated permission validation
* [ ] SSH configuration hardening
* [ ] `umask` configuration
* [ ] Secret management using Vault or a cloud secrets manager
* [ ] File integrity monitoring
* [ ] Audit logging
* [ ] Automated security checks
* [ ] CI validation for shell scripts
* [ ] ShellCheck integration

---

# 📸 Screenshots

Recommended GitHub screenshots:

### 1. Before Hardening

Show the insecure permissions:

```bash
ls -la /root/.ssh
ls -l /root/app/secrets.env
```

### 2. After Hardening

Show:

```bash
ls -ld /root/.ssh
ls -l /root/.ssh/
ls -l /root/app/secrets.env
```

### 3. PATH Configuration

Show:

```bash
which deploy-helper
```

### 4. Deploy Alias

Show:

```bash
alias deploy
deploy
```

Expected:

```text
deploying esc bash app
```

---

# 💼 Resume Description

**Linux Security Hardening — Bash**

> Hardened Linux file and SSH key permissions using `chmod`, configured a persistent user PATH with a symlink-based deployment helper, and created Bash aliases for simplified command execution.

---

# ⭐ Key Takeaway

```text
SECURE
  ↓
Apply least-privilege permissions
  ↓
PROTECT
  ↓
Restrict SSH private keys and secrets
  ↓
CONFIGURE
  ↓
Add required tools to PATH
  ↓
AUTOMATE
  ↓
Create convenient shell aliases
```

This project combines **Linux security + Bash + system administration + shell configuration**, which are foundational skills for Cloud and DevOps engineering.
