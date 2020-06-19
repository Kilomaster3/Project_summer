# frozen_string_literal: true

# This class is simple logger
class Logger
  def self.log(contener, message)
    p message
    contener.each { |item| p item }
  end

  def self.log_request_time(urls, responses)
    p 'Request time: '
    urls.each do |url|
      p "#{url} #{responses[url].total_time}"
    end
  end
end
