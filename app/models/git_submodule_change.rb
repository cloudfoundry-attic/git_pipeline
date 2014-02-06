class GitSubmoduleChange
  attr_reader :path, :git_repo, :git_log

  def initialize(path, git_repo, git_log)
    @path = path
    @git_repo = git_repo
    @git_log  = git_log
  end

  def +(operand)
    raise ArgumentError, "operand must be a #{self.class.name}" \
      unless operand.is_a?(self.class)

    if (a = operand.path) != (b = path)
      raise ArgumentError,
        "operand's path (#{a.inspect}) must equal " +
        "self's path (#{b.inspect})"
    end

    if (a = operand.git_repo) != (b = git_repo)
      raise ArgumentError,
        "operand's git_repo (#{a.inspect}) must equal " +
        "self's git_repo (#{b.inspect})"
    end

    self.class.new(path, git_repo, git_log + operand.git_log)
  end
end
