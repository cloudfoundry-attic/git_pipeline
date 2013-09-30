class StageCollection
  include Enumerable

  alias_method :size, :count

  def initialize(existing_stages, stage_fetcher)
    @existing_stages = existing_stages
    @stage_fetcher   = stage_fetcher
  end

  def each(*args, &blk)
    @stages ||= @existing_stages + @stage_fetcher.fetch
    @stages.each(*args, &blk)
  end
end
