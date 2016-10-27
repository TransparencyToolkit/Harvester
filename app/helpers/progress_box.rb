module ProgressBox
  # Add message to array
  def append_message(collection, status_message)
    collection.pbox_messages = [] if collection.pbox_messages == nil
    collection.pbox_messages << ("<"+Time.now.to_s+"> "+status_message+"<br />")
    collection.save
  end

  # Print so that newer results are first
  def show_message(pbox_msg)
    outmsg = ""
    if pbox_msg
      pbox_msg.reverse.each do |m|
        outmsg += m
      end
    end
    return outmsg
  end
end
