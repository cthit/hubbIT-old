FROM ruby:2.5.1
#
RUN apt-get update && apt-get install -y \
#Packages
net-tools netcat

RUN apt-get clean

#Install gems
RUN mkdir /app
WORKDIR /app
COPY Gemfile* /app/
RUN bundle install

# Database defaults
ENV DATABASE_NAME hubbit_dev
ENV DATABASE_HOST 0.0.0.0
ENV DATABASE_USER hubbit
ENV DATABASE_PASSWORD iamapassword
ENV DATABASE_ADAPTER mysql2

ENV OAUTH_ID vwbTQzyjnYJIKuyfFpWqMofFVS6qyqDMaiyiqweUMgD8Ifo3PqmkmULGftUi6Soe3Sl3eMYvGUx
ENV OAUTH_SECRET gqNouiDZx1vjvlMkgzbo5kgSyQwJvA48q5vMCvwICWEbhuLqC5nAw4Kv8oh4slIINBXUnu8f4kf
ENV CLIENT_CREDENTIALS 26o[Dm@vpfV84]2)2s(&Jvh4GiX7H42[[v+tY=UGyQKj>iy8YTZcXg%7&=AbFd?+xS[#yTC6tYwR5n]X2$(H48fwDMvC=xj?or8(

# Start server
ENV RAILS_ENV development
ENV RACK_ENV development
ENV SECRET_KEY_BASE secret
ENV PORT 3001
EXPOSE 3001

#Upload source
COPY . /app
RUN useradd ruby
RUN chown -R ruby /app
USER ruby

CMD ["sh", "start.sh"]
