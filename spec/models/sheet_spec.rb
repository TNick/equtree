# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		RSpec Tests for Sheet data model
#
# == Schema Information
#
# Table name: sheets
#
#  id         :integer          not null, primary key
#  context    :integer
#  dfile_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
describe "Sheet model" do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:directory) { FactoryGirl.create(:directory, user: user) }
  let(:dfile) { FactoryGirl.create(:dfile, directory: directory, ftype: Dfile::FTYPE_SHEET ) }
  
  before do
	# get sheet from file
	@sheet = dfile.getSheet()
  end
  
  # default target for future tests
  subject { @sheet }
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # check the fields
  it { should respond_to( :context ) }
  it { should respond_to( :dfile_id ) }
  it { should respond_to( :created_at ) }
  it { should respond_to( :updated_at ) }
  it { should be_valid }
  it "should be a Sheet" do
    @sheet.is_a?(Sheet).should be_true 
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "file association" do
    it "should be associated with the file" do
      dfile.type_index.should_not equal(-1)
    end
    describe "is valid filled" do
        before do
          # @sheet.description = 'Some description'
        end
        it { should be_valid }
     end
    describe "is valid empty" do
        before do
          #@sheet.description = ''
        end
        it { should be_valid }
     end
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   describe "description" do
#     describe "is valid filled" do
#         before do
#           @sheet.description = 'Some description'
#         end
#         it { should be_valid }
#      end
#     describe "is valid empty" do
#         before do
#           @sheet.description = ''
#         end
#         it { should be_valid }
#      end
#   end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "toJSON method" do
    it "should return proper content" do
      @sheet.toJSON().should_not be_empty
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
