class CronParser

  attr_reader :cron_data

  def initialize(cron_data = %w(* * * * *))
    check_format(cron_data)
    @cron_data = cron_data
  end

  def can_run_now?
    return true if all_asterisk?
    time = Time.now
    ok_count = 0
    ok_count += 1 if check_cron_part(@cron_data[0], time.min)
    ok_count += 1 if check_cron_part(@cron_data[1], time.hour)
    ok_count += 1 if check_cron_part(@cron_data[2], time.day)
    ok_count += 1 if check_cron_part(@cron_data[3], time.mon)
    ok_count += 1 if check_cron_part(@cron_data[4], time.wday)
    if ok_count == 5
      true
    else
      false
    end
  end

  def cron_data=(cron_data)
    check_format(cron_data)
    @cron_data = cron_data
  end

  private

  def check_cron_part(cron_part, time_part)
    if cron_part == '*'
      true
    elsif is_number?(cron_part)
      check_exact_number(cron_part, time_part)
    elsif cron_part.include?(',') and not( cron_part.include?('-'))
      check_multiple_values(cron_part, time_part)
    elsif cron_part.include?('/')
      check_division(cron_part, time_part)
    elsif ( cron_part.include?('-') ) and not(cron_part.include?('/')) and not(cron_part.include?(','))
      check_range(cron_part, time_part)
    elsif ( cron_part.include?(',') ) and ( cron_part.include?('-'))
      check_multiple_values_with_ranges(cron_part, time_part)
    end
  end

  def all_asterisk?
    asterisk_count = 0
    @cron_data.each { |c| asterisk_count += 1 if c == '*' }
    if asterisk_count == 5
      true
    else
      false
    end
  end

  def check_exact_number(cron_part, time_part)
    if cron_part.to_i == time_part
      true
    else
      false
    end
  end

  def check_division(cron_part, time_part)
    if cron_part.include?('-')
      return false unless check_range(cron_part, time_part)
    end
    divider = cron_part.split('/')[1]
    if time_part.divmod(divider.to_i)[1] == 0
      true
    else
      false
    end
  end

  def check_range(cron_part, time_part)
    from, to = cron_part.split('-')
    if (time_part >= from.to_i) and (time_part <= to.to_i)
      true
    else
      false
    end
  end

  def check_multiple_values_with_ranges(cron_part, time_part)
    values = cron_part.split(',')
    values.each do |value|
      if value.include?('-')
        return true if check_range(value, time_part)
      elsif is_number?(value)
        return true if check_exact_number(value, time_part)
      elsif value.include?('/')
        return true if check_division(value, time_part)
      end
    end
    false
  end

  def check_multiple_values(cron_part, time_part)
    allowed_values = cron_part.split(',')
    if allowed_values.include?(time_part.to_s)
      true
    else
      false
    end
  end

  def check_format(cron_data)
    raise TypeError, 'You must give array with 5 elements' unless cron_data.length == 5
  end

  def is_number?(string)
    true if Float(string) rescue false
  end
end