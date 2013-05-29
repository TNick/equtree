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
  it "should be a Directory" do
    @directory.is_a?(Directory).should be_true 
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "user id" do
    describe "when user_id is invalid" do
      before do
        @directory.user_id = nil
      end

      it { should_not be_valid }
    end
    
    describe "get root directory back from user" do
      it "should be able to get back root" do
        user.directories[0].should ==(@directory)
      end
    end
    
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
    
    describe "with unicode characters" do
      before do
        @directory.name = "dir name \234\457\032"
      end
      it { should be_valid }
    end
    
    describe "with only unicode characters" do
      before do
        @directory.name = "\234\457\032"
      end
      it { should be_valid }
    end
    
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "ancestry" do
    
    describe "initial directory" do
      
      it "should behave" do
        @directory.parent.should be_nil
        @directory.parent_id.should be_nil
        @directory.root.should ==(@directory)
        @directory.root_id.should ==(1)
        #@directory.root?.should be_true
        @directory.is_root? .should be_true
        @directory.ancestor_ids.length.should ==(0)
        @directory.ancestors.length.should ==(0)
        @directory.path_ids.length.should ==(1)
        @directory.path.length.should ==(1)
        @directory.is_only_child?.should be_true
        @directory.has_siblings?.should be_false
        @directory.depth.should ==(0)
        
      end
      
      it "should have no kids" do
        @directory.children.length.should ==(0)
        @directory.has_children?.should be_false
        @directory.is_childless?.should be_true
      end
      
    end
    
    describe "with a sibling" do
      before do
        @d2 = FactoryGirl.create(:directory, user: user)
      end
      
      it "should behave" do
        @directory.parent.should be_nil
        @directory.parent_id.should be_nil
        @directory.root.should ==(@directory)
        @directory.root_id.should ==(1)
        #@directory.root?.should be_true
        @directory.is_root? .should be_true
        @directory.ancestor_ids.length.should ==(0)
        @directory.ancestors.length.should ==(0)
        @directory.path_ids.length.should ==(1)
        @directory.path.length.should ==(1)
        @directory.is_only_child?.should be_false
        @directory.has_siblings?.should be_true
        @directory.depth.should ==(0)
        
        @d2.parent.should be_nil
        @d2.parent_id.should be_nil
        @d2.root.should ==(@d2)
        @d2.root_id.should ==(2)
        #@d2.root?.should be_true
        @d2.is_root? .should be_true
        @d2.ancestor_ids.length.should ==(0)
        @d2.ancestors.length.should ==(0)
        @d2.path_ids.length.should ==(1)
        @d2.path.length.should ==(1)
        @d2.is_only_child?.should be_false
        @d2.has_siblings?.should be_true
        @d2.depth.should ==(0)        
        
      end
    end
    
    describe "with a kid" do
      before do
        @d2 = @directory.createChild name: "dir name"
      end
      
      it "should behave" do
        @directory.parent.should be_nil
        @directory.parent_id.should be_nil
        @directory.root.should ==(@directory)
        @directory.root_id.should ==(1)
        #@directory.root?.should be_true
        @directory.is_root? .should be_true
        @directory.ancestor_ids.length.should ==(0)
        @directory.ancestors.length.should ==(0)
        @directory.path_ids.length.should ==(1)
        @directory.path.length.should ==(1)
        @directory.is_only_child?.should be_true
        @directory.has_siblings?.should be_false
        @directory.depth.should ==(0)
        
        @d2.parent.should ==(@directory)
        @d2.parent_id.should ==(@directory.id)
        @d2.root.should ==(@directory)
        @d2.root_id.should ==(1)
        #@d2.root?.should be_true
        @d2.is_root? .should be_false
        @d2.ancestor_ids.length.should ==(1)
        @d2.ancestors.length.should ==(1)
        @d2.path_ids.length.should ==(2)
        @d2.path.length.should ==(2)
        @d2.is_only_child?.should be_true
        @d2.has_siblings?.should be_false
        @d2.depth.should ==(1)        
        
      end      
    end
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "as JSON" do
    
    describe "common state" do
      let(:s) { @directory.to_json }
      it "should contain valid data" do
        s.should include('"id"')
        s.should include('"name"')
        s.should include('"user_id"')
        s.should include('"ancestry"')
        s.should include('"created_at"')
        s.should include('"updated_at"')
        # d s
      end
    end
    
    describe "with data" do
      before do
        @directory.name = "dir name"
        @d2 = @directory.createChild( "subdir" )
        
        @s = @d2.to_json
      end
      
      it "should contain valid data" do
        @s.should include('"subdir"')
        # d @s
      end
    end
    
  end # "as JSON"
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
