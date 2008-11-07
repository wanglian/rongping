require 'fileutils'

namespace :thinking_sphinx do
  task :app_env do
    Rake::Task[:environment].invoke if defined?(RAILS_ROOT)
    Rake::Task[:merb_env].invoke    if defined?(Merb)
  end
  
  desc "Stop if running, then start a Sphinx searchd daemon using Thinking Sphinx's settings"
  task :running_start => :app_env do
   Rake::Task["thinking_sphinx:stop"].invoke if sphinx_running?
   Rake::Task["thinking_sphinx:start"].invoke
  end
  
  desc "Start a Sphinx searchd daemon using Thinking Sphinx's settings"
  task :start => :app_env do
    config = ThinkingSphinx::Configuration.instance
    
    FileUtils.mkdir_p config.searchd_file_path
    raise RuntimeError, "searchd is already running." if sphinx_running?
    
    Dir["#{config.searchd_file_path}/*.spl"].each { |file| File.delete(file) }

    cmd = "#{config.bin_path}searchd --config #{config.config_file}"
    puts cmd
    system cmd
    
    sleep(2)
    
    if sphinx_running?
      puts "Started successfully (pid #{sphinx_pid})."
    else
      puts "Failed to start searchd daemon. Check #{config.searchd_log_file}."
    end
  end
  
  desc "Stop Sphinx using Thinking Sphinx's settings"
  task :stop => :app_env do
    raise RuntimeError, "searchd is not running." unless sphinx_running?
    pid = sphinx_pid
    system "kill #{pid}"
    puts "Stopped search daemon (pid #{pid})."
  end
  
  desc "Restart Sphinx"
  task :restart => [:app_env, :stop, :start]
  
  desc "Generate the Sphinx configuration file using Thinking Sphinx's settings"
  task :configure => :app_env do
    config = ThinkingSphinx::Configuration.instance
    puts "Generating Configuration to #{config.config_file}"
    config.build
  end
  
  desc "Index data for Sphinx using Thinking Sphinx's settings"
  task :index => :app_env do
    config = ThinkingSphinx::Configuration.instance
    unless ENV["INDEX_ONLY"] == "true"
      puts "Generating Configuration to #{config.config_file}"
      config.build
    end
        
    FileUtils.mkdir_p config.searchd_file_path
    cmd = "#{config.bin_path}indexer --config #{config.config_file} --all"
    cmd << " --rotate" if sphinx_running?
    puts cmd
    system cmd
  end
end

namespace :ts do
  desc "Stop if running, then start a Sphinx searchd daemon using Thinking Sphinx's settings"
  task :run     => "thinking_sphinx:running_start"
  desc "Start a Sphinx searchd daemon using Thinking Sphinx's settings"
  task :start   => "thinking_sphinx:start"
  desc "Stop Sphinx using Thinking Sphinx's settings"
  task :stop    => "thinking_sphinx:stop"
  desc "Index data for Sphinx using Thinking Sphinx's settings"
  task :in      => "thinking_sphinx:index"
  desc "Index data for Sphinx using Thinking Sphinx's settings"
  task :index   => "thinking_sphinx:index"
  desc "Restart Sphinx"
  task :restart => "thinking_sphinx:restart"
  desc "Generate the Sphinx configuration file using Thinking Sphinx's settings"
  task :conf    => "thinking_sphinx:configure"
  desc "Generate the Sphinx configuration file using Thinking Sphinx's settings"
  task :config  => "thinking_sphinx:configure"
end

def sphinx_pid
  config = ThinkingSphinx::Configuration.instance
  
  if File.exists?(config.pid_file)
    `cat #{config.pid_file}`[/\d+/]
  else
    nil
  end
end

def sphinx_running?
  sphinx_pid && `ps -p #{sphinx_pid} | wc -l`.to_i > 1
end
