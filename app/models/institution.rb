class Institution < ActiveRecord::Base
   has_many(:users);
   has_many(:tournaments);
end
