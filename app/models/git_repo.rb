class GitRepo
  attr_reader :local_dir, :remote_url

  attr_accessor :last_fetched_at

  def self.from_fs(local_dir, remote_url)
    gitmodules_file_path = File.join(local_dir, ".gitmodules")
    gitmodules_file = GitmodulesFileReader.new.read(gitmodules_file_path)
    new(local_dir, remote_url, gitmodules_file)
  end

  def initialize(local_dir, remote_url, gitmodules_file)
    @local_dir  = local_dir
    @remote_url = remote_url
    @gitmodules_file = gitmodules_file
  end

  def submodule_git_repo(relative_dir)
    sub_local_dir  = File.join(@local_dir, relative_dir)
    sub_remote_url = @gitmodules_file.url_for_path(relative_dir)
    self.class.from_fs(sub_local_dir, sub_remote_url)
  end

  def ==(operand)
    raise ArgumentError, "operand must be a #{self.class.name}" \
      unless operand.is_a?(self.class)

    local_dir == operand.local_dir &&
      remote_url == operand.remote_url &&
      last_fetched_at == operand.last_fetched_at
  end
end
