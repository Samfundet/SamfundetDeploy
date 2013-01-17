module Tasks
  class TaskExecutor
    def command(command)
      io = IO.popen "#{command} 2>&1"
      Process.wait io.pid
      output = io.read

      raise output unless $?.success?
    end

    def ask(question)
      print "#{question} [y/n] "
      answer = STDIN.getc
      STDIN.getc # Removing new line character from stack
      answer.downcase == "y"
    end
  end
end
