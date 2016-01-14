class SubstanceClassification < ActiveRecord::Base
  include IncludeFlags

  acts_as_paranoid
  audited

  has_many :substance_statutes
  has_many :classification_amendments, -> { joins('LEFT JOIN statutes ON statutes.id=substance_classifications.statute_id').order('statutes.start_date ASC') }, { foreign_key: :parent_id, inverse_of: :substance_classification }
  belongs_to :statute, inverse_of: :substance_classifications

  delegate :state, to: :statute

  validates :name, uniqueness: { scope: [:schedule_level, :statute] }

  def substances
    substance_statutes.map { |ss| ss.substance }.uniq.sort { |a,b| a.name <=> b.name }
  end

  def to_s
    base_name = schedule_level ? "(#{ScheduleLevelsController::LEVELS.keys[schedule_level - 1]}) #{name}" : name
    base_name += " (#{state.upcase})" if statute
    base_name += " (Amended #{statute.start_date})" if self.is_a?(ClassificationAmendment) && statute
    base_name
  end
end
