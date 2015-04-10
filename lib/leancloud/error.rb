# -*- encoding : utf-8 -*-
module AV

  # Base exception class for errors thrown by the Parse
  # client library. AVError will be raised by any
  # network operation if AV.init() has not been called.
  class AVError < StandardError #Exception ... why? A:http://www.skorks.com/2009/09/ruby-exceptions-and-exception-handling/
  end

  # An exception class raised when the REST API returns an error.
  # The error code and message will be parsed out of the HTTP response,
  # which is also included in the response attribute.
  class AVProtocolError < AVError
    attr_accessor :code
    attr_accessor :error
    attr_accessor :response
    attr_accessor :http_status_code

    def initialize(response)
      @response = response
      if response
        @code   = response["code"]
        @error  = response["error"]
        @http_status_code = response["http_status_code"]
      end

      super("#{@code}: #{@error}")
    end

    def to_s
      @message || super
    end

    def message=(msg)
      @message = msg
    end
  end

  class AVProtocolRetry < AVProtocolError
  end

end
