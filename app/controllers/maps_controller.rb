class MapsController < ApplicationController
  def index
  end

  def results
  	@food = params[:food]
  	@location = params[:location]
  	parameters = { term: @food, limit: 9 }

  	@results = Yelp.client.search(@location, parameters)
  end

  def test
    parameters = { term: "pancakes", limit: 10 }

    @results = Yelp.client.search('Atlanta, GA', parameters)
  end

end
