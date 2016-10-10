module IdGen
  # Get fields for ID
  def get_id_fields(source)
    id_fields = JSON.parse(Curl.get("http://0.0.0.0:9506/get_crawler_info?crawler="+source).body_str)["id_fields"]
    @primary_id_field = id_fields["primary_id_field"]
    @secondary_id_field = id_fields["secondary_id_field"]
    @get_id_after = id_fields["get_id_after"]
  end

  # Generate the ID
  def gen_id(dataitem, source)
    get_id_fields(source)
    id_initial = dataitem[@primary_id_field]
    clean_id = cleanID(removeIDPart(id_initial))
    return appendSecondary(clean_id, dataitem)
  end

  # Remove part of ID if needed
  def removeIDPart(id_initial)
    if @get_id_after != nil && !@get_id_after.empty?
      split_id = id_initial.split(@get_id_after)
      id_initial = split_id.length > 1 ? split_id[1] : split_id[0]
    end

    return id_initial
  end

  # Removes non-urlsafe chars from ID
  def cleanID(str)
    if str
      return str.gsub("/", "").gsub(" ", "").gsub(",", "").gsub(":", "").gsub(";", "").gsub("'", "").gsub(".", "")
    end
  end

  # Append secondary ID fields
  def appendSecondary(clean_id, item)
    if @secondary_id_field
      @secondary_id_field.each do |f|
        secondary_field = item[f]
        clean_id += cleanID(secondary_field.to_s) if secondary_field != nil
      end
    end
    return clean_id
  end
end
