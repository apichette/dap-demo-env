docker run --name conjur-appliance -d --security-opt seccomp=unconfined registry2.itci.conjur.net/conjur-appliance:5.0-stable
docker exec conjur-appliance evoke configure master -h conjur-master -p secret dev
docker exec conjur-appliance /opt/conjur/evoke/bin/wait_for_conjur
docker exec conjur-appliance sv stop conjur
docker exec conjur-appliance sv stop pg
docker commit conjur-appliance configured-master
docker rm -f conjur-appliance
docker run --name conjur-appliance -d --security-opt seccomp=unconfined configured-master
docker exec conjur-appliance /opt/conjur/evoke/bin/wait_for_conjur
docker exec conjur-appliance curl -s localhost/health
