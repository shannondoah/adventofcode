class PasswordValidator
  REQUIRED = {
    hcl: ->(pp) { pp.match? /hcl:#[0-9a-f]{6}\b/ },
    ecl: ->(pp) { pp.match? /ecl:(?:amb|blu|brn|gry|grn|hzl|oth)\b/ },
    pid: ->(pp) { pp.match? /pid:\d{9}\b/ },
    byr: ->(pp) { pp.match(/byr:(\d{4})\b/)&.captures[0]&.to_i&.between?(1920, 2002) },
    iyr: ->(pp) { pp.match(/iyr:(\d{4})\b/)&.captures[0]&.to_i&.between?(2010, 2020) },
    eyr: ->(pp) { pp.match(/eyr:(\d{4})\b/)&.captures[0]&.to_i&.between?(2020, 2030) },
    hgt: ->(pp) do
      match = pp.match(/hgt:(?<hgt>\d{2,3})(?<unit>cm|in)\b/)
      match && match[:hgt].to_i.between?(*(match[:unit] == "cm" ? [150, 193] : [59, 76]))
    end
  }

  OPTIONAL = "cid"

  attr_reader :passport

  def self.check(passport)
    new(passport).check
  end

  def initialize(passport)
    @passport = passport
  end

  def check
    return false if REQUIRED.keys.any? { |field| !passport.match?(field.to_s) }

    check_harder
  end

  def check_harder
    REQUIRED.all? { |field, validator| instance_exec(passport, &validator) }
  end
end

passports = File.read(File.expand_path('input.txt', File.dirname(__FILE__))).split("\n\n")

puts passports.count { |pp| PasswordValidator.check(pp) }
