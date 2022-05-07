DEFAULT_PASSWORD = 123456

namespace :dev do
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Dropping Data-Base"...) { %x(rails db:drop) }

      show_spinner("Creating Data-Base...") { %x(rails db:create)} 

      show_spinner("Migrating Data-Base...") { %x(rails db:migrate)} 

      show_spinner("Creating Default Admin...") { %x(rails dev:add_default_admin)} 

      show_spinner("Creating Defaut User"...) { %x(rails dev:add_default_user)} 

    else
      puts "You're not on development environment"
    end  
  end

  desc "Add default Admin"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Add default User"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end
  
  private

  def show_spinner(msg_start, msg_end = "Done!")

    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end

end