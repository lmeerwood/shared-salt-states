# Sometimes it is necessary to increase the timeout of NPM in order
# to give it time to finish installing packages.
NPM Increase Max and Min Timeout:
  cmd.run:
    - name: "npm config set fetch-retry-mintimeout 100000 -g && npm config set fetch-retry-maxtimeout 600000 -g"
