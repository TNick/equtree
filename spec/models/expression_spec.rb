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
# Table name: expressions
#
#  id            :integer          not null, primary key
#  context_id    :integer
#  omath         :text
#  description   :text
#  info_uri      :text
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
describe "Expression model" do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:directory) { FactoryGirl.create(:directory, user: user) }
  let(:dfile) { FactoryGirl.create(:dfile, directory: directory, ftype: Dfile::FTYPE_SHEET ) }
  let(:sheet) { dfile.getSheet() }
  let(:context) { FactoryGirl.create(:context, sheet: sheet) }
  before do
	# get creates sheet from file
	@expression = FactoryGirl.create(:expression, context: context)
  end

   
  # default target for future tests
  subject { @expression }
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # check the fields
  it { should respond_to( :context_id ) }
  it { should respond_to( :omath ) }
  it { should respond_to( :description ) }
  it { should respond_to( :info_uri ) }
  it { should respond_to( :position_left ) }
  it { should respond_to( :position_top ) }
  it { should respond_to( :created_at ) }
  it { should respond_to( :updated_at ) }
  
  it { should be_valid }
  it "should be a Expression" do
    @expression.is_a?(Expression).should be_true 
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "description" do
    describe "is valid filled" do
        before do
          @expression.description = 'Some description'
        end
        it { should be_valid }
     end
    describe "is valid empty" do
        before do
          @expression.description = ''
        end
        it { should be_valid }
     end
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "OpenMath" do
    describe "is valid filled" do
        before do
          @expression.omath = 'Some description'
        end
        it { should be_valid }
     end
    describe "is invalid empty" do
        before do
          @expression.omath = ''
        end
        it { should_not be_valid }
     end
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "to_hash method" do
    it "should return proper content" do
      @expression.to_hash().should_not be_empty
    end
    it "should include specific information" do
      @expression.to_hash().to_s().should include("id")
      @expression.to_hash().to_s().should include("context_id")
      @expression.to_hash().to_s().should include("omath")
      @expression.to_hash().to_s().should include("description")
      @expression.to_hash().to_s().should include("info_uri")
      @expression.to_hash().to_s().should include("position_left")
      @expression.to_hash().to_s().should include("position_top")
    end
    
    describe "returned values" do
      before do
        @expression.omath = "$$the math goes here$$"
        @expression.description = "Import description"
        @expression.info_uri = "http://www.google.com"
        @expression.position_left = "50.1"
        @expression.position_top = "60.1"
        @str_repr = @expression.to_hash().to_s()
      end
      
      it "should contain the values that we set" do
        @str_repr.should include("$$the math goes here$$")
        @str_repr.should include("Import description")
        @str_repr.should include("http://www.google.com")
        @str_repr.should include("50.1")
        @str_repr.should include("60.1")
      end
      
    end # describe "returned values" do
    
  end # describe "to_hash method" do
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "position" do
    it "should have a valid position" do
      @expression.position_left.should >=(0.0)
      @expression.position_top.should >=(0.0)
    end
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "parent context" do
    it "should have a parent context" do
      @expression.context_id.should >=(0)
    end
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  
  
end # describe "Expression model"
# ========================================================================= 

#  TESTS    ==============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
