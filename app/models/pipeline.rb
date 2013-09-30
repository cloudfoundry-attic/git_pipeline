class Pipeline
  attr_reader :id, :name, :git_repo, :stages

  def initialize(id, name, git_repo, stages)
    @id = id
    @name = name
    @git_repo = git_repo
    @stages = stages
  end

  def to_param
    @id
  end
end
