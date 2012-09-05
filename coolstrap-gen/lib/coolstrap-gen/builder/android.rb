module Coolstrap::Gen
  module Builder
    class Android < Thor
      include ::Coolstrap::Gen::Utils
      no_tasks {
        def build()
          
          #check if there is middleman build app
          unless Dir.exists?(location.join("build"))
            say("Build Static app before android", :green) 
              ::Coolstrap::Gen::Builder::Middleman.build
          end
          
          project_name = get_app_config["app_name"]
          native_android_path = location.join("native/android/#{project_name}")
          say native_android_path.join('cordova/debug')
          system "#{native_android_path.join('cordova/debug')}"
          # removing defaults
          system "rm -rf #{location.join(native_android_path).join("assets/www")}/*"
          # copy middleman templates
          system "cp -r #{location.join("build")}/ #{location.join(native_android_path).join("assets/www")}/"
        end

        def deploy
        end
      }
    end
  end
end

