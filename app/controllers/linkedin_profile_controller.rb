class LinkedinProfileController < ApplicationController
  def new
  end

  def create
    @linkedin_profile = LinkedinProfile.new(linkedin_profile_params)
  end
end
