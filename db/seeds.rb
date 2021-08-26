require 'csv'
require "open-uri"

filepath_exhib = "exhibitionslist.csv"
filepath_artworks = "artworks-sans-jpg.csv"

csv_options = { col_sep: ';', headers: :first_row, encoding:'iso-8859-1:utf-8' }

puts "Deleting all"
Artwork.delete_all
ExhibitionAuthor.delete_all
Author.delete_all
ExhibitionType.delete_all
User.delete_all
Type.delete_all
Exhibition.delete_all
Review.delete_all

puts "creating user"
user1 = User.create(email: 'axel@gmail.com', password: "1234567")
user1.save!
user2 = User.new(email: 'tristan@gmail.com', password: "1234567")
user2.save!
user3 = User.new(email: 'jean@gmail.com', password: "1234567")
user3.save!


CSV.foreach(filepath_exhib, csv_options) do |row|
  image = FastImage.size(row[33])
  if (image[0] || image[1]) > 2300
    puts "image is too big"
  else
    new_exhib = Exhibition.create(name: row[2],
                      start_date: row[8],
                      end_date: row[9],
                      museum: row[12],
                      address: row[13],
                      price_expo: row[31] == "payant" ? 0 : 1)
    file = URI.open(row[33])
    new_exhib.photo.attach(io: file, filename: row[2], content_type: 'image/jpg')
  end
end



CSV.foreach(filepath_artworks, csv_options) do |row|
  image = FastImage.size(row[6])
  if (image[0]||image[1]) > 2300
    puts "image XX is too big"
  else
    author = Author.first_or_create(name: row[0])
    type = Type.first_or_create(name: row[5])
    puts "---- creating"
    new_art = Artwork.create(title: row[3],
                    mouvement: row[2],
                    museum: row[4],
                    author: author,
                    type: type)
    file = URI.open(row[6])
    new_art.photo.attach(io: file, filename: row[3], content_type: 'image/jpg')
  end
end
