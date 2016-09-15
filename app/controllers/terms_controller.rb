require 'pry'

class TermsController < ApplicationController
  include TagGen
  include SaveData
  include CollectData
  include UpdateColselec
  include SaveColselec
  
  def destroy
    @term = Term.find(params[:id])
    @dataset = @term.dataset
    remove_renum_dataset

    # Destroy associated data items
    i = IndexData.new
    i.delay.remove_item_elastic(@term.dataitems)
    @term.dataitems.delay.each{|d| d.delete}

    respond_to do |format|
      if @term.destroy
        format.html{redirect_to @dataset, notice: 'Selector was successfully deleted.'}
      end
    end
  end

  # Recrawls a single item
  def recrawl
    @term = Term.find(params[:selector])
    @dataset = @term.dataset
    scrape_selector(@term, @dataset.source, @dataset)
    redirect_to @dataset, notice: 'Selector was successfully recrawled'
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
