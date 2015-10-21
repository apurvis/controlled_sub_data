module IncludeFlags
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def available_flags
      column_names.select { |k| k =~ /^include_/ }.map(&:to_sym)
    end
  end

  def include_flags_string
    include_flags.map { |f| f.sub(/^include_/, '').humanize }.join(', ')
  end

  def has_include_flags?
    include_flags.size > 0
  end

  def include_flags
    self.attributes.select { |k,v| k =~ /^include_/ && v == true }.keys
  end
end
