require "git"
require "git/version"

raise "Monkey patch may not work with this Git gem version" unless Git::VERSION == "1.2.6"

Git::Lib.class_eval do
  def submodule_update_recursive
    command('submodule', 'update', '--init', '--recursive')
  end
end

Git::Base.class_eval do
  def submodule_update_recursive
    self.lib.submodule_update_recursive
  end
end
