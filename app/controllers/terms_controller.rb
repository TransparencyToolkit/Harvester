require 'pry'

class TermsController < ApplicationController
  include IndexData
  
  def destroy
    @term = Term.find(params[:id])
    @dataset = @term.dataset
    remove_renum_dataset

    # Destroy associated data items
    remove_item_elastic(@term.dataitems)
    @term.dataitems.each{|d| d.delete}

    respond_to do |format|
      if @term.destroy
        format.html{redirect_to @dataset, notice: 'Selector was successfully deleted.'}
      end
    end
  end

  private

  # Remove from input_query_fields and renumber others
  def remove_renum_dataset
    # Remove from input_query_fields
    @dataset.input_query_fields.delete(@term.selector_num)
    @dataset.save

    # Renumber other input_query_fields
    @dataset.input_query_fields=@dataset.input_query_fields.transform_keys{|k| k.to_i > @term.selector_num.to_i ? (k.to_i-1).to_s : k}
    @dataset.save
    
    # Renumber selector_num in terms
    @dataset.terms.each do |t|
      if t.selector_num.to_i > @term.selector_num.to_i
        t.selector_num = (t.selector_num.to_i-1).to_s
      end
      t.save
    end

    # Remove association with dataset
    @dataset.terms.delete(@term)
    @dataset.save
  end

  def term_params
    params.permit!
  end
end
