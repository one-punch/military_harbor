class LargeTranslatedText < ActiveRecord::Migration[5.1]
  def change
    change_column :questions, :translated_text, :text
    change_column :questions, :voice_text, :text
    change_column :questions, :que_desc, :text
  end
end
