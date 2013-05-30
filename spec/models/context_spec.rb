# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		RSpec Tests for Dfile data model
#
# == Schema Information
#
# Table name: contexts
#
#  id            :integer          not null, primary key
#  sheet_id      :integer
#  ancestry      :text
#  description   :text
#  info_uri      :text
#  position_left :float
#  position_top  :float
#  size_width    :float
#  size_height   :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

#  INCLUDES    ===========================================================
#
#
#
#
#  TESTS    --------------------------------------------------------------

# ------------------------------------------------------------------------- 
describe "Context model" do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:directory) { FactoryGirl.create(:directory, user: user) }
  let(:dfile) { FactoryGirl.create(:dfile, directory: directory, ftype: Dfile::FTYPE_SHEET ) }
  let(:sheet) { dfile.getSheet() }
  before do
    # get creates sheet from file
    @context = FactoryGirl.create(:context, sheet: sheet)
  end

   
  # default target for future tests
  subject { @context }
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # check the fields
  it { should respond_to( :sheet_id ) }
  it { should respond_to( :ancestry ) }
  it { should respond_to( :description ) }
  it { should respond_to( :info_uri ) }
  it { should respond_to( :position_left ) }
  it { should respond_to( :position_top ) }
  it { should respond_to( :size_width ) }
  it { should respond_to( :size_height ) }
  it { should respond_to( :created_at ) }
  it { should respond_to( :updated_at ) }
  
  it { should be_valid }
  it "should be a Context" do
    @context.is_a?(Context).should be_true 
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "description" do
    describe "is valid filled" do
        before do
          @context.description = 'Some description'
        end
        it { should be_valid }
     end
    describe "is valid empty" do
        before do
          @context.description = ''
        end
        it { should be_valid }
     end
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "position" do
    it "should have a valid position" do
      @context.position_left.should >=(0.0)
      @context.position_top.should >=(0.0)
    end
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "size" do
    it "should have a valid position" do
      @context.size_width.should >=(0.0)
      @context.size_height.should >=(0.0)
    end
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "ancestry" do
    
    describe "initial directory" do
      
      it "should behave" do
        @context.parent.should be_nil
        @context.parent_id.should be_nil
        @context.root.should ==(@context)
        @context.root_id.should ==(1)
        #@context.root?.should be_true
        @context.is_root? .should be_true
        @context.ancestor_ids.length.should ==(0)
        @context.ancestors.length.should ==(0)
        @context.path_ids.length.should ==(1)
        @context.path.length.should ==(1)
        @context.is_only_child?.should be_true
        @context.has_siblings?.should be_false
        @context.depth.should ==(0)
        
      end
      
      it "should have no kids" do
        @context.children.length.should ==(0)
        @context.has_children?.should be_false
        @context.is_childless?.should be_true
      end
      
    end
    
    describe "with a sibling" do
      before do
        @ctx2 = FactoryGirl.create(:context, sheet: sheet)
      end
      
      it "should behave" do
        @context.parent.should be_nil
        @context.parent_id.should be_nil
        @context.root.should ==(@context)
        @context.root_id.should ==(1)
        #@context.root?.should be_true
        @context.is_root? .should be_true
        @context.ancestor_ids.length.should ==(0)
        @context.ancestors.length.should ==(0)
        @context.path_ids.length.should ==(1)
        @context.path.length.should ==(1)
        @context.is_only_child?.should be_false
        @context.has_siblings?.should be_true
        @context.depth.should ==(0)
        
        @ctx2.parent.should be_nil
        @ctx2.parent_id.should be_nil
        @ctx2.root.should ==(@ctx2)
        @ctx2.root_id.should ==(2)
        #@ctx2.root?.should be_true
        @ctx2.is_root? .should be_true
        @ctx2.ancestor_ids.length.should ==(0)
        @ctx2.ancestors.length.should ==(0)
        @ctx2.path_ids.length.should ==(1)
        @ctx2.path.length.should ==(1)
        @ctx2.is_only_child?.should be_false
        @ctx2.has_siblings?.should be_true
        @ctx2.depth.should ==(0)        
        
      end
    end
    
    describe "with a kid" do
      before do
        @ctx2 = @context.createSubContext 
      end
      
      it "should behave" do
        @context.parent.should be_nil
        @context.parent_id.should be_nil
        @context.root.should ==(@context)
        @context.root_id.should ==(1)
        #@context.root?.should be_true
        @context.is_root? .should be_true
        @context.ancestor_ids.length.should ==(0)
        @context.ancestors.length.should ==(0)
        @context.path_ids.length.should ==(1)
        @context.path.length.should ==(1)
        @context.is_only_child?.should be_true
        @context.has_siblings?.should be_false
        @context.depth.should ==(0)
        
        @ctx2.parent.should ==(@context)
        @ctx2.parent_id.should ==(@context.id)
        @ctx2.root.should ==(@context)
        @ctx2.root_id.should ==(1)
        #@ctx2.root?.should be_true
        @ctx2.is_root? .should be_false
        @ctx2.ancestor_ids.length.should ==(1)
        @ctx2.ancestors.length.should ==(1)
        @ctx2.path_ids.length.should ==(2)
        @ctx2.path.length.should ==(2)
        @ctx2.is_only_child?.should be_true
        @ctx2.has_siblings?.should be_false
        @ctx2.depth.should ==(1)        
        
      end      
    end
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "to_hash method" do
    
    it "should return proper content" do
      @context.to_hash().should_not be_empty
    end
    it "should include specific information" do
      @context.to_hash().to_s().should include("id")
      @context.to_hash().to_s().should include("sheet_id")
      @context.to_hash().to_s().should include("description")
      @context.to_hash().to_s().should include("info_uri")
      
      @context.to_hash().to_s().should include("position_left")
      @context.to_hash().to_s().should include("position_top")
      @context.to_hash().to_s().should include("size_width")
      @context.to_hash().to_s().should include("size_height")
      
      @context.to_hash().to_s().should include("imports")
      @context.to_hash().to_s().should include("expressions")
      @context.to_hash().to_s().should include("contexts")
      
    end
    
    describe "returned values" do
      before do
        @context.description = "Import description"
        @context.info_uri = "http://www.google.com"
        @context.position_left = "50.1"
        @context.position_top = "60.1"
        @context.size_width = "150.1"
        @context.size_height = "160.1"
        @str_repr = @context.to_hash().to_s()
      end
      
      it "should contain the values that we set" do
        @str_repr.should include("Import description")
        @str_repr.should include("http://www.google.com")
        @str_repr.should include("50.1")
        @str_repr.should include("60.1")
        @str_repr.should include("150.1")
        @str_repr.should include("160.1")
      end
      
    end # describe "returned values" do
    
  end # describe "to_hash method" do
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =


end # describe "Context model"
# ========================================================================= 

#  TESTS    ==============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
