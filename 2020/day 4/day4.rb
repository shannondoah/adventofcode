class PasswordValidator
  REQUIRED = {
    byr: { regex: /byr:(\d{4})\b/, min: 1920, max: 2002 },
    iyr: { regex: /iyr:(\d{4})\b/, min: 2010, max: 2020 },
    eyr: { regex: /eyr:(\d{4})\b/, min: 2020, max: 2030 },
    hgt: { regex: /hgt:(\d{2,3})(cm|in)\b/, min: [150, 59], max: [193, 76] },
    hcl: { regex: /hcl:#[0-9a-f]{6}\b/ },
    ecl: { regex: /ecl:(?:amb|blu|brn|gry|grn|hzl|oth)\b/ },
    pid: { regex: /pid:\d{9}\b/ }
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
    REQUIRED.all? do |field, rules|
      return false unless (match = passport.match(rules[:regex]))

      if match.size == 1
        true
      elsif match.size == 2
        match[1].to_i.between?(rules[:min], rules[:max])
      elsif match[2] == "cm"
        match[1].to_i.between?(rules[:min][0], rules[:max][0])
      else
        match[1].to_i.between?(rules[:min][1], rules[:max][1])
      end
    end
  end
end

passports = File.read(File.expand_path('input.txt', File.dirname(__FILE__))).split("\n\n")

puts passports.count { |pp| PasswordValidator.check(pp) }
