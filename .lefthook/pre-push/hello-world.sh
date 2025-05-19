#!/bin/bash
# .lefthook/pre-push/hello-world.sh

echo "👋 Hello world from the pre-push hook!"
echo "Pushing to remote..."

# To make the hook pass, it must exit with 0.
# To make it fail, exit with a non-zero status, e.g., exit 1.
exit 0