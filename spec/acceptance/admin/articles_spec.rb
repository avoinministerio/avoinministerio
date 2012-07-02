#encoding: utf-8

require "acceptance/acceptance_helper"

feature "Articles" do
  let (:idea) {
    Factory :idea
  }
  describe "PUT /articles" do
    before do
      @author = create_citizen
      create_logged_in_administrator
      visit administrator_root_path
      click_link "Artikkelit"
      
      current_path.should == admin_articles_path
    end
    it "creates a blog post" do      
      click_link "Uusi artikkeli"
      
      current_path.should == new_admin_article_path
      
      select "blog", :from => "Artikkelin tyyppi"
      fill_in "Otsikko", :with => "Ensimmäinen kansalaisaloite mennyt läpi"
      fill_in "Johdanto", :with => "Ensimmäisen kerran kansalaisaloite on saavuttanut 50 000 allekirjoituksen rajan."
      fill_in "Teksti", :with => "Läpi päässyt aloite ehdottaa automaattisten päänrapsuttimien tekemistä pakollisiksi."
      fill_in "Kirjoittaja (nimi tai sähköpostiosoite)",
        :with => @author.profile.name
      select "", :from => "Idea"
      click_button "Luo Artikkeli"
      
      current_path.should == admin_articles_path
      page.should have_content "Ensimmäinen kansalaisaloite mennyt läpi"
    end
    it "creates a statement" do
      idea
      click_link "Uusi artikkeli"
      
      current_path.should == new_admin_article_path
      
      select "statement", :from => "Artikkelin tyyppi"
      fill_in "Otsikko", :with => "Pakkoruotsi voidaan poistaa tavallisen lain säätämisjärjestyksessä"
      fill_in "Johdanto", :with => "Pakkoruotsin poistaminen ei edellytä Suomen muuttamista yksikieliseksi maaksi."
      fill_in "Teksti", :with => "Esimerkiksi Kanada on kaksikielinen maa, jossa ranska ei ole pakollinen oppiaine."
      fill_in "Kirjoittaja (nimi tai sähköpostiosoite)",
        :with => @author.profile.name
      select idea.title, :from => "Idea"
      click_button "Luo Artikkeli"
      
      current_path.should == admin_articles_path
      page.should have_content "Pakkoruotsi voidaan poistaa tavallisen lain säätämisjärjestyksessä"
    end
  end
end