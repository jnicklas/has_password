require File.expand_path('spec_helper', File.dirname(__FILE__))

HasPassword::FORBIDDEN << 'chunky_bacon'

describe HasPassword do
    
  it "should be invalid if the password hash is not formatted like a SHA256 hash" do
    @user = User.new
    @user.password_hash = 'foo'
    @user.should_not be_valid
    @user.password = 'foo'
    @user.should be_valid
  end
  
  
  it "should be invalid if the password does not match the confirmation" do
    @user = User.create(:username => 'jcoglan', :password => 'foobarfoobar', :password_confirmation => 'foobarfoobar')
    @user = User.find_by_username('jcoglan')
    @user.should be_valid
    @user.password = 'nothing'
    @user.should be_valid
    @user.password_confirmation = 'something'
    @user.should_not be_valid
    @user.password_confirmation = 'nothing'
    @user.should be_valid
  end
  
  it "should be change the password" do
    @user = User.create(:username => 'jcoglan', :password => 'foobarfoobar', :password_confirmation => 'foobarfoobar')
    @user = User.find_by_username('jcoglan')
    @user.should have_password('foobarfoobar')
    @user.should_not have_password('nothing')
    
    @user.update_attributes(:password => 'nothing', :password_confirmation => 'nothing').should be_true
    
    @user.should_not have_password('foobarfoobar')
    @user.should have_password('nothing')
    
    @user.update_attributes(:password => '')
    @user.should have_password('nothing')
  end
  
  it "should return the plain text password but not persist it" do
    @user = User.create(:username => 'jcoglan', :password => 'foobarfoobar')
    @user.password.should == 'foobarfoobar'
    @user = User.find_by_username('jcoglan')
    @user.password.should be_nil
  end
  
  it "should be invalid if the password is blank on creating the record" do
    User.create.should_not be_valid
    @user = User.new(:password => '')
    @user.should_not be_valid
  end
  
  it "should not allow evil words as password" do
    @user = User.new(:password => 'something')
    @user.should be_valid
    @user.password = 'thePaSSwoRD'
    @user.should_not be_valid
    @user.errors.full_messages.should include("Password may not contain the string 'password'")
    @user.password = 'chUNKy_bacON'
    @user.should_not be_valid
  end
  
  it "should trigger a callback after saving the record" do
    @user = User.create(:username => 'me', :password => 'something')
    @user.count.should == 0
    @user.username.should == 'me'

    @user.update_attributes(:username => 'james')
    @user.count.should == 0
    @user.username.should == 'james'

    @user.update_attributes(:password => 'nothing')
    @user.count.should == 1
    @user.username.should == 'changed'

    3.times { @user.save }

    @user.count.should == 1
    @user.update_attributes(:password => 'something')
    @user.count.should == 2
  end
  
end
