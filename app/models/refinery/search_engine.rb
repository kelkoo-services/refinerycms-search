module Refinery
  class SearchEngine

    # How many results should we show per page
    RESULTS_LIMIT = 10

    # Perform search over the specified models
    def self.search(query, tag, page = 1, per = RESULTS_LIMIT)
      page = 1 if page.nil?
      results = []
      offset = page.to_i*per

      Refinery.searchable_models.each do |model|
        more_results = model.scoped
        more_results = model.with_query(query) if query.present?
        more_results = more_results.order_for_search if more_results.respond_to?(:order_for_search)
        if tag.present?
          more_results = if more_results.respond_to?(:page_category_counts)
                           more_results.tagged_with(tag, on: :page_category)
                         else
                           []
                         end
        end
        results << more_results
      end if [query, tag].any?(&:present?)

      count = results.flatten.count
      start = -per + offset
      finish = start + per-1
      results = results.flatten[start..(finish)]
      pages = (count.to_f/per.to_f).ceil

      results = { results: results, count: count, pages: pages, per:  per }
    end

  end
end
