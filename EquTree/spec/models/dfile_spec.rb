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
# Table name: dfiles
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  directory_id  :integer
#  ftype         :integer
#  type_index    :integer
#  special_users :text
#  public_policy :integer
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
  it { should respond_to( :type_index ) }
  it { should respond_to( :typeName ) }
  it { should respond_to( :getSheet ) }
  it { should respond_to( :special_users ) }
  it { should respond_to( :public_policy ) }
  it { should respond_to( :created_at ) }
  it { should respond_to( :updated_at ) }
  it { should be_valid }
  it "should be a Dfile" do
    @dfile.is_a?(Dfile).should be_true 
  end
  
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "constants" do
    it "should have constants inside bounds" do
      Dfile::FTYPE_TEST.should >(Dfile::FTYPE_MIN)
      Dfile::FTYPE_SHEET.should >(Dfile::FTYPE_MIN)
      Dfile::FTYPE_TEST.should <(Dfile::FTYPE_MAX)
      Dfile::FTYPE_SHEET.should <(Dfile::FTYPE_MAX)
    end
    it "should not overlap" do
      Dfile::FTYPE_TEST.should_not ==(Dfile::FTYPE_SHEET)
      
      Dfile::PP_PRIVATE.should_not ==(Dfile::PP_MAYVIEW)
      Dfile::PP_PRIVATE.should_not ==(Dfile::PP_MAYEDIT)
      Dfile::PP_MAYVIEW.should_not ==(Dfile::PP_MAYEDIT)
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
    
    describe "with unicode characters" do
      before do
        @dfile.name = "file name \234\457\032"
      end
      it { should be_valid }
    end
    
    describe "with only unicode characters" do
      before do
        @dfile.name = "\234\457\032"
      end
      it { should be_valid }
    end
    
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "directory" do
    
    describe "when directory_id is invalid" do
      before do
        @dfile.directory_id = nil
      end

      it { should_not be_valid }
    end
    
    it "should get the file back from directory" do
      @dfile.directory.dfiles[0].should ==(@dfile)
    end
    
    describe "directory should destroy the file when destroies" do
      before do
        @dfile.directory.destroy        
      end
      it "should have been removed from database" do
        expect do
          Dfile.find( @dfile.id )
        end.to raise_error(ActiveRecord::RecordNotFound )
      end
    end
     
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
    
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "file type and index in other table" do
    
    describe "is not set" do
      before do
        @dfile.ftype = Dfile::FTYPE_MIN
      end
      it { should_not be_valid }
      it { @dfile.getSheet.should be_nil}
      it { @dfile.typeName.should ==("generic")}
      it { @dfile.type_index.should ==(-1)}
      
    end
    
    describe "is test" do
      before do
        @dfile = FactoryGirl.create(:dfile, directory: directory, ftype: Dfile::FTYPE_TEST)
      end
      it { should be_valid }
      it { @dfile.getSheet.should be_nil}
      it { @dfile.typeName.should ==("test")}
      it { @dfile.type_index.should ==(-1)}
      
    end
    
    describe "is sheet" do
      before do
        @dfile = FactoryGirl.create(:dfile, directory: directory, ftype: Dfile::FTYPE_SHEET)
      end
      it { should be_valid }
      it { @dfile.getSheet.should_not be_nil}
      it { @dfile.typeName.should ==("mathsheet")}
      it { @dfile.type_index.should ==(1)}
      
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
  describe "special permissions" do
    
    before do
      @user_1 = FactoryGirl.create(:user, name: "user 1")
      @user_2 = FactoryGirl.create(:user, name: "user 2")
      @user_3 = FactoryGirl.create(:user, name: "user 3")
      @user_4 = FactoryGirl.create(:user, name: "user 4")
    end    
    
    it "invalid input should generate exception" do
      expect do
        @dfile.mayView?( nil )
      end.to raise_error(NoMethodError)
      expect do
        @dfile.mayEdit?( nil )
      end.to raise_error(NoMethodError)
    end
    
    describe "current user should be allowed" do
      it { @dfile.mayView?( user ).should be_true }
      it { @dfile.mayEdit?( user ).should be_true }
    end
    
    describe "by default is private" do
      it { @dfile.mayView?( @user_1 ).should be_false }
      it { @dfile.mayEdit?( @user_1 ).should be_false }
      it { @dfile.mayView?( @user_2 ).should be_false }
      it { @dfile.mayEdit?( @user_2 ).should be_false }
    end
    
    describe "public view-able file available to all" do
      before do
        @dfile.public_policy = Dfile::PP_MAYVIEW
      end
      
      it { @dfile.mayView?( @user_1 ).should be_true }
      it { @dfile.mayView?( @user_2 ).should be_true }
      it { @dfile.mayView?( user ).should be_true }
      
      it { @dfile.mayEdit?( @user_1 ).should be_false }
      it { @dfile.mayEdit?( @user_2 ).should be_false }
      it { @dfile.mayEdit?( user ).should be_true }
    end
    
    describe "public edit-able file available to all" do
      before do
        @dfile.public_policy = Dfile::PP_MAYEDIT
      end
      
      it { @dfile.mayView?( @user_1 ).should be_true }
      it { @dfile.mayView?( @user_2 ).should be_true }
      it { @dfile.mayView?( user ).should be_true }
      
      it { @dfile.mayEdit?( @user_1 ).should be_true }
      it { @dfile.mayEdit?( @user_2 ).should be_true }
      it { @dfile.mayEdit?( user ).should be_true }
    end
    
    describe "private" do
      before do
        @dfile.public_policy = Dfile::PP_PRIVATE
      end      
    
      describe "but available for view to some" do
        before do@dfile
          @dfile.setPermissionView( @user_1 )
          @dfile.setPermissionView( @user_2 )
        end
        
        it { @dfile.mayView?( @user_1 ).should be_true }
        it { @dfile.mayView?( @user_2 ).should be_true }
        it { @dfile.mayView?( @user_3 ).should be_false }
        it { @dfile.mayView?( @user_4 ).should be_false }
        it { @dfile.mayView?( user ).should be_true }
        
        it { @dfile.mayEdit?( @user_1 ).should be_false }
        it { @dfile.mayEdit?( @user_2 ).should be_false }
        it { @dfile.mayEdit?( @user_3 ).should be_false }
        it { @dfile.mayEdit?( @user_4 ).should be_false }
        it { @dfile.mayEdit?( user ).should be_true }
      end
      
      describe "but available for edit to some" do
        before do
          @dfile.setPermissionEdit( @user_1 )
          @dfile.setPermissionEdit( @user_2 )
        end
        
        it { @dfile.mayView?( @user_1 ).should be_true }
        it { @dfile.mayView?( @user_2 ).should be_true }
        it { @dfile.mayView?( @user_3 ).should be_false }
        it { @dfile.mayView?( @user_4 ).should be_false }
        it { @dfile.mayView?( user ).should be_true }
        
        it { @dfile.mayEdit?( @user_1 ).should be_true }
        it { @dfile.mayEdit?( @user_2 ).should be_true }
        it { @dfile.mayEdit?( @user_3 ).should be_false }
        it { @dfile.mayEdit?( @user_4 ).should be_false }
        it { @dfile.mayEdit?( user ).should be_true }
      end
      
      describe "but available for view to some and edit to others" do
        before do
          @dfile.setPermissionView( @user_1 )
          @dfile.setPermissionEdit( @user_2 )
          
        end
        
        it { @dfile.mayView?( @user_1 ).should be_true }
        it { @dfile.mayView?( @user_2 ).should be_true }
        it { @dfile.mayView?( @user_3 ).should be_false }
        it { @dfile.mayView?( @user_4 ).should be_false }
        it { @dfile.mayView?( user ).should be_true }
        
        it { @dfile.mayEdit?( @user_1 ).should be_false }
        it { @dfile.mayEdit?( @user_2 ).should be_true }
        it { @dfile.mayEdit?( @user_3 ).should be_false }
        it { @dfile.mayEdit?( @user_4 ).should be_false }
        it { @dfile.mayEdit?( user ).should be_true }
      end
     
    end # private
    
    
    describe "public view" do
      before do
        @dfile.public_policy = Dfile::PP_MAYVIEW
      end
      
      it { @dfile.mayView?( @user_1 ).should be_true }
      it { @dfile.mayView?( @user_2 ).should be_true }
      it { @dfile.mayView?( @user_3 ).should be_true }
      it { @dfile.mayView?( @user_4 ).should be_true }
      it { @dfile.mayView?( user ).should be_true }
      
      describe "public view but available for edit to some" do
        before do
          @dfile.setPermissionView( @user_1 )
          @dfile.setPermissionEdit( @user_2 )
        end
        
        it { @dfile.mayEdit?( @user_1 ).should be_false }
        it { @dfile.mayEdit?( @user_2 ).should be_true }
        it { @dfile.mayEdit?( @user_3 ).should be_false }
        it { @dfile.mayEdit?( @user_4 ).should be_false }
        it { @dfile.mayEdit?( user ).should be_true }
        
      end

    end # "public view"
    
    
    describe "set and remove permission" do
      before do
        @dfile.public_policy = Dfile::PP_PRIVATE
        @dfile.setPermissionView( @user_1 )
        @dfile.setPermissionEdit( @user_2 ) 
        @dfile.save
        @dfile.reload
      end
      
      it { @dfile.mayEdit?( @user_1 ).should be_false }
      it { @dfile.mayView?( @user_1 ).should be_true }
      it { @dfile.mayEdit?( @user_2 ).should be_true }
      it { @dfile.mayView?( @user_2 ).should be_true }
      it { @dfile.mayEdit?( @user_3 ).should be_false }
      it { @dfile.mayView?( @user_3 ).should be_false }
      it { @dfile.mayEdit?( user ).should be_true }
      
      describe "after reload" do
        
        before do
          @dfile.removePermission( @user_1 )
          @dfile.removePermission( @user_2 ) 
          @dfile.removePermission( @user_3 )           
        end
      
        it { @dfile.mayEdit?( @user_1 ).should be_false }
        it { @dfile.mayView?( @user_1 ).should be_false }
        it { @dfile.mayEdit?( @user_2 ).should be_false }
        it { @dfile.mayView?( @user_2 ).should be_false }
        it { @dfile.mayEdit?( @user_3 ).should be_false }
        it { @dfile.mayView?( @user_3 ).should be_false }
        it { @dfile.mayEdit?( user ).should be_true }
        
      end
      
    end
    
    
    
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
