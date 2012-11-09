#!/bin/bash
# Author: Vladimir Roudakov
# Contact: vladimir@tomato-elephant-studio.com
# Date: 09-Nov-2012
# Help: https://github.com/VladimirAus

usage="Usage: bash -x quick.sh new|help dbname dblogin dbpassword themename"

if [ "$#" != "5" ] || [ "$1" == "help" ]; then
    if [ "$#" != "5" ] && [ "$1" != "help" ]; then
      echo "Error: wrong number of parameters"
    fi
    echo "Usage: $usage"
    exit
fi

if [ "$1" == "new" ]; then
  drush make ./assets/makes/core.make --yes
  sudo chmod -Rf 775 sites
  mkdir sites/all/modules/contrib
  mkdir sites/all/libraries
  mkdir sites/all/themes/$5
  sudo chmod -Rf 775 sites
  sudo chmod -Rf 777 sites/default/files
  drush make ./assets/makes/modules.make --yes --no-core
  cp -Rf ./assets/profiles/faultstart ./profiles/faultstart
  sudo rm -Rf ./sites/all/libraries/ckeditor/_*
  
  #subtheme setup
  cp -Rf ./sites/all/themes/omega/starterkits/omega-html5/* ./sites/all/themes/$5/
  mv ./sites/all/themes/$5/starterkit_omega_html5.info ./sites/all/themes/$5/$5.info
  mv ./sites/all/themes/$5/css/YOURTHEME-alpha-default.css ./sites/all/themes/$5/css/$5-alpha-default.css
  mv ./sites/all/themes/$5/css/YOURTHEME-alpha-default-narrow.css ./sites/all/themes/$5/css/$5-alpha-default-narrow.css
  mv ./sites/all/themes/$5/css/YOURTHEME-alpha-default-normal.css ./sites/all/themes/$5/css/$5-alpha-default-normal.css
  mv ./sites/all/themes/$5/css/YOURTHEME-alpha-default-wide.css ./sites/all/themes/$5/css/$5-alpha-default-wide.css
  
  sudo sed -i "s/name = Omega HTML5 Starterkit/name = TES HTML5 Omega subtheme: $5/" ./sites/all/themes/$5/$5.info
  sudo sed -i "s/description = Default starterkit for/description = HTML5 subtheme based on /" ./sites/all/themes/$5/$5.info
  sudo sed -i "s/. You should not directly edit this starterkit, but make your own copy./theme./" ./sites/all/themes/$5/$5.info
  
  #installation
  drush site-install faultstart --db-url=mysql://$3:$4@localhost/$2 --account-name=yadmin --account-pass=padmin install_configure_form.site_default_country=AU --site-name=Yoshinkan
fi
