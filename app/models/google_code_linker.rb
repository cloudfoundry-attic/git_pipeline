class GoogleCodeLinker
  attr_reader :repo_url

  def initialize(repo_url)
    @repo_url = repo_url
  end

  def commit_url(sha)
    "#{@repo_url}/source/detail?r=#{sha}"
  end

  def ref_url(ref)
    "#{@repo_url}/source/browse/?name=#{no_origin(ref)}"
  end

  def compare_url(symbolic_from, symbolic_to)
    from = no_origin(symbolic_from)
    to   = no_origin(symbolic_to)
    "#{@repo_url}/source/diff?spec=svn#{from}&r=#{to}&format=unidiff&path=%2F"
  end

  private

  def no_origin(ref)
    ref.gsub(%r{origin/}, "")
  end
end
