class PropertyController < ApplicationController
    require 'rubygems'
    require 'rillow'
    require 'pp'

    before_action except: :show do
        redirect_to sign_in_path, alert: 'Please Sign In' if @current_user.nil?
    end

    before_action only: [:search, :show, :index] do
        search_google_places
    end

    def create
    end

    def search
        rillow = Rillow.new'X1-ZWz19n208o61hn_8xo7s'

        result = rillow.get_deep_search_results(@street, @city_state).to_hash

        # get the zillow id for initial location
        # test if it has results

        if result['response'].blank?
          flash[:notice] = 'No properties found'
          redirect_to root_path

        else
        zsearch = result['response'][0]['results'][0]['result'][0]

        latitude = zsearch['address'][0]['latitude']
        longitude = zsearch['address'][0]['longitude']
        prime_address = []
        prime_address << zsearch['address'][0]['street']
        prime_address << zsearch['address'][0]['city']
        prime_address << zsearch['address'][0]['zipcode']
        pa_bath = zsearch['bathrooms']
        pa_bed = zsearch['bedrooms']
        pa_price = zsearch['zestimate'][0]['amount'][0]['content']

        @prime_address = prime_address.join(', ')
        @pa_bath = pa_bath.join
        @pa_bed = pa_bed.join
        @pa_price = pa_price

        @prime_lon = longitude.join.to_f
        @prime_lat = latitude.join.to_f


        zpid = zsearch['zpid']
        puts zpid
        puts "^^^^^^^^^^^^^^^"
        @zpid = zpid.join(',')
        @addresses = []
        @zestimate = []
        @web_address = []
        # number of properties returned
        @num_search = 10
        # list properties near zpid
        list = rillow.get_comps(@zpid.to_s, @num_search)
        # get initial property details
        # add all returned location to array
        i = 0
        loop do
            @addresses << list['response'][0]['properties'][0]['comparables'][0]['comp'][i]['address']
            @zestimate << list['response'][0]['properties'][0]['comparables'][0]['comp'][i]['zestimate']
            @web_address << list['response'][0]['properties'][0]['comparables'][0]['comp'][i]['links'][0]["homedetails"][0]
            i += 1
            break if i == @num_search
        end
        # search results address
        x = 0
        @sr_address = []
        @add_lat = []
        @add_lng = []
        @sr_zestimate = []
        @sr_website = []

        loop do
            @sr_address[x] = @addresses[x][0]['street']
            @sr_address[x] << @addresses[x][0]['city']
            @sr_address[x] << @addresses[x][0]['state']
            @sr_address[x] << @addresses[x][0]['zipcode']
            @add_lat[x] = @addresses[x][0]['latitude']
            @add_lng[x] = @addresses[x][0]['longitude']
            @sr_zestimate[x] = @zestimate[x][0]['amount'][0]['content']
            @sr_website[x] = @web_address[x]
            x += 1
            break if x == @num_search
        end

        gon.add = @sr_address.collect { |i| i.join(', ') }
        gon.lat = @add_lat.collect { |i| i }
        gon.lng = @add_lng.collect { |i| i }
        gon.est = @sr_zestimate.collect(&:to_f)
        gon.web = @sr_website.collect { |i| i }
        end
    end

    def show
        search
    end

    def search_google_places
        place_id = params[:place_id] || 'ChIJXUPcIm6_QIYR9_qtbzRyy5w'
        puts place_id
        puts '========================='
        url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=#{place_id}&key=AIzaSyAjWDRMKvLrDwFxqutyccPKkJnn1PRg37g"

        json = JSON.parse(Http.get(url).body)
        puts '========================'
        street = []
        city_state = []
        subpremise = json['result']['address_components'][0]['types'][0]
        if subpremise == 'subpremise'
            street << json['result']['address_components'][1]['long_name']
            street << json['result']['address_components'][2]['long_name']
            city_state << json['result']['address_components'][4]['long_name']
            city_state << json['result']['address_components'][6]['long_name']
        else
            street << json['result']['address_components'][0]['long_name']
            street << json['result']['address_components'][1]['long_name']
            city_state << json['result']['address_components'][3]['long_name']
            city_state << json['result']['address_components'][5]['long_name']
        end
        puts @street
        puts @city_state

        @street = street.join(' ')
        @city_state = city_state.join(', ')
    end

    def index
        search
    end
end
