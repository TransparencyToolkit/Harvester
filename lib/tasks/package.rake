desc "Create packages for the current system architecture"
namespace :package do
  # absolute paths describing where the toolkit will
  # go on the target machine once the package is installed
  PKG_ROOT = "/opt/transparency"
  RUBY_ROOT = "#{PKG_ROOT}/ruby"

  # relative paths describing where the output from git-archive-all
  # goes during the packaging process
  PKG_APP_PATH = "pkg#{PKG_ROOT}/harvester"
  PKG_RUBY_PATH = "pkg#{PKG_ROOT}/ruby"

  INSTALL_RUBY_VERSION = "2.1.8"

  def check_deps
    unless system("git-archive-all --help 2>&1 > /dev/null")
      puts "Please install git-archive-all before trying to create a package"
      puts "Run: pip install git-archive-all"
      exit 1
    end

    # build a version of Ruby into PKG_ROOT/ruby
    unless system("ruby-install --help 2>&1 > /dev/null")
      puts "Please install ruby-install before trying to create a package"
      puts "See: https://github.com/postmodern/ruby-install"
      exit 1
    end
  end

  desc "Create a Debian/Ubuntu package"
  task :deb, :gitref, :version do |t, args|
    check_deps()

    gitref = args.fetch(:gitref, "HEAD")
    version = `git rev-parse --short #{gitref}`
    puts "Creating a debian package for gitref #{gitref} using version #{version}"

    puts "Building ruby #{INSTALL_RUBY_VERSION} into #{PKG_ROOT}/ruby using install-ruby"
    if Dir.exists?(RUBY_ROOT)
      puts "The directory #{RUBY_ROOT} already exists, skipping ruby-install"
    else
      sh "sudo ruby-install --install-dir #{RUBY_ROOT} ruby #{INSTALL_RUBY_VERSION}"
    end

    puts "Adding all project files and submodules to #{PKG_APP_PATH}"

    sh "git checkout #{gitref}"
    sh "git-archive-all --force-submodules packaged-app.tar"

    sh "mkdir -p #{PKG_APP_PATH}"
    sh "tar xf -C #{PKG_APP_PATH} packaged-app.tar"
    sh "rm packaged-app.tar"

    puts "Bundling gems using the ruby version at #{RUBY_ROOT}"
    sh "#{RUBY_ROOT}/bin/gem install bundler"

    Dir.chdir(PKG_APP_PATH) do
      sh "#{RUBY_ROOT}/bin/gem install bundler"
    end

    # copy the compiled ruby into the pkg/ folder
    sh "cp -r #{RUBY_ROOT} #{PKG_RUBY_PATH}"
  end
end
