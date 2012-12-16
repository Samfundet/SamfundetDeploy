module Tasks
  class TasksExtractor
    attr_accessor :tasks
    attr_accessor :invoked_groups
    attr_accessor :registered_task_groups

    def initialize
      @tasks = []
      @invoked_groups = []
      @registered_task_groups = {}
    end

    def task(description, &block)
      @tasks << {
          :description => description,
          :block => block
      }
    end

    def invoke_group(identifier, options = {})
      if !options.has_key?(:once) || !@invoked_groups.include?(identifier)
        tasks_extractor = self.class.new
        tasks_extractor.registered_task_groups = @registered_task_groups
        tasks_extractor.invoked_groups = @invoked_groups.dup
        tasks_extractor.instance_eval &@registered_task_groups[identifier][:block]

        (tasks_extractor.invoked_groups + [identifier]).each do |group|
          @invoked_groups << group unless @invoked_groups.include?(group)
        end

        tasks_extractor.tasks.each do |task|
          @tasks << task
        end
      end
    end

    def description(*args) end
  end
end
