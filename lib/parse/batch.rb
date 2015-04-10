# -*- encoding : utf-8 -*-
module AV
  class Batch
    attr_reader :requests
    attr_reader :client

    def initialize(client = AV.client)
      @client = client
      @requests ||= []
    end

    def add_request(request)
      @requests << request
    end

    def create_object(object)
      method = "POST"
      path = AV::Protocol.class_uri(object.class_name)
      body = object.safe_hash
      add_request({
        "method" => method,
        "path" => path,
        "body" => body
      })
    end

    def update_object(object)
      method = "PUT"
      path = AV::Protocol.class_uri(object.class_name, object.id)
      body = object.safe_hash
      add_request({
        "method" => method,
        "path" => path,
        "body" => body
      })
    end

    def delete_object(object)
      add_request({
        "method" => "DELETE",
        "path" => AV::Protocol.class_uri(object.class_name, object.id)
      })
    end

    def run!
      uri = AV::Protocol.batch_request_uri
      body = {:requests => @requests}.to_json
      @client.request(uri, :post, body)
    end

  end

end
