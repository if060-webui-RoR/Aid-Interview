module InterviewHelper
  def bar_color(mark)
    case mark
    when 'green'
      'success'
    when 'yellow'
      'warning'
    when 'red'
      'danger'
    end
  end

  def bar_width(mark)
    case mark
    when 'green'
      '100'
    when 'yellow'
      '75'
    when 'red'
      '50'
    else
      '0'
    end
  end

  def mark_value(mark)
    case mark
    when 'green'
      'EXCELLENT'
    when 'yellow'
      'GOOD'
    when 'red'
      'BAD'
    end
  end

  def mark_color(question_mark, mark)
    color = 'default'
    if question_mark == mark
      color = 'danger' if mark == 'red'
      color = 'warning' if mark == 'yellow'
      color = 'success' if mark == 'green'
    end
    color
  end

  def target_level_param(target_level)
    case target_level
    when 'beginner'
      { level: target_level, width: "40%", color: "success" }
    when 'intermediate'
      { level: target_level, width: "66%", color: "warning" }
    when 'advanced'
      { level: target_level, width: "100%", color: "danger" }
    end
  end

  def interview_color_number(interview)
    number = 'no'
    sum_mark = 0
    sum_question = interview.interview_questions.where('mark IS NOT NULL').count
    interview.interview_questions.each do |question|
      sum_mark += 1 if question.mark == 'yellow'
      sum_mark += 2 if question.mark == 'green'
    end
    number = 10 * sum_mark / sum_question if sum_question > 0
    number
  end

  def interview_color(interview)
    color = 'default'
    if interview_color_number(interview) != 'no'
      color = 'danger'
      color = 'warning' if interview_color_number(interview) >= 5
      color = 'success' if interview_color_number(interview) >= 15
    end
    color
  end
end
