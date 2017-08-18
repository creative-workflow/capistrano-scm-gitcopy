require "capistrano/scm/plugin"

class Capistrano::SCM::Localgitcopy < ::Capistrano::SCM::Plugin
  def set_defaults
    set_if_empty :archive_name, 'deploy-archive.tar.gz'
    set_if_empty :include_dir,  './'
    set_if_empty :tar_roles,    :all
    set_if_empty :tar_verbose,  true
    set_if_empty :exclude_dir,  nil
    set_if_empty :temp_file,    '/tmp/deploy-archive.tar.gz'
  end

  def define_tasks
    eval_rakefile File.expand_path("tasks/localgitcopy.rake", __FILE__)
  end

  def register_hooks
    before 'deploy:started', 'localgitcopy:clean'
    after  'deploy:new_release_path', 'localgitcopy:create_archive'
    after  'localgitcopy:create_archive', 'localgitcopy:create_release'
    before 'deploy:set_current_revision', 'localgitcopy:set_current_revision'
    after  'deploy:finished', 'localgitcopy:clean'
  end

  def fetch_revision
    `git rev-list --max-count=1 $(git rev-parse --abbrev-ref HEAD)`
  end
end
