class SubstanceStatute < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :substance
  belongs_to :statute
end
