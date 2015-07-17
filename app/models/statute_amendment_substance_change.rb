class StatuteAmendmentSubstanceChange < ActiveRecord::Base
  belongs_to :statute_amendment
  belongs_to :substance
end
