module ScheduleRecrawl
  include CollectData
  include RecrawlTime
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

  # Check which terms need to be recrawled
  def check_recrawl
    need_recrawl = Term.all.select{|t| t.next_recrawl_time <= Time.now}

    # Recrawl each term
    need_recrawl.each do |t|
      loop_and_run(t.dataset.source, t.dataset, [t])
    end
  end
end
