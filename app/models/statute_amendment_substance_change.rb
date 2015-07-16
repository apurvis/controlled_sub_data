class StatuteAmendmentSubstanceChange < ActiveRecord::Base
  belongs_to :statute_amendment
  has_one :substance
end
