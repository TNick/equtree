# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		RSpec Tests for User data model
#
# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'spec_helper'

#  INCLUDES    ===========================================================
#
#
#
#
#  TESTS    --------------------------------------------------------------

# ------------------------------------------------------------------------- 
describe "User model" do
  
  # create a new, clean user before each test
  before { @user = User.new( name: "Example User", email: "user@example.com", 
                             password: 'foobar', 
                             password_confirmation: 'foobar' ) }
   
  # default target for future tests
  subject { @user }
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # check the fields
  it { should respond_to( :name ) }
  it { should respond_to( :email ) }
  it { should respond_to( :created_at ) }
  it { should respond_to( :updated_at ) }
  it { should respond_to( :password_digest ) }
  it { should respond_to( :remember_token ) }
  it { should respond_to( :admin ) }
  it { should respond_to( :authenticate ) }
  it { should respond_to( :directories ) }
  it { should be_valid }
  it { should_not be_admin }
  it "should be a User" do
    @user.is_a?(User).should be_true 
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "a new instance" do
    before do
      @local_u = User.new
    end
    subject { @local_u }
    
    it { should_not be_admin }
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "the id" do
    it "should not be set" do
      @user.id.should be_nil
    end
    
    describe "after save" do
      before do
        @user.save
      end
      
      it "should be set" do
        @user.id.should_not be_nil
      end
      
    end
    
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
    
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "the name" do
  
    describe "when name is too long" do
      before { @user.name = "a" * 51 }
      it { should_not be_valid }
    end
  
    describe "when name is one character" do
      before { @user.name = "a" }
      it { should_not be_valid }
    end
  
    describe "when name is two characters" do
      before { @user.name = "aa" }
      it { should be_valid }
    end
    
    describe "when name is empty" do
      before { @user.name = "" }
      it { should_not be_valid }
    end
      
    describe "when name has unicode" do
      before { @user.name = "name \330\271" }
      it { should be_valid }
    end
    
    describe "when name is only unicode \330\271" do
      before { @user.name = "\330\271" }
      it { should be_valid }
    end
    
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "the email" do
    
    describe "when email is not present" do
      before { @user.email = " " }
      it { should_not be_valid }
    end
    
    describe "when email format is invalid" do
      it "should be invalid" do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                      foo@bar_baz.com foo@bar+baz.com]
        addresses.each do |invalid_address|
          @user.email = invalid_address
          @user.should_not be_valid
        end
      end
    end
    
    describe "when email format is valid" do
      it "should be valid" do
        addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        addresses.each do |valid_address|
          @user.email = valid_address
          @user.should be_valid
        end      
      end
    end
  
    describe "email address with mixed case" do
      let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

      it "should be saved as all lower-case" do
        @user.email = mixed_case_email
        @user.save
        @user.reload.email.should == mixed_case_email.downcase
      end
    end
    
    describe "when email address is already taken" do
      before do
        user_with_same_email = @user.dup
        user_with_same_email.email = @user.email.upcase
        user_with_same_email.save
      end

      it { should_not be_valid }
    end
    
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
    
  
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
    
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
    
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }
    
    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end
    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "directory association" do
	before { @user.save }
	let!( :rootdir ) { FactoryGirl.create(:directory, user: @user) }
	
	it "factory should create valid instance" do
	  rootdir.should be_valid
	end
	
	it "should have right directory" do
	  @user.directories.should == [rootdir]
	end
	
	it "should destroy associated directories" do
      directories = @user.directories.dup
	  directories.should_not be_empty
      @user.destroy
      directories.should_not be_empty
      directories.each do |directory|
        Directory.find_by_id(directory.id).should be_nil
      end
    end
    
    describe  "should allow more than one root directories" do
      before do
        d = FactoryGirl.create(:directory, user: @user)
        d = FactoryGirl.create(:directory, user: @user)
        d = FactoryGirl.create(:directory, user: @user)
        d = FactoryGirl.create(:directory, user: @user)
      end
      after do
        @user.directories.each do |dir|
          dir.destroy
        end
      end
      it "should have lots of dirs" do
        @user.directories.length.should ==(5)
      end
    end
	
  end # "directory association"
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
 
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "as JSON" do
    
    describe "common state" do
      let(:s) { @user.to_json }
      it "should contain valid data" do
        s.should include('"id"')
        s.should include('"name"')
        s.should include('"email"')
        s.should include('"password_digest"')
        s.should include('"remember_token"')
        s.should include('"admin"')
        s.should include('"created_at"')
        s.should include('"updated_at"')
      end
    end
    
    describe "with data" do
      before do
        @user.name = "uname"
        @user.email = "umail"
        @user.save
        @s = @user.to_json
      end
      
      it "should contain valid data" do
        @s.should include('"uname"')
        @s.should include('"umail"')
        # d @s
      end
    end
    
  end # "as JSON"
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

end # describe "User model"
# ========================================================================= 

#  TESTS    ==============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
