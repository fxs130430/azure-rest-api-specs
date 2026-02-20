---
# No `on:` here — this is a shared component meant to be imported.
description: List of networks accessible from GitHub agent workflow
network:
  allowed:
    - defaults
    - "login.microsoftonline.com"
    - "dev.azure.com"
    - "*.dev.azure.com"
    - "*.applicationinsights.azure.com"
    - "*.visualstudio.com"
    - "management.azure.com"
---
