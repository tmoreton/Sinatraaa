require 'sinatra'
require 'stripe'

set :publishable_key, ENV['PUBLISHABLE_KEY']
set :secret_key, ENV['SECRET_KEY']

Stripe.api_key = settings.secret_key

before do
  headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Headers'] = 'accept, authorization, origin'
  headers['Access-Control-Allow-Credentials'] = 'true'
end

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
	# response['Access-Control-Allow-Origin'] = 'http://tmoreton.github.io'
	redirect "http://tmoreton.github.io/ThinkBoldDesign?success"
end