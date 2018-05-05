require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.
require 'byebug'
class SQLObject


  def self.columns
    # ...
    # p self.table_name
    # debugger
    unless @colid
      ret = DBConnection.execute2(<<-SQL)
        SELECT
          *
        FROM
          #{self.table_name}
      SQL
      @colid = ret.first.map(&:to_sym)
    end
    @colid
  end

  def self.finalize!

    # debsugger
    self.columns.each do |col_n|
      define_method("#{col_n}") do
        self.attributes[col_n]
      end
    end

    # debugger
    self.columns.each do |col_n|
      define_method("#{col_n}=") do |val|
        self.attributes[col_n] = val
      end
    end

    # hash = {}
    #
    # self.columns.each do |col|
    #   hash[col] = nil
    # end
    #
    # self.attributes.each do |k,v|
    #   hash[k] = v
    # end

  end

  def self.table_name=(table)
    # @table_name.nil? self.to_s.downcase + "s" : @table_name

    @table_name = table
  end

  def self.table_name
    # ...
    @table_name ||= self.to_s.downcase + "s"

    @table_name
  end

  def self.all
    # ...
    results = DBConnection.execute(<<-SQL)
    SELECT
      *
    FROM
      #{self.table_name}
    SQL
    parse_all(results)
  end

  def self.parse_all(results)
    # ...
    arr_cats = []
    results.each do |cat|
      arr_cats.push(self.new(cat))
    end
    arr_cats
  end

  def self.find(id)
    # ...
    # the_subs = all
    # the_subs.each do |obj|
    #   return obj if (obj.send :id) == id
    # end
    # nil
    results = DBConnection.execute(<<-SQL, id)
    SELECT
      *
    FROM
      #{self.table_name}
    WHERE
      id = ?
    SQL
    parse_all(results).first
  end

  def initialize(params = {})

    params.each do |k,v|
      k = k.to_sym

      raise "unknown attribute '#{k}'" unless self.class.columns.include?(k)

      self.send "#{k}=",v
    end
  #
  end

  def attributes
    # ...
    @attributes ||= {}
  end

  def attribute_values
    # ...
    @attributes.values
  end

  def insert
    # ...
    
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
