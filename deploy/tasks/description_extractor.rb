module Tasks
  class DescriptionExtractor
    def description(description = nil)
      @description ||= description
    end

    def env(*args) end
    def task(*args) end
    def invoke_group(*args) end
  end
end
