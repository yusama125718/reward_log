class Master::MasterController < ApplicationController
  include Permission
  before_action :require_gm
  
  def index
  end
end
