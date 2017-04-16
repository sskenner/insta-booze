# config/initializers/uber_rush.rb

module Uber
  # Default pickup location, for single-store implementations
  PICKUP =
    {
      location: {
        address: "462 1st Avenue",
        city: "New York",
        state: "New York",
        postal_code: "10016",
        country: "US"

      },
      contact: {
        company_name: "InstaBooze",
        email: "admin@instabooze.com",
        phone: {
          number: "+13476613311",
          sms_enabled: true
        }
      }
    }

  class RUSH
    include HTTParty
    attr_reader :base_path

    # Sandbox URI, Change to Production when Ready
    base_uri 'https://sandbox-api.uber.com/v1/deliveries'

    # Gets OAuth Token on new Instance
    def initialize
      url = "https://login.uber.com/oauth/v2/token"

      token = self.class.post(url,
        body: {
          client_id: ENV['uber_rush_client_id'],
          client_secret: ENV['uber_rush_client_secret'],
          grant_type: 'client_credentials',
          scope: 'delivery'
        }
      )["access_token"]

      @base_path = "?access_token=#{token}"
    end

    # Gets all deliveries on your account
    def get_deliveries
      url = "#{base_path}"
      self.class.get(url)
    end

    # Gets one specified delivery on your account
    def get_delivery(id)
      url = "/#{id}#{base_path}"
      self.class.get(url)
    end

    # Returns a delivery quote
    def create_quote(pickup_obj = Uber::PICKUP, dropoff_obj)
      url = "/quote#{base_path}"

      self.class.post(url,
        body: { pickup: pickup_obj, dropoff: dropoff_obj }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    # Creates a delivery and returns a delivery object
    def create_delivery(items_arr, pickup_obj = Uber::PICKUP, dropoff_obj)
      url = "#{base_path}"

      self.class.post(url,
        body: { items: items_arr, pickup: pickup_obj, dropoff: dropoff_obj }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    # Changes delivery status to client_canceled
    def cancel_delivery(id)
      url = "/#{id}/cancel#{base_path}"
      self.class.post(url)
    end
  end
end