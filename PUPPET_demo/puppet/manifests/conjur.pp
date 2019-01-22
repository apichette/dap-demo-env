class { conjur:
  account	     => 'dev',
  appliance_url      => 'https://conjur-master:30443/api',
  authn_login        => "host/app-${::trusted['hostname']}",
  host_factory_token => Sensitive('2hfag88natgyr1xtqghz1f9e4ph2fy4wax1keremf24vc8g92mehkes'),
  ssl_certificate    => file('/etc/conjur.pem'),
  version            => 5,
}

