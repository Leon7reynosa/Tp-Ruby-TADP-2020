
class EstrategiaDefault
  def resolver_conflicto(m1, m2)
    proc { TraitError.noResolvisteLosConflictosDeTraits()}
  end
end

class EstrategiaEnOrden
  def resolver_conflicto(metodo_bloque_1 , metodo_bloque_2)
    proc { |args|
      instance_exec args, &metodo_bloque_1
      instance_exec args, &metodo_bloque_2
    }
  end
end



class Estrategia

  attr_accessor :estrategia

  def initialize(estrategia)
    @estrategia = estrategia
  end

  def resolver_conflicto(bloque_1 , bloque_2)
    _estrategia = self.estrategia
    # TODO Fixeado, lo dejo como referencia
    # TODO este proc va a recibir los posibles parámetros que tenga el método, acá como no los están definiendo se los pierden
    # Agreguen un vararg a este proc:
    # [1] pry(main)> a = proc { |*args| puts(args) }
    # => #<Proc:0x00007faa662869d8@(pry):1>
    # [2] pry(main)> a.call(1,2,3)
    # 1
    # 2
    # 3
    # => nil
    # TODO luego esos *args los van a usar para la estrategia (pueden pasar instance_exec(bloque1, bloque2, *args) y que esa sea la firma para resolver conflictos, dos bloques y N argumentos, donde N puede ser 0 o más)
    proc {|*args| instance_exec(bloque_1, bloque_2, *args, &_estrategia)}
  end
end

class EstrategiaSumaPreferencial < Estrategia

  def initialize
    @estrategia = proc { |m1, m2, *args|
      instance_exec(*args, &m1)
    }
  end

end

class EstrategiaFold < Estrategia
  def initialize(join_function)
    @estrategia = proc { |m1, m2, *args|
      m1_response = instance_exec(*args, &m1)
      m2_response = instance_exec(*args, &m2)
      instance_exec(m1_response, m2_response, &join_function)
    }
  end
end

class EstrategiaDeCondicional < Estrategia

  def initialize(funCondicional)
    @estrategia = proc { |m1, m2, *args|
      if instance_exec (instance_exec *args, &m1), &funCondicional
        # instance_exec args, &m1
        instance_exec *args, &m1
        elsif instance_exec (instance_exec *args, &m2), &funCondicional
         # instance_exec args, &m2
          instance_exec *args, &m2
      else
         raise "Ningun metodo cumple la condición dada"
      end
    }
  end
end