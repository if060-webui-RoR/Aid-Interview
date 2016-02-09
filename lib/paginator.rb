class Paginator
  class << self
    def pagination_attributes(source_obj, data_hash = {})
      data_hash[:total_entries] = source_obj.total_entries
      previous_page = source_obj.previous_page.present? ? source_obj.previous_page : 0
      data_hash[:current_page] = previous_page + 1
      data_hash[:total_pages] = (data_hash[:total_entries].to_f / source_obj.per_page).ceil
      data_hash
    end
  end
end
