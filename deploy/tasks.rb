require File.expand_path('tasks/tasks_extractor', File.dirname(__FILE__))
require File.expand_path('tasks/description_extractor', File.dirname(__FILE__))

module Tasks
  def task_group(identifier, options = {}, &block)
    @task_groups ||= {}

    description_extractor = DescriptionExtractor.new
    description_extractor.instance_eval &block

    @task_groups[identifier] = {
        :description => description_extractor.description,
        :block => block
    }.merge(options)
  end

  def execute_group(identifier)
    tasks_extractor = TasksExtractor.new
    tasks_extractor.registered_task_groups = @task_groups
    tasks_extractor.instance_eval &@task_groups[identifier][:block]

    tasks_extractor.tasks.each do |task|
      unless execute_task(task)
        puts "An error occurred and execution of remaining tasks was halted.".red
        return false
      end
    end

    true
  end

  def execute_task(task)
    success = true

    begin
      print "#{task[:description]}.. "
      task[:block].call
      puts "success".green
    rescue Exception => e
      puts "error".red
      puts e.message
      success = false
    end

    success
  end

  def shown_task_groups
    @task_groups.select do |identifier, task_group|
      !task_group[:hidden]
    end
  end

  def task_identifier_to_option(identifier)
    "--#{identifier.to_s.gsub("_", "-")}"
  end
end
