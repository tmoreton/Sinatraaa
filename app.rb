require 'sinatra'
require 'stripe'
require 'pony'

set :publishable_key, ENV['PUBLISHABLE_KEY']
set :secret_key, ENV['SECRET_KEY']

Stripe.api_key = settings.secret_key

before do
  headers['Access-Control-Allow-Methods'] = 'GET, POST'
  headers['Access-Control-Allow-Origin'] = '*'
  # headers['Access-Control-Allow-Headers'] = 'accept, authorization, origin'
  # headers['Access-Control-Allow-Credentials'] = 'true'
end

configure do
  Pony.options = {
    :from => "noreply@thinkBigDesign.com",
    :via => :smtp,
    :via_options => {
      :address => 'smtp.sendgrid.net',
      :port => '587',
      :domain => 'sinatraaa.herokuapp.com',
      :user_name => ENV['SENDGRID_USERNAME'],
      :password => ENV['SENDGRID_PASSWORD'],
      :authentication => :plain,
      :enable_starttls_auto => true
    }
  }
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
  @email = params[:email]
  @subject = params[:subject]
  @body = params[:message]

  begin
    Pony.mail(:to => 'tmoreton89@gmail.com', :from => @email, :subject => @subject, :body => @body)
  rescue => e
    puts e
  end

end