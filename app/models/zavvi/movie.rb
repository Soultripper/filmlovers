module Zavvi
  class Movie
    include Mongoid::Document
    include Mongoid::Timestamps

    field :_id, type: Integer
    field :title_director, type: String



    def self.with_director
      ne(model_number: "")
    end

    def self.set_title_director_keys
      with_director.each {|m| m.update_attribute :title_director, m.title_director_key}
    end

    def id
      self['aw_product_id']
    end


    def film
      return unless @film = find_film
      @film.add_provider(self)
      @film
    end

    def find_film
      Film.where(title_director: title_director).first
    end


    def title
      self['product_name']
    end

    def directors_name
      self['model_number']
    end


    def title_director_key
      "#{title}__#{directors_name}".parameterize
    end

    def year

    end

    def link
      self['aw_deep_link']
    end

    def rating
      0
    end

    def release_date
    end

    def poster
      self['aw_image_url']
    end

    def genres
      {}
    end
  
    def release_date_country
    end

    def trailer
    end

    def classification
      nil
    end

    def set_film_provider!
      film.update_film_provider self
    end


  end
end