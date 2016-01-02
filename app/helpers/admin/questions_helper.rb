module Admin
  module QuestionsHelper
    def bar_param(q_level)
      case q_level
      when 0
        { level: POSSIBLE_LEVELS[0], width: "40%", color: "success" }
      when 1
        { level: POSSIBLE_LEVELS[1], width: "66%", color: "warning" }
      when 2
        { level: POSSIBLE_LEVELS[2], width: "100%", color: "danger" }
      end
    end
  end
end
