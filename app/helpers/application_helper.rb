module ApplicationHelper
  def full_title(page_title = nil)
    [page_title, "AID-Interview"].compact.join(" | ")
  end
end 
