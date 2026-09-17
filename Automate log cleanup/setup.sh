```bash
#!/bin/bash

LOG_DIR="/var/log/escbash-app"

echo "Setting up automated log cleanup project..."

sudo mkdir -p "$LOG_DIR"

echo "service started" | sudo tee "$LOG_DIR/app.log" > /dev/null

echo "old entries" | sudo tee "$LOG_DIR/app.log.1.old" > /dev/null
echo "old entries" | sudo tee "$LOG_DIR/app.log.2.old" > /dev/null
echo "old entries" | sudo tee "$LOG_DIR/app.log.3.old" > /dev/null

sudo touch "$LOG_DIR/cleanup.log"

echo "Setup completed."
echo
echo "Current files:"
ls -lh "$LOG_DIR"
```
