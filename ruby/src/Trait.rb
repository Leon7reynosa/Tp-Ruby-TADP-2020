require_relative '../src/TraitError'
require_relative '../src/Estrategias'
class Trait

  def initialize(_estrategia = EstrategiaDefault.new)
    @diccionario_de_metodos = {}
    @estrategia = _estrategia
  end

  def self.define(&block)
    Trait.new().instance_eval(&block)
  end

  def name(nombre)
    Object.const_set nombre, self
  end

  def method(nombre_metodo, &block)
    @diccionario_de_metodos[nombre_metodo.to_sym] = block
  end

  def +(unTrait)
    nuevo = Trait.new()
    diccionario_generado = sin_repetidos(self.dame_tu_diccionario, unTrait.dame_tu_diccionario)
    nuevo.agregar_metodos(diccionario_generado)
    nuevo.setEstrategia(self.getEstrategia)
    nuevo
  end

  def &(unTrait)
    nuevo = Trait.new()
    Trait.setEstrategia(EstrategiaSumaPreferencial.new)
    return nuevo +

    diccionario_generado = sin_repetidos(self.dame_tu_diccionario, unTrait.dame_tu_diccionario, EstrategiaSumaPreferencial.new)
    nuevo.agregar_metodos(diccionario_generado)
    nuevo.setEstrategia(self.getEstrategia)
    nuevo
  end

  def -(metodo_a_restar)
    trait_de_retorno = Trait.new()
    diccionario_metodos = self.dame_tu_diccionario
    if diccionario_metodos.delete(metodo_a_restar).nil?
      raise MetodoNoExistente
    end
    trait_de_retorno.agregar_metodos(diccionario_metodos)
    trait_de_retorno
  end

  def <<(rename)
    rename.do_rename(@diccionario_de_metodos)
    self
  end

  def agregar_metodos_al_diccionario( diccionario_metodos , hash_metodos)
    hash_metodos.each do |key, value|
      diccionario_metodos[key.to_sym] = value
    end
  end

  def agregar_metodos(un_diccionario)
    un_diccionario.each do |metodo_symbol, metodo_bloque|
      self.dame_tu_diccionario[metodo_symbol] = metodo_bloque
    end
  end

  def dame_tu_diccionario
    @diccionario_de_metodos
  end

  def aplicate_sobre(unaClase)
    @diccionario_de_metodos.each do |key, value|
      agregar_metodo(unaClase, key, value)
    end
  end

  def agregar_metodo(unaClase, nombre_metodo, bloque)
    unaClase.define_method(nombre_metodo, &bloque)
  end

  def getEstrategia
    @estrategia
  end

  def setEstrategia(unaEstrategia)
    @estrategia = unaEstrategia
  end


  private
  #Aca agregamos un parametro estrategia que si no le pasamos nada va a ser nil y usara la estrategia del trait
  def sin_repetidos(unHash, otroHash, estrategia = nil)
    hash_nuevo = unHash

    otroHash.each do |metodo_symbol, metodo_bloque|
      if unHash.has_key?(metodo_symbol)
        if estrategia.nil?
          hash_nuevo[metodo_symbol] = self.getEstrategia.resolver_conflicto(unHash[metodo_symbol], otroHash[metodo_symbol])
        else
          hash_nuevo[metodo_symbol] = estrategia.resolver_conflicto(unHash[metodo_symbol], otroHash[metodo_symbol])
        end

      else
        hash_nuevo[metodo_symbol] = metodo_bloque
      end
    end
    hash_nuevo
  end

end
