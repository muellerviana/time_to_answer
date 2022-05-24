class Subject < ApplicationRecord
    has_many :questions
 # Kaminari    

 paginates_per 17


end
