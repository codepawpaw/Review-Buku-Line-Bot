From ruby:2.4.1-jessie

RUN mkdir /usr/src/bot-review-buku
COPY . /usr/src/bot-review-buku

WORKDIR /usr/src/bot-review-buku

RUN bundle update rails
RUN bundle install

CMD ["rails", "s"]
