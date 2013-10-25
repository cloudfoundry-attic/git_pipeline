class VersionCollection
  include Enumerable

  alias_method :size, :count

  def initialize(version_fetcher)
    @version_fetcher = version_fetcher
  end

  def each(*args, &blk)
    @versions ||= @version_fetcher.fetch(25)
    @versions.each(*args, &blk)
  end
end
