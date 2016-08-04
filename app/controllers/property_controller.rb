class PropertyController < ApplicationController
    require 'rubygems'
    require 'rillow'
    require 'pp'

    def search
        rillow = Rillow.new'X1-ZWz19n208o61hn_8xo7s'
        result_nasty = rillow.get_deep_search_results('417 Travis St', 'Houston, Tx')
        result = result_nasty.to_hash
        #get the zillow id fro loaction
        zpid = result["response"][0]["results"][0]["result"][0]["zpid"]
        @zpid = zpid.join(",")

        @result = result

        #list properties near zpid

        list = rillow.get_comps("#{@zpid}",1)
        puts "=============================================="
        @property_details = list["response"][0]["properties"][0]["principal"][0]["address"]
        @comp = list["response"][0]["properties"][0]["comparables"][0]["comp"][0]["address"]
        pp list

        @list = list

        puts "=============================================="

    end
    def show
      search
    end
end
