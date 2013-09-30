class GitCommit
  attr_reader :sha, :message, :author_name

  def initialize(sha, message, author_name)
    @sha = sha
    @message = message
    @author_name = author_name
  end

  def short_sha
    sha.first(7)
  end

  def message_first_line
    @message_first_line ||= \
      message.split("\n").first
  end

  def message_rest
    @message_rest ||= message.split("\n")[1..-1].join("\n").strip
  end

  def author_initials
    @author_initials ||= \
      author_name.gsub(/\s+and/, " ").split(" ").map(&:first).join
  end
end
