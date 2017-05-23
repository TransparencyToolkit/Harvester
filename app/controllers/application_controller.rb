class ApplicationController < ActionController::Base
  include CrawlerManager
  before_action :load_crawlers
  private
  def load_crawlers
    @crawlers = JSON.parse(list_crawlers)
  end
end
