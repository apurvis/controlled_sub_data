class StatuteAmendment < ActiveRecord::Base
  belongs_to :statute
  has_many :statute_amendment_substance_changes
end
