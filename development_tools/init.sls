# pkg.group_install is not yet available as a state.
# See https://github.com/saltstack/salt/issues/5504
Development Tools:
  module.run:
    - name: pkg.group_install
    - m_name: Development Tools
