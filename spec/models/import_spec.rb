# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date        May 2013
#  \author      TNick
#
#  \brief       RSpec Tests for Sheet data model
#
# == Schema Information
#
# Table name: expressions
#
#  id            :integer          not null, primary key
#  context_id    :integer
#  imported_context_id    :integer
#  position_left :float
#  position_top  :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
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
describe "Import model" do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:directory) { FactoryGirl.create(:directory, user: user) }
  let(:dfile) { FactoryGirl.create(:dfile, directory: directory, ftype: Dfile::FTYPE_SHEET ) }
  let(:sheet) { dfile.getSheet() }
  let(:context) { FactoryGirl.create(:context, sheet: sheet) }
  before do
    # get creates sheet from file
    @import = FactoryGirl.create(:import, context: context)
  end

   
  # default target for future tests
  subject { @import }
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # check the fields
  it { should respond_to( :context_id ) }
  it { should respond_to( :imported_context_id ) }
  it { should respond_to( :position_left ) }
  it { should respond_to( :position_top ) }
  it { should respond_to( :created_at ) }
  it { should respond_to( :updated_at ) }
  
  it { should be_valid }
  it "should be a Import" do
    @import.is_a?(Import).should be_true 
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "to_hash method" do
    before do
      @str_hash = @import.to_hash().to_s()
    end
    it "should return proper content" do
      @str_hash.should_not be_empty
    end
    it "should include specific information" do
      @str_hash.should include("id")
      @str_hash.should include("context_id")
      @str_hash.should include("imported_context_id")
      @str_hash.should include("position_left")
      @str_hash.should include("position_top")
    end
    
    
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "position" do
    it "should have a valid position" do
      @import.position_left.should >=(0.0)
      @import.position_top.should >=(0.0)
    end
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "parent context" do
    it "should have a parent context" do
      @import.context_id.should >=(0)
    end
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  
  
end # describe "Import model"
# ========================================================================= 

#  TESTS    ==============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
