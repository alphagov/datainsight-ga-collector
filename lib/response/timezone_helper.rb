class DateTime
  def to_local_timezone
    new_offset(TZInfo::Timezone.get("Europe/London").period_for_utc(self).utc_total_offset_rational)
  end
end
