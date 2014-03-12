nginx-repository:
   pkgrepo.managed:
      - name: nginx
      - humanname: nginx repo
      - baseurl: http://nginx.org/packages/{{ 'centos' if grains['os'] == 'CentOS' else 'rhel' }}/{{ grains['osmajorrelease'][0] }}/$basearch/ 
      - gpgcheck: 0
      - enabled: 1 

nginx:
   pkg.installed: 
      - require:
           - pkgrepo: nginx-repository
   service.running:
      - enable: True
      - reload: True
      - watch:
          - pkg: nginx
   file.managed:
      - name: /etc/nginx/nginx.conf
      - source: salt://jcu/nginx/nginx.conf 
      - user: nginx
      - group: nginx
      - mode: 644
      - template: jinja
      - require:
          - pkg: nginx
      - watch_in:
          - service: nginx

# Remove default files
{% for path in ['/etc/nginx/conf.d/default.conf', '/etc/nginx/conf.d/example_ssl.conf'] %}
{{ path }}:
   file.absent:
      - require:
        - pkg: nginx
{% endfor %}

Nginx snippets and base configuration:
   file.recurse:
      - name: /etc/nginx/conf.d
      - source: salt://jcu/nginx/conf.d
      - user: nginx
      - group: nginx
      - require:
         - pkg: nginx

nginx maintenance resources:
   file.recurse:
      - name: /usr/share/nginx/html/maintenance
      - source: salt://jcu/nginx/maintenance
      - user: nginx
      - group: nginx
      - template: jinja
      - require:
         - pkg: nginx

# Firewall configuration
http iptables:
   module.wait:
      - name: iptables.insert
      - table: filter
      - chain: INPUT
      - position: 3
      - rule: -p tcp --dport 80 -j ACCEPT
      - watch:
        - pkg: nginx

https iptables:
   module.wait:
      - name: iptables.insert
      - table: filter
      - chain: INPUT
      - position: 3
      - rule: -p tcp --dport 443 -j ACCEPT
      - watch:
        - pkg: nginx
