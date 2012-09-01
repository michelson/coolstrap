require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Create project & build" do
  before(:all) do
    system("bundle exec coolstrap project new dailyfocus")
    FileUtils.cp(root + "/gemfile.tpl", "dailyfocus/Gemfile" )
    
    #::Coolstrap::Gen::Generate::Project.create('dailyfocus', 'org.codewranglers.demo', 'ipad')
  end
  
  context "build ios" do
    before(:each) do
      system("cd dailyfocus && bundle show coolstrap")
      system("cd dailyfocus && bundle show coolstrap-gen")
      #system("cd dailyfocus && bundle install")
      system("cd dailyfocus && bundle exec coolstrap build ios")
      # system("cd dailyfocus && coolstrap build ios 5.1")
    end
    
    it "should have created the ios build directory" do
      File.directory?("dailyfocus/native/ios/build").should be_true
      File.directory?("dailyfocus/native/ios/build/Debug-iphonesimulator/include").should be_true
    end

  end

  after(:all) do
    remove_directories('dailyfocus', 'app', 'spec/views')
  end
end