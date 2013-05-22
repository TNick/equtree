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
# Table name: formulas
#
#  id         :integer          not null, primary key
#  omath      :text
#  descr      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sheet_id   :integer          not null
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
describe "Formula model" do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:directory) { FactoryGirl.create(:directory, user: user) }
  let(:dfile) { FactoryGirl.create(:dfile, directory: directory, ftype: Dfile::FTYPE_SHEET ) }
  let(:sheet) { dfile.getSheet() }
  before do
	# get creates sheet from file
	@formula = FactoryGirl.create(:formula, sheet: sheet)
  end

   
  # default target for future tests
  subject { @formula }
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # check the fields
  it { should respond_to( :descr ) }
  it { should respond_to( :omath ) }
  it { should respond_to( :created_at ) }
  it { should respond_to( :updated_at ) }
  it { should be_valid }
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "description" do
    describe "is valid filled" do
        before do
          @formula.descr = 'Some description'
        end
        it { should be_valid }
     end
    describe "is valid empty" do
        before do
          @formula.descr = ''
        end
        it { should be_valid }
     end
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "OpenMath" do
    describe "is valid filled" do
        before do
          @formula.omath = 'Some description'
        end
        it { should be_valid }
     end
    describe "is invalid empty" do
        before do
          @formula.omath = ''
        end
        it { should_not be_valid }
     end
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "toJSON method" do
    it "should return proper content" do
      @formula.toJSON().should_not be_empty
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
