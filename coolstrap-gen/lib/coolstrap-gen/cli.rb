require "thor/group"
require "coolstrap"
module Coolstrap::Gen
  class CLI < Thor
    include Utils
    include Thor::Actions

    STATUS_TYPES = {:success          => 0,
                    :general_error    => 1,
                    :not_supported    => 3,
                    :not_found        => 4,
                    :incorrect_usage  => 64,
                    }

    no_tasks {
      def cli_error(message, exit_status=nil)
        $stderr.puts message
        exit_status = STATUS_TYPES[exit_status] if exit_status.is_a?(Symbol)
        exit(exit_status || 1)
      end
    }

    ### TODO: When these commands list grows big, we need to move them into a seperate commands.rb file
    map %w(--version -v) => 'info'
    desc "info", "information about Coolstrap::Generator."
    def info
      say "Version #{::Coolstrap::VERSION}"
    end

    map %w(r) => 'server'
    desc "server ", "run middleman app"
    def server
      system "echo == :::COOLSTRAP STARTING::: =="
      system "bundle exec middleman server"
    end

    map %w(b) => 'build'
    desc "build ", "builds middleman/ios/android app"
    long_desc "Build Coolstrap static files (middleman) or Builds an ios app. See 'coolstrap help build' for more information.
              \n\nExample:
              \n\ncoolstrap build ios ==> build iphone app.
              \n\ncoolstrap build ios 5.1 ==> build iphone app with sdk 5.1.
              \n\ncoolstrap build mm ==> build middleman static files.
              \n\ncoolstrap build ==> build middleman & IOS."
        
    #method_option :attributes, :type => :hash, :default => {}, :required => true          
    #method_options :type => "all"
    #method_options :ver => "5.1"
    def build(type="", ver="5.1")
      system "echo ::== COOLSTRAP BUILD =="
      case type
      when "mm"
        ::Coolstrap::Gen::Builder::Middleman.build
      when "ios"
        ::Coolstrap::Gen::Builder::Ios.build(ver)
      else
        ::Coolstrap::Gen::Builder::Middleman.build
        ::Coolstrap::Gen::Builder::Ios.build
      end
    end
    
    
    def install_vendors
      say_status("Downloading Cordova ios")
      root = ::Coolstrap::Gen.root.to_s
      system "wget --no-check-certificate https://github.com/apache/incubator-cordova-ios/zipball/master"
      system "tar xzf master -C #{}/incubator-cordova-ios/ --strip 1"
      system "rm master*"

      say_status("Install templates")
      FileUtils.cp_r("#{root}/incubator-cordova-ios/bin/templates/project/__TESTING__", "#{root}/coolstrap-gen/lib/coolstrap-gen/templates/bridges/cordova/ios/__TESTING__" )
      FileUtils.cp_r("#{root}/incubator-cordova-ios/bin/templates/project/__TESTING__.xcodeproj", "#{root}/coolstrap-gen/lib/coolstrap-gen/templates/bridges/cordova/ios/__TESTING__.xcodeproj/" )

      say_status("Installing CordovaLib")
      
      FileUtils.cp_r("#{root}/incubator-cordova-ios/CordovaLib", "#{root}/coolstrap-gen/lib/vendor" )
      FileUtils.cp "#{root}/incubator-cordova-ios/bin/templates/project/www/cordova-2.1.0rc1.js", "#{root}/coolstrap-gen/lib/coolstrap-gen/templates/app/assets/javascripts/"
      
    end
    
    register Coolstrap::Gen::Simulator::Ios, :simulate, "simulator", "ios simulator"
    register Coolstrap::Gen::Generate::Project, :project, "project", "project generator"
    register Coolstrap::Gen::Generate::View, :view, "view", "view generator"
    
    
  end
end
