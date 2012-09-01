require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Creating of a new Coolstrap Project" do
  before(:all) do
    #::Coolstrap::Gen::Generate::Project.create('dailyfocus', 'org.codewranglers.demo', 'ipad')
    system("bundle exec coolstrap project new dailyfocus")
    FileUtils.cp(root + "/gemfile.tpl", "dailyfocus/Gemfile" )
    system("cd dailyfocus && bundle show coolstrap")
    system("cd dailyfocus && bundle show coolstrap-gen")
  end

  context "Directories should be created" do

    it "should have created the project" do
      File.directory?("dailyfocus").should be_true
    end

    it "should have an app directory" do
      File.directory?("dailyfocus/source").should be_true
    end

    it "should have a assets directory" do
      File.directory?("dailyfocus/source/assets").should be_true
    end

    it "should have a docs directory" do
      File.directory?("dailyfocus/docs").should be_true
    end

    it "should have a specs directory" do
      File.directory?("dailyfocus/spec").should be_true
    end

    it "should have a tmp directory" do
      File.directory?("dailyfocus/tmp").should be_true
    end

    it "should have a native/ios directory" do
      File.directory?("dailyfocus/native").should be_true
      File.directory?("dailyfocus/native/ios").should be_true
      File.directory?("dailyfocus/native/ios/dailyfocus").should be_true
      Dir["dailyfocus/native/ios/dailyfocus/*"].should_not be_empty
    end
  end

  context "Top tier files should be created" do

    it "should have created the LICENSE" do
      File.exists?("dailyfocus/LICENSE").should be_true
    end

    it "should have created the config file" do
      File.exists?("dailyfocus/config.rb").should be_true
    end

    it "should have created the Readme.mkd" do
      File.exists?("dailyfocus/Readme.mkd").should be_true
    end

    it "should have created the Gemfile" do
      File.exists?("dailyfocus/Gemfile").should be_true
    end
    
    it "should have created coolstrap config file" do
      File.exists?("dailyfocus/coolstrap.yml").should be_true
    end
  end

  context "Inside the source directory" do

    it "should have created the models directory" do
      File.directory?("dailyfocus/source/models").should be_true
    end

    it "should have created the stylesheets directory" do
      File.directory?("dailyfocus/source/assets/stylesheets").should be_true
    end

    it "should have created the javascripts directory" do
      File.directory?("dailyfocus/source/assets/javascripts").should be_true
    end

    it "should have created the images directory" do
      File.directory?("dailyfocus/source/assets/images").should be_true
    end

    it "should have created the fonts directory" do
      File.directory?("dailyfocus/source/assets/fonts").should be_true
    end

    it "should have created the views directory" do
      File.directory?("dailyfocus/source/views").should be_true
    end
  end

  context "Inside the Resources directory" do

    it "should have created the images directory" do
      File.directory?("dailyfocus/native/ios/dailyfocus/Resources/icons").should be_true
    end

    it "should have created the icons files within the Resources icons directory" do
      File.exists?("dailyfocus/native/ios/dailyfocus/Resources/icons/icon.png").should be_true
      File.exists?("dailyfocus/native/ios/dailyfocus/Resources/icons/icon@2x.png").should be_true
      File.exists?("dailyfocus/native/ios/dailyfocus/Resources/icons/icon-72@2x.png").should be_true
      File.exists?("dailyfocus/native/ios/dailyfocus/Resources/icons/icon-72.png").should be_true
    end
  end

  context "Inside the native dir ios" do
    it "should have created the images directory" do
      f = File.open("dailyfocus/native/ios/dailyfocus/main.m").readlines
      f.join("").include?("dailyfocus")
    end
  end

  after(:all) do
    #remove_directories('dailyfocus')
  end
end