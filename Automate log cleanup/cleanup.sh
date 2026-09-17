```bash
#!/bin/bash

LOG_DIR="/var/log/escbash-app"

rm -f "$LOG_DIR"/*.old

echo "$(date '+%Y-%m-%d %H:%M:%S') - Log cleanup completed"
```
Then: chmod +x cleanup.sh