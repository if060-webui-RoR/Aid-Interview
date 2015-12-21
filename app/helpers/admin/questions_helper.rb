module Admin::QuestionsHelper
  def bar_param(q_level)
    width, color  = '100%', 'danger'	
    if q_level == 'beginner'
      width, color = '33%', 'success'
    end
    if q_level == 'good'
      width, color = '66%', 'warning'
    end
    {level: q_level, width: width, color: color}
  end
end
