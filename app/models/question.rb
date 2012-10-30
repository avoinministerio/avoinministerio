class Question < ActiveRecord::Base
  include Surveyor::Models::QuestionMethods

  def get_question_number
    return reference_identifier unless reference_identifier.nil?
    #Following code is deprecated only required for older survey versions
    #Which didn't have reference_identifiers
    @@question_number ||= display_order.to_i - 2 # Subtracting labels
    @@flag ||= false
    question_number = @@question_number + 1
    if part_of_group?
      @@flag = true
    else
      if @@flag
        @@question_number += 1
        @@flag = false
      end
      @@question_number += 1
      question_number = @@question_number
    end
    return question_number
  end
end

