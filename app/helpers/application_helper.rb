module ApplicationHelper
<<<<<<< HEAD

  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "AID-Interview"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
=======
	def full_title(page_title = nil)
		[page_title, "AID-Interview"].compact.join(" | ")
	end 
end



>>>>>>> home-page
