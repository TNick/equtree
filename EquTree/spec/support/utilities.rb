# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		Contain helper code for RSpec tests
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
#  FUNCTIONS    -----------------------------------------------------------

# ------------------------------------------------------------------------- 
# will return a full title for input
def		full_title		(partial_title)
  
  base_title = "EquTree"
  if partial_title.blank?
	base_title
  else
	"#{base_title} | #{partial_title}"
  end
  
end
# ========================================================================= 

# ------------------------------------------------------------------------- 
RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end
# ========================================================================= 

# ------------------------------------------------------------------------- 
RSpec::Matchers.define :have_no_error_message do
  match do |page|
    page.should_not have_selector('div.alert.alert-error')
  end
end
# ========================================================================= 

# ------------------------------------------------------------------------- 
def valid_signin	( user )
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end
# ========================================================================= 

# ------------------------------------------------------------------------- 
def sign_in			( user )
  visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end
# ========================================================================= 


#  FUNCTIONS    ===========================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
