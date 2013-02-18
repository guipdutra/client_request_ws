require 'rubygems'
require 'savon'


module DSMNRequest
  
  
  WSDL_URL  = 'xXx'


  class EnvelopeCreator

    def initialize(operation)
      @operation = operation
      @items = []

      @subscriber = {
        :subscriberID => 0,
        :item => @items
      }

      @request = {
        :requestID => 0,
        :operation => @operation,
        :subscriber => @subscriber
      }

    end

    def product_name(value)
      @request[:product_name] = value
      self
    end

    def and(key)
      @items << {:key => key}
      self
    end

    def is(value)
      @items.last[:value] = value
      self
    end
 
    def to_envelope
      @request
    end


    def please
      envelope = {
        :request => self.to_envelope
      }

      client = Savon.client(wsdl: WSDL_URL, log: false)
      response = client.call(:dsmn_request, message: envelope)
      add_method_to_response(response)

      response
    end


    private
    def add_method_to_response(response)
      response.define_singleton_method(:was_ok?) do
        result = body[:dsmn_response][:response][:result]
        if result.is_a?(Array)
          envelope = result.first[:item].first  
        else
          envelope = result[:item].first  
        end
        
        not envelope.has_value?("errorCode")
      end
    end

  end
end

module DSMNRequestHelpers
  def call(operation)
    DSMNRequest::EnvelopeCreator.new(operation)
  end
end





