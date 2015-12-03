class DataitemController < ApplicationController
  def new
  end

  def create
    @dataitem = Dataitem.new(dataitem_params) # FIX PARAMS
  end

  private

  # Permit all
  def dataitem_params
    params.permit!
  end
end
