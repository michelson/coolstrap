module Coolstrap::Gen
  module Builder
    class Android < Thor
      include ::Coolstrap::Gen::Utils
      no_tasks {
        def build()
          project_name = get_app_config["app_name"]
          project_path = location.join("native/ios/#{project_name}")
          
          #system "#{project_path.}"
        end

        def deploy
        end
      }
    end
  end
end

