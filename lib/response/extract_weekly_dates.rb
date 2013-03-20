require_relative 'timezone_helper'
module ExtractWeeklyDates
  def extract_start_at(start_date)
    DateTime.parse(start_date).to_local_timezone.strftime
  end

  def extract_end_at(end_date)
    (DateTime.parse(end_date)+1).to_local_timezone.strftime
  end
end