require "connection_adapter"

module ActiveRecord
  class Base
    @@connection = SqliteAdapter.new

    def initialize(attributes = {})
      @attributes = attributes
    end

    def method_missing(name, *args) # args = []
      if @@connection.columns(self.class.table_name).include?(name)
        @attributes[name]
      else
        super # raise MethodNotFound
      end
    end

    def self.find(id)
      find_by_sql("SELECT * FROM #{table_name} WHERE id = #{id.to_i} LIMIT 1").first
    end

    def self.find_by_sql(sql)
      rows = @@connection.execute(sql)
      rows.map do |attributes|
        new(attributes)
      end
    end

    def self.table_name
      name.downcase + 's' # "users"
    end

    def self.all
      find_by_sql("SELECT * FROM #{table_name}")
    end
  end
end
