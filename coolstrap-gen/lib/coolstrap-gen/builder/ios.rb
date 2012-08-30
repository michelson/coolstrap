
module Coolstrap::Gen
  module Builder
    class Ios
      class << self
        include ::Coolstrap::Gen::Utils
        def build(simulator_version="5.1")
          project_name = get_app_config["app_name"]
          project_path = location.join("native/ios/#{project_name}.xcodeproj")
          native_ios_path = location.join("native/ios/")
          project_dir = location.join("native/ios/#{project_name}")
          vendor_lib = "#{::Coolstrap::Gen.root.to_s}/vendor/CordovaLib"
          cordova_build = "#{vendor_lib}/build/Debug-iphonesimulator/"
          #puts project_path
          #puts project_dir
          # move to project
          #puts("symlink to #{location.join(native_ios_path).join("www")}")
          #puts("vendor is in #{vendor_lib}")
          FileUtils.mkdir_p(location.join(native_ios_path).join("www"))
          #puts "location #{location.join("build")}"
          system "cp -r #{location.join("build")}/ #{location.join(native_ios_path).join("www")}/"
          #sdk = "iphonesimulator#{simulator_version}"
          sdk = `xcodebuild -showsdks | grep Sim | tail -1 | awk '{print $6}'`
          
          #COPY HEADERS TO BUILD // Ugly hack for now until find a way to pass -IDir to cmd
          if Dir.exists?(cordova_build) && Dir.exists?(location.join(native_ios_path).join("build"))
            FileUtils.cp_r("#{cordova_build}/", location.join(native_ios_path).join("build"))
          end
          system "xcodebuild -project #{project_path} -arch i386 -target #{project_name} -configuration Debug -sdk #{sdk} clean build VALID_ARCHS=\"i386\" CONFIGURATION_BUILD_DIR=\"#{project_dir}/build\" -I#{cordova_build}/DerivedSources/i386 -I#{cordova_build}/DerivedSources"

        end

        def deploy
          # http://blog.octo.com/wp-content/uploads/2010/11/build.txt
          # /usr/bin/xcrun -sdk iphoneos PackageApplication -v "${PROJECT_BUILDDIR}/${APPLICATION_NAME}.app" -o "${BUILD_HISTORY_DIR}/${APPLICATION_NAME}.ipa" --sign "${DEVELOPPER_NAME}" --embed "${PROVISONNING_PROFILE}"
        end
      end
    end
  end
end

