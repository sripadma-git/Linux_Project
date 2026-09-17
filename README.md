# 🧹 Automated Log Cleanup — Linux & DevOps Project

> **Automate repetitive Linux log maintenance using Bash scripting and Cron.**

![Linux](https://img.shields.io/badge/Linux-Administration-black?logo=linux)
![Bash](https://img.shields.io/badge/Bash-Scripting-4EAA25?logo=gnubash\&logoColor=white)
![Cron](https://img.shields.io/badge/Cron-Automation-blue)
![DevOps](https://img.shields.io/badge/DevOps-Automation-orange)

---

## 📌 Project Overview

Application servers continuously generate log files. Over time, old rotated logs can consume disk space and potentially cause disk-full problems.

This project automates the cleanup of old application logs using:

* **Bash** — cleanup automation
* **Cron** — scheduled execution
* **Linux filesystem** — log management
* **Logging** — execution history and error capture

The cleanup process removes only files ending in `.old` while preserving the active `app.log`.

---

## 🎯 Problem Statement

The application server stores logs in:

```text
/var/log/escbash-app/
```

Example:

```text
app.log
app.log.1.old
app.log.2.old
app.log.3.old
```

The problem is that old `.old` log files accumulate over time and consume disk space.

Manually deleting these files is:

* Repetitive
* Error-prone
* Easy to forget
* Not scalable

### Objective

Build an automated process that:

1. Identifies old `.old` log files.
2. Deletes only those files.
3. Preserves the active `app.log`.
4. Runs automatically using Cron.
5. Records every execution.
6. Can also be executed manually when required.

---

# 🏗️ Architecture

```text
                 Linux Application Server
                         │
                         ▼
              /var/log/escbash-app/
                         │
              ┌──────────┴──────────┐
              │                     │
          app.log              *.old files
        (KEEP)                  (DELETE)
                                  │
                                  ▼
                         cleanup.sh
                                  │
                                  ▼
                            Cron Scheduler
                                  │
                                  ▼
                         cleanup.log
```

---

# 🔄 How It Works

```text
Cron
  │
  │ Scheduled execution
  ▼
cleanup.sh
  │
  ├── Find *.old
  │
  ├── Delete old rotated logs
  │
  └── Print execution message
          │
          ▼
     cleanup.log
```

The active:

```text
app.log
```

is never targeted by the cleanup pattern.

---

# 📁 Project Structure

```text
automated-log-cleanup/
│
├── README.md
├── cleanup.sh
├── setup.sh
├── cron-example.txt
│
└── screenshots/
    ├── before-cleanup.png
    ├── after-cleanup.png
    └── cron-log.png
```

---

# 🛠️ Technologies Used

| Technology | Purpose                            |
| ---------- | ---------------------------------- |
| Linux      | Operating system environment       |
| Bash       | Automation script                  |
| Cron       | Job scheduling                     |
| `rm`       | Removing old log files             |
| `echo`     | Printing execution status          |
| `chmod`    | Making the script executable       |
| `>>`       | Appending output to a log          |
| `2>&1`     | Redirecting errors to the same log |

---

# ⚙️ Setup

## 1. Create the application log directory

```bash
sudo mkdir -p /var/log/escbash-app
```

## 2. Create sample logs

```bash
echo "service started" | sudo tee /var/log/escbash-app/app.log

echo "old entries" | sudo tee /var/log/escbash-app/app.log.1.old
echo "old entries" | sudo tee /var/log/escbash-app/app.log.2.old
echo "old entries" | sudo tee /var/log/escbash-app/app.log.3.old
```

Check the files:

```bash
ls -lh /var/log/escbash-app/
```

Expected:

```text
app.log
app.log.1.old
app.log.2.old
app.log.3.old
```

---

# 📝 Cleanup Script

Create the script:

```bash
sudo mkdir -p /root/bin
sudo nano /root/bin/cleanup.sh
```

Add:

```bash
#!/bin/bash

rm -f /var/log/escbash-app/*.old

echo "Log cleanup completed"
```

Make it executable:

```bash
sudo chmod +x /root/bin/cleanup.sh
```

---

# 🧪 Test the Script

Run it manually:

```bash
sudo /root/bin/cleanup.sh
```

Expected output:

```text
Log cleanup completed
```

Check the directory:

```bash
ls -lh /var/log/escbash-app/
```

Expected:

```text
app.log
```

The `.old` files should no longer exist.

---

# ⏰ Cron Automation

Create the cleanup log:

```bash
sudo touch /var/log/escbash-app/cleanup.log
```

Open root's crontab:

```bash
sudo crontab -e
```

Add:

```cron
0 0 * * * /root/bin/cleanup.sh >> /var/log/escbash-app/cleanup.log 2>&1
```

This runs the cleanup script **every day at midnight**.

---

# 🔍 Understanding the Cron Entry

```cron
0 0 * * * /root/bin/cleanup.sh >> /var/log/escbash-app/cleanup.log 2>&1
```

| Part                   | Meaning                     |
| ---------------------- | --------------------------- |
| `0`                    | Minute                      |
| `0`                    | Hour                        |
| `*`                    | Every day of month          |
| `*`                    | Every month                 |
| `*`                    | Every day of week           |
| `/root/bin/cleanup.sh` | Script to execute           |
| `>>`                   | Append output               |
| `cleanup.log`          | Execution log               |
| `2>&1`                 | Send errors to the same log |

### Schedule

```text
0 0 * * *
│ │ │ │ │
│ │ │ │ └── Day of week
│ │ │ └──── Month
│ │ └────── Day of month
│ └──────── Hour
└────────── Minute
```

Therefore:

```text
0 0 * * *
```

means:

> Run every day at 00:00.

---

# 📊 Verify Cron

Check the configured Cron jobs:

```bash
sudo crontab -l
```

You should see:

```cron
0 0 * * * /root/bin/cleanup.sh >> /var/log/escbash-app/cleanup.log 2>&1
```

---

# 📜 Check Cleanup History

After the script runs:

```bash
cat /var/log/escbash-app/cleanup.log
```

Example:

```text
Log cleanup completed
Log cleanup completed
Log cleanup completed
```

This provides a basic execution history.

---

# 🔐 Safety Considerations

The script deliberately targets:

```bash
/var/log/escbash-app/*.old
```

instead of deleting everything:

```bash
rm -rf /var/log/escbash-app/*
```

This is important because:

```text
*.old     → delete
app.log   → preserve
cleanup.log → preserve
```

The cleanup operation is therefore scoped to the intended rotated log files.

---

# 🧠 DevOps Concepts Demonstrated

This project demonstrates several practical Linux/DevOps concepts:

### Linux Administration

* Filesystem management
* `/var/log`
* File permissions
* Executable scripts
* Root privileges

### Bash Scripting

* Shebang
* Commands
* Wildcards
* File deletion
* Exit/output handling

### Automation

* Cron jobs
* Scheduled maintenance
* Repetitive task automation

### Logging

* Standard output redirection
* Error redirection
* Persistent execution logs

### Operational Thinking

The key DevOps principle demonstrated here is:

> **Automate repetitive operational tasks instead of relying on manual intervention.**

---

# 🚀 Possible Production Improvements

This project intentionally keeps the implementation simple, but a production environment could improve it further.

### 1. Delete based on file age

Instead of deleting every `.old` file:

```bash
find /var/log/escbash-app/ -name "*.old" -type f -mtime +7 -delete
```

This would delete `.old` files older than 7 days.

### 2. Add timestamps

Instead of:

```bash
echo "Log cleanup completed"
```

use:

```bash
echo "$(date '+%Y-%m-%d %H:%M:%S') - Log cleanup completed"
```

Example:

```text
2026-09-17 00:00:00 - Log cleanup completed
```

### 3. Add error handling

A production script could check whether the log directory exists before attempting cleanup.

### 4. Use `logrotate`

For real production log management, Linux's `logrotate` is often more appropriate than manually deleting rotated logs.

---

# 🧪 Validation Checklist

After implementation, verify:

```text
☑ cleanup.sh exists
☑ cleanup.sh is executable
☑ *.old files are deleted
☑ app.log remains
☑ cleanup.log exists
☑ Cron job is configured
☑ Script output is recorded
☑ Script can be executed manually
```

Useful commands:

```bash
ls -l /root/bin/cleanup.sh
```

```bash
ls -lh /var/log/escbash-app/
```

```bash
sudo crontab -l
```

```bash
cat /var/log/escbash-app/cleanup.log
```

---

# 📸 Project Evidence

Add screenshots demonstrating the project working.

Recommended screenshots:

### 1. Before Cleanup

Show:

```text
app.log
app.log.1.old
app.log.2.old
app.log.3.old
```

### 2. Script Execution

Show:

```bash
sudo /root/bin/cleanup.sh
```

and:

```text
Log cleanup completed
```

### 3. After Cleanup

Show that only:

```text
app.log
cleanup.log
```

remain.

### 4. Cron Configuration

Show:

```bash
sudo crontab -l
```

with the scheduled job.

### 5. Cleanup Log

Show:

```bash
cat /var/log/escbash-app/cleanup.log
```

---

# 📈 Future Enhancements

This project can be extended into a more production-oriented log management solution:

* [ ] Delete logs based on age
* [ ] Compress old logs using `gzip`
* [ ] Monitor disk usage
* [ ] Send alerts when disk usage exceeds a threshold
* [ ] Add structured logging
* [ ] Add error handling
* [ ] Add Bash exit codes
* [ ] Integrate with Prometheus/Grafana
* [ ] Run the cleanup using a `systemd` timer
* [ ] Containerize the demonstration environment

---

# 🎓 What I Learned

Through this project, I practiced:

* Linux filesystem management
* Bash scripting
* File permissions
* Cron scheduling
* Output redirection
* Error redirection
* Log management
* Linux automation
* Basic operational reliability practices

---

# 💼 Resume Relevance

**Automated Log Cleanup — Linux/Bash**

> Developed a Bash-based automated log cleanup solution using Cron to remove obsolete rotated logs while preserving active application logs; implemented execution logging and scheduled maintenance to reduce manual operational overhead.

---

## ⭐ Key Takeaway

The project is based on a simple operational workflow:

```text
IDENTIFY
   ↓
Old logs consuming disk space
   ↓
AUTOMATE
   ↓
Bash cleanup script
   ↓
SCHEDULE
   ↓
Cron
   ↓
OBSERVE
   ↓
cleanup.log
   ↓
REDUCE
   ↓
Manual operational effort
```

**This is a small project, but it demonstrates an important DevOps principle:**

> **If a task is predictable, repetitive, and operationally necessary, automate it.**
