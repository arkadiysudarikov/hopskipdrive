# frozen_string_literal: true

# Description: This file is used to define the ApplicationRecord class which is the parent class for
# all the models in the application.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
