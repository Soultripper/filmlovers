class MongoFilm
  extend FilmScopes
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title,                 type: String
  field :classification,        type: String
  field :director,              type: String
  field :release_date,          type: Date
  field :release_date_country,  type: String
  field :fetched_at,            type: DateTime, default: nil
  field :poster,                type: String
  field :backdrop,              type: String
  field :trailer,               type: String
  field :genres,                type: Array
  field :popularity,            type: Float
  field :provider_id,           type: Integer
  field :provider,              type: String,   default: :tmdb
  field :title_director,        type: String

  # embeds_one :details, class_name: "FilmDetails", autobuild: true
  embeds_one  :counters,  class_name: "FilmCounters", autobuild: true
  has_many    :providers, class_name: 'FilmProvider'

  index({ release_date: -1 },           { unique: false, name: "film_release_date_index", background: true })
  index({ title: -1 },                  { unique: true,  name: "film_title_index", background: true })
  index({ genres: -1 },                 { unique: false, name: "film_genres_index", background: true })
  index({ popularity: -1 },             { unique: false, name: "film_popularity_index", background: true })
  index({ provider: 1, provider_id: 1}, { unique: true,  name: "provider_index", background: true })
  index({ title_director: -1 },         { unique: true,  name: "film_title_director_index", background: true })

  index({ 'counters.watched'=> -1 },    { unique: false, name: "film_counters_watched", background: true })
  index({ 'counters.loved'  => -1 },    { unique: false, name: "film_counters_loved", background: true })
  index({ 'counters.owned'  => -1 },    { unique: false, name: "film_counters_owned", background: true })

  def self.create_uuid(title, year)
    title = title.gsub("'","").parameterize
    "#{title}-#{year}"  if !title.empty?
  end


  # def self.find_or_create_from_provider(movie, create=true)
  #   film = find(movie.title_id) if movie.title_id
  #   film = if !film and create
  #     create_from(movie) unless movie.not_allowed?
  #   end
  #   return unless film
  #   film.add_provider(movie)
  #   film.provider_by(:Imdb, movie.imdb_id).save if movie.imdb_id?
  #   film
  # end

  def self.create_from(provider)
    Log.debug("Creating film '#{provider.title_id}' from provider '#{provider.identifier}-#{provider._id}'")
    film = create(
      id: provider.title_id, 
      fetched_at: Time.now.utc,
      title: provider.title,
      director: provider.directors_name,
      release_date: provider.release_date, 
      release_date_country: provider.release_date_country,
      poster: provider.poster, 
      genres: provider.genres,
      trailer: provider.trailer,
      popularity: provider.popularity,
      classification: provider.classification,
      provider_id: provider._id, 
      provider: provider.identifier,
      title_director: title_director_key) 
    film.counters.save
    film 
  rescue 
    Log.error "Could not create film of id: #{provider.id}, title_id: #{provider.title_id}"
  end


  def entries
    @entries ||= FilmEntry.where(film_id: self.id)
  end
 
  def details
    @details ||= "#{film_provider_class}::Movie".constantize.find provider_id
  end

  def details_presenter
    "#{film_provider_class}Presenter".constantize
  end

  def presenter
    details_presenter.new(self, details_presenter)
  end

  def entries_for(action)
    entries.find_by_action(action)
  end
  
  def year
    release_date.year if release_date
  end

  def score
    watched = actions_for(:watched).count
    return 0 unless watched > 0
    ((actions_for(:loved).count / watched) * 100).round(0)
  end

  def poster?
    poster
  end

  def trailer?
    trailer
  end

  def backrop?
    backrop
  end

  def has_provider?(name)
    providers.where(:name => name).exists?
  end

  def provider_by(identifier, id)
    providers.find_or_initialize_by name: identifier, id: id
  end

  def provider_for(identifier)
    providers.find_by name: identifier
  end

  def add_provider(movie)
    # return if has_provider? provider.identifier
    provider_by(movie.identifier, movie.id).tap do |film_provider|
      film_provider.link            = movie.link || film_provider.link
      film_provider.rating          = movie.rating || film_provider.rating
      film_provider.fetched_at      = Time.now.utc
      film_provider.save
    end    
    self
  end

  def title_director_key
    "#{title}__#{director}".parameterize
  end

  def set_release_date(date=nil, country)
    if date
      update_attributes!({
       release_date: date,
       release_date_country: country
      }) 
      Log.debug "Film #{id} release date set to #{date} for country #{country}"
    else
      Log.debug "No release date found for #{country}"
    end
    self
  end


  def film_provider_class
    provider.capitalize
  end

  def update_film_provider(film_provider)
    update_attributes!({
      fetched_at: Time.now.utc,
      popularity: film_provider.popularity,
      provider: film_provider.identifier, 
      provider_id: film_provider.id
    })
    notify_observers :film_details_updated
    self
  end

  def to_param
    id
  end

end

