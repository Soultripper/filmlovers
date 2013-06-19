namespace :tmdb do

  


  task :poll, [:page_no] => :environment do |t, args|
    @tmdb_films = Filmlovers::TmdbFilmsSearch.new

    if args[:page_no].nil?
      fetch_trend :now_playing
      fetch_trend :upcoming
    end
    fetch_trend :popular,  args[:page_no].to_i 
  end

  task :update_changes, [:start_date, :page_no] => :environment do |t, args|
    start_date = args[:start_date] ? eval(args[:start_date]) : 3.days.ago
    fetch_changed_movies start_date, (args[:page_no] || 1).to_i
  end

  task :fetch_all, [:starting_id] => :environment do |t, args|
    AdminConfig.instance.update_attribute(:fetched_index, args[:starting_id].to_i) if args[:starting_id].to_i > 0
    AdminConfig.fetch_all
  end

  def fetch_trend(trend, page=1)
    results_page = @tmdb_films.by_trend trend, {page: page}
    fetch_films results_page

    while results_page.more_pages? do
      results_page = @tmdb_films.by_trend trend, {page: page+=1}
      fetch_films results_page
    end
  end

  def fetch_changed_movies(start_date, page_no)
    results_page = tmdb_results(start_date, page_no) 
    fetch_films(results_page, true)
    while results_page.more_pages? do
      results_page = tmdb_results(start_date, page_no+=1) 
      fetch_films results_page, true
    end
  end

  def tmdb_results(start_date, page_no)
    results = Tmdb::API.changes :movie, {start_date: start_date, end_date: Time.now, page: page_no}
    ResultsPage.new results['results'], results['total_results'], 100, page_no
  end

  def fetch_films(results_page, force=false)
    Log.debug "Page #{results_page.page_no} of #{results_page.total_pages}"
    index = 1
    results_page.results.each do |film_id| 
      begin
        film = force ?  Film.force_fetch(film_id['id']) : Film.fetch(film_id.id)
        Log.debug "Film #{index} of #{results_page.results.count}: #{film.title}"
      rescue
         Log.debug "Film #{film_id} failed"
      end
      index+=1
    end
  end

  # def force_fetch_films(results_page)
  #   Log.debug "Page #{results_page.page_no} of #{results_page.total_pages}"

  #   index = 0
  #   results_page.results.each do |film_id| 
  #     begin
  #       film = Film.force_fetch film_id['id']
  #       Log.debug "Film #{index} of #{results_page.results.count}: #{film.title}"
  #     rescue
  #        Log.debug "Film #{film_id['id']} failed"
  #     end
  #     index+=1
  #   end
  # end


end