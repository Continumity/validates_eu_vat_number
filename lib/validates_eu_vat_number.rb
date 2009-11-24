require 'net/http'
require 'uri'

module ValidatesEUVatNumber
	def self.validate(number, options = {})
		return [ :invalid ] unless number =~ /([a-z]{2})(\w{5,12})/i
		member_state = $~[1]
		vat = $~[2]

		params = { :ms => member_state, :iso => member_state, :vat => vat }
		if options[:requester] =~ /([a-z]{2})(\w{5,12})/i
			params[:requesterMs] = params[:requesterIso] = $~[1]
			params[:requesterVat] = $~[2]
		end

		response = Net::HTTP.post_form(URI.parse('http://ec.europa.eu/taxation_customs/vies/viesquer.do'), params)

		return [ :invalid ] if response.body =~ /(No, invalid|Error)/i
		nil
	end
end

module ActiveRecord
	module Validations
		module ClassMethods
			def validates_eu_vat_number(*attr_names)
				options = {	:on => :save }
				options.update(attr_names.extract_options!)

				validates_each(attr_names, options) do |record, attr_name, value|
					v = value.to_s
					errors = ValidatesEUVatNumber::validate(v, options)
					errors.each do |error|
						record.errors.add(attr_name, error)
					end unless errors.nil?
				end
			end
		end   
	end
end

