FROM ruby:2.3.3
#
RUN apt-get update && apt-get install -y \
#Packages
net-tools \
nodejs

#Install gems
RUN mkdir /app
WORKDIR /app
COPY Gemfile* /app/
RUN bundle install

#Upload source
COPY . /app
RUN useradd ruby
RUN chown -R ruby /app
USER ruby

# Database defaults Replace these in Rancher.
ENV DATABASE_NAME user
ENV DATABASE_HOST host
ENV DATABASE_USER user
ENV DATABASE_PASSWORD pass

# Start server
ENV RAILS_ENV production
ENV RACK_ENV production
ENV SECRET_KEY_BASE secret
ENV PORT 3000
EXPOSE 3000


CMD ["sh", "start.sh"]
