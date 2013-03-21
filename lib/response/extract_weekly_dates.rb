module ExtractWeeklyDates
  def extract_start_at(start_date)
    DateTime.parse(start_date).with_tz_offset("Europe/London").strftime
  end

  def extract_end_at(end_date)
    (DateTime.parse(end_date)+1).with_tz_offset("Europe/London").strftime
  end
end