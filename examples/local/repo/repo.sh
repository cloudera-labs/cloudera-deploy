# set user and password
USR="$1"
PWD="$2"

# download cloudera manager repos
wget \
  --continue \
  --directory-prefix . \
  "https://$USR:$PWD@archive.cloudera.com/p/cm7/7.3.1/repo-as-tarball/cm7.3.1-redhat7.tar.gz" && \
tar \
  --strip-components=1 \
  --directory=./cm7 \
  -xvzf cm7.3.1-redhat7.tar.gz && \
chmod -R ugo+rX ./cm7

# download parcels
wget \
  --continue \
  --recursive \
  --no-parent \
  --no-host-directories \
  --directory-prefix . \
  --cut-dirs=1 \
  --accept "*el7.parcel*" \
  --accept "manifest.json" \
  "https://$USR:$PWD@archive.cloudera.com/p/cdh7/7.1.6.0/parcels/" && \
chmod -R ugo+rX ./cdh7
