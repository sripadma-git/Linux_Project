# 🚨 Incident Health Snapshot

> Capture a real-time snapshot of Linux system health during an incident using Bash and standard monitoring commands.

![Linux](https://img.shields.io/badge/Linux-Administration-black?logo=linux)
![Bash](https://img.shields.io/badge/Bash-Scripting-4EAA25?logo=gnubash\&logoColor=white)
![Incident Response](https://img.shields.io/badge/Incident-Response-red)
![Monitoring](https://img.shields.io/badge/System-Monitoring-blue)

---

## 📌 Project Overview

When a production server becomes slow or an alert fires, the first step is to understand the current state of the machine before making changes.

This project creates a single health report containing key system information:

* ⏱️ Uptime and load average
* 🧠 Memory usage
* ⚙️ Running processes
* 💾 Filesystem disk usage
* 📂 Largest directories under `/var`
* 🌐 Listening network ports

The information is collected from standard Linux commands and written into:

```text
/root/health-report.txt
```

---

## 🎯 Problem Statement

During an incident, engineers need a quick picture of the server's current health.

Instead of manually running multiple commands:

```text
uptime
free
ps
df
du
ss
```

we can capture them into one report.

### Objective

Create a repeatable health snapshot that allows an on-call engineer to quickly inspect:

```text
System
  ↓
CPU / Load
  ↓
Memory
  ↓
Processes
  ↓
Disk
  ↓
Storage hotspots
  ↓
Network listeners
```

---

# 🏗️ Architecture

```text
                 🚨 INCIDENT / ALERT
                         │
                         ▼
                  health-check.sh
                         │
          ┌──────────────┼──────────────┐
          │              │              │
          ▼              ▼              ▼
       uptime          free -h        ps aux
          │              │              │
          ├──────────────┼──────────────┤
          │              │              │
          ▼              ▼              ▼
        df -h       du + sort        ss -tlnp
          │              │              │
          └──────────────┼──────────────┘
                         ▼
              /root/health-report.txt
                         │
                         ▼
                  👨‍💻 On-call Engineer
```

---

# 🛠️ Technologies & Commands

| Command    | Purpose                           |
| ---------- | --------------------------------- |
| `uptime`   | System uptime and load average    |
| `free -h`  | Memory usage summary              |
| `ps aux`   | Running process snapshot          |
| `df -h`    | Filesystem disk usage             |
| `du`       | Directory size analysis           |
| `sort -rh` | Sort directories by size          |
| `ss -tlnp` | Listening TCP ports and processes |
| Bash       | Automation                        |

---

# ⚙️ Project Setup

Create the application log directory:

```bash
mkdir -p /var/log/escbash-app
```

Create sample application logs:

```bash
echo "service started" > /var/log/escbash-app/app.log
echo "request handled" >> /var/log/escbash-app/app.log
echo "request handled" >> /var/log/escbash-app/app.log
```

Verify:

```bash
cat /var/log/escbash-app/app.log
```

Expected:

```text
service started
request handled
request handled
```

---

# 🚀 Manual Health Snapshot

Create the report:

```bash
uptime > /root/health-report.txt
```

Append memory information:

```bash
free -h >> /root/health-report.txt
```

Append running processes:

```bash
ps aux >> /root/health-report.txt
```

Append filesystem usage:

```bash
df -h >> /root/health-report.txt
```

Append the largest directories under `/var`:

```bash
du -h --max-depth=1 /var | sort -rh >> /root/health-report.txt
```

Append listening ports:

```bash
ss -tlnp >> /root/health-report.txt
```

---

# 📄 Generated Report

The final report is stored at:

```text
/root/health-report.txt
```

View the report:

```bash
cat /root/health-report.txt
```

Or:

```bash
less /root/health-report.txt
```

---

# 🧠 Understanding the Commands

## 1. `uptime`

```bash
uptime
```

Provides:

* Current time
* How long the system has been running
* Number of logged-in users
* Load average

Example:

```text
23:10:02 up 5 days, 3:21, 2 users, load average: 0.12, 0.18, 0.15
```

The three load values represent approximately:

```text
1 minute   5 minutes   15 minutes
```

---

## 2. `free -h`

```bash
free -h
```

Displays memory information in human-readable units.

Important values include:

```text
total
used
available
```

This helps determine whether memory pressure could be contributing to poor performance.

---

## 3. `ps aux`

```bash
ps aux
```

Provides a snapshot of running processes.

Useful information includes:

```text
USER
PID
%CPU
%MEM
COMMAND
```

This can help identify processes consuming significant CPU or memory.

---

## 4. `df -h`

```bash
df -h
```

Shows filesystem disk usage.

Important columns include:

```text
Filesystem
Size
Used
Avail
Use%
Mounted on
```

This helps identify filesystems approaching capacity.

---

## 5. `du` + `sort`

```bash
du -h --max-depth=1 /var | sort -rh
```

The command:

```bash
du
```

checks directory sizes.

The option:

```text
--max-depth=1
```

limits the output to directories directly underneath `/var`.

Then:

```bash
sort -rh
```

sorts the results from largest to smallest.

This helps quickly identify storage hotspots.

---

## 6. `ss -tlnp`

```bash
ss -tlnp
```

Shows listening TCP sockets.

Options:

```text
-t  TCP
-l  listening
-n  numeric addresses/ports
-p  process information
```

This helps determine which services are currently listening for network connections.

---

# 🤖 Automating the Process

Instead of manually executing six commands during every incident, create:

```text
health-check.sh
```

Example:

```bash
#!/bin/bash

REPORT="/root/health-report.txt"

echo "===== SYSTEM HEALTH SNAPSHOT =====" > "$REPORT"
echo "Generated: $(date)" >> "$REPORT"

echo "" >> "$REPORT"
echo "===== UPTIME & LOAD =====" >> "$REPORT"
uptime >> "$REPORT"

echo "" >> "$REPORT"
echo "===== MEMORY =====" >> "$REPORT"
free -h >> "$REPORT"

echo "" >> "$REPORT"
echo "===== RUNNING PROCESSES =====" >> "$REPORT"
ps aux >> "$REPORT"

echo "" >> "$REPORT"
echo "===== FILESYSTEM USAGE =====" >> "$REPORT"
df -h >> "$REPORT"

echo "" >> "$REPORT"
echo "===== LARGEST /var DIRECTORIES =====" >> "$REPORT"
du -h --max-depth=1 /var | sort -rh >> "$REPORT"

echo "" >> "$REPORT"
echo "===== LISTENING PORTS =====" >> "$REPORT"
ss -tlnp >> "$REPORT"

echo "" >> "$REPORT"
echo "===== SNAPSHOT COMPLETE =====" >> "$REPORT"

echo "Health report generated: $REPORT"
```

Make it executable:

```bash
chmod +x health-check.sh
```

Run:

```bash
sudo ./health-check.sh
```

View:

```bash
cat /root/health-report.txt
```

---

# 🔍 Why Use `>` and `>>`?

The first command uses:

```bash
>
```

because we want to create a **fresh report**.

Example:

```bash
uptime > /root/health-report.txt
```

Every subsequent command uses:

```bash
>>
```

because we want to **append** information without deleting the previous section.

```text
uptime
   ↓
health-report.txt
   ↓
free -h
   ↓
append
   ↓
ps aux
   ↓
append
   ↓
df -h
   ↓
append
   ↓
du
   ↓
append
   ↓
ss
```

---

# 📊 Incident Investigation Workflow

A practical way to think about this during an incident:

```text
🚨 Alert
   │
   ▼
📋 Capture current state
   │
   ├── Load → Is the system under CPU pressure?
   │
   ├── Memory → Is available memory low?
   │
   ├── Processes → Which processes are active?
   │
   ├── Disk → Is a filesystem nearly full?
   │
   ├── /var → Which directories consume storage?
   │
   └── Ports → Which services are listening?
   │
   ▼
📄 health-report.txt
   │
   ▼
🔎 Begin investigation
```

The important operational principle is:

> **Capture the current state before changing the system.**

This gives the team an initial snapshot that can be reviewed during troubleshooting.

---

# 🔐 Operational Considerations

This project is intended as a **diagnostic snapshot**, not a remediation script.

It does not:

* Kill processes
* Restart services
* Delete files
* Modify network configuration
* Change system settings

It only collects information.

That makes it safer to run at the beginning of an incident.

---

# 🚀 Possible Improvements

The basic snapshot can be extended into a more production-oriented diagnostic tool.

### Future enhancements

* [ ] Add CPU utilization
* [ ] Add top CPU-consuming processes
* [ ] Add top memory-consuming processes
* [ ] Add inode usage
* [ ] Add network statistics
* [ ] Add failed systemd services
* [ ] Add recent system errors
* [ ] Add application log tail
* [ ] Add disk alerts
* [ ] Add timestamped reports
* [ ] Export the report to a monitoring system
* [ ] Integrate with Prometheus/Grafana
* [ ] Add automated incident notifications

---

# 📸 Screenshots

Recommended screenshots:

### Before / Environment

Show:

```bash
ls -lh /var/log/escbash-app/
```

### Script Execution

Show:

```bash
sudo ./health-check.sh
```

### Generated Report

Show:

```bash
cat /root/health-report.txt
```

### System Information

Capture the report showing:

```text
UPTIME
MEMORY
PROCESSES
FILESYSTEM
/var STORAGE
LISTENING PORTS
```

---

# 🎓 What I Learned

This project helped me practice:

* Linux system monitoring
* Bash scripting
* Process inspection
* Memory monitoring
* Disk analysis
* Network socket inspection
* Output redirection
* Incident-response fundamentals
* Operational troubleshooting

---

# 💼 Resume Description

**Incident Health Snapshot — Linux/Bash**

> Built a Bash-based Linux incident diagnostic tool that captures system uptime, load average, memory utilization, running processes, filesystem usage, `/var` storage consumption, and listening network ports into a consolidated health report for rapid incident investigation.

---

# ⭐ Key Takeaway

```text
Don't immediately change the server.

First:
    ↓
Capture
    ↓
Understand
    ↓
Investigate
    ↓
Then remediate
```

A health snapshot gives the on-call engineer a **baseline of the machine's state at the moment an incident occurs**.
