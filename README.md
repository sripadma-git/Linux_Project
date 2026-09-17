# 🐧 Linux Projects — DevOps & System Administration

> A collection of practical Linux projects focused on automation, monitoring, troubleshooting, security, and system administration.

![Linux](https://img.shields.io/badge/Linux-Administration-black?logo=linux)
![Bash](https://img.shields.io/badge/Bash-Scripting-4EAA25?logo=gnubash\&logoColor=white)
![DevOps](https://img.shields.io/badge/DevOps-Automation-orange)
![Projects](https://img.shields.io/badge/Projects-3-blue)

---

# 📌 About This Repository

Linux is one of the most important foundations of Cloud and DevOps engineering.

This repository contains hands-on Linux projects designed around common tasks that a Cloud/DevOps engineer or Linux administrator may perform on a server.

The projects focus on three important operational areas:

```text
Automation
    ↓
Monitoring & Incident Response
    ↓
Security & Access Control
```

Each project starts with a real-world operational problem and solves it using standard Linux tools and Bash scripting.

---

# 📂 Projects

| #  | Project                                                    | Main Focus                   | Tools                              |
| -- | ---------------------------------------------------------- | ---------------------------- | ---------------------------------- |
| 01 | 🧹 [Automated Log Cleanup](./automated-log-cleanup/)       | Automation & Log Management  | Bash, Cron                         |
| 02 | 🚨 [Incident Health Snapshot](./incident-health-snapshot/) | Monitoring & Troubleshooting | Bash, uptime, free, ps, df, du, ss |
| 03 | 🔐 [Linux Security Hardening](./linux-security-hardening/) | Permissions & Shell Security | Bash, chmod, SSH, PATH             |

---

# 01. 🧹 Automated Log Cleanup

### What does it do?

Application servers continuously generate log files.

For example:

```text
/var/log/escbash-app/

app.log
app.log.1.old
app.log.2.old
app.log.3.old
```

The current `app.log` must remain available, while old rotated `.old` files can eventually consume disk space.

This project creates a Bash script that:

```text
Find old logs
     ↓
Delete *.old
     ↓
Preserve app.log
     ↓
Record execution
```

The cleanup is then scheduled using **Cron** so that it runs automatically.

### Technologies

```text
Linux
Bash
Cron
File management
Log management
```

### Why is it important?

Servers can generate thousands of log files over time.

If disk space reaches 100%:

```text
Disk fills
    ↓
Applications may fail
    ↓
Services may stop
    ↓
Production incident
```

Automating log cleanup reduces repetitive manual work and helps prevent avoidable disk-space problems.

### Key concepts learned

* Bash scripting
* File wildcards
* `rm`
* Cron scheduling
* Output redirection
* Error redirection
* Linux log management
* Automation

### Project

👉 [View Automated Log Cleanup](./automated-log-cleanup/)

---

# 02. 🚨 Incident Health Snapshot

### What does it do?

When a production server becomes slow, an engineer first needs to understand the current state of the machine.

Instead of manually running several commands, this project collects important system information into:

```text
/root/health-report.txt
```

The report contains:

```text
Uptime & Load
      ↓
Memory
      ↓
Running Processes
      ↓
Filesystem Usage
      ↓
Largest /var Directories
      ↓
Listening Network Ports
```

### Technologies

```text
Linux
Bash
System monitoring
Disk analysis
Network inspection
```

### Commands used

```bash
uptime
free -h
ps aux
df -h
du
sort
ss -tlnp
```

### Why is it important?

During an incident, changing the server immediately can destroy useful evidence.

A better approach is:

```text
🚨 Alert
   ↓
📋 Capture current state
   ↓
🔎 Investigate
   ↓
🛠️ Remediate
   ↓
✅ Verify
```

The health snapshot provides a baseline of the server at the moment the incident occurs.

For example, it can help answer:

* Is the system under high load?
* Is memory running low?
* Which processes are consuming resources?
* Is a filesystem nearly full?
* Which `/var` directories are large?
* Which services are listening on network ports?

### Key concepts learned

* Linux system monitoring
* CPU/load analysis
* Memory monitoring
* Process inspection
* Disk usage analysis
* Network socket inspection
* Bash automation
* Incident-response fundamentals

### Project

👉 [View Incident Health Snapshot](./incident-health-snapshot/)

---

# 03. 🔐 Linux Security Hardening

### What does it do?

This project starts with a Linux server containing several security and configuration problems:

```text
Secrets readable by everyone
        ↓
SSH directory too permissive
        ↓
Private key readable by others
        ↓
Deployment helper requires full path
        ↓
No convenient deploy command
```

The project fixes these issues using Linux permissions, PATH configuration, symlinks, and Bash aliases.

### Permissions

Sensitive files are restricted:

```text
secrets.env → 600
.ssh        → 700
id_rsa      → 600
id_rsa.pub  → 644
```

### Deployment helper

Instead of:

```bash
/root/tools/deploy-helper.sh
```

the helper can be executed as:

```bash
deploy-helper
```

And an alias provides:

```bash
deploy
```

### Technologies

```text
Linux permissions
Bash
SSH
chmod
PATH
Symlinks
Bash aliases
```

### Why is it important?

Security problems often begin with excessive permissions.

For example:

```text
Private SSH key
      ↓
Should only be accessible by its owner
```

Giving unnecessary access to secrets or private keys can expose credentials and potentially allow unauthorized access.

This project demonstrates the **principle of least privilege**:

> Give users and processes only the permissions they actually need.

### Key concepts learned

* Linux file permissions
* `chmod`
* SSH key security
* File ownership
* PATH configuration
* Symbolic links
* `.bashrc`
* Bash aliases
* Least privilege

### Project

👉 [View Linux Security Hardening](./linux-security-hardening/)

---

# 🔄 How These Projects Connect

These three projects represent different stages of Linux/DevOps operations.

```text
                    LINUX SERVER
                         │
          ┌──────────────┼──────────────┐
          │              │              │
          ▼              ▼              ▼
      AUTOMATE        MONITOR         SECURE
          │              │              │
          ▼              ▼              ▼
    Log Cleanup     Health Report    Permissions
          │              │              │
          ▼              ▼              ▼
        Cron       Incident Response   SSH/PATH
```

Together, they cover three fundamental operational responsibilities:

### 1. Automate

Don't repeatedly perform the same operational task manually.

```text
Bash + Cron
```

### 2. Observe

Before troubleshooting, understand the current state of the system.

```text
uptime + free + ps + df + du + ss
```

### 3. Secure

Restrict sensitive resources and follow least-privilege principles.

```text
chmod + SSH + PATH + .bashrc
```

---

# 🎯 Why These Projects Matter for DevOps

A DevOps engineer isn't only expected to know cloud services and CI/CD.

Strong Linux fundamentals are required to troubleshoot and operate servers effectively.

These projects demonstrate practical knowledge of:

```text
Linux
  │
  ├── Files & Permissions
  │
  ├── Processes
  │
  ├── Memory
  │
  ├── Disk
  │
  ├── Networking
  │
  ├── Bash
  │
  ├── Automation
  │
  ├── Cron
  │
  └── Security
```

These fundamentals transfer directly into environments involving:

```text
AWS
Docker
Kubernetes
CI/CD
Terraform
Jenkins
Monitoring
Production Operations
```

---

# 📈 Skills Demonstrated

### Linux Administration

* Filesystem management
* Permissions
* Processes
* Memory
* Disk
* Networking

### Bash

* Shell scripting
* Variables
* Command execution
* Output redirection
* File operations
* Automation

### DevOps

* Operational automation
* Scheduled jobs
* Incident response
* System monitoring
* Troubleshooting
* Security hardening

### Security

* Least privilege
* SSH key protection
* Sensitive file protection
* Shell configuration

---

# 🧠 Learning Approach

Each project follows the same operational thinking:

```text
1. Identify the problem
        ↓
2. Understand the Linux system
        ↓
3. Choose the appropriate command/tool
        ↓
4. Automate repetitive work
        ↓
5. Verify the result
        ↓
6. Document the solution
```

The goal is not simply to memorize Linux commands.

The goal is to understand:

> **What problem am I solving, which Linux tool solves it, and how can I make the solution reliable and repeatable?**

---

# 🚀 Future Projects

More Linux/DevOps projects will be added to this repository.

Planned projects include:

* [ ] Disk Usage Monitoring
* [ ] Service Health Checker
* [ ] Automated Backup
* [ ] CPU & Memory Monitoring
* [ ] Linux User Management
* [ ] Nginx Deployment Automation
* [ ] Server Log Analyzer
* [ ] Systemd Service Management
* [ ] Network Troubleshooting Toolkit
* [ ] Automated Server Provisioning

---

# 📚 Repository Goal

The goal of this repository is to build practical Linux skills through small, realistic engineering problems.

Rather than only learning commands theoretically, each project focuses on:

```text
Problem
   ↓
Implementation
   ↓
Automation
   ↓
Verification
   ↓
Documentation
```

---

## 👨‍💻 Author

**Sri Padma Chinta**

Cloud & DevOps Engineer | Linux | AWS | Docker | Kubernetes | Terraform | CI/CD

---

⭐ If you find this repository useful, consider giving it a star.
