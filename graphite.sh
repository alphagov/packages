#! /bin/bash

#
# This script needs "fpm". If you dont have it,
# run "gem install fpm"
#
# You also need to "apt-get install python-setuptools" (otherwise fpm fails)

clean() {
    rm -rf whisper-0.9.9 carbon-0.9.9 graphite-web-0.9.9
    rm -f python*.deb
}

download() {
    [ -e graphite-web-0.9.9.tar.gz ] || wget http://launchpad.net/graphite/0.9/0.9.9/+download/graphite-web-0.9.9.tar.gz
    [ -e carbon-0.9.9.tar.gz ] || wget http://launchpad.net/graphite/0.9/0.9.9/+download/carbon-0.9.9.tar.gz
    [ -e whisper-0.9.9.tar.gz ] || wget http://launchpad.net/graphite/0.9/0.9.9/+download/whisper-0.9.9.tar.gz
}

extract() {
    tar -zxvf graphite-web-0.9.9.tar.gz
    tar -zxvf carbon-0.9.9.tar.gz
    tar -zxvf whisper-0.9.9.tar.gz
}

package() {
    fpm -s python -t deb txamqp
    fpm -s python -t deb -S 2.7 --depends "python" --depends "python-support" whisper-0.9.9/setup.py
    fpm --python-install-lib /opt/graphite/ --python-install-bin /opt/graphite -s python -t deb -S 2.7 --depends "python" --depends "python-support" \
--depends "python-twisted" carbon-0.9.9/setup.py
    fpm --python-install-lib /opt/graphite/ --python-install-bin /opt/graphite -s python -t deb -S 2.7 --depends "python" --depends "python-support" \
--depends "python-twisted" \
--depends "python-cairo" \
--depends "python-django" \
--depends "python-django-tagging" \
--depends "python-ldap" \
--depends "python-memcache" \
--depends "python-pysqlite2" \
--depends "python-sqlite" \
--depends "libapache2-mod-python" \
graphite-web-0.9.9/setup.py
}

move_to_debs() {
 mv *.deb debs
}

clean_up() {
 rm carbon-0.9.9.tar.gz
 rm -rf carbon-0.9.9
 rm whisper-0.9.9.tar.gz
 rm -rf whisper-0.9.9
 rm graphite-web-0.9.9.tar.gz
 rm -rf graphite-web-0.9.9
}

download
clean
extract
package
move_to_debs
clean_up
