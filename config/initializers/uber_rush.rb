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
      )["eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZXMiOltdLCJzdWIiOiJkZDU1NTI4Zi02ZTUyLTRhMGUtYTg3Ni1lNzNkODMzOWQwY2MiLCJpc3MiOiJ1YmVyLXVzMSIsImp0aSI6IjhiM2Q0NGMzLTk0YjAtNGQ0My1iOGI0LTVmODVjZTE1YWI5MCIsImV4cCI6MTQ5NDk2NzI0NiwiaWF0IjoxNDkyMzc1MjQ2LCJ1YWN0Ijoid1RTWHROSktibUV0M0tCVHhmR2k2bkNvalY0d2MzIiwibmJmIjoxNDkyMzc1MTU2LCJhdWQiOiJxNDRTbDJvR3lUU0VfcmMxVjFReTUyNTJveUJ3WnJOVCJ9.krRJ7jX3hIAufxq0CyxYUSEy8wSUtpqruF1ihWoLJJGnYXvT95zZt4gOn3nnKfLQNG0Qf0ZZNEd_ReqlF7jwPYwoOS27FjB79JFg4uI5zoD5Wv-9UM5gha5n24X4lzBcMgSTk9cjwp1c9Mvi8W8LaE_R1F0rsDh8V5w55-YzChFd5j27EQGio7xaJe0XUGHwjPHB-TdsPc9WtAkt1m_a1zq4NjxClDlkYde41ATo1GF5YA3Dabd8Qr_YD0DPLDT3xTzsapvc-YowMQHN2h3A7WTOsnBrGL8BRAjfGRYqmG0WQTgVAECEYc8iMhq10RdDqIY63xwL4ook74_hYPuPlg"]

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