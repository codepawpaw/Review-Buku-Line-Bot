class MainBotController < ApplicationController
	protect_from_forgery with: :null_session
	skip_before_filter  :verify_authenticity_token

	require 'sinatra'
	require 'line/bot'
	require 'rest-client'
  	require 'nokogiri'
  	require 'tempfile'

  	require "google/cloud/vision"

  	def vision
  	  @vision ||= Google::Cloud::Vision.new project: 'baca-pesat'
  	end

	def client
	  @client ||= Line::Bot::Client.new { |config|
	    config.channel_secret = "57608b508df7cad2ba2b4f18440cf95e"
	    config.channel_token = "IkgWgy3zjhWfy0V7sF90RqC655An+TGB/kIHzK9YWe78V/dmbBbwdU3aFufvF4+RBK3c4gno7TPoP04IqhQgIQvkiwuaqyXBaARZC/M0lwDDo1BbosW4IKr+AZyxSCHP2B/8puctiyCdtTuWrbg8PQdB04t89/1O/w1cDnyilFU="
	  }
	end

	def index
	  body = request.body.read

	  signature = request.env['HTTP_X_LINE_SIGNATURE']
	  unless client.validate_signature(body, signature)
	    error 400 do 'Bad Request' end
	  end

	  events = client.parse_events_from(body)

	  events.each { |event|

	      if event.type == Line::Bot::Event::MessageType::Text
	        url = "https://www.goodreads.com/search/index.xml?key=hfQfAv9UN6tjGlTMKj0qtw&q=" + event.message['text']
			response = RestClient.get url

			doc = Nokogiri::XML(response)
			@messages = []
			counter = 0
		    doc.search('//work').each do |element|
		    	p counter
		    	if counter > 6 then
		    		break
		    	end

		    	book_detail = element.at('best_book')
		    	book = {
		    		:id => element.at('id').text,
		    		:publication_year => element.at('original_publication_year').text,
		    		:rating => element.at('average_rating').text,
		    		:ratings_count => element.at('ratings_count').text,
		    		:title => book_detail.at('title').text,
		    		:author => book_detail.at('author').at('name').text,
		    		:image_url => book_detail.at('image_url').text,
		    		:small_image_url => book_detail.at('small_image_url').text
		    	}

		    	image_message = {
		    		type: 'image',
		    		originalContentUrl: book[:image_url],
		    		previewImageUrl: book[:image_url]
		    	}

		    	@messages << image_message

				text_message = {
		          type: 'text',
		          text: book[:title] + "\n" + "by " + book[:author] + "\n" + book[:rating] + " avg rating - " + book[:ratings_count] + "\n" + "publication year : " + book[:publication_year]
			    }

			    @messages << text_message
			    counter = counter + 1
			    
			end
			client.reply_message(event['replyToken'], @messages[0..3])
		  end

		  if event.type == Line::Bot::Event::MessageType::Image
		  	p event.message['id']
	        response = client.get_message_content(event.message['id'])

			case response
			when Net::HTTPSuccess then
			  p 'masuk mas'
			  binary_data = Base64.decode64(response.body)
			  f = File.open('image_line.png', 'wb') {|f| f.write(binary_data)}
			  p File.basename('./image_line.png')
			  p File.dirname('image_line.png')

			  image  = vision.image 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRafuUraaIa2npZ1GzxbJG0UJnXMY9fPf5JIqx0RKwKr70FnFetAw'

			  # puts image.text

			  p "end"
			else
			  p "#{response.code} #{response.body}"
			end

	        text_message = {
		        type: 'text',
		        text: 'image message'
			}
	        client.reply_message(event['replyToken'], text_message)
	      end
	  }

	  json_response([])
	end

	def show
		p "show"
	end
end
