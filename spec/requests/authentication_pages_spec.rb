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
  
  before do
    # have an user at hand
    @user = FactoryGirl.create(:user,
                    name: "Capybara test", email: "capybara@test.com", 
                    password: 'capybara-test', 
                    password_confirmation: 'capybara-test' )
  end
  
  # common tests
  shared_examples_for "all auth pages" do
	it { should have_content( 'EquTree' ) }
    it { should have_selector( 'h1',    text: heading ) }
    it { should have_selector( 'title', text: full_title(page_title ) ) }
  end
    
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "Sign in page" do
    before do
      visit signin_path 
      # d signin_path
    end
    
    shared_examples_for "sign in page" do
      it_should_behave_like "all auth pages"
      it { should have_selector( 'label',    text: "Email" ) }
      it { should have_selector( 'input',    id: "session[email]" ) }
      it { should have_selector( 'label',    text: "Password" ) }
      it { should have_selector( 'input',    id: "session[password]" ) }
      it { should have_selector( 'input',    value: "Sign in" ) }
      it { find_link("Sign up").visible?.should be_true }

    end
    
    shared_examples_for "failed sign in" do
      it_should_behave_like "sign in page"
      it { should have_content( 'Invalid email/password combination' ) }
    end    
    
    let(:heading)    { 'Sign in' }
    let(:page_title) { 'Sign in' }
    
    it_should_behave_like "sign in page"
    
    describe "used to sign in an user" do
      before do
        # d User.all
      end
      
      describe "with no mail or password" do
        before do
          click_button "Sign in"
        end
        it_should_behave_like "failed sign in"
      end
      
      describe "with mail but no password" do
        before do
          fill_in 'session[email]', :with => 'capybara@test.com'
          click_button "Sign in"
        end
        it_should_behave_like "failed sign in"
      end
      
      describe "with password but no mail" do
        before do
          fill_in 'session[password]', :with => 'capybara-test'
          click_button "Sign in"
        end
        it_should_behave_like "failed sign in"
      end
      
      describe "with a valid mail and password" do
        before do
          # d "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
          # d page.body
          # d "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
          fill_in 'session[email]', :with => 'capybara@test.com'
          fill_in 'session[password]', :with => 'capybara-test'
          click_button "Sign in"
          # d "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
          # d page.body 
          # d "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
          
        end
        
        it { should have_content( 'EquTree' ) }
        it { should have_selector 'title', text: full_title('Capybara test') }
        
        describe "then sign out" do
          before do
            click_link "Sign out"
          end
          
          it { should have_selector 'title', text: full_title('') }
          
        end # then sign out"
        
      end # "with a valid mail and password" 
      
      describe "with an invalid mail" do
        before do
          fill_in 'session[email]', :with => 'XcapybaraX@test.com'
          fill_in 'session[password]', :with => 'capybara-test'
          click_button "Sign in"
        end
        it_should_behave_like "failed sign in"
        
      end # "with an invalid mail"
      
      describe "with an invalid password" do
        before do
          fill_in 'session[email]', :with => 'capybara@test.com'
          fill_in 'session[password]', :with => 'Xcapybara-testX'
          click_button "Sign in"
        end
        it_should_behave_like "failed sign in"
        
      end # "with an invalid password"
       
      describe "with an invalid password and mail" do
        before do
          fill_in 'session[email]', :with => 'Xcapybara@test.comX'
          fill_in 'session[password]', :with => 'Xcapybara-testX'
          click_button "Sign in"
        end
        it_should_behave_like "failed sign in"
        
      end # "with an invalid password and mail"
      
     end # "used to sign in an user"
    
  end # "Sign in page"
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  describe "Sign up page" do
    before do
      visit signup_path
      # d signup_path
    end

    shared_examples_for "sign up page" do
      it_should_behave_like "all auth pages"
      it { should have_selector( 'label',    text: "Name" ) }
      it { should have_selector( 'input',    id: "user_name" ) }
      it { should have_selector( 'label',    text: "Email" ) }
      it { should have_selector( 'input',    id: "user_email" ) }
      it { should have_selector( 'label',    text: "Password" ) }
      it { should have_selector( 'input',    id: "user_password" ) }
      it { should have_selector( 'label',    text: "Confirmation" ) }
      it { should have_selector( 'input',    id: "user_password_confirmation" ) }
      it { should have_selector( 'input',    value: "Create my account" ) }
    end
    
    shared_examples_for "failed sign up" do
      it_should_behave_like "sign up page"
      it { should have_content( 'The form contains' ) }
      # it { should ( have_content( 'errors' ) or have_content( 'error' ) )  }
    end  
    
    let(:heading)    { 'Sign up' }
    let(:page_title) { 'Sign up' }
    
    it_should_behave_like "all auth pages"
    
    describe "used to create a new user" do
      before do
        # d User.all
      end
      
      describe "with no input" do
        before do
          click_button "Create"
        end
        it_should_behave_like "failed sign up"
      end # "with no input"
      
      describe "with name" do
        before do
          fill_in 'user[name]', :with => 'Capybara test'
          click_button "Create"
        end
        it_should_behave_like "failed sign up"
      end # "with name"
      
      describe "with name and email" do
        before do
          fill_in 'user[name]', :with => 'Capybara test'
          fill_in 'user[email]', :with => 'capybara@test.com'
          click_button "Create"
        end
        it_should_behave_like "failed sign up"
      end # "with name and email"
      
      describe "with name and email and pass" do
        before do
          fill_in 'user[name]', :with => 'Capybara test'
          fill_in 'user[email]', :with => 'capybara@test.com'
          fill_in 'user[password]', :with => 'capybara-test'
          click_button "Create"
        end
        it_should_behave_like "failed sign up"
      end # "with name and email and pass"
      
      describe "with name and email and pass and confirmation" do
        before do
          fill_in 'user[name]', :with => 'Capybara test'
          fill_in 'user[email]', :with => 'capybara@test.com'
          fill_in 'user[password]', :with => 'capybara-test'
          fill_in 'user[password_confirmation]', :with => 'capybara-test'
          click_button "Create"
        end
        it_should_behave_like "failed sign up"
        it { should have_content( 'Email has already been taken' ) }        
      end # "with name and email and pass and confirmation"
      
      describe "with wrong confirmation" do
        before do
          fill_in 'user[name]', :with => 'Capybara test'
          fill_in 'user[email]', :with => 'capybara@test.com'
          fill_in 'user[password]', :with => 'capybara-test'
          fill_in 'user[password_confirmation]', :with => 'Xcapybara-testX'
          click_button "Create"
        end
        it_should_behave_like "failed sign up"
        it { should have_content( "Password doesn't match confirmation" ) }        
      end # "with wrong confirmation"
      
      describe "with valid data" do
        before do
          fill_in 'user[name]', :with => 'Capybara Second Test'
          fill_in 'user[email]', :with => 'capybara.second@test.com'
          fill_in 'user[password]', :with => 'capybara-test'
          fill_in 'user[password_confirmation]', :with => 'capybara-test'
          click_button "Create"
        end
        
        it { should have_content( 'EquTree' ) }
        it { should have_selector 'title', text: full_title('Capybara Second Test') }
        
        describe "then sign out" do
          before do
            click_link "Sign out"
          end
          
          it { should have_selector 'title', text: full_title('') }
          
        end # then sign out"
        
      end # "with valid data"
      
    end # "used to create a new user"
    
  end # "Sign up page"
  # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

  
end # describe "AuthenticationPages pages"
# ========================================================================= 

#  TESTS    ==============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
