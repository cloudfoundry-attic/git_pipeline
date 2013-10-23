class GitTag
  attr_reader :name, :sha, :version

  def initialize(name, sha, version)
    @name = name
    @sha = sha
    @version = version
  end

  def versioned?
    !@version.nil?
  end
end
