# This mirror is provided by the Carnegie Mellon University.
# Currently only used to install Antiword on Centos 8

{% if grains['os_family'] == 'RedHat' and grains['osmajorrelease']|int == 8 %}
cert-forensics-tools:
  pkg.installed:
    - sources:
      - cert-forensics-tools-release: https://forensics.cert.org/cert-forensics-tools-release-el8.rpm

# We only want to use this repos for Antiword. So they are disabled by default and called when needed.
disable-forensics-repo:
  pkgrepo.managed:
    - name: forensics
    - enabled: false
    - require:
      - pkg: cert-forensics-tools

disable-forensics-splunk-repo:
  pkgrepo.managed:
    - name: forensics-splunk
    - enabled: false
    - require:
      - pkg: cert-forensics-tools
{% endif %}
