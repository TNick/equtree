# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		Code for user model
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
#  CLASS    ---------------------------------------------------------------

# models the data associated with an user
#
# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean
#
#
class User < ActiveRecord::Base
  
  #
  #
  #
  #
  #  DEFINITIONS    -------------------------------------------------------
  
  # a regex for a valid e-mail
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  #  DEFINITIONS    =======================================================
  #
  #
  #
  #
  #  ATTRIBUTES    --------------------------------------------------------
  
  # the list of attributes that are accesible for get/set
  attr_accessible :email, :name, :password, :password_confirmation

  # use MD5 storage instead of plain passwords
  has_secure_password

  # user is parent for directories; destro them all if user is destroied
  has_many :directories, dependent: :destroy
  
  #  ATTRIBUTES    ========================================================
  #
  #
  #
  #
  #  VALIDATION    --------------------------------------------------------

  # there must always be a name that is between 2 and 50 characters long
  validates :name,	presence: true, 
					length: { minimum: 2, maximum: 50 }

  # there must always be an email that is unique in our database;
  # we treat the email as case-insensitive and we check this against 
  # a simple pattern
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }

  # the password must be at least six characters long
  validates :password, 
                    presence: true,
					length: { minimum: 6 }

  # always confirm the password
  validates :password_confirmation,
					presence: true

  #  VALIDATION    ========================================================
  #
  #
  #
  #
  #  MODIFIERS    ---------------------------------------------------------

  # make sure that the emmail is stores in the database in lower case form
  before_save { |user| user.email = email.downcase }

  # create a token to identify the user
  before_save :create_remember_token

  #  MODIFIERS    =========================================================
  #
  #
  #
  #
  #  PRIVATE HELPERS    ---------------------------------------------------

private


  # -----------------------------------------------------------------------
  # create a token to identify the user
  def create_remember_token

    # Create the token.
    self.remember_token = SecureRandom.urlsafe_base64

  end # def create_remember_token
  # =======================================================================


  #  PRIVATE HELPERS    ===================================================
  #
  #
  #
  #
  
end # class User

#  CLASS    ===============================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
