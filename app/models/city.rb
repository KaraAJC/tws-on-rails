class City < ActiveRecord::Base
  validates_uniqueness_of :city_code
  validates_presence_of :city_code, :timezone
  before_save :upcase_code
  has_attached_file :header_bg, default_url: "http://placecorgi.com/1280"
  validates_attachment_content_type :header_bg, :content_type => /\Aimage\/.*\Z/
  enum brew_status: { cold_water: 0, warming_up: 1, fully_brewed: 2, hidden: 3}
  has_many :tea_times
  has_many :users, foreign_key: 'home_city_id'

  has_and_belongs_to_many :proxy_cities,
    class_name: 'City',
    join_table: :proxy_cities,
    foreign_key: :city_id,
    association_foreign_key: :proxy_city_id

  validate :proxy_city_not_self

  scope :visible, -> { where.not(brew_status: brew_statuses[:hidden]) }
  scope :hidden, -> { where(brew_status: brew_statuses[:hidden]) }

  def hosts
    hosts + User.hosts.where(home_city: self)
  end

  def timezone=(tz)
    val = tz if City.timezone_mappings.key? tz
    if val
      write_attribute(:timezone, val) 
    else
     raise ArgumentError, "TimeZone must be one from TZinfo"
    end
  end

  def to_param
    city_code
  end

  def tea_times
    tts = proxy_cities.inject([]) {|lst, c| lst + c.tea_times}
    tts + super
  end

  private
    def upcase_code
      write_attribute(:city_code, read_attribute(:city_code).upcase)
    end

    # Having self as proxy creates an infinite chain of queries when
    # attempting to resolve tea times for the city.
    def proxy_city_not_self
      proxy_cities.each do |proxy_city|
        errors.add(:proxy_cities) if proxy_city.id == self.id
      end
    end

  class << self
    def timezone_mappings
      @tzs ||= ActiveSupport::TimeZone::MAPPING
    end

    def for_code(code)
      for_code_proxy(code, :find_by)
    end

    def for_code!(code)
      for_code_proxy(code, :find_by!)
    end

    private
      def for_code_proxy(code, method)
        unscoped{ self.send(method, city_code: code.upcase) }
      end
  end
end

