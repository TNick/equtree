# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		RSpec tests for the file system
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
describe "File system " do
  

  subject { page }
  
  before do
    # have an user at hand
    @user = FactoryGirl.create(:user,
                    name: "Capybara test", email: "capybara@test.com", 
                    password: 'capybara-test', 
                    password_confirmation: 'capybara-test' )
    visit signin_path
    fill_in 'session[email]', :with => 'capybara@test.com'
    fill_in 'session[password]', :with => 'capybara-test'
    click_button "Sign in"
  end
  
  describe "required content" do
    it { should have_selector( 'div',    id: "fs_content_dir" ) }
    it { should have_selector( 'div',    id: "fs_file_zone" ) }
    it { should have_selector( 'div',    id: "fs_toolb" ) }
    it { should have_selector( 'div',    id: "directory_tree" ) }
    
    it { should have_selector( 'a',    id: 'tb_new_file' ) }
    it { should have_selector( 'a',    id: 'tb_new_dir' ) }
    it { should have_selector( 'a',    id: 'tb_edit_name' ) }
    it { should have_selector( 'a',    id: 'tb_cut' ) }
    it { should have_selector( 'a',    id: 'tb_copy' ) }
    it { should have_selector( 'a',    id: 'tb_paste' ) }
    it { should have_selector( 'a',    id: 'tb_delete' ) }
    it { should have_selector( 'a',    id: 'tb_undo' ) }
    it { should have_selector( 'a',    id: 'tb_redo' ) }
    
#     it { find_link("tb_new_file").visible?.should be_false }
#     it { find_link("tb_new_dir").visible?.should be_false }
#     it { find_link("tb_edit_name").visible?.should be_false }
#     it { find_link("tb_cut").visible?.should be_false }
#     it { find_link("tb_copy").visible?.should be_false }
#     it { find_link("tb_paste").visible?.should be_false }
#     it { find_link("tb_delete").visible?.should be_false }
#     it { find_link("tb_undo").visible?.should be_false }
#     it { find_link("tb_redo").visible?.should be_false }    
    
  end # "required content"
  
  describe "fs toolbar" do
    before do
      find('#btmbtn_explore').click
      find('#directory_tree').click # brings up the toolbar
      find('#tb_new_dir').click
      save_and_open_page
    end
    it { should have_selector( 'div',    id: "fs_content_dir" ) }
  end
  
  #describe "create root directory", :js => true do
  #  before do
      #find_link("tb_new_dir").click
      # 
 #   end
    #it { should have_selector( 'div',    id: "fs_content_dir" ) }
    
  #end # "create root directory"
  
  
	
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "state after sign up" do
	
    
	
  end # describe "Singup page"
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "add a directory" do
	
    
	
  end # describe "Singup page"
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "add a file" do
	
    
	
  end # describe "Singup page"
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  
end # describe "User pages"
# ========================================================================= 

#  TESTS    ==============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
