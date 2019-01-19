class { conjur:
  account	     => 'dev',
  appliance_url      => 'https://conjur-master:30443/api',
  authn_login        => "host/app-${::trusted['hostname']}",
  host_factory_token => Sensitive('2260yed1snhy1w3qkqepkfgew1b25vy2fz15dcd32cry2c7325qg0h'),
  ssl_certificate    => file('/etc/conjur.pem'),
  version            => 5,
}

