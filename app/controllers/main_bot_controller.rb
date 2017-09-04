class MainBotController < ApplicationController
	protect_from_forgery with: :null_session
	skip_before_filter  :verify_authenticity_token

	require 'sinatra'
	require 'line/bot'
	require 'rest-client'
  	require 'nokogiri'

	def client
	  @client ||= Line::Bot::Client.new { |config|
	    config.channel_secret = "57608b508df7cad2ba2b4f18440cf95e"
	    config.channel_token = "IkgWgy3zjhWfy0V7sF90RqC655An+TGB/kIHzK9YWe78V/dmbBbwdU3aFufvF4+RBK3c4gno7TPoP04IqhQgIQvkiwuaqyXBaARZC/M0lwDDo1BbosW4IKr+AZyxSCHP2B/8puctiyCdtTuWrbg8PQdB04t89/1O/w1cDnyilFU="
	  }
	end

	def index
	  # body = request.body.read

	  # signature = request.env['HTTP_X_LINE_SIGNATURE']
	  # unless client.validate_signature(body, signature)
	  #   error 400 do 'Bad Request' end
	  # end

	  # events = client.parse_events_from(body)
	  # events.each { |event|
	  #   case event
	  #   when Line::Bot::Event::Message

	  #     case event.type
	  #     when Line::Bot::Event::MessageType::Text
	  #       url = "https://www.goodreads.com/search/index.xml?key=hfQfAv9UN6tjGlTMKj0qtw&q=" + event.message['text']
			# response = RestClient.get url

			# doc = Nokogiri::XML(response)
		 #    doc.search('//work').each do |element|
		 #    	book_detail = element.at('best_book')
		 #    	book = {
		 #    		:id => element.at('id').text,
		 #    		:publication_year => element.at('original_publication_year').text,
		 #    		:rating => element.at('average_rating').text,
		 #    		:ratings_count => element.at('ratings_count').text,
		 #    		:title => book_detail.at('title').text,
		 #    		:author => book_detail.at('author').at('name').text,
		 #    		:image_url => book_detail.at('image_url').text
		 #    	}

			# 	message = {
		 #          type: 'text',
		 #          text: book[:rating]
			#     }
			#     client.reply_message(event['replyToken'], message)
			# end
			# message = {
		 #          type: 'text',
		 #          text: 'asd'
		 #    }
		 #    client.reply_message(event['replyToken'], message)

	  #     when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
	  #       response = client.get_message_content(event.message['id'])
	  #       tf = Tempfile.open("content")
	  #       tf.write(response.body)
	  #     end
	  #   end
	  # }

		  		url = "https://www.goodreads.com/search/index.xml?key=hfQfAv9UN6tjGlTMKj0qtw&q=of+mice+and+men"
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
			    	p book[:rating]
				end

	  json_response([])
	end

	def show
		p "show"
	end
end
