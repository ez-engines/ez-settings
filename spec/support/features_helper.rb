module Ez::Settings
  module Test
    module FeaturesHelpers
      # Find error on the page in special div class for some resource
      #
      # it 'FAILS' do
      #   fill_in 'Title', with: ''
      #   click_button 'Submit'
      #
      #   expect_an_error resource_title: :blank
      # end
      #
      def expect_an_error(hash_pair = {}, no = false)
        field     = hash_pair.keys.first
        value     = hash_pair.values.first
        error_div = "div.#{field}.field_with_errors"

        msg = if value == :blank
          "can't be blank"
        elsif value == :has_been_taken
          'has already been taken'
        else
          value
        end

        to_or_not = no ? :not_to : :to

        expect(page).send(to_or_not, have_css(error_div))

        return if no

        expect(find("#{error_div}")).send(to_or_not, have_content(msg))
      end

      def expect_not_an_error(hash_pair = {})
        expect_an_error(hash_pair, true)
      end

      def delete_dummy_config_file!
        config_file = Rails.root.join('spec', 'dummy', 'config', 'settings.yml')

        File.delete(config_file) if File.exists?(config_file)
      end
    end
  end
end
