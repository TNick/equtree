# == Schema Information
#
# Table name: contexts
#
#  id            :integer          not null, primary key
#  sheet_id      :integer
#  ancestry      :text
#  description   :text
#  info_uri      :text
#  position_left :float
#  position_top  :float
#  size_width    :float
#  size_height   :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

describe Context do
  pending "add some examples to (or delete) #{__FILE__}"
end
