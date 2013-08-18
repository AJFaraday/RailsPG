ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'test/unit'
require 'mocha/setup'

class ActiveSupport::TestCase


  # stub collections to effect 
  def stub_for_successful_effect
    SkillEffect.any_instance.stubs(:roll_for_evade => false,
                                   :roll_for_defence => false,
                                   :roll_for_critical => false)
  end

  def stub_for_critical
    SkillEffect.any_instance.stubs(:roll_for_evade => false,
                                   :roll_for_defence => false,
                                   :roll_for_critical => true)
  end

  def stub_for_evade
    SkillEffect.any_instance.stubs(:roll_for_evade => true,
                                   :roll_for_defence => false,
                                   :roll_for_critical => false)
  end

  def stub_for_defend
    SkillEffect.any_instance.stubs(:roll_for_evade => false,
                                   :roll_for_defence => true,
                                   :roll_for_critical => false)
  end


end
