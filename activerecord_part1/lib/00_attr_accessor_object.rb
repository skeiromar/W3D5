class AttrAccessorObject
  def self.my_attr_accessor(*names)
    # ...

    # names = :age, :color defined as attr_accessor :age, :color
    # [:age, :color].each do |name| 
    # define_method(name + '=') do |arg| -> self.instance_variable_set(@ + 'name', arg)
    # we defined a method called age= and color= and then took an argument for it.
    # then we used a ruby language method to get the instance variable for @age defined in it and setting it to the arg
    # then we define two more methods again called :age, :color and then we are passing a dummy block and then 
    # we are using ruby instance variable to get the instance variable.
    names.each do |name|
      sett = name.to_s + '='
      define_method(sett) do |set|
        set_inst_var = '@' + name.to_s
        self.instance_variable_set(set_inst_var, set)
      end
      
      define_method(name) do |_ = 1|
        instance_var = '@' + name.to_s
        self.instance_variable_get(instance_var)
      end

    end 

  end
end
