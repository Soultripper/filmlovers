class FilmPresenter
  extend Forwardable

  attr_reader :user, :film, :thumbnail_size

  def_delegators :film, :title, :has_poster?, :id, :has_backdrop?, :has_trailer?, :overview, :score

  def initialize(user, film, thumbnail_size='w185')
    @user, @film, @thumbnail_size = user, film, thumbnail_size
  end
  
  def self.from_films(user, film_ids)
    Film.find(film_ids).map {|film| FilmPresenter.new user, film } if !film_ids.empty?
  end

  def actioned?(action)
    return false unless user
    user.film_actioned? film, action
  end

  def stats(action)
    film.users[action].count
  end

  def thumbnail(size='w154')
    size = size ? size : 'w154'
    has_poster? ? film.poster(size ? size : thumbnail_size) : "http://placehold.it/#{size.slice(1..-1)}&text=#{film.title}"
  end

  def backdrop(size='original')
    film.backdrop(size)
  end

  def release_date
    film.release_date ? "#{Date.parse(film.release_date).year}" : ''
  end

  def director
    @director ||= film.credits.crew.find {|member| member['job']=='Director'}
    @director ? @director['name'] : ''
  end

  def year
    @year ||= (Date.parse(film.release_date).year if film.release_date)
  end

  def similar_films?
    film.similar_movies
  end

  def similar_films
    return unless similar_films?
    film.similar_movies['results'].compact.map {|f| FilmPresenter.new user, Film.new(f), 'w92'}
  end
end