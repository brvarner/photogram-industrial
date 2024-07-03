desc "Fill the database tables with some sample data"
task sample_data: :environment do
  p "Creating sample data"

  if Rails.env.development?
    FollowRequest.destroy_all
    Comment.destroy_all
    Like.destroy_all
    Photo.destroy_all
    User.destroy_all
  end

  usernames = Array.new { Faker::Name.first_name }

  usernames << "alice"
  usernames << "bob"

  usernames.each do |username|
    User.create(
      email: "#{username}@example.com",
      password: "password",
      username: username.downcase,
      private: [true, false].sample,
    )
  end

  # Create users first
  12.times do 
    name = Faker::Name.first_name
    
    User.create(
      email: "#{name}@example.com",
      password: "password",
      username: name,
      private: [true, false].sample,
    )
  end
  users = User.all
  # Create follow requests
  users.each do
    FollowRequest.create(
      recipient: users.sample,
      sender: users.sample,
      status: FollowRequest.statuses.values.sample,
    ).tap { |f| p f.errors.full_messages }
  end

  # Create photos
  users.each do |user|
    Photo.create(
      image: "https://picsum.photos/400",
      owner: user,
      caption: "Oh we IN HERE IN HERE",
    ).tap { |p| p.errors.full_messages }
  end

  # Create likes and comments
  users.each do
    Like.create(
      fan: users.sample,
      photo: Photo.all.sample,
    ).tap { |l| p l.errors.full_messages }

    Comment.create(
      author: users.sample,
      photo: Photo.all.sample,
      body: Faker::Games::Fallout.quote,
    ).tap { |c| p c.errors.full_messages }
  end

  p "There are now #{User.count} users."
end
