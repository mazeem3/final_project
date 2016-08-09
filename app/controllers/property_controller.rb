class PropertyController < ApplicationController
    require 'rubygems'
    require 'rillow'
    require 'pp'
    before_action except: :show do
        redirect_to sign_in_path, alert: 'Please Sign In' if @current_user.nil?
    end

    def create

    end

    def search

        rillow = Rillow.new'X1-ZWz19n208o61hn_8xo7s'
        result = rillow.get_deep_search_results('4203 Montrose Blvd', 'Houston, Tx').to_hash
        # get the zillow id for initial location
        zsearch = result['response'][0]['results'][0]['result'][0]

        latitude = zsearch['address'][0]["latitude"]
        longitude = zsearch['address'][0]["longitude"]
        prime_address = []
        prime_address << zsearch['address'][0]['street']
        prime_address << zsearch['address'][0]['city']
        prime_address << zsearch['address'][0]['zipcode']
        pa_bath = zsearch['bathrooms']
        pa_bed = zsearch['bedrooms']
        pa_price = zsearch['zestimate'][0]['amount'][0]['content']

        @prime_address = prime_address.join(", ")
        @pa_bath = pa_bath.join
        @pa_bed = pa_bed.join
        @pa_price = pa_price

        @prime_lon = longitude.join.to_f
        @prime_lat = latitude.join.to_f




        zpid = zsearch['zpid']
        @zpid = zpid.join(',')
        @addresses = []
        @zestimate = []
        # number of properties returned
        @num_search = 10
        # list properties near zpid
        list = rillow.get_comps(@zpid.to_s, @num_search)
        # get initial property details
        @initial_details = list['response'][0]['properties'][0]['principal'][0]['address']
        # add all returned location to array
        i = 0
        loop do
            @addresses << list['response'][0]['properties'][0]['comparables'][0]['comp'][i]['address']
            @zestimate << list['response'][0]['properties'][0]['comparables'][0]['comp'][i]['zestimate']
            i += 1
            break if i == @num_search
        end

        #search results address
        x = 0
        @sr_address= []
        @add_lat = []
        @add_lng = []
        @sr_zestimate = []
        loop do
          @sr_address[x] = @addresses[x][0]['street']
          @sr_address[x] << @addresses[x][0]['city']
          @sr_address[x] << @addresses[x][0]['state']
          @sr_address[x] << @addresses[x][0]['zipcode']
          @add_lat[x] = @addresses[x][0]['latitude']
          @add_lng[x] = @addresses[x][0]['longitude']
          @sr_zestimate[x] = @zestimate[x][0]['amount'][0]['content']
          x += 1
            break if x == @num_search
        end

        gon.add = @sr_address.collect{ |i| i.join(", ") }
        gon.lat = @add_lat.collect {|i| i}
        gon.lng = @add_lng.collect {|i| i}
        gon.est = @sr_zestimate.collect {|i| i.to_f}

    end

    def show
        search
    end

    def index
      search
    end


end
