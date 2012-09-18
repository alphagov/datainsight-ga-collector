module ExtractWeeklyDates
  def extract_start_at(start_date)
    DateTime.parse(start_date).strftime
  end

  def extract_end_at(end_date)
    (DateTime.parse(end_date)+1).strftime
  end
end