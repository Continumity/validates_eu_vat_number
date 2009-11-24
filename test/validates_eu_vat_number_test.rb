require 'test_helper'
require 'validates_eu_vat_number'

class ValidatesEUVatNumberTest < ActiveSupport::TestCase
  VALID_VAT = 'ATU12345678'

  def test_invalid_number
		assert_equal ValidatesEUVatNumber::validate('ATU11111111'), [ :invalid ]
  end

  def test_invalid_number_format
		assert_equal ValidatesEUVatNumber::validate('FORMAT_INVALID'), [ :invalid ]
  end
  
	def test_valid_number_without_requester
		assert_equal ValidatesEUVatNumber::validate(VALID_VAT), nil
  end

	def test_valid_number_with_invalid_requester
		assert_equal ValidatesEUVatNumber::validate(VALID_VAT, :requester => 'ATINVALID'), [ :invalid ]
  end

	def test_valid_number_with_valid_requester
		assert_equal ValidatesEUVatNumber::validate(VALID_VAT, :requester => VALID_VAT), nil
  end
end

