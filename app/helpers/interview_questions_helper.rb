module InterviewQuestionsHelper
  def mark_nil(interview_questions)
    m_nil = 0
    interview_questions.each do |q|
      m_nil += 1 if (q.mark).nil?
    end
    m_nil
  end
end
