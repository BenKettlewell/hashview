FROM ruby:2.3.3

EXPOSE 4567

# Base Tools
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev redis-server openssl apt-utils mysql-client 

# Tools to download and build Hashcat binaries
RUN apt-get install -y curl gcc make p7zip-full

# Drivers to run Hashcat
RUN apt-get install -y ocl-icd-libopencl1 ocl-icd-dev ocl-icd-opencl-dev 

# Setup Hashcat
RUN curl https://hashcat.net/files/hashcat-5.1.0.7z --output hashcat-5.1.0.7z 
RUN 7z x hashcat-5.1.0.7z 
RUN mv hashcat-5.1.0 /opt
RUN rm hashcat-5.1.0.7z

# Cleanup
RUN apt-get purge -y p7zip-full 

# Build app
RUN mkdir /src
WORKDIR /src
ADD Gemfile /src/Gemfile
ADD Gemfile.lock /src/Gemfile.lock
RUN gem install bundler
RUN bundle install
#ADD . /src

# Configuration
RUN export PATH="$PATH:$HOME/.rvm/bin"
