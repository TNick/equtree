class CreateInitial < ActiveRecord::Migration
  def change
    
    create_table :users do |t|
      t.string  :name
      t.string  :email
      t.string  :password_digest
      t.string  :remember_token
      t.boolean :admin

      t.timestamps
    end
    add_index  :users, :remember_token
    
    
    
    create_table :directories do |t|
      t.string  :name
      t.integer :user_id
      t.string  :ancestry

      t.timestamps
    end
    add_index :directories, [:user_id, :created_at]
    add_index :directories, :ancestry

    
    
    create_table :dfiles do |t|
      t.string  :name
      t.integer :directory_id
      t.integer :ftype
      t.integer :type_index
      t.text    :special_users
      t.integer :public_policy

      t.timestamps
    end
    
    
    
    create_table :sheets do |t|
      t.integer  :context_id;
      t.integer  :dfile_id

      t.timestamps
    end
    
    
    
    create_table :contexts do |t|
      t.integer  :sheet_id
      t.text     :ancestry
      t.text     :description
      t.text     :info_uri
      t.float    :position_left
      t.float    :position_top
      t.float    :size_width
      t.float    :size_height

      t.timestamps
    end
    add_index :contexts, :ancestry
    
    
    create_table :expressions do |t|
      t.integer  :context_id
      t.text     :omath
      t.text     :description
      t.text     :info_uri
      t.float    :position_left
      t.float    :position_top

      t.timestamps
    end
    
    
    
    create_table :imports do |t|
      t.integer  :context_id
      t.integer  :imported_context_id
      t.float    :position_left
      t.float    :position_top

      t.timestamps
    end

    
    

    
    
  end
end
