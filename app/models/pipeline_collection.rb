class PipelineCollection
  include Enumerable

  def self.load_from_config_dir
    file_paths = Dir[Rails.root.join("config", "pipelines", "*.yml")]
    new(file_paths.sort.map { |f| PipelineFileLoader.new(f).load })
  end

  def initialize(pipelines)
    @pipelines = pipelines
  end

  def each(*args, &blk)
    @pipelines.each(*args, &blk)
  end

  def find_by_id(id)
    @pipelines.detect { |p| p.id == id }
  end
end
