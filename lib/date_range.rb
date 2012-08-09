module DateRange

  def DateRange.get_last_week(date)
    last_saturday = date - (date.wday + 1)
    sunday_before = last_saturday-6

    (sunday_before..last_saturday)
  end
end