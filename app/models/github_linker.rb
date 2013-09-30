class GithubLinker
  def initialize(base_url)
    @base_url = base_url
  end

  def repo_url
    @base_url
  end

  def commit_url(sha)
    "#{@base_url}/commit/#{sha}"
  end

  def ref_url(ref)
    "#{@base_url}/tree/#{no_origin(ref)}"
  end

  def compare_url(symbolic_from, symbolic_to)
    from = no_origin(symbolic_from)
    to   = no_origin(symbolic_to)
    "#{@base_url}/compare/#{from}...#{to}"
  end

  private

  def no_origin(ref)
    ref.gsub(%r{origin/}, "")
  end
end
