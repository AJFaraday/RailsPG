ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'test/unit'
require 'mocha/setup'

class ActiveSupport::TestCase


  # stub collections to effect 
  def stub_for_successful_bar_effect
    BarEffect.any_instance.stubs(:roll_for_evade => false,
                                 :roll_for_defence => false,
                                 :roll_for_critical => false)
  end

  def stub_for_critical_bar_effect
    BarEffect.any_instance.stubs(:roll_for_evade => false,
                                 :roll_for_defence => false,
                                 :roll_for_critical => true)
  end

  def stub_for_evade_bar_effect
    BarEffect.any_instance.stubs(:roll_for_evade => true,
                                 :roll_for_defence => false,
                                 :roll_for_critical => false)
  end

  def stub_for_defend_bar_effect
    BarEffect.any_instance.stubs(:roll_for_evade => false,
                                 :roll_for_defence => true,
                                 :roll_for_critical => false)
  end

  def stub_for_successful_attribute_effect
    AttributeEffect.any_instance.stubs(:roll_for_evade => false,
                                       :roll_for_defence => false,
                                       :roll_for_critical => false)
  end

  def stub_for_critical_attribute_effect
    AttributeEffect.any_instance.stubs(:roll_for_evade => false,
                                       :roll_for_defence => false,
                                       :roll_for_critical => true)
  end

  def stub_for_evade_attribute_effect
    AttributeEffect.any_instance.stubs(:roll_for_evade => true,
                                       :roll_for_defence => false,
                                       :roll_for_critical => false)
  end

  def stub_for_defend_attribute_effect
    AttributeEffect.any_instance.stubs(:roll_for_evade => false,
                                       :roll_for_defence => true,
                                       :roll_for_critical => false)
  end


end
