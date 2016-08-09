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
        latitude = result['response'][0]['results'][0]['result'][0]['address'][0]["latitude"]
        longitude = result['response'][0]['results'][0]['result'][0]['address'][0]["longitude"]
        prime_address = []
        prime_address << result['response'][0]['results'][0]['result'][0]['address'][0]['street']
        prime_address << result['response'][0]['results'][0]['result'][0]['address'][0]['city']
        prime_address << result['response'][0]['results'][0]['result'][0]['address'][0]['zipcode']
        pa_bath = result['response'][0]['results'][0]['result'][0]['bathrooms']
        pa_bed = result['response'][0]['results'][0]['result'][0]['bedrooms']
        pa_price = result['response'][0]['results'][0]['result'][0]['zestimate'][0]['amount'][0]['content']

        @prime_address = prime_address.join(", ")
        @pa_bath = pa_bath.join
        @pa_bed = pa_bed.join
        @pa_price = pa_price

        @prime_lon = longitude.join.to_f
        @prime_lat = latitude.join.to_f




        zpid = result['response'][0]['results'][0]['result'][0]['zpid']
        @zpid = zpid.join(',')
        @addresses = []
        # number of properties returned
        num_search = 1
        # list properties near zpid
        list = rillow.get_comps(@zpid.to_s, num_search)
        # get initial property details
        @initial_details = list['response'][0]['properties'][0]['principal'][0]['address']
        # add all returned location to array
        i = 0
        loop do
            @addresses << list['response'][0]['properties'][0]['comparables'][0]['comp'][i]
            i += 1
            break if i == num_search
        end
        puts '==============================='
        pp @addresses.inspect

    end

    def show
        search
    end

    def index
      search
    end


end
