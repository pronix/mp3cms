class Gateway < ActiveRecord::Base
  serialize :preferences, Hash
  cattr_reader :providers

  has_many :cost_countries # только для sms билинга

  @provier = nil?
  @@providers = [Gateway::Webmoney, Gateway::Mobilcents]

  validates_presence_of :name, :type
  validates_uniqueness_of :type
  validates_inclusion_of  :type, :in => @@providers.map(&:to_s)


  %w(active).each do |m|
    scope m.to_sym, where(m.to_sym => true)
  end

  class << self

    @@providers.map(&:to_s).each do |m|
      define_method m.demodulize.downcase  do |*args|
        first :conditions => { :type => m }
      end
    end

  end

  def gateway_type
    new_record? ? self.class.to_s :
      read_attribute("type")
  end
  def gateway_type=(v)
    write_attribute("type",v)
  end


  def provider_class
    raise "You must implement provider_class method for this gateway."
  end

  def provider
    gateway_options = options
    gateway_options[:test] = true if test_mode
		@provider ||= provider_class.new(gateway_options)
  end

  def method_missing(method, *args)
	 	if @provider.nil?
			super
		else
			@provider.respond_to?(method) ? provider.send(method) : super
		end
	end

end
