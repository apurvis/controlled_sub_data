class StatuteSearchesController < ApplicationController
  before_action :authenticate_user!

  def index
    @substance_name_id_map = Substance.all.map { |s| [s.name[0..70], s.id] }
    @substance_name_id_map += SubstanceAlternateName.where('substance_statute_id IS NOT NULL').all.map { |san| [san.name, san.substance_statute.substance_id] }
    @substance_name_id_map.sort! { |a,b| a[0] <=> b[0] }
  end
end
