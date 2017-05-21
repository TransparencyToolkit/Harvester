class ApplicationController < ActionController::Base
  before_action :load_crawlers
  private
  def load_crawlers
    @crawlers = JSON.parse(Curl.get('http://0.0.0.0:9506/list_crawlers').body_str)
  end
end
