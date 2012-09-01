require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Creating of a view file" do
  before(:all) do
    system("bundle exec coolstrap project new dailyfocus")
    #::Coolstrap::Gen::Generate::Project.create('dailyfocus', 'org.codewranglers.demo', 'ipad')
  end
  
  context "Creating a view file and its spec" do
    before(:each) do
      system("cd dailyfocus && bundle exec coolstrap build mm")
    end
    
    it "should have created the build directory" do
      File.directory?("dailyfocus/build").should be_true
      File.directory?("dailyfocus/build/assets/images/coolstrap/startup").should be_true
      File.directory?("dailyfocus/build/assets/images/startup").should be_true
      File.directory?("dailyfocus/build/assets/images/coolstrap").should be_true
      File.directory?("dailyfocus/build/assets/fonts").should be_true
      File.directory?("dailyfocus/build/assets/javascripts").should be_true
      File.exists?("dailyfocus/build/index.html").should be_true
    end
    
  end

  after(:all) do
    remove_directories('dailyfocus', 'app', 'spec/views')
  end
end