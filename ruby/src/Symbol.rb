class Symbol
  def >>(otro_symbol)
    Rename.new(self, otro_symbol)
  end
end

class Rename
  attr_reader :old, :new

  def initialize(old, new)
    @old = old
    @new = new
  end

  def do_rename(dict)
    if dict.has_key? self.old
      dict[self.new] = dict.delete(self.old)
      dict
    end
  end
end