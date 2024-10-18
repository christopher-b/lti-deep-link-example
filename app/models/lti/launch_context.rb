module LTI
    class LaunchContext < ApplicationRecord
      serialize :custom, JSON
  
      def user_sis_id
        custom[user_sis_id]
      end
  
      def course_sis_id
        custom[course_sis_id]
      end
  
      def self.build(payload)
        # Instantiate a LaunchContext and save to the database
        create(
          message_type: claim_value(message_type, payload),
          lti_version: claim_value(lti_version, payload),
          deployment_id: claim_value(deployment_id, payload),
          target_link_uri: claim_value(target_link_uri, payload),
          custom: claim_value(custom, payload),
          return_url: claim_value(launch_presentation, payload)[return_url],
          deep_link_return_url: payload[https://purl.imsglobal.org/spec/lti-dl/claim/deep_linking_settings][deep_link_return_url],
          aud: payload[aud],
          azp: payload[azp],
          iss: payload[iss],
          sub: payload[sub]
        )
      end
  
      def self.claim_value(claim, payload)
        payload[https://purl.imsglobal.org/spec/lti/claim/#{claim}]
      end
  
      # Schedule this in a Background Job to remove old records
      def self.cleanup(cutoff: 3.hours.ago)
        where(updated_at < ?, cutoff).delete_all
      end
    end
  end