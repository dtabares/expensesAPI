require 'rubygems'
require 'sinatra'
require 'data_mapper'
require File.dirname(__FILE__) + '/models.rb'
require 'json'
require 'date'

use Rack::Logger


before do
    content_type :json
    headers 'Access-Control-Allow-Origin' => '*',
            'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST', 'PUT', 'DELETE'],
            'Access-Control-Allow-Headers' => ['X-Requested-With', 'accept', 'Content-Type']
end

set :protection, false

get "/expenses" do
    @expenses = Expense.all
    @expenses.to_json
end

options '/expenses/new' do
    200
end

post "/expenses/new" do
    #content_type :json
    begin
      params.merge! JSON.parse(request.env["rack.input"].read)
    rescue JSON::ParserError
      logger.error "Cannot parse request body."
    end
    @expense = Expense.new
    @expense.date = DateTime.parse(params[:date])
    @expense.type = params[:type]
    @expense.subtype = params[:subtype]
    @expense.description = params[:description]
    @expense.value = params[:value]
    @expense.deleted = false
    if @expense.save
        @expenses = Expense.all
        {:expenses => @expenses, :status => "success"}.to_json
    else
        {:expense => @expense, :status => "failure"}.to_json
    end


end

put "/expenses/:id" do
    @expense = Expense.find(params[:id])
    @expense.date = DateTime.parse(params[:date])
    @expense.type = params[:type]
    @expense.subtype = params[:subtype]
    @expense.description = params[:description]
    @expense.value = params[value]
    if @expense.save
        {:expense => @expense, :status => "success"}.to_json
    else
        {:expense => @expense, :status => "failure"}.to_json
    end
end

delete "/expenses/:id" do
    @expense = Expense.find(params[:id])
    @expense.deleted = true
    if @expense.save
        {:expense => @expense, :status => "success"}.to_json
    else
        {:expense => @expense, :status => "failure"}.to_json
    end
end
