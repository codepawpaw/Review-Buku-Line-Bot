class BookController < ApplicationController
  require 'rest-client'
  require 'nokogiri'

  # GET /books
  def index
  	if !params[:title] && !params[:isbn]
  		return json_response([])
  	end

  	if params[:title]
	  	param = CGI.escape(params[:title])
	 end

	if params[:isbn]
		param = CGI.escape(params[:isbn])
	end

	@books = []

	#NOTE! this is example api for getting reviews count
	#https://www.goodreads.com/book/review_counts.json?key={apikey}&isbns=0596009208,0596517742

	url = "https://www.goodreads.com/search/index.xml?key=hfQfAv9UN6tjGlTMKj0qtw&q=" + param
	response = RestClient.get url

	doc = Nokogiri::XML(response)
    doc.search('//work').each do |element|
    	book_detail = element.at('best_book')
    	book = {
    		:id => element.at('id').text,
    		:publication_year => element.at('original_publication_year').text,
    		:rating => element.at('average_rating').text,
    		:ratings_count => element.at('ratings_count').text,
    		:title => book_detail.at('title').text,
    		:author => book_detail.at('author').at('name').text,
    		:image_url => book_detail.at('image_url').text
    	}
		@books << book
	end

	json_response(@books)

  end

end
