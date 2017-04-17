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
          client_id: ENV['q44Sl2oGyTSE_rc1V1Qy5252oyBwZrNT'],
          client_secret: ENV['80wPYE04EYRzgYhMQnAZ5HIDslwHJY0WI_K6tcJM'],
          grant_type: 'client_credentials',
          scope: 'delivery'
        }
      )["eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZXMiOltdLCJzdWIiOiJkZDU1NTI4Zi02ZTUyLTRhMGUtYTg3Ni1lNzNkODMzOWQwY2MiLCJpc3MiOiJ1YmVyLXVzMSIsImp0aSI6Ijc5NDY0ZTIzLTZkZDgtNGFlMy05OTViLTRlNWE1NjM5ZmQwMiIsImV4cCI6MTQ5NTAzODUxNiwiaWF0IjoxNDkyNDQ2NTE2LCJ1YWN0IjoiZ1JBR3RmQm5oekp0ZkRja1NrTUNzYzNydTJ2cmUzIiwibmJmIjoxNDkyNDQ2NDI2LCJhdWQiOiJxNDRTbDJvR3lUU0VfcmMxVjFReTUyNTJveUJ3WnJOVCJ9.KxDOllAHTMci_KShRj4Kmv0HE5xV_4ALbGbVtgK6jpU0mWHGIjzsJtUglHDyNG7rAovvONQIYFOdyTHaasG9-QGHc1UgrMWYzmyCvQQvdJ7TlhAtA1RjJ3BVQBReBVxGwQs-xFncPD3pf_CQ1fyN_Xav5sH5KyltoU2bkumoVU-FYPi2qC2xOLlgk1OcwudiuSDB7An1rEk1StByW-7__n7FLS3z6ywUtNoH4snLkL_-4aD9yLhQaDVqxiIAjEytTe3LkNnIRNznFdv8_pOltmmQOb5NJwfuT0o6RfQ_7IUNBTz2FwThr6ku8cCh7pU05y7JNKi-gBF9ioQBj1A0Qg"]

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