# == Schema Information
#
# Table name: directories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ancestry   :string(255)
#

# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		RSpec Tests for Directory data model
#
require 'spec_helper'

#  INCLUDES    ===========================================================
#
#
#
#
#  TESTS    --------------------------------------------------------------

# ------------------------------------------------------------------------- 
describe "Directory model" do
  
  let(:user) { FactoryGirl.create(:user) }
  before do
	# create a new, clean directory before each test
	@directory = FactoryGirl.create(:directory, user: user)
  end

   
  # default target for future tests
  subject { @directory }
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # check the fields
  it { should respond_to( :name ) }
  it { should respond_to( :user_id ) }
  it { should respond_to( :user ) }
  its(:user) { should == user }
  it { should respond_to( :created_at ) }
  it { should respond_to( :updated_at ) }
  it { should respond_to( :ancestry ) }
  it { should be_valid }
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "when user_id is invalid" do
    before do
      @directory.user_id = nil
    end

    it { should_not be_valid }
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Directory.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "name" do
	
	describe "empty" do
	  before do
		@directory.name = ""
	  end
	  it { should_not be_valid }
	end
  
	describe "longer than 50 characters" do
	  before do
		@directory.name = "a"*51
	  end
	  it { should_not be_valid }
	end

	describe "shorter than 50 characters" do
	  before do
		@directory.name = "a"*48
	  end
	  it { should be_valid }
    end
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

  
  
end # describe "Directory model"
# ========================================================================= 

#  TESTS    ==============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
