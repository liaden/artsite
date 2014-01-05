#encoding: utf-8
class AddAriststatementArticle < ActiveRecord::Migration
  def up
    Article.create :title => :artist_statement, :content => '<p>When I was ten years old, I received my first radio cassette player for Christmas. I remember spending a lot of time listening to various stations and recording my favorite songs as they would pop up. I recorded everything from Alice in Chains to Cher. Since then, I’ve made mixtapes and playlists for the most mundane and excellent moments of my life.. selecting songs from a wide variety of genres, artists, and languages.<p>

<p>My artwork is essentially a personal, visual mixtape of emotions, events, and pop culture interpretations. It is typically grounded in portraiture that extends into the realms of fantasy and science fiction. I enjoy creating portraits that give “flesh” to the moments of my life and the world around me. My work is a visual diary that is always leading me back to myself regardless of where I go, who I meet, and what happens around me.</p>

<p>Moreover, it is my way of saying, “Hello,” to a world of people I haven’t met and may never meet. Because emotions, facial expressions, and many symbols are universal, it is my hope that my work may bring comfort when it would be helpful, and that it may be thought-provoking when necessary.</p>'
  end

  def down
    Article.first.destroy
  end
end
