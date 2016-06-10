require 'sinatra'
require 'stripe'

set :publishable_key, ENV['pk_test_OxISGD7GxGhZCOofus3QFoW8']
set :secret_key, ENV['sk_test_Cv1UxGFrtA7dBCrUWstCn5sA']

# Stripe.api_key = settings.secret_key
Stripe.api_key = 'sk_test_Cv1UxGFrtA7dBCrUWstCn5sA'

get '/' do
  erb :index
end

post '/charge' do
  @amount = 500

  customer = Stripe::Customer.create(
    :email => params[:email],
    :card  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => 'ThinkBoldDesign',
    :currency    => 'usd',
    :customer    => customer
  )

  redirect "http://tmoreton.github.io/ThinkBoldDesign/success.html"
end