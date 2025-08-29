class Node
  include Comparable
  attr_accessor :data, :left_child, :right_child

  def <=>(other)
    if other.is_a?(Node)
      @data <=> other.data
    else
      nil
    end
  end
  
  def initialize(data)
    @data = data
    @left_child = nil
    @right_child = nil
  end
  
end