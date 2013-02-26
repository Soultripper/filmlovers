object @films_page

attributes :description, :name, :id

node(:url) {|films_page| user_list_path( films_page.user, films_page.films_list)}
node(:edit_url) {|films_page| edit_user_list_path( films_page.user, films_page.films_list)}
node(:lists_url) {|films_page| user_lists_path( )}


node(:films) do |films_page|
  partial "films/film_summary", :object => films_page.films(@films_count)
end