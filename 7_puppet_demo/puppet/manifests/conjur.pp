class { conjur:
  account	     => 'dev',
  appliance_url      => 'https://conjur-master:30443/api',
  authn_login        => "host/app-${::trusted['hostname']}",
  host_factory_token => Sensitive('1py382b210w3pa1cm8egj1tntkedy8w8jp36jgqzt1xpf4me3wwgmjx'),
  ssl_certificate    => file('/etc/conjur.pem'),
  version            => 5,
}

