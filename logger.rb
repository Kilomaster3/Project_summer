class Logger

	def self.log(contener,message)
		p message
    contener.each { |item| p item }
	end
end