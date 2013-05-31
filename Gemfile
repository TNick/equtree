# ========================================================================= 
# ------------------------------------------------------------------------- 
#
#  \date		May 2013
#  \author		TNick
#
#  \brief		Controlls the dependencies of our project
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
#  INCLUDES    ------------------------------------------------------------ 

source 'https://rubygems.org'

#  INCLUDES    ============================================================ 
#
#
#
#
#  COMMON GEMS    --------------------------------------------------------- 


gem 'rails', '3.2.13'

# jQuerry for rails
gem 'jquery-rails'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# helper for paginating long lists
gem 'will_paginate', '3.0.3'
gem 'bootstrap-will_paginate', '0.0.6'

# tree structure in a model - https://github.com/stefankroes/ancestry
gem 'ancestry'

gem 'jquery-ui-themes'


#  COMMON GEMS    ========================================================= 
#
#
#
#
#  DEVELOPMENT    ---------------------------------------------------------

group :development do
    
  # add some smart comments about the structure of our tables
  gem 'annotate', '2.5.0'
  
  require 'rbconfig'
  gem 'wdm', '>= 0.1.0' if RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i
end

#  DEVELOPMENT    =========================================================
#
#
#
#
#  TESTS    ---------------------------------------------------------------

group :test do
  
  # easly create database components
  gem 'factory_girl_rails', '4.1.0'
  
  # better tests with this
  gem 'capybara', '1.1.2'
  
  # for Guard
  gem 'rb-fchange', '0.0.5',   :platform => [:mswin, :mingw]
  gem 'rb-notifu', '0.0.4',    :platform => [:mswin, :mingw]
  gem 'win32console', '1.3.0', :platform => [:mswin, :mingw]   
  gem 'rb-inotify', '0.9.0',   :platform => [:ruby]  
  gem 'libnotify', '0.5.9',    :platform => [:ruby]  

end

#  TESTS    ===============================================================
#
#
#
#
#  DEVELOPMENT AND TESTS    -----------------------------------------------


group :development, :test do

  # using sqlite in LOCAL MACHINE
  gem 'sqlite3', '1.3.5'
  
  # for testing we're using RSpec
  gem 'rspec-rails', '2.11.0'
  gem 'guard-rspec', '1.2.1'
  
  # for spork
  gem 'guard-spork', '1.2.0'
  gem 'childprocess'
  gem 'spork', '0.9.2'
  
  gem "teabag"
  gem "guard-teabag"
  gem "rb-fsevent" # used by guard
  
  gem 'log_buddy'
  gem 'webrick', '~> 1.3.1'
  
end

#  DEVELOPMENT AND TESTS    ===============================================
#
#
#
#
#  ASSETS    --------------------------------------------------------------

group :assets do

  # better css 
  gem 'sass-rails',   '~> 3.2.5'
  
  # javascripting
  gem 'coffee-rails', '~> 3.2.2'
  
  # uglify javascript so that people can't read it; why?
  gem 'uglifier', '>= 1.2.4'
  
  # some pretty formatting
  gem 'bootstrap-sass', '2.1'
  
end

#  ASSETS    ==============================================================
#
#
#
#
#  PRDUCTION    -----------------------------------------------------------

group :production do

  gem "pg"
  
end

#  PRDUCTION    ===========================================================
#
#
#
#
# ------------------------------------------------------------------------- 
# ========================================================================= 
