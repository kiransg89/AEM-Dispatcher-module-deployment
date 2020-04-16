#!/bin/bash

#Remove OOTB VHOST 
sudo rm -f /etc/httpd/conf.d/enabled_vhosts/aem_publish.vhost
sudo rm -f /etc/httpd/conf.d/enabled_vhosts/aem_author.vhost

sudo rm -f /etc/httpd/conf.dispatcher.d/enabled_farms/999_ams_publish_farm.any

# Remove added via Manual efforts
sudo rm -f /etc/httpd/conf.d/enabled_vhosts/aem_example_publish.vhost
sudo rm -f /etc/httpd/conf.d/enabled_vhosts/aem_example_markup.vhost