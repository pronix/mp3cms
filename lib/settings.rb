module Settings
  def self.load!
    @settings ||= YAML.load(ERB.new(File.read(File.join(RAILS_ROOT,'config', 'application.yml'))).result).to_hash[RAILS_ENV]
  end

  def self.[](key)
    load! if @settings.nil?
    @settings[key.to_s.downcase]
  end

  def self.show
    load! if @settings.nil?
    @settings
  end
end
