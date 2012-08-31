require 'session'
module Coolstrap::Gen
  module Simulator
    class Ios < Thor
      class << self
        include ::Coolstrap::Gen::Utils

        def simulate
          project_name = get_app_config["app_name"]
          native_ios_path = location.join("native/ios/")
          app = "build/Debug-iphonesimulator/#{project_name}.app"
          project_dir = location.join("native/ios/#{project_name}")
          app_path = "#{native_ios_path}/#{app}"
          system "echo :::LAUNCHING IPHONE SIMULATOR:::"
          # We need to use the session gem so that we can access the user's aliases
          bash = Session::Bash::new 'program' => 'bash --login -i'
          cmd = "ios-sim launch \"#{app_path}\"" #--stderr \"#{project_dir}/tmp/console.log\" --stdout \"#{project_dir}/tmp/console.log\" "
          bash.execute(cmd) { |out, err| puts out }
        end

      end
    
      map %w(sim) => 'simulate'
      desc "simulate ", "launch ios/android simulator"
      long_desc "Launch IOS or Android simulator.
                \n\nExample:
                \n\ncoolstrap simulate ios ==> launch iphone simulator"
      def ios(simulator_version="5.1")
        system "echo ::== COOLSTRAP SIMULATOR ==::"
        if yes?("Do you want to build html5 app ?", :green)
          ::Coolstrap::Gen::Builder::Middleman.build
        end
        if yes?("Do you want to build ios app ?", :green) 
          ::Coolstrap::Gen::Builder::Ios.build(simulator_version)
        end
        ::Coolstrap::Gen::Simulator::Ios.simulate
          #system "echo you must pass ios or android to coolstrap simulate command."
      end
    
      # def android, o en otro archivo (simulator/android)??
    end
  end
end


# /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone\ Simulator.app/Contents/MacOS/iPhone\ Simulator -SimulateApplication source/native/ios/build/Release-iphonesimulator/NativeBridgeiOS.app/NativeBridgeiOS