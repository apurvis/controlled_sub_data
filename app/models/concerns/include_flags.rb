module IncludeFlags
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
