# This workflow uses actions that are not certified by GitHub.
# They are provided by a third-party and are governed by
# separate terms of service, privacy policy, and support
# documentation.

# This workflow integrates Scan with GitHub's code scanning feature
# Scan is a free open-source security tool for modern DevOps teams from ShiftLeft
# Visit https://slscan.io/en/latest/integrations/code-scan for help
name: SL Scan

on:
  push:
    branches: [ base, branch ]
  pull_request:
    # The branches below must be a subset of the branches above
    branches: [ base ]
  schedule:
    - cron: '45 4 * * 2'

jobs:
  Scan-Build:
    # Scan runs on ubuntu, mac and windows
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    # Instructions
    # 1. Setup JDK, Node.js, Python etc depending on your project type
    # 2. Compile or build the project before invoking scan
    #    Example: mvn compile, or npm install or pip install goes here
    # 3. Invoke Scan with the github token. Leave the workspace empty to use relative url

    - name: Perform Scan
      uses: ShiftLeftSecurity/scan-action@39af9e54bc599c8077e710291d790175c9231f64
      env:
        WORKSPACE: ""
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        SCAN_AUTO_BUILD: true
      with:
        output: reports
        # Scan auto-detects the languages in your project. To override uncomment the below variable and set the type
        # type: credscan,java
        # type: python

    - name: Upload report
      uses: github/codeql-action/upload-sarif@v1
      with:
        sarif_file: reports
