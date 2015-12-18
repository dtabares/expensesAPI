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
            'Access-Control-Allow-Headers' => ['X-Requested-With', 'accept', 'Content-Type', 'application/json']
end

set :protection, false

get "/expenses" do
    @expenses = Expense.all(:deleted => false)
    @expenses.to_json
end

options '/expenses/new' do
    200
end

options "/expense" do
  200
end

options "/expense/edit" do
  200
end

options "/expense/delete" do
  200
end

post "/expenses/new" do
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
        @expenses = Expense.all(:deleted => false)
        {:expenses => @expenses, :status => "success"}.to_json
    else
        status 500
        body @expense.save.to_json
    end

end

put "/expense/edit" do
    begin
      params.merge! JSON.parse(request.env["rack.input"].read)
    rescue JSON::ParserError
      logger.error "Cannot parse request body."
    end
    @expense = Expense.get(params[:id])
    @expense.date = DateTime.parse(params[:date])
    @expense.type = params[:type]
    @expense.subtype = params[:subtype]
    @expense.description = params[:description]
    @expense.value = params[:value]
    if @expense.save
        @expenses = Expense.all(:deleted => false)
        {:expenses => @expenses, :status => "success"}.to_json
    else
        status 500
        body @expense.save.to_json
    end
end

put "/expense/delete" do
    begin
      params.merge! JSON.parse(request.env["rack.input"].read)
    rescue JSON::ParserError
      logger.error "Cannot parse request body."
    end
    @expense = Expense.get(params[:id])
    @expense.deleted = true
    if @expense.save
        @expenses = Expense.all(:deleted => false)
        {:expenses => @expenses, :status => "success"}.to_json
    else
        status 500
        body @expense.save.to_json
    end
end
