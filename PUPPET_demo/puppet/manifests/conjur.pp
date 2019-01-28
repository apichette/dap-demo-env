class { conjur:
  account	     => 'dev',
  appliance_url      => 'https://conjur-master:30443/api',
  authn_login        => "host/app-${::trusted['hostname']}",
  host_factory_token => Sensitive('1zavj9v1vgsh9dhhd3q52m8decc3w6e8nw21j9eeff1ybjfkcxezk'),
  ssl_certificate    => file('/etc/conjur.pem'),
  version            => 5,
}

