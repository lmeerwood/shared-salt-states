include:
  - jcu.development_tools

python_2_7 package dependencies:
  pkg.installed:
    - names:
      - zlib-devel
      - bzip2-devel
      - openssl-devel
      - ncurses-devel
      - sqlite-devel
      - readline-devel
      - tk-devel
    - require:
      - cmd: Development Tools

# Starts a chain of events which results in the altinstall of python to /usr/local
python_2_7 source:
  cmd.run:
    - name: wget http://python.org/ftp/python/2.7.3/Python-2.7.3.tar.bz2
    - cwd: /tmp/
    # Don't do this if python2.7 is already installed
    - unless: "[ -x '/usr/local/bin/python2.7' ]"
#    - unless: "[ -f '/tmp/Python-2.7.3.tar.bz2' ]"

python_2_7 decompress:
  cmd.watch:
    - name: tar -xf Python-2.7.3.tar.bz2
    - cwd: /tmp/
    - watch:
      - cmd: python_2_7 source

python_2_7 configure:
  cmd.watch:
    - name: ./configure --prefix=/usr/local/
    - cwd: /tmp/Python-2.7.3/
    - require:
      - pkg: python_2_7 package dependencies
    - watch:
      - cmd: python_2_7 decompress

python_2_7 make && make altinstall:
  cmd.watch:
    - name: make && make altinstall
    - cwd: /tmp/Python-2.7.3/
    - watch:
      - cmd: python_2_7 configure
