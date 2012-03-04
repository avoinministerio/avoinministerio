class CreateSlugsForExistingArticles < ActiveRecord::Migration
  def up
    Article.transaction {
      articles = Article.all
      puts "Updating slugs for #{articles.size} articles."
      articles.each do |article|
        article.save!
      end
      puts "Updated."
    }
  end

  def down
  end
end
