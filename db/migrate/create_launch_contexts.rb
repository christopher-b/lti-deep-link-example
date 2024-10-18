class CreateLaunchContexts < ActiveRecord::Migration[7.0]
    def change
      create_table :launch_contexts do |t|
        t.string :message_type
        t.string :lti_version
        t.string :deployment_id
        t.string :target_link_uri
        t.string :return_url
        t.string :custom
        t.string :deep_link_return_url
        t.string :aud
        t.string :azp
        t.string :iss
        t.string :sub
  
        t.timestamps
      end
    end
end