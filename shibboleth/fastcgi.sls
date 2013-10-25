include:
   - jcu.shibboleth
   - jcu.repositories.eresearch
   - jcu.supervisord
   - jcu.nginx.custom

{% set shibboleth_user = salt['pillar.get']('shibboleth:user', 'shibd') %}
{% set shibboleth_group = salt['pillar.get']('shibboleth:group', 'shibd') %}

# Install customised version supporting FastCGI
extend:
   shibboleth:
      pkg:
         - fromrepo: jcu-eresearch
         - require:
            - pkgrepo: jcu-eresearch 
            - file: Shibboleth package repository 

# Nginx snippets and configuration
/etc/nginx/conf.d/:
   file.recurse:
      - source: salt://jcu/shibboleth/nginx/
      - user: nginx
      - group: nginx
      - require:
         - pkg: nginx

# Manage FastCGI applications
shibboleth fastcgi:
    file.directory:
      - name: /opt/shibboleth
      - user: {{ shibboleth_user }}
      - group: {{ shibboleth_group }}
      - makedirs: true
    user.present:
       - name: nginx
       - groups:
          - nginx
          - shibd
       - require:
          - pkg: nginx
       - watch_in:
          - service: nginx

/etc/supervisord.d/shibboleth-fastcgi.ini:
   file.managed:
      - source: salt://jcu/shibboleth/shibboleth-fastcgi.ini
      - user: root
      - group: root
      - mode: 644
      - requires:
         - user: shibboleth fastcgi
         - pkg: supervisord
         - pkg: shibboleth
         - file: /opt/shibboleth
      - watch_in:
         - service: supervisord

shibauthorizer:
   supervisord.running:
      - update: true
      - watch:
         - file: /etc/supervisord.d/shibboleth-fastcgi.ini

shibresponder:
   supervisord.running:
      - update: true
      - watch:
         - file: /etc/supervisord.d/shibboleth-fastcgi.ini
