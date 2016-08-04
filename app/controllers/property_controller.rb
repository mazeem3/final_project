class PropertyController < ApplicationController
    require 'rubygems'
    require 'rillow'
    require 'pp'

    def search
        rillow = Rillow.new'X1-ZWz19n208o61hn_8xo7s'
        result_nasty = rillow.get_search_results('2114 Bigelow Ave', 'Seattle, WA')
        result = result_nasty.to_hash
        @results = pp result
    end
    def show
      search
    end
end
