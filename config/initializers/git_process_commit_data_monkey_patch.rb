require "git"
require "git/version"

raise "Monkey patch may not work with this Git gem version" unless Git::VERSION == "1.2.6"

# Taken from .../gems/git-1.2.6/lib/git/object.rb
Git::Lib.class_eval do
  def process_commit_data(data, sha = nil, indent = 4)
    in_message = false
    just_one_commit = !!sha

    if sha
      hsh = {'sha' => sha, 'message' => '', 'parent' => []}
    else
      hsh_array = []
    end

    # See https://github.com/cloudfoundry/cf-release/commit/f81d1647e1ba60fc43759d5fbc7a92fb96876629
    # for the case when keying off 'commit' does not work
    data.each_with_index do |line, i|
      line = line.chomp
      if line == ''
        # <PATCH>
        if just_one_commit
          # Commit message runs until EOF when used for parsing
          # `git cat-file commit 083f598fc28db926fb1effa8013095e1a50f4d92`
          in_message = true
        else
          # New commit begins with 'commit ' on a new line
          # and commit messages are indented
          # `git log -2 --pretty=raw`
          if data[i+1] && data[i+1].start_with?("commit ")
            in_message = false
          else
            in_message = true
          end
        end
        # </PATCH>
      elsif in_message
        hsh['message'] << line[indent..-1] << "\n"
      else
        dd = line.split
        key = dd.shift
        value = dd.join(' ')
        if key == 'commit'
          sha = value
          hsh_array << hsh if hsh
          hsh = {'sha' => sha, 'message' => '', 'parent' => []}
        end
        if key == 'parent'
          hsh[key] << value
        else
          hsh[key] = value
        end
      end
    end

    if hsh_array
      hsh_array << hsh if hsh
      hsh_array
    else
      hsh
    end
  end
end
