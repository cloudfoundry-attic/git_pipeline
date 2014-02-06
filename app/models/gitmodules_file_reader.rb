class GitmodulesFileReader
  DEF_LINE  = /\A\s*\[submodule\s*\"(.+)\"\]\s*\z/ # [submodule "src/vblob_src"]
  PATH_LINE = /\A\s*path\s*=\s*(.+)\s*\z/          #   path = src/vblob_src
  URL_LINE  = /\A\s*url\s*=\s*(.+)\s*\z/           #   url = https://github.com/cloudfoundry/vblob.git

  def read(file_path)
    f = File.open(file_path)
    entries = []

    name, path, url = nil, nil, nil

    f.each_with_index do |line, i|
      name = $1 if line =~ DEF_LINE
      path = $1 if line =~ PATH_LINE
      url  = $1 if line =~ URL_LINE

      if name && path && url
        entries << GitmodulesFile::Entry.new(name, path, url)
        name, path, url = nil, nil, nil
      end
    end

    GitmodulesFile.new(entries)
  rescue Errno::ENOENT
    GitmodulesFile.new([])
  ensure
    f.close if f
  end
end
