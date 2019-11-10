module Kaminari
  module PageScopeMethods

    def last_page?
      current_page >= total_pages
    end
  end
end