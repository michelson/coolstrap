require 'session'
module Coolstrap::Gen
  module Simulator
    class Android < Thor
      class << self
        include ::Coolstrap::Gen::Utils

        def simulate
          project_name = get_app_config["app_name"]
          native_android_path = location.join("native/android")
          project_dir = location.join("native/android/#{project_name}")
          system "echo :::LAUNCHING ANDROID SIMULATOR:::"
          # We need to use the session gem so that we can access the user's aliases
          bash = Session::Bash::new 'program' => 'bash --login -i'
          cmd = "#{native_android_path.join('cordova/emulate')}"
          bash.execute(cmd) #{ |out, err| puts out }
        end

      end
    
      map %w(sim) => 'simulate'
      desc "simulate ", "launch android/android simulator"
      long_desc "Launch IOS or Android simulator.
                \n\nExample:
                \n\ncoolstrap simulate android ==> launch iphone simulator"
      def android(simulator_version="5.1")
        system "echo ::== COOLSTRAP SIMULATOR ==::"
        if yes?("Do you want to build html5 app ?", :green)
          ::Coolstrap::Gen::Builder::Middleman.build
        end
        if yes?("Do you want to build Android app ?", :green) 
          ::Coolstrap::Gen::Builder::Android.new.build
        end
        ::Coolstrap::Gen::Simulator::Android.simulate
      end
    
    end
  end
end