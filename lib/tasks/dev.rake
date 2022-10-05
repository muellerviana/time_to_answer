DEFAULT_PASSWORD = 123456
DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

namespace :dev do
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Dropping Data-Base"...) { %x(rails db:drop) }

      show_spinner("Creating Data-Base...") { %x(rails db:create)} 

      show_spinner("Migrating Data-Base...") { %x(rails db:migrate)} 

      show_spinner("Creating Default Admin...") { %x(rails dev:add_default_admin)} 

      show_spinner("Creating Extras Admins...") { %x(rails dev:add_extras_admins)} 

      show_spinner("Creating Defaut User...") { %x(rails dev:add_default_user)} 

      show_spinner("Registering standard subjects...") { %x(rails dev:add_subjects) }

      show_spinner("Registering questions and answers...") { %x(rails dev:add_answers_and_questions) }

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

  #Add extras admins

  desc "Add default Admin"
  task add_extras_admins: :environment do
    10.times do |i|
   
   Admin.create!(
      email: Faker::Internet.email,
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
    end
  end





  #-----------------

  desc "Add default User"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona assuntos padrões"
  task add_subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)
    
    File.open(file_path, 'r').each do |line|
      Subject.create!(description: line.strip)
    end
  end

  desc "Adiciona questões e respostas"
  task add_answers_and_questions: :environment do
    Subject.all.each do |subject|
      rand(5..10).times do |i|
        params = create_question_params(subject)
        answers_array = params[:question][:answers_attributes]

        add_answers(answers_array)
        elect_true_answer(answers_array)

        rand(2..5).times do |i|
          params[:question][:answers_attributes].push(
            { description: Faker::Lorem.sentence, correct: false}
          )
        end

        index = rand(params[:question][:answers_attributes].size)
        params[:question][:answers_attributes][index] = { description: Faker::Lorem.sentence, correct: true }
                
        Question.create!(params[:question])
      end
    end
  end

  private

  def create_question_params(subject = Subject.all.sample)
    { question: {
          description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
          subject: subject,
          answers_attributes: []
      }
    }
  end

  def create_answer_params(correct = false)
    { description: Faker::Lorem.sentence, correct: correct }
  end

  def add_answers(answers_array = [])
    rand(2..5).times do |j|
      answers_array.push(
        create_answer_params
      )
    end
  end

  def elect_true_answer(answers_array = [])
    selected_index = rand(answers_array.size)
    answers_array[selected_index] = create_answer_params(true)
  end


  def show_spinner(msg_start, msg_end = "Done!")

    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end