module TemplateHelpers
  def eval_file(source)
    location = File.expand_path(find_in_source_paths(source))
    unique_name = SecureRandom.hex

    define_singleton_method unique_name do
      instance_eval File.read(location)
    end

    public_send unique_name
  end

  def source_path(path)
    define_singleton_method :source_paths do
      [File.expand_path(File.dirname(path))]
    end
  end

  def erase_comments(file)
    gsub_file file, /^\s*#[^\n]*\n/, ''
  end
end