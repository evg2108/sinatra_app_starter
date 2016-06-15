class Client
  FIELDS_NAMES_MAP = [:client_id, :client_name, :balance]

  attr_accessor *FIELDS_NAMES_MAP

  def self.find(client_id)
    new(client_id: client_id, client_name: 'John', balance: 20)
  end


  def initialize(options = {})
    self.client_id = options[:client_id]
    self.client_name = options[:client_name]
    self.balance = options[:balance]
  end

  def to_hash
    FIELDS_NAMES_MAP.each_with_object({}) do |attr_name, hash|
      hash[attr_name] = self.public_send(attr_name)
    end
  end

  def to_ary
    [to_hash]
  end
end