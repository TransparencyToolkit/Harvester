module ScheduleRecrawl
  # Save recrawl_frequency, recrawl_interval, next_recrawl_time
  def save_rescrape_info(collection, selector_list, recrawl_frequency, recrawl_interval)
    # Save frequency and interval for dataset
    collection.update_attributes({recrawl_frequency: recrawl_frequency, recrawl_interval: recrawl_interval})
    collection.save

    # Get next rescrape time
    next_recrawl_time = calculate_next_rescrape(recrawl_frequency, recrawl_interval)
    
    # Loop through items and set recrawl frequency, interval, and next rescrape time
    selector_list.each do |r|
      r.update_attributes({recrawl_frequency: recrawl_frequency,
                           recrawl_interval: recrawl_interval,
                           next_recrawl_time: next_recrawl_time
                          })
      r.save
    end
  end

  # Calculate the next time data should be rescraped
  def calculate_next_rescrape(recrawl_frequency, recrawl_interval)
    if recrawl_frequency == "once"
      return nil
    else
      return Time.now+(eval("1.#{recrawl_interval}")/recrawl_frequency.to_i)
    end
  end
end
