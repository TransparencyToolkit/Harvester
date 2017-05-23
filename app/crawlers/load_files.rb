class LoadFiles
  def initialize(harvester_url, selector_id, dir)
    @dir = dir
    @tika = nil
    
    @harvester_url = harvester_url
    @selector_id = selector_id
  end

  # Load in docs
  def run
    cm_hash = {crawler_manager_url: @harvester_url,
               selector_id: @selector_id}

    Thread.new do
      # Make blocks for dircrawl
      block = lambda do |file, in_dir, out_dir, tika|
        p = ParseFile.new(file, in_dir, out_dir, tika)
        p.parse_file
      end

      include = lambda do
        require 'parsefile'
      end

      # Path input hash
      path_params = { path: @dir,
                      output_dir: "#{@dir}_output",
                      ignore_includes: "_terms",
                      failure_mode: "log"
                    }
      
      # Extras
      extras = lambda do |out_dir|
      end
      
      DirCrawl.new(path_params, block, include, extras, cm_hash, path_params[:path], path_params[:output_dir], @tika)
    end
  end
end
