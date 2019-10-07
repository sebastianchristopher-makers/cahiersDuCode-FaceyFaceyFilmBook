class DateHelper
  def self.screen_date(json_date)
    d = DateTime.strptime(json_date, '%Y-%m-%dT%H:%M:%S%z')
    d.strftime('%a %d %b %Y %H:%M')
  end
end
