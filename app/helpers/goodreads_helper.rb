module GoodreadsHelper
	require 'rest-client'
  	require 'nokogiri'

	def search(param)
		url = "https://www.goodreads.com/search/index.xml?key=hfQfAv9UN6tjGlTMKj0qtw&q=" + param
		response = RestClient.get url
		doc = Nokogiri::XML(response)
		return doc
	end

end