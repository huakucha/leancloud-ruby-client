require 'helper'

class TestCloud < LCTestCase
	# functions stored in test/cloud_functions/MyCloudCode
	# see https://parse.com/docs/cloud_code_guide to learn how to use LC Cloud Code
	#
	# LC.Cloud.define('trivial', function(request, response) {
  # 	response.success(request.params);
	# });

	def test_cloud_function_initialize
		assert_not_equal nil, LC::Cloud::Function.new("trivial")
	end

    def test_request_sms
      VCR.use_cassette('test_request_sms', :record => :new_episodes) do
        assert_equal (LC::Cloud.request_sms :mobilePhoneNumber => "186xxxxxxx",:op => "test",:ttl => 5), {}
        puts LC::Cloud.verify_sms_code('186xxxxxxx', '123456').inspect
      end
    end

	def test_cloud_function
		omit("this should automate the parse deploy command by committing that binary to the repo")

		VCR.use_cassette('test_cloud_function', :record => :new_episodes) do
			function = LC::Cloud::Function.new("trivial")
			params = {"foo" => "bar"}
			resp = function.call(params)
			assert_equal resp, params
		end
	end
end
