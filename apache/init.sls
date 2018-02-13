{% from "apache/map.jinja" import apache with context %}
{% set service_function = { 'enabled':'running', 'dead':'dead', 'disabled':'disabled'}.get(apache.service_status) %}
{% set service_enabled  = { 'enabled':True,      'dead':False,  'disabled':False     }.get(apache.service_status) %}

apache:
  pkg.installed:
    - name: {{ apache.server }}
  group.present:
    - name: {{ apache.group }}
    - system: True
  user.present:
    - name: {{ apache.user }}
    - gid: {{ apache.group }}
    - system: True
  service.{{ service_function }}:
    - name: {{ apache.service }}
    - enable: {{ service_enabled }}

# The following states are inert by default and can be used by other states to
# trigger a restart or reload as needed.
apache-reload:
  module.wait:
    - name: service.reload
    - m_name: {{ apache.service }}

apache-restart:
  module.wait:
    - name: service.restart
    - m_name: {{ apache.service }}
