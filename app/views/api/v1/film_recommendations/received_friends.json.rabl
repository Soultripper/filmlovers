object false

extends 'api/v1/shared/header'
node :film_recommendations do
  @results.map do |user|
    friend_presenter = present(user, UserPresenter)
    {
      friend:{
        id: user.id,
        username: friend_presenter.username,
        friend_url: api_v1_user_path(user.id),
        avator_uri: friend_presenter.avatar_url,
      },
      recommendations: 
        current_user.recommended_films.includes(:film).where(user_id: user.id).map do |recommendation|
          presenter = present(recommendation.film, FilmPresenter)
          {
            id: recommendation.id,
            title: presenter.title,
            poster: presenter.poster_uri,
            release_date: presenter.release_date,
            comment: recommendation.comment,
            status: recommendation.state,
            approve: change_api_v1_film_recommendation_path(recommendation, 'approve'),
            hide: change_api_v1_film_recommendation_path(recommendation, 'hide'),            
            providers: presenter.film.providers.apple.map do |p|
            {
              id: p.id,
              name: p.name,
              link: p.aff_link,
              rating: p.rating
            }
            end,
          }
        end  
      }
  end
end