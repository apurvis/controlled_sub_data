class StatuteSearchesController < ApplicationController
  before_action :authenticate_user!

  def index
    @name_id_map = Substance.all.map { |s| [s.name[0..70], s.id] } + SubstanceAlternateName.all.map { |san| [san.name, san.substance_id] }
    @name_id_map.sort! { |a,b| a[0] <=> b[0] }
  end
end
