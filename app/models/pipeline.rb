class Pipeline
  attr_reader :id, :name, :git_repo, :stages, :versions

  def initialize(id, name, git_repo, stages, versions)
    @id = id
    @name = name
    @git_repo = git_repo
    @stages = stages
    @versions = versions
  end

  def to_param
    @id
  end
end
