class GitTag
  attr_reader :name, :sha

  def initialize(name, sha)
    @name = name
    @sha = sha
  end

  def versioned?
    @name =~ /\Av\d+(-.*)?\z/
  end

  def version
    @name.scan(/\d+/)[0].to_i
  end
end
