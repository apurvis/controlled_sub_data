module RomanScheduleLevel
  LEVELS = {
    'I'   => 1,
    'II'  => 2,
    'III' => 3,
    'IV'  => 4,
    'V'   => 5,
    'VI'  => 6
  }

  def roman_schedule_level
    return nil unless schedule_level

    LEVELS.keys[schedule_level - 1]
  end
end
