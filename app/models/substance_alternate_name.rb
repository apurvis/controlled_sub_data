class SubstanceAlternateName < ActiveRecord::Base
  belongs_to :substance

  validates :name, presence: true
  validates :substance_id, presence: true
end
