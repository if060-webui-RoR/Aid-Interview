module InterviewQuestionsHelper
  def button_next(interview, question)
    next_but = "NEXT"
    next_but = "FINISH" if interview.interview_questions.last.id == question.id
    next_but
  end
end
