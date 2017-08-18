# capistrano-scm-localgitcopy

A copy strategy for Capistrano 3, which uses `git ls-files` local, tars the files, uploads and extracts.

It depends on the local git revision.

It is helpfull if you have a shred web hoster like netcup with a very limited set of commands.

## Requirements
Machine running Capistrano:

- Capistrano 3
- tar
- git

Servers:

- tar

## Installation
First make sure you install the capistrano-scm-localgitcopy by adding it to your `Gemfile`:

    gem "capistrano-scm-localgitcopy"

Add to Capfile:

    require 'capistrano/scm/localgitcopy'
    install_plugin Capistrano::SCM::Localgitcopy

## Configuration (defaults)
```
set :archive_name, 'deploy-archive.tar.gz'      # local archive name
set :include_dir,  './'                         # you can use a subfolder for deployment
set :tar_roles,    :all                         # roles to run on tar
set :tar_verbose,  true                         # enable verbose mode for tar
set :exclude_dir,  nil                          # exclude directories
set :temp_file,    '/tmp/deploy-archive.tar.gz' # temp file on server
```

## Pitfall: git and utf 8 chars
If you have problems with utf8 chars in file names that wont included in the deploy tar, do the following:

```
$ git config --global core.precomposeunicode true
$ git config core.precomposeunicode.true

$ git ls-files | grep "\""
$ git rm --cached "`printf "<File>"`" #this for each file
$ git commit -m "clean up bad encoding of file names"

```

### License
The MIT License (MIT)

### Changelog

0.1.0
-----

- Initial release
