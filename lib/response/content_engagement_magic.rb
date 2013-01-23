module ContentEngagementMagic
  ENTRY_LABEL = "Entry"
  SUCCESS_LABEL = "Success"

  def collect_engagement_by_key(rows)
    weeks = { }
    rows.each do |key, action, value|
      weeks[key] ||= [0, 0]
      if action == ENTRY_LABEL
        weeks[key][0] += value.to_i
      elsif action == SUCCESS_LABEL
        weeks[key][1] += value.to_i
      else
        logger.warn { "Unrecognized action '#{action}' for key '#{key}'" }
      end
    end
    weeks.map(&:flatten)
  end

  def normalize_format(format, category_prefix)
    format.gsub(/^#{category_prefix}/, '')
  end
end