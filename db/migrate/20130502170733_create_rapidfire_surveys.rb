class CreateRapidfireSurveys < ActiveRecord::Migration
  def change
    create_table :rapidfire_surveys do |t|
      t.string  :name
      t.boolean :active
      t.integer :position
      t.timestamps
    end
  end
end
