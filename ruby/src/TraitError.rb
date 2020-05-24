class TraitError < RuntimeError
  def self.noResolvisteLosConflictosDeTraits
    raise TraitError.new("Excepcion de colision de metodos")
  end
end

class MetodoNoExistente < StandardError;
  def message
    raise "El Metodo que se quiere borrar no existe"
  end
end