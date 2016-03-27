require 'pry'

class TermController < ApplicationController
  def create
    @term = Term.new(term_params)
  end

  private

  def term_params
    params.permit!
  end
end
