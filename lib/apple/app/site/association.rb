# frozen_string_literal: true

require 'json'
require 'sinatra/base'

module Apple
  module App
    module Site
      class Association < Sinatra::Base
        class Config
          def initialize
            @apps = []
            @details = []
            @webcredentials = {}
          end

          def apps(*a)
            @apps.push(*a)
          end

          def details(*d)
            @details.push(*d)
          end

          def webcredentials(hash)
            @webcredentials.merge!(hash)
          end

          def to_json
            {
              applinks: {
                apps: @apps,
                details: @details,
                webcredentials: @webcredentials
              }
            }.to_json
          end
        end

        def self.config
          @config ||= Config.new
        end

        def self.configure
          yield(config) if block_given?
        end

        get '/apple-app-site-association' do
          content_type :json
          cache_control :public, :must_revalidate
          status 200
          self.class.config.to_json
        end
      end
    end
  end
end
