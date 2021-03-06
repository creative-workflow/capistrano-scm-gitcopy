copy_plugin = self

namespace :localgitcopy do
  task :create_release do
    tar_roles = fetch(:local_git_copy_tar_roles, :all)

    on release_roles tar_roles do
      set(:branch, copy_plugin.fetch_revision)
      execute :mkdir, "-p", release_path

      repo_path = "#{fetch(:deploy_to)}/repo"
      execute :mkdir, "-p", repo_path

      # Create a temporary file on the server
      tmp_file     = fetch(:local_git_copy_temp_file)
      archive_name = fetch(:local_git_copy_archive_name)

      execute :rm, "-f", tmp_file
      execute :touch, tmp_file

      # Upload the archive, extract it and finally remove the tmp_file
      upload!(archive_name, tmp_file)
      execute :tar, "-xzf", tmp_file, "-C", "#{release_path}"
      execute :rm, tmp_file
    end
  end

  desc "Determine the revision that will be deployed"
  task :set_current_revision do
    tar_roles = fetch(:local_git_copy_tar_roles, :all)

    on release_roles tar_roles do
      within repo_path do
        set :current_revision, copy_plugin.fetch_revision
      end
    end
  end

  task :create_archive do
    tar_roles = fetch(:local_git_copy_tar_roles, :all)

    on release_roles tar_roles do
      archive_name  = fetch(:local_git_copy_archive_name)
      tar_verbose   = fetch(:local_git_copy_tar_verbose, true) ? "v" : ""
      include_dir   = fetch(:local_git_copy_include_dir)
      exclude_dir   = Array(fetch(:local_git_copy_exclude_dir))
      exclude_args  = exclude_dir.map { |dir| "--exclude '#{dir}'"}

      #cmd = "git archive #{tar_verbose} --format=tar.gz --output=#{archive_name} HEAD:#{include_dir}"
      cmd = ["git ls-files #{include_dir} | tar -c#{tar_verbose}zf #{archive_name} -T -", *exclude_args]
      puts cmd.join(' ')
      system cmd.join(' ')

      # cmd = "cd #{include_dir} && git submodule foreach tar --append --file=collection.tar rock"
      # # "tar -c#{tar_verbose}zf #{archive_name} $(git ls-files)", *exclude_args
      # puts cmd
      # system cmd
    end
  end

  task :clean do
    archive_name = fetch(:local_git_copy_archive_name)
    File.delete archive_name if File.exists? archive_name
  end
end
