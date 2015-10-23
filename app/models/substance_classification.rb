class SubstanceClassification < ActiveRecord::Base
  include IncludeFlags

  acts_as_paranoid
  audited

  has_many :substance_statutes
  has_many :classification_amendments, -> { joins('LEFT JOIN statutes ON statutes.id=substance_classifications.id').order('statutes.start_date ASC') }, { foreign_key: :parent_id, inverse_of: :substance_classification }
  belongs_to :statute, inverse_of: :substance_classifications

  def substances
    substance_statutes.map { |ss| ss.substance }.uniq.sort { |a,b| a.name <=> b.name }
  end

  def to_s
    if schedule_level
      "#{name} (#{ScheduleLevelsController::LEVELS.keys[@level - 1]})"
    else
      name
    end
  end
end
