#!/usr/bin/env rake
#require "bundler/gem_tasks"

require 'rubygems' unless defined?(Gem)
# require 'fileutils' unless defined?(FileUtils)
require 'rake'

require File.expand_path("../coolstrap/lib/coolstrap/version.rb", __FILE__)

ROOT = File.expand_path(File.dirname(__FILE__))
GEM_NAME = 'coolstrap'

coolstrap_gems = %w(coolstrap-core coolstrap-gen coolstrap)
GEM_PATHS = coolstrap_gems.freeze

def sh_rake(command)
  sh "#{Gem.ruby} -S rake #{command} --trace", :verbose => true
end

def say(text, color=:magenta)
  n = { :bold => 1, :red => 31, :green => 32, :yellow => 33, :blue => 34, :magenta => 35 }.fetch(color, 0)
  puts "\e[%dm%s\e[0m" % [n, text]
end

def install_cordova_ios
  root = "#{ROOT}/coolstrap-gen/lib"
  vendor = "#{root}/vendor"
  
  say("Downloading Cordova ios in #{root}", :green)
  system("mkdir -p #{vendor}/incubator-cordova-ios")
  system "wget --no-check-certificate https://github.com/apache/incubator-cordova-ios/zipball/master"
  system "tar xzf master -C #{vendor}/incubator-cordova-ios/ --strip 1"
  system "rm master*"

  say("Install templates", :green)
  FileUtils.cp_r("#{vendor}/incubator-cordova-ios/bin/templates/project/__TESTING__", "#{root}/coolstrap-gen/templates/bridges/cordova/ios/__TESTING__" )
  FileUtils.cp_r("#{vendor}/incubator-cordova-ios/bin/templates/project/__TESTING__.xcodeproj", "#{root}/coolstrap-gen/templates/bridges/cordova/ios/__TESTING__.xcodeproj/" )

  say("Installing Ios CordovaLib", :green)
  
  FileUtils.cp_r("#{vendor}/incubator-cordova-ios/CordovaLib", "#{vendor}" )
  FileUtils.cp "#{vendor}/incubator-cordova-ios/bin/templates/project/www/cordova-2.1.0rc1.js", "#{root}/coolstrap-gen/templates/app/assets/javascripts/"
end

def install_cordova_android
  root = "#{ROOT}/coolstrap-gen/lib"
  vendor = "#{root}/vendor"
  
  say("Downloading Cordova android in #{root}", :green)
  system("mkdir -p #{vendor}/incubator-cordova-android")
  system "wget --no-check-certificate https://github.com/apache/incubator-cordova-android/zipball/master"
  system "tar xzf master -C #{vendor}/incubator-cordova-android/ --strip 1"
  system "rm master*"

  say("Install templates", :green)
  #FileUtils.cp_r("#{vendor}/incubator-cordova-ios/bin/templates/project/__TESTING__", "#{root}/coolstrap-gen/templates/bridges/cordova/ios/__TESTING__" )
  #FileUtils.cp_r("#{vendor}/incubator-cordova-ios/bin/templates/project/__TESTING__.xcodeproj", "#{root}/coolstrap-gen/templates/bridges/cordova/ios/__TESTING__.xcodeproj/" )

  say("Installing CordovaLib", :green)
  
  #FileUtils.cp_r("#{vendor}/incubator-cordova-ios/CordovaLib", "#{vendor}" )
  #FileUtils.cp "#{vendor}/incubator-cordova-ios/bin/templates/project/www/cordova-2.1.0rc1.js", "#{root}/coolstrap-gen/templates/app/assets/javascripts/"
end
  
desc "Run 'install' for all projects"
task :install do
  system "rm -rf #{ROOT}/coolstrap-gen/lib/vendor/CordovaLib"
  system "rm -rf #{ROOT}/coolstrap-gen/lib/vendor/incubator-cordova-ios"
  system "rm -rf #{ROOT}/coolstrap-gen/lib/vendor/incubator-cordova-android"
  system "rm -rf #{ROOT}/coolstrap-gen/lib/coolstrap-gen/templates/bridges/cordova/ios/*"
  system "rm -rf #{ROOT}/dailyfocus"
  
  GEM_PATHS.each do |dir|
    puts dir
    Dir.chdir(dir) { sh_rake(:install) }
  end
end

desc "install vendor"
task :install_vendor do
  install_cordova_ios
  install_cordova_android
end

desc "install vendor"
task :uninstall_vendor do
  say("Uninstalling cordova libs")
  root = "#{ROOT}/coolstrap-gen/lib"
  vendor = "#{root}/vendor"
  system("rm -r #{vendor}/incubator-cordova-ios")
  system("rm -r #{vendor}/incubator-cordova-android")
end

desc "Clean pkg and other stuff"
task :clean do
  GEM_PATHS.each do |g|
    %w[tmp pkg coverage].each { |dir| sh 'rm -rf %s' % File.join(g, dir) }
  end
end

desc "Clean pkg and other stuff"
task :uninstall do
  sh "gem search --no-version coolstrap | grep coolstrap | xargs gem uninstall -a"
end

desc "Displays the current version"
task :version do
  say "Current version: #{Coolstrap::VERSION}"
end

desc "Bumps the version number based on given version"
task :bump, [:version] do |t, args|
  raise "Please specify version=x.x.x !" unless args.version
  version_path = File.dirname(__FILE__) + '/coolstrap/lib/coolstrap/version.rb'
  version_text = File.read(version_path).sub(/VERSION = '[\d\.\w]+'/, "VERSION = '#{args.version}'")
  say "Updating Coolstrap to version #{args.version}"
  File.open(version_path, 'w') { |f| f.write version_text }
  sh 'git commit -a -m "Bumped version to %s"' % args.version
end

desc "Executes a fresh install removing all coolstrap version and then reinstall all gems"
task :fresh => [:uninstall, :install, :clean]

desc "Pushes repository to GitHub"
task :push do
  say "Pushing to github..."
  sh "git tag v#{Coolstrap::VERSION}"
  sh "git push origin master"
  sh "git push origin v#{Coolstrap::VERSION}"
end

desc "Release all coolstrap gems"
task :publish => :push do
  say "Pushing to rubygems..."
  GEM_PATHS.each do |dir|
    Dir.chdir(dir) { sh_rake("release") }
  end
  Rake::Task["clean"].invoke
end

desc "Generate documentation for all coolstrap gems"
task :doc do
  GEM_PATHS.each do |g|
    sh "cd #{File.join(ROOT, g)} && #{Gem.ruby} -S rake yard"
  end
end

desc "Run tests for all coolstrap gems"
task :spec do
  GEM_PATHS.each do |g|
    sh "cd #{File.join(ROOT, g)} && #{Gem.ruby} -S rake spec"
  end
end
