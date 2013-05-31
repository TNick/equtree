# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		RSpec Tests for static pages
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
describe "Static pages" do
  
  # default target for future tests
  subject { page }
  
  # common tests
  shared_examples_for "all static pages" do
	it { should have_content( 'EquTree' ) }
    it { should have_selector( 'h1',    text: heading ) }
    it { should have_selector( 'title', text: full_title(page_title ) ) }
  end
  
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "Home page" do
	before { visit root_path }
	
    let(:heading)    { 'EquTree' }
    let(:page_title) { '' }
    
    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: '| Home' }
    it { should have_content( 'Welcome' ) }
    it { find_link( "Sign up" )[:href].should ==("/signup") }
    
  end # describe "Home page"
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "Contact page" do
	before { visit contact_path }
	
	let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }
	
	it_should_behave_like "all static pages"
    
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "Help page" do
	before { visit help_path }
	
	let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }
	
	it_should_behave_like "all static pages"
	
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "About page" do
	before { visit about_path }
	
	let(:heading)    { 'About' }
    let(:page_title) { 'About' }
	
	it_should_behave_like "all static pages"
  end
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    should have_selector 'title', text: full_title('About Us')
    click_link "Help"
    should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    should have_selector 'title', text: full_title('Contact')
    click_link "Home"
    click_link "Sign up now!"
    should have_selector 'title', text: full_title('Sign up')
    click_link "EquTree"
    should have_selector 'title', text: full_title('')
  end  
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
end # describe "Static pages"
# ========================================================================= 

#  TESTS    ==============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
