class Audited::Adapters::ActiveRecord::Audit
  belongs_to :user
  serialize :audited_changes

  def change_string
    if action == 'update'
      audited_changes.keys.map do |k|
        "<strong>old #{k}</strong>: #{audited_changes[k][0]}<br /><strong>new #{k}</strong>: #{audited_changes[k][1]}"
      end.join("<br /><br />")
    else
      audited_changes.to_s
    end
  end

  def audited_object
    auditable_type.safe_constantize.with_deleted.where(id: auditable_id).first
  end
end
