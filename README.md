# AEM 6.5 Dispatcher configuration

This module contains the basic dispatcher configurations. The configuration gets bundled in a ZIP file,
and can be downloaded and unzipped to a local folder for development.

## File Structure
   
   ```
   ./
   ├── ams-config-immutable
   ├───── conf.d
   │       ├── available_vhosts
   │       │       └── default.vhost
   │       ├── dispatcher_vhost.conf
   │       ├── enabled_vhosts
   │       │   ├── README
   │       │   └── default.vhost -> ../available_vhosts/default.vhost
   │       └── rewrites
   │       │   ├── default_rewrite.rules
   │       │   └── rewrite.rules
   │       └── variables
   │           └── custom.vars
   └─────── conf.dispatcher.d
           ├── available_farms
           │   └── default.farm
           ├── cache
           │   ├── default_invalidate.any
           │   ├── default_rules.any
           │   └── rules.any
           ├── clientheaders
           │   ├── clientheaders.any
           │   └── default_clientheaders.any
           ├── dispatcher.any
           ├── enabled_farms
           │   ├── README
           │   └── default.farm -> ../available_farms/default.farm
           ├── filters
           │   ├── default_filters.any
           │   └── filters.any
           ├── renders
           │   └── default_renders.any
           └── virtualhosts
               ├── default_virtualhosts.any
               └── virtualhosts.any
   ```
   
   ## Files Explained
   
   - `conf.d/available_vhosts/default.vhost`
     - `*.vhost` (Virtual Host) files are included from inside the `dispatcher_vhost.conf`. These are `<VirtualHosts>` entries to match host names and allow Apache to handle each domain traffic with different rules. From the `*.vhost` file, other files like rewrites, white listing, etc. will be included. The `available_vhosts` directory is where the `*.vhost` files are stored and `enabled_vhosts` directory is where you enable Virtual Hosts by using a symbolic link from a file in the `available_vhosts` to the `enabled_vhosts` directory.
   
   - `conf.d/rewrites/rewrite.rules`
     - `rewrite.rules` file is included from inside the `conf.d/enabled_vhosts/*.vhost` files. It has a set of rewrite rules for `mod_rewrite`.
   
   - `conf.d/variables/custom.vars`
     - `custom.vars` file is included from inside the `conf.d/enabled_vhosts/*.vhost` files. You can put your Apache variables in there.
   
   - `conf.dispatcher.d/available_farms/<CUSTOMER_CHOICE>.farm`
     - `*.farm` files are included inside the `conf.dispatcher.d/dispatcher.any` file. These parent farm files exist to control module behavior for each render or website type. Files are created in the `available_farms` directory and enabled with a symbolic link into the `enabled_farms` directory. 
   
   - `conf.dispatcher.d/filters/filters.any`
     - `filters.any` file is included from inside the `conf.dispatcher.d/enabled_farms/*.farm` files. It has a set of rules change what traffic should be filtered out and not make it to the backend.
   
   - `conf.dispatcher.d/virtualhosts/virtualhosts.any`
     - `virtualhosts.any` file is included from inside the `conf.dispatcher.d/enabled_farms/*.farm` files. It has a list of host names or URI paths to be matched by blob matching to determine which backend to use to serve that request.
   
   - `conf.dispatcher.d/cache/rules.any`
     - `rules.any` file is included from inside the `conf.dispatcher.d/enabled_farms/*.farm` files. It specifies caching preferences.
   
   - `conf.dispatcher.d/clientheaders.any`
     - `clientheaders.any` file is included inside the `conf.dispatcher.d/enabled_farms/*.farm` files. It specifies which client headers should be passed through to each renderer.
   
   ## Environment Variables
   
   - `CONTENT_FOLDER_NAME`
     - This is the customer's content folder in the repository. This is used in the `customer_rewrite.rules` to map shortened URLs to their correct repository path.  
   
   ## Immutable Configuration Files
   
   Some files are immutable, meaning they cannot be altered or deleted.  These are part of the base framework and enforce standards and best practices.  When customization is needed, copies of immutable files (i.e. `default.vhost` -> `publish.vhost`) can be used to modify the behavior.  Where possible, be sure to retain includes of immutable files unless customization of included files is also needed.
   
   ### Immutable Files
   
   ```
   conf.d/available_vhosts/default.vhost
   conf.d/dispatcher_vhost.conf
   conf.d/rewrites/default_rewrite.rules
   conf.dispatcher.d/available_farms/default.farm
   conf.dispatcher.d/cache/default_invalidate.any
   conf.dispatcher.d/cache/default_rules.any
   conf.dispatcher.d/clientheaders/default_clientheaders.any
   conf.dispatcher.d/dispatcher.any
   conf.dispatcher.d/enabled_farms/default.farm
   conf.dispatcher.d/filters/default_filters.any
   conf.dispatcher.d/renders/default_renders.any
   conf.dispatcher.d/virtualhosts/default_virtualhosts.any
   ```

## EXAMPLE Project Structure

```
./
├── exaple-config-immutable
├─── common
├───── conf.d
│       ├── available_vhosts
│       │       └── example_author.vhost
│       │       └── example_publish.vhost
│       │       └── example_publish_cname.vhost
│       ├── enabled_vhosts
│       │   ├── README
│       │   └── example*.vhost -> ../symlinks to available vhost
│       └── rewrites
│       │   └── example_rewrite.rules
│       └── variables
│           └── ams_default.vars
│           └── example.vars
└─────── conf.dispatcher.d
        ├── available_farms
        │   └── 100_example_publish_farm.any
        ├── cache
        │   ├── example_publish_cache.any
        ├── enabled_farms
        │   ├── 100_example_publish_farm.any -> ../symlinks to available farms
        ├── filters
        │   ├── example_filters.any
        └── virtualhosts
            └── example_virtualhosts.any
├── dev
└─────── conf.d
        ├── available_farms
        │   └── example_markup.vhost
        ├── enabled_farms
        │   ├── example_markup.vhost -> ../symlinks to available farms
        └── variables
            ├── ams_default.vars
            └── example.vars 
├── qa
└─────── conf.d
        └── variables
            ├── ams_default.vars
            └── example.vars 
```

## Files Explained

Common will have example site related configurations

DEV and QA folder consists of environment specific vhost, variables

# Environment specific Deployment
```
./
├── deploy-scripts
    └── deploy-conf.sh
    └── disable-defaults.sh

```

## Copy files Instruction
* ./copy-to-target.sh username ipaddress


## Deploy files Instruction
* cd src/deploy-scripts/
* ./deploy-conf.sh dev all

* ./deploy-conf.sh qa all

environment specific names like qa, dev, all should be name in shell script

* deploy-scripts deployment shell scripts (backup and deploy)

* disable-default removing old files