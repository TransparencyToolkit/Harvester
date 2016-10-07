class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
#  protect_from_forgery with: :exception
  include DataitemGen

  before_action :load_sources

  private

  # Load in all data sources
  def load_sources
    create_all_models
  end
end
