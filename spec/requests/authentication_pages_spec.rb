# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		RSpec tests for the user pages
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
describe "Authentication Pages: " do
  
  subject { page }
  
  # common tests
  shared_examples_for "all auth pages" do
	it { should have_content( 'EquTree' ) }
    it { should have_selector( 'h1',    text: heading ) }
    it { should have_selector( 'title', text: full_title(page_title ) ) }
  end
  
  
  describe "Sign in page" do
    before { visit signin_path }
    
    let(:heading)    { 'Sign in' }
    let(:page_title) { 'Sign in' }
    
    it_should_behave_like "all auth pages"
    
    
  end
  
  describe "Sign up page" do
    before { visit signup_path }
    
    let(:heading)    { 'Sign in' }
    let(:page_title) { 'Sign in' }
    
    it_should_behave_like "all auth pages"
    
    
  end
  
end # describe "AuthenticationPages pages"
# ========================================================================= 

#  TESTS    ==============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
