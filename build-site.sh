#!/bin/sh

DSA_WP_THEME='dsa-wordpress/wp-content/themes/portland-dsa'
PUPPET_WP_FILES='puppet/environments/production/modules/wordpress/files'

set -e

pushd $DSA_WP_THEME
gulp build
popd

mkdir -p $PUPPET_WP_FILES/dsa-wp-theme

for f in assets index.php style.css style.css.map views; do
  cp -r $DSA_WP_THEME/$f $PUPPET_WP_FILES/dsa-wp-theme/
done
