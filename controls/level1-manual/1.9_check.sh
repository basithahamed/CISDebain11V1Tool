#!/usr/bin/env bash

# Check if package manager repositories are configured
if apt -s upgrade 2>&1 | grep -q '0 upgraded, 0 newly installed'; then
  echo -e "1.9 Ensure updates, patches, and additional security software are installed --> \e[32mPASS\e[0m"
else
  echo -e "1.9 Ensure updates, patches, and additional security software are installed --> \e[31mFAIL\e[0m\n - Package manager repositories are not properly configured"
fi
