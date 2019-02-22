require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject

  def self.columns
    # ...
    return @cols if @cols
    t = self.table_name
    data = DBConnection.execute2(<<-SQL)
    SELECT
      *
    FROM
      #{self.table_name}
    WHERE 
      id <= 1
    SQL

    @cols = data[0].map {|s| s.to_sym}
    @cols
  end

  def self.finalize!
    # Now we can finally write ::finalize!. It should iterate through all the ::columns, using define_method 
    # (twice) to create a getter and setter method for each column, just like my_attr_accessor. 
    # But this time, instead of dynamically creating an instance variable, store everything in the #attributes hash.
    # define_method()
    self.columns
    @cols.each do |name|

      
      
      sett = name.to_s + '='
      define_method(sett) do |set|
        set_inst_var = '@' + name.to_s
        self.instance_variable_set(set_inst_var, set)
        
        
      end
      
      define_method(name) do |_ = 1|
        instance_var = '@' + name.to_s
        self.instance_variable_get(instance_var)
        
      end
      
      define_method(name) do |_ = 1|
        # @ will create a new var. use self instead.
        self.attributes[name]
      end
      define_method(sett) do |a|
        self.attributes[name] = a
      end
    end
  end
  
  def self.table_name=(table_name)
    # ...
    # implement this method later
    # if send(table_name) == 'humen'
    #   table_name = 'humans'
    # end
    # self.instance_variable_set(self.table_name, table_name)
    # self.name = table_name
    @table_name = table_name
  end

  def self.table_name
    # ...
    # convert canel case to snake case later
    # use tableize 
    @table_name || self.name.tableize
  end

  def self.all
    # ...
    data = DBConnection.execute(<<-SQL)
    SELECT
    *
    FROM 
    #{self.table_name}
    
    
    SQL
    # debugger
    self.parse_all(data)
  end

  def self.parse_all(results)
    # ...
    arr = []
    results.each do |h| 
      arr << self.new(h)
    end
    arr
  end

  def self.find(id)
    # ...
    data = DBConnection.execute(<<-SQL)
    SELECT
    *
    FROM 
    #{self.table_name}
    WHERE 
    #{self.table_name}.id = #{id}
    SQL
    data.map {|h| self.new(h)}[0]
  end

  def initialize(params = {})
    # ...
    params.each do |k,v|
      attr_name = k.to_sym 
      # debugger
      unless self.class.columns.include?(attr_name)
        raise "unknown attribute '#{attr_name}'" 
      end
    end
        
    params.each {|k, v|  self.send("#{k}=", v)}
    # @attributes = params 
    
  end

  def attributes
    # ...
    @attributes ||= {}
  end

  def attribute_values
    self.attributes.map {|k,v| v}
    # ...
  end

  def insert
    # ...
    data = DBConnection.execute(<<-SQL)
      SELECT
      *
      FROM 
      #{self.table_name}
      WHERE 
      #{self.table_name}.id = #{id}
    SQL
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
