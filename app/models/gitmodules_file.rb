class GitmodulesFile
  class Entry < Struct.new(:name, :path, :url); end

  def initialize(entries)
    @entries = entries
  end

  def url_for_path(path)
    entry = @entries.detect { |e| e.path == path }
    entry ? entry.url : nil
  end
end
