# config/initializers/stripe.rb

Rails.configuration.stripe = {
  publishable_key: ENV['pk_test_PIckIH8IvjCGq80edHBCU08I'],
  secret_key: ENV['sk_test_JQREcFqcTqOjBp4SfkVTjOQI']
  }

  Stripe.api_key = Rails.configuration.stripe[:secret_key]