module RecrawlTime
  # Calculate the next time data should be rescraped
  def calculate_next_rescrape(recrawl_frequency, recrawl_interval)
    if recrawl_frequency == "once"
      return nil
    else
      return Time.now+(eval("1.#{recrawl_interval}")/recrawl_frequency.to_i)
    end
  end

  # Update the term recrawl time
  def update_recrawl_time(selector)
    next_rescrape = calculate_next_rescrape(selector.recrawl_frequency, selector.recrawl_interval)
    selector.update_attributes({next_recrawl_time: next_rescrape})
    selector.save
  end
end
