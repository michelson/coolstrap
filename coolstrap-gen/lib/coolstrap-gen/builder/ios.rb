
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
          puts project_path
          puts project_dir
          # move to project
          #puts("symlink to #{location.join(native_ios_path).join("www")}")
          #puts("vendor is in #{vendor_lib}")
          FileUtils.mkdir_p(location.join(native_ios_path).join("www"))
          #puts "location #{location.join("build")}"
          system "cp -r #{location.join("build")}/ #{location.join(native_ios_path).join("www")}/"
          #sdk = "iphonesimulator#{simulator_version}"
          sdk = `xcodebuild -showsdks | grep Sim | tail -1 | awk '{print $6}'`
          system "xcodebuild -project #{project_path} -arch i386 -target #{project_name} -configuration Debug -sdk #{sdk} clean build VALID_ARCHS=\"i386\" CONFIGURATION_BUILD_DIR=\"#{project_dir}/build\""
          # system "xcodebuild -project #{project_path} -arch i386 -target #{project_name} -configuration Debug -sdk #{sdk} clean build VALID_ARCHS=\"i386\" CONFIGURATION_BUILD_DIR=\"#{project_dir}/build\" HEADER_SEARCH_PATHS=\"#{vendor_lib}/build/Debug-iphonesimulator/include/**\""
          # system "xcodebuild -project #{project_path} -arch i386 -target #{project_name} -configuration Debug -sdk #{sdk} clean build VALID_ARCHS=\"i386\" CONFIGURATION_BUILD_DIR=\"#{project_path}/build\" HEADER_SEARCH_PATHS=\"#{vendor_lib}/build/Debug-iphonesimulator/include/**\""
          # system "xcodebuild -project #{project_path} -arch i386 -target #{project_name} -configuration Debug -sdk #{sdk}" # clean build VALID_ARCHS=\"i386\"" #CONFIGURATION_BUILD_DIR=\"#{project_path}/build\""
          # system "xcodebuild -project '#{project_path}' -target '#{project_name}' -sdk '#{sdk}' -configuration Debug"
          # system "xcodebuild -project '#{project_path}' -target '#{project_name}' -sdk '#{sdk}' -configuration Release" # Debug clean build
        
        end

        def deploy
          # http://blog.octo.com/wp-content/uploads/2010/11/build.txt
          # /usr/bin/xcrun -sdk iphoneos PackageApplication -v "${PROJECT_BUILDDIR}/${APPLICATION_NAME}.app" -o "${BUILD_HISTORY_DIR}/${APPLICATION_NAME}.ipa" --sign "${DEVELOPPER_NAME}" --embed "${PROVISONNING_PROFILE}"
        end
      end
    end
  end
end

