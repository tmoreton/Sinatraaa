require 'sinatra'
require 'stripe'

set :publishable_key, ENV['PUBLISHABLE_KEY']
set :secret_key, ENV['SECRET_KEY']

Stripe.api_key = settings.secret_key

get '/' do
  erb :index
end

post '/charge' do
  @amount = params[:amount]

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

  redirect "http://tmoreton.github.io/ThinkBoldDesign?success"
end

post '/contact' do
  Pony.mail :to => 'tmoreton89@gmail.com',
            :from => params[:email],
            :subject => params[:subject],
            :message => params[:message]
end