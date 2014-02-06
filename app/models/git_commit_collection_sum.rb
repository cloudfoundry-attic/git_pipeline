class GitCommitCollectionSum
  include Enumerable

  alias_method :size, :count

  def initialize(a, b)
    @a, @b = a, b
  end

  def available?
    @a.available? && @b.available?
  end

  def each(*args, &blk)
    (@a.to_a + @b.to_a).each(*args, &blk) # immediate
  end
end
