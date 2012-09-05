module Coolstrap::Gen
  module Builder
    class Ios < Thor
      include ::Coolstrap::Gen::Utils
      no_tasks {
        def build(simulator_version="5.1")
          project_name = get_app_config["app_name"]
          project_path = location.join("native/ios/#{project_name}.xcodeproj")
          native_ios_path = location.join("native/ios/")
          project_dir = location.join("native/ios/#{project_name}")
          vendor_lib = "#{::Coolstrap::Gen.root.to_s}/vendor/incubator-cordova-ios/CordovaLib"
          cordova_build = "#{vendor_lib}/build/Debug-iphonesimulator/"
          sdk = `xcodebuild -showsdks | grep Sim | tail -1 | awk '{print $6}'`
          build_cmd = "xcodebuild -project #{project_path} -arch i386 -target #{project_name} -configuration Debug -sdk #{sdk} clean build VALID_ARCHS=\"i386\" CONFIGURATION_BUILD_DIR=\"#{project_dir}/build\" -I#{cordova_build}/DerivedSources/i386 -I#{cordova_build}/DerivedSources"
          
          #check if there is middleman build app
          unless Dir.exists?(location.join("build"))
            say("Build Static app before xcode", :green) 
              ::Coolstrap::Gen::Builder::Middleman.build
          end
        
          FileUtils.mkdir_p(location.join(native_ios_path).join("www"))
          system "cp -r #{location.join("build")}/ #{location.join(native_ios_path).join("www")}/"
        
          say("Building XCode project", :green)
          system build_cmd
          
          #COPY HEADERS TO BUILD (build & copy)// Ugly hack until we find a way to pass -IDir to cmd propperly
          if Dir.exists?(cordova_build) && !Dir.exists?(location.join(native_ios_path).join("build/Debug-iphonesimulator/include"))
            say("CordovaLib Headers aren't installed, hang on... we are going to build & copy & build", :red)
            sleep(2)
            system build_cmd
            FileUtils.cp_r("#{cordova_build}/", location.join(native_ios_path).join("build"))            
          end
          #say("Building XCode project", :green)
          #system build_cmd
        end

        def deploy
          # http://blog.octo.com/wp-content/uploads/2010/11/build.txt
          # /usr/bin/xcrun -sdk iphoneos PackageApplication -v "${PROJECT_BUILDDIR}/${APPLICATION_NAME}.app" -o "${BUILD_HISTORY_DIR}/${APPLICATION_NAME}.ipa" --sign "${DEVELOPPER_NAME}" --embed "${PROVISONNING_PROFILE}"
        end
      }
    end
  end
end

