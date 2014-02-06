class RickAstleyLinker
  YOUTUBE_URL = "http://www.youtube.com/watch?v=dQw4w9WgXcQ".freeze

  attr_reader :repo_url

  def initialize
    @repo_url = YOUTUBE_URL
  end

  def commit_url(sha)
    YOUTUBE_URL
  end

  def ref_url(ref)
    YOUTUBE_URL
  end

  def compare_url(symbolic_from, symbolic_to)
    YOUTUBE_URL
  end
end
