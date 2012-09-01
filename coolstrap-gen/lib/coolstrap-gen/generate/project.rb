# -*- encoding : utf-8 -*-

require 'session'
module Coolstrap
  module Gen
    module Generate
      class Project < Thor
        class << self
          attr_accessor :project_name, :device_platform, :app_id
          include ::Coolstrap::Gen::Utils
          # Coolstrap::Generator::Generate::Project.create('demo', 'org.codewranglers.demo', 'ipad')
          def create(name, id, platform='iphone')
            
            @project_name    = name
            @device_platform = platform
            @app_id          = id

            begin
              create_directories('tmp')
              copy_defaults
              remove_old_files
              generate_files
              copy_bridges
              log "Your Coolstrap project is ready for you to get coding!"
            rescue => e
              error "There was an error generating your Coolstrap project. #{e} #{e.backtrace}"
            end
          end

          def copy_defaults
            #FileUtils.cp(location.join("Resources/KS_nav_ui.png"),    "/tmp/")
            #FileUtils.cp(location.join("Resources/KS_nav_views.png"), "/tmp/")
          end

          def generate_files
            create_project_directory
            full_app_hash = {:app_name => @project_name, :app_name_underscore => underscore(@project_name), :platform => @device_platform}
            create_with_template('.gitignore', 'defaults/gitignore', full_app_hash)
            create_with_template('Gemfile', 'defaults/Gemfile', full_app_hash)
            create_with_template('LICENSE', 'defaults/LICENSE', full_app_hash)
            create_with_template('coolstrap.yml', 'defaults/coolstrap.yml', full_app_hash)

            create_with_template('config.rb', 'defaults/config', full_app_hash)
            default_templates = ['Readme.mkd']
            default_templates.each do |tempfile|
              create_with_template(tempfile, "defaults/#{tempfile}", full_app_hash)
            end

            FileUtils.cp_r(templates("app/views/shared/."), location.join("source/views/shared") )
            FileUtils.cp_r(templates("app/assets/."), location.join("source/assets") )

            create_with_template('source/index.html.haml', 'app/index.html.haml', full_app_hash)
            create_with_template('source/layout.haml', 'app/layout.haml', full_app_hash)
            create_with_template('source/views/_home.haml', 'app/views/_home.haml', full_app_hash)

          end

          def create_project_directory
            create_directories('docs', 'spec',
                               "source/assets",
                               "source/assets/images",
                               "source/assets/fonts",
                               "source/assets/stylesheets",
                               "source/assets/javascripts",
                               "source/views",
                               "source/models", 
                               "native", "native/ios")
          end

          def remove_old_files
            #remove_files('README')
            #remove_directories('Resources')
          end

          def location
            base_location.join(@project_name)
          end

          def copy_ios_bridge
            ## for now raw cp, Todo: erb
            #FileUtils.cp_r(templates("bridges/."), location.join("native") )
            FileUtils.cp_r(templates("bridges/cordova/ios/__TESTING__/."), location.join("native/ios/#{@project_name}") )
            FileUtils.cp_r(templates("bridges/cordova/ios/__TESTING__.xcodeproj/."), location.join("native/ios/#{@project_name}.xcodeproj") )
            
            FileUtils.mv location.join("native/ios/#{@project_name}/__TESTING__-Info.plist"), location.join("native/ios/#{@project_name}/#{@project_name}-Info.plist") 
            FileUtils.mv location.join("native/ios/#{@project_name}/__TESTING__-Prefix.pch"), location.join("native/ios/#{@project_name}/#{@project_name}-Prefix.pch") 
            
            #### RENAME CORDOVA TEMPLATE
            native_path = location.join("native/ios/").join(@project_name)
            native_path = native_path.to_s
            gsub_file( native_path + '.xcodeproj/project.pbxproj', /__TESTING__/, @project_name )
            gsub_file( native_path + '/Classes/AppDelegate.h', "__TESTING__", @project_name)
            gsub_file( native_path + '/Classes/AppDelegate.m', "__TESTING__", @project_name)
            gsub_file( native_path + '/Classes/MainViewController.h', "__TESTING__", @project_name)
            gsub_file( native_path + '/Classes/MainViewController.m', "__TESTING__", @project_name)    
            gsub_file( native_path + '/main.m', "__TESTING__", @project_name)   
            gsub_file( native_path + "/#{@project_name}-Prefix.pch", "__TESTING__", @project_name)          
            gsub_file( native_path + "/#{@project_name}-Info.plist", "__TESTING__", @project_name)          
            #### LINK CORDOVA LIB TO APP (maybe change it to ruby script ?? )
            system "python #{vendor('incubator-cordova-ios/bin/update_cordova_subproject').to_s}  #{location.join("native/ios/#{@project_name}.xcodeproj").to_s}"
            
          end
          
          def copy_android_bridge
            
            # generate app
            #FileUtils.cp_r("#{vendor}/incubator-cordova-ios/bin/templates/project/__TESTING__", "#{root}/coolstrap-gen/templates/bridges/cordova/ios/__TESTING__" )
            native_path = location.join("native/android").join(@project_name)
            puts "#{vendor('incubator-cordova-android/bin/create').to_s} #{native_path} com.#{@project_name}.special #{@project_name.capitalize}"
            
            system "#{vendor('incubator-cordova-android/bin/create').to_s} #{native_path} com.#{@project_name}.special #{@project_name.capitalize}"
            
          end
          
          def copy_bridges
            copy_ios_bridge
            copy_android_bridge
          end

          def source_root
            File.dirname(__FILE__)
          end
          
          def install_cordova_ios
            root = "#{::Coolstrap::Gen.root.to_s}"
            vendor = "#{root}/vendor"

            system("mkdir -p #{vendor}/incubator-cordova-ios")
            system "wget --no-check-certificate https://github.com/apache/incubator-cordova-ios/zipball/master"
            system "tar xzf master -C #{vendor}/incubator-cordova-ios/ --strip 1"
            system "rm master*"

            #say("Install templates in #{vendor}/incubator-cordova-ios/", :green)
            system("mkdir -p #{root}/coolstrap-gen/templates/bridges/cordova/ios")
            FileUtils.cp_r("#{vendor}/incubator-cordova-ios/bin/templates/project/__TESTING__", "#{root}/coolstrap-gen/templates/bridges/cordova/ios/__TESTING__" )
            FileUtils.cp_r("#{vendor}/incubator-cordova-ios/bin/templates/project/__TESTING__.xcodeproj", "#{root}/coolstrap-gen/templates/bridges/cordova/ios/__TESTING__.xcodeproj/" )

            #say("Installing CordovaLib in #{vendor}/incubator-cordova-ios/CordovaLib", :green)

            FileUtils.cp "#{vendor}/incubator-cordova-ios/bin/templates/project/www/cordova-2.1.0rc2.js", "#{root}/coolstrap-gen/templates/app/assets/javascripts/"
            
          end
          
          def install_cordova_android
            root = "#{::Coolstrap::Gen.root.to_s}"
            vendor = "#{root}/vendor"
            #say("Downloading Cordova android in #{root}", :green)
            system("mkdir -p #{vendor}/incubator-cordova-android")
            system "wget --no-check-certificate https://github.com/apache/incubator-cordova-android/zipball/master"
            system "tar xzf master -C #{vendor}/incubator-cordova-android/ --strip 1"
            system "rm master*"
            #Copy commons codec & update android project & ant jar
            system "mkdir -p #{vendor}/incubator-cordova-android/framework/libs"
            system "cp #{vendor}/android-extras/commons-codec-1.6.jar #{vendor}/incubator-cordova-android/framework/libs/commons-codec-1.6.jar"
            system "cd #{vendor}/incubator-cordova-android/framework/ && android update project -p . -t android-16 --subprojects && ant jar"

          end
          
        end
        
        include ::Coolstrap::Gen::Utils
        
        desc "install_vendor", "downloads apache cordova & install templates"
        def install_vendor
          ::Coolstrap::Gen::Generate::Project.install_cordova_ios
          ::Coolstrap::Gen::Generate::Project.install_cordova_android
          say("Cordova complete", :green)
        end
        
        map %(n) => 'new'
        desc "project new <name> ", "generates a new Coolstrap project."
        long_desc "Generates a new Coolstrap project. See 'coolstrap help new' for more information.
                  \n\nExample:
                  \n\ncoolstrap project new demo ==> Creates a new project skeleton."
        def new(name, device_id='org.mycompany.demo', platform='iphone')
          unless check_vendor_existence?
            say("CordovaLib isn´t detected we are going to install it", :red)
            invoke :install_vendor, []
          end
          ::Coolstrap::Gen::Generate::Project.create(name, device_id, platform)
        end
      
      end
    end
  end
end
