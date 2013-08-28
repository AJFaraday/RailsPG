require 'csv'
class Adventure < ActiveRecord::Base

  has_many :levels, :dependent => :destroy
  has_many :characters, :dependent => :destroy

  has_many :games, :dependent => :destroy

  validates_uniqueness_of :folder_path

  attr_accessor :spec
  attr_accessor :player_positions
  attr_accessor :enemy_positions
  attr_accessor :exit_positions


  def Adventure.create_from_folder(path)
    transaction do
      spec = YAML.load_file("#{Rails.root}/#{path}/specification.yml")
      adventure = Adventure.create!(:name => spec['name'],
                                    :description => spec['description'],
                                    :folder_path => path)
      door_specs=[]
      level_specs = spec['playspaces']
      level_specs.each do |internal_name, level_spec|
        level = adventure.levels.create(:name => level_spec['name'],
                                        :internal_name => internal_name,
                                        :columns => level_spec['columns'],
                                        :rows => level_spec['rows'])
        @player_positions=[]
        @enemy_positions=[]
        @exit_positions=[]
        level.obstacle_positions=[]

        layout = File.read("#{Rails.root}/#{path}/#{level_spec['filename']}")
        layout = CSV.parse(layout)
        layout.each_with_index do |row, row_index|
          row.each_with_index do |cell, column_index|
            coords = [column_index + 1, row_index + 1]
            if cell
              case cell[0..0]
                when 'o'
                  level.obstacle_positions << coords
                when 'p'
                  @player_positions[cell[1..-1].to_i] = coords
                when 'e'
                  @enemy_positions[cell[1..-1].to_i] = coords
                when 'd'
                  @exit_positions[cell[1..-1].to_i] = coords
              end
            end
          end
        end
        level.save!

        @player_positions.each_with_index do |position, index|
          if position
            # positions start at 1 for simplicity purposes
            index -= 1
            player_spec = level_spec['players'][index]
            player = level.characters.create!(:name => player_spec['name'],
                                              :level => player_spec['level'],
                                              :character_class_id => CharacterClass.find_by_name(player_spec['class']).id,
                                              :player => true,
                                              :row => position[1],
                                              :column => position[0],
                                              :adventure_id => adventure.id)
            player_spec['skills'].each do |skill_spec|
              player.character_skills.create!(:level => skill_spec['level'],
                                              :skill_id => Skill.find_by_name(skill_spec['name']).id)
            end
          end
        end

        @enemy_positions.each_with_index do |position, index|
          if position

            # positions start at 1 for simplicity purposes
            index -= 1
            enemy_spec = level_spec['enemies'][index]
            enemy = level.characters.create!(:name => enemy_spec['name'],
                                             :level => enemy_spec['level'],
                                             :character_class_id => CharacterClass.find_by_name(enemy_spec['class']).id,
                                             :player => false,
                                             :row => position[1],
                                             :column => position[0], 
                                             :adventure_id => adventure.id)
            enemy_spec['skills'].each do |skill_spec|
              enemy.character_skills.create!(:level => skill_spec['level'],
                                             :skill_id => Skill.find_by_name(skill_spec['name']).id)
            end
          end
        end

        @exit_positions.each_with_index do |position, index|
          if position

            index -= 1
            door_spec = level_spec['doors'][index]
            door_specs << door_spec.merge({'level' => internal_name,
                                           'row' => position[1],
                                           'column' => position[0]})
          end
        end

      end
      # after creating levels and characters, connect up with doors
      door_specs.each do |door_spec|
        level_name = door_spec.delete('level')
        destination_level_name = door_spec.delete('destination')
        Door.create!(door_spec.merge({:level_id => adventure.levels.find_by_internal_name(level_name).id,
                                      :destination_level_id => adventure.levels.find_by_internal_name(destination_level_name).id}))
      end
      adventure
    end
  end

end
