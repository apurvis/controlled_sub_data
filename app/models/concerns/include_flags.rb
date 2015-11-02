module IncludeFlags
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def available_flags
      column_names.select { |k| k =~ /^include_/ }.map(&:to_sym).sort
    end
  end

  def include_flags_string
    include_flags.map { |f| f.sub(/^include_/, '').humanize }.uniq.join(', ')
  end

  def has_include_flags?
    include_flags.size > 0
  end

  def include_flags(options = {})
    flags = self.attributes.select { |k,v| k =~ /^include_/ && v == true }.keys

    if self.is_a?(SubstanceStatute) &&
       substance_classification &&
       (options[:as_of].nil? || (substance_classification.statute && substance_classification.statute.start_date > options[:as_of].to_date))
      flags += substance_classification.include_flags
    elsif self.is_a?(SubstanceClassification)
      flags += classification_amendments.map do |ca|
        if options[:as_of].nil? || (ca.statute && ca.statute.start_date > options[:as_of].to_date)
          ca.include_flags
        else
          nil
        end
      end.flatten.compact
    end

    flags.sort
  end
end
