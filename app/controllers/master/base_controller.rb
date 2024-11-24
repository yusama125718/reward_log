class BaseController < ActionController::Master
  include Permission
  before_action: require_gm
end