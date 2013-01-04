module Tasks
  class TaskExecutor
    def command(command)
      io = IO.popen "#{command} 2>&1"
      Process.wait io.pid
      output = io.read

      raise output unless $?.success?
    end
  end
end
