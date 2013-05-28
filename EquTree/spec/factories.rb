# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		FactoryGirl factories for our RSpec tests
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
FactoryGirl.define do
   
  # -----------------------------------------------------------------------
  # create an entry of User kind
  factory :user do
  
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}  
    password "foobar"
    password_confirmation "foobar"
    
    factory :admin do
      admin true
    end
    
  end
  # =======================================================================

  # -----------------------------------------------------------------------
  # create an entry of Directory kind
  factory :directory do
  
    sequence(:name)  { |n| "Dir #{n}" }
    user
	
  end
  # =======================================================================

  # -----------------------------------------------------------------------
  # create an entry of File kind
  factory :dfile do
  
    sequence(:name)		{ |n| "File #{n}" }
	ftype				Dfile::FTYPE_TEST
    type_index          -1
    # special_users       SpecialUsers.new()
    public_policy       0
    directory
	
  end
  # =======================================================================

  # -----------------------------------------------------------------------
  # create an entry of Sheet kind
  factory :sheet do
  
    context_id              0
    dfile_id                0
	
  end
  # =======================================================================

  # -----------------------------------------------------------------------
  # create an entry of Context kind
  factory :context do
  
    sequence(:description)  { |n| "Description #{n}" }
    sequence(:info_uri)     { |n| "http://www.google.com/#{n}" }
    position_left           0.0
    position_top            0.0
    size_width              80.0
    size_height             80.0
    
    sheet
  end
  # =======================================================================
 
  # -----------------------------------------------------------------------
  # create an entry of Formula kind
  factory :expression do
  
    sequence(:description)  { |n| "Description #{n}" }
	sequence(:omath)		{ |n| "Omath #{n}" }
    sequence(:info_uri)     { |n| "http://www.google.com/#{n}" }
    position_left           0.0
    position_top            0.0
    context
    
  end
  # =======================================================================
 
  # -----------------------------------------------------------------------
  # create an entry of Imports kind
  factory :import do
  
    imported_context_id     0
    position_left           0.0
    position_top            0.0
    context
    
  end
  # =======================================================================

  
  
end
#  FUNCTIONS    ===========================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
