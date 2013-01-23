node default {
  # used by classes/defines specs
}

node 'basic_setup' {
  include 'collectd'
}

node 'single_plugin' {
  include 'collectd'
  collectd::plugin { 'vmem': }

  collectd::config::plugin { 'configure vmem':
    plugin   => 'vmem',
    settings => 'Verbose false',
  }
}

node 'several_plugins_with_deps' {
  include 'collectd'
  collectd::plugin { ['rrdtool', 'ping'] : }
}

node 'plugins_with_same_deps' {
  include 'collectd'
  collectd::plugin { ['apache', 'nginx'] : }
}

node 'custom_intervals' {
  class { 'collectd':
    interval => {
      'cpu'    => 5,
      'memory' => 20,
    }
  }
  collectd::plugin { 'cpu': }
}

node 'globals_exception' {
  include 'collectd'
  collectd::plugin { ['perl', 'python', 'java'] : }
}

node 'plugin_autoload_by_config' {
  include 'collectd'

  collectd::config::plugin { 'configure df':
    plugin   => 'df',
    settings => '
      Device "/dev/sda1"
      ReportReserved true
      ReportInodes true
',
  }
}

node 'plugin_autoload_only_load_once' {
  include 'collectd'

  collectd::config::plugin {
    'foo': plugin => 'ping', settings => 'Host "foo"';
    'bar': plugin => 'ping', settings => 'Host "bar"';
  }
}

node 'custom_type' {
  include 'collectd'

  collectd::config::type { 'my_custom_type':
    value => 'tot:COUNTER:0:U   in:GAUGE:0:U   out:GAUGE:0:U',
  }

  collectd::config::type { 'some_obvious_mistake':
    value => "
I have no idea what I'm doing
",
  }
}

node 'global_param' {
  include 'collectd'
  collectd::config::global { 'Hostname': value => 'foobar' }
}

