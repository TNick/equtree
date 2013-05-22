# == Schema Information
#
# Table name: dfiles
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  directory_id :integer
#  ftype        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  type_index   :integer
#

# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		RSpec Tests for Dfile data model
#
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
  it { should respond_to( :ftype ) }
  it { should respond_to( :created_at ) }
  it { should respond_to( :updated_at ) }
  it { should respond_to( :type_index ) }
  it { should respond_to( :typeName ) }
  it { should respond_to( :getSheet ) }
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
  describe "ftype" do
	
	describe "is not set" do
	  before do
		@dfile.ftype = nil
	  end
	  it { should_not be_valid }
	end
	
	describe "is test" do
	  before do
		@dfile.ftype = Dfile::FTYPE_TEST
	  end
	  it { should be_valid }
	end
	
	describe "is sheet" do
	  before do
		@dfile.ftype = Dfile::FTYPE_SHEET
	  end
	  it { should be_valid }
	end
	
	describe "is large" do
	  before do
		@dfile.ftype = 1000
	  end
	  it { should_not be_valid }
	end
	
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "saving" do
    before do
      @prev_ftype = @dfile.ftype
      @prev_name = @dfile.name
      @prev_type_index = @dfile.type_index
      @dfile.save
    end
    it "should be saved and reloaded" do
      @dfile.reload
      @dfile.ftype.should eq(@prev_ftype)
      @dfile.name.should eq(@prev_name)
      @dfile.type_index.should eq(@prev_type_index)
    end
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "the id" do
    before do
      # @dfile.save
    end
    it "should have a valid id" do
      @dfile.id.should_not be_nil
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
