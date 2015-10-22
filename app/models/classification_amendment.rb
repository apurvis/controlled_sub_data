class ClassificationAmendment < SubstanceClassification
  belongs_to :substance_classification, { foreign_key: :parent_id, inverse_of: :classification_amendments }

  delegate :name, to: :substance_classification, allow_nil: true
end
