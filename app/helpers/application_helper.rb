module ApplicationHelper
  def full_title(page_title = '')
    page_title.empty? ? "AID-Interview" :  page_title + " | " + "AID-Interview"
  end
end