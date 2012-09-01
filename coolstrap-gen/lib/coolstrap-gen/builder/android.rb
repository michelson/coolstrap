module Coolstrap::Gen
  module Builder
    class Android < Thor
      include ::Coolstrap::Gen::Utils
      no_tasks {
        def build()
          
        end

        def deploy
        end
      }
    end
  end
end

