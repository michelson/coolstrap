require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Creating of a view file" do
  before(:all) do
    system("bundle exec coolstrap project new dailyfocus")
    #::Coolstrap::Gen::Generate::Project.create('dailyfocus', 'org.codewranglers.demo', 'ipad')
    FileUtils.cp(root + "/gemfile.tpl", "dailyfocus/Gemfile" )
  end
  
  context "Creating a view file and its spec" do
    before(:each) do
      
      # uncoment if you want to tests simulator
       system("cd dailyfocus && bundle exec coolstrap simulate ios")
    end
    
    it "should have created the ios build directory" do
      pending("uncomment this test torun it , xcode required")
      File.exists?("dailyfocus/tmp/ios.log").should be_true
    end

  end

  after(:all) do
    remove_directories('dailyfocus', 'app', 'spec/views')
  end
end