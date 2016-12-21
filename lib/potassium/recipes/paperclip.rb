class Recipes::Paperclip < Recipes::Base
  def ask
    enabled answer(:paperclip) { Ask.confirm("Do you want to use Paperclip for uploads?") }
  end

  def create
    add_paperclip if enabled
  end

  def install
    add_paperclip
  end

  def installed?
    gem_exists?(/paperclip/)
  end

  private

  def add_paperclip
    # gather_gem 'paperclip', '~> 4.3'
    paperclip_config =
      <<-RUBY.gsub(/^ {7}/, '')
         config.paperclip_defaults = {
           storage: :s3,
           s3_credentials: {
             bucket: ENV['AWS_BUCKET']
           }
         }
         RUBY
    application paperclip_config.strip, env: 'production'
    append_to_file '.env.development', 'AWS_BUCKET='
    append_to_file '.gitignore', "/public/system/*\n"
    add_readme_section :internal_dependencies, :paperclip
  end
end
