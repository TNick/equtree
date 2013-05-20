# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		RSpec Tests for Directory data model
#
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
#
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Please read COPYING and README files in root folder
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
#
#
#
#
#  INCLUDES    -----------------------------------------------------------

require 'spec_helper'

#  INCLUDES    ===========================================================
#
#
#
#
#  TESTS    --------------------------------------------------------------

# ------------------------------------------------------------------------- 
describe "File model" do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:directory) { FactoryGirl.create(:directory, user: user) }
  before do
	# create a new, clean file before each test
	@dfile = FactoryGirl.create(:dfile, directory: directory)
  end

   
  # default target for future tests
  subject { @dfile }
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # check the fields
  it { should respond_to( :name ) }
  it { should respond_to( :directory_id ) }
  it { should respond_to( :directory ) }
  its(:directory) { should == directory }
  it { should respond_to( :type ) }
  it { should respond_to( :created_at ) }
  it { should respond_to( :updated_at ) }
  it { should be_valid }
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "when directory_id is invalid" do
    before do
      @dfile.directory_id = nil
    end

    it { should_not be_valid }
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "accessible attributes" do
    it "should not allow access to directory_id" do
      expect do
        Directory.new(directory_id: directory.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "name" do
	
	describe "empty" do
	  before do
		@dfile.name = ""
	  end
	  it { should_not be_valid }
	end
  
	describe "longer than 50 characters" do
	  before do
		@dfile.name = "a"*51
	  end
	  it { should_not be_valid }
	end

	describe "shorter than 50 characters" do
	  before do
		@dfile.name = "a"*48
	  end
	  it { should be_valid }
    end
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "type" do
	
	describe "is not set" do
	  before do
		@dfile.type = nil
	  end
	  it { should_not be_valid }
	end
	
	describe "is test" do
	  before do
		@dfile.type = Dfile::FTYPE_TEST
	  end
	  it { should be_valid }
	end
	
	describe "is sheet" do
	  before do
		@dfile.type = Dfile::FTYPE_SHEET
	  end
	  it { should be_valid }
	end
	
	describe "is large" do
	  before do
		@dfile.type = 1000
	  end
	  it { should_not be_valid }
	end
	
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  
end # describe "File model"
# ========================================================================= 

#  TESTS    ==============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
