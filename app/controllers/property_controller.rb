class PropertyController < ApplicationController
    require 'rubygems'
    require 'rillow'
    require 'pp'
    before_action except: :show do
        redirect_to sign_in_path, alert: 'Please Sign In' if @current_user.nil?
    end

    def search
        rillow = Rillow.new'X1-ZWz19n208o61hn_8xo7s'
        result = rillow.get_deep_search_results('2918 Brannon Hill Ln', 'Sugar Land, Tx').to_hash
        # get the zillow id for initial location
        zpid = result['response'][0]['results'][0]['result'][0]['zpid']
        @zpid = zpid.join(',')
        @addresses = []
        # number of properties returned
        num_search = 1

        # list properties near zpid

        list = rillow.get_comps(@zpid.to_s, num_search)
        puts '=============================================='
        # get initial property details
        @initial_details = list['response'][0]['properties'][0]['principal'][0]['address']
        # add all returned location to array
        i = 0
        loop do
            @addresses << list['response'][0]['properties'][0]['comparables'][0]['comp'][i]['address']
            i += 1
            break if i == num_search
        end

    end

    def show
        search
    end
end
