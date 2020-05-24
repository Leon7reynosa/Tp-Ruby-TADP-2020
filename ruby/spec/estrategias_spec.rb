require 'rspec'
require_relative '../src/Class'
require_relative '../src/Trait'
require_relative '../src/Estrategias'

describe 'Tests de Estrategias de Resolucion de Conflictos' do


  it "Estrategia Default - hace un raise error" do
    Trait.define do
      name :Trait1
      method :metodo1 do
        1
      end
    end

    Trait.define do
      name :Trait2
      method :metodo1 do
        2
      end
    end

    class TestClass
      uses Trait1 + Trait2
    end

    instancia = TestClass.new
    expect{instancia.metodo1}.to raise_error(TraitError,"Excepcion de colision de metodos")
  end

  it 'Prueba estrategia Orden' do
    Trait.define do
      name :Trait1
      setEstrategia EstrategiaEnOrden.new
      method :metodo1 do |texto|
        p texto
      end
    end

    Trait.define do
      name :Trait2
      method :metodo1 do |*texto|
        p @t2
      end
    end

    Trait.define do
      name :Trait3
      method :metodo1 do |*x|
        p "Hola del Trait3"
      end
    end

    class UnaClase
      attr_accessor :t1,:t2
      def initialize
        @t1 = "Hola del Trait1 - por parametro"
        @t2 = "Hola del Trait2 - var de clase"
      end
      uses Trait1 + Trait2 + Trait3
    end

    instancia = UnaClase.new

    instancia.metodo1(instancia.t1)
    expect(instancia.metodo1(instancia.t1)).to eq("Hola del Trait3")
  end

  it 'Prueba estrategia Fold' do
    Trait.define do
      name :TraitA
      setEstrategia EstrategiaFold.new(proc{|a, b| a + b} )
      method :metodo1 do |param1, param2|
        @uno + param1 + param2
      end
    end

    Trait.define do
      name :TraitB
      method :metodo1 do |param1, param2|
        @cuatro + param1 - param2
      end
    end

    class OtraClase
      uses TraitA + TraitB
      def initialize
        @uno = 1
        @cuatro = 4
      end
    end

    instancia1  = OtraClase.new

    # @uno + param1 + param2 + @cuatro + param1 - param2
    # 1 + 10 + 200 + 4 + 10 - 200
    expect(instancia1.metodo1(10,200)).to eq(25)
  end

  it 'Prueba estrategia Fold Rework' do
    Trait.define do
      name :TraitA
      setEstrategia EstrategiaFold.new(proc{|a, b| a + b + @cosntante} )
      # setEstrategia EstrategiaFold.new(proc{ @secret } )
      method :metodo1 do
        1
      end
    end

    Trait.define do
      name :TraitB
      method :metodo1 do
        4
      end
    end

    class TestClass
      def initialize
        @cosntante = 9
      end
      uses TraitA + TraitB
    end

    instancia  = TestClass.new

    expect(instancia.metodo1).to eq(14)
  end

  it 'Prueba estrategia Fold 3 traits' do
    Trait.define do
      name :TraitA
      setEstrategia EstrategiaFold.new(proc{|a, b| a * b} )
      method :metodo1 do
        -1
      end
    end

    Trait.define do
      name :TraitB
      method :metodo1 do
        4
      end
    end

    Trait.define do
      name :TraitC
      method :metodo1 do
        4
      end
    end

    class OtraClase
      uses TraitA + TraitB + TraitC
    end

    instancia1  = OtraClase.new

    expect(instancia1.metodo1).to eq(-16)
  end

  it 'Prueba Estrategia Condicional' do
    Trait.define do
      name :TraitAlpha
      setEstrategia EstrategiaDeCondicional.new(proc{|a| a > 3} )
      method :metodo1 do
        1
      end
    end

    Trait.define do
      name :TraitBeta
      method :metodo1 do
        4
      end
    end

    class OtraClase
      uses TraitAlpha + TraitBeta
    end

    instancia2 = OtraClase.new

    expect(instancia2.metodo1).to eq(4)
  end

  it 'Prueba Estrategia Condicional - Ningun metodo cumple la condicion' do
    Trait.define do
      name :TraitAlpha
      setEstrategia EstrategiaDeCondicional.new(proc{|a| a > 3} )
      method :metodo1 do
        1
      end
      method :metodo2 do
        p "Chau del UnTrait"
      end
    end

    Trait.define do
      name :TraitBeta
      method :metodo1 do
        2
      end
    end

    class TestClass
      uses TraitAlpha + TraitBeta
    end

    instancia = TestClass.new

    expect{instancia.metodo1}.to raise_error(RuntimeError,"Ningun metodo cumple la condición dada")
  end

  it 'Prueba Estrategia Condicional Rework - usa variables de clase' do
    Trait.define do
      name :Trait1
      setEstrategia EstrategiaDeCondicional.new proc{|a| a > 3}
      method :metodo1 do
        @varT1
      end
      method :m2 do |a|
        a
      end
    end

    Trait.define do
      name :Trait2
      method :metodo1 do
        @varT2
      end
      method :m2 do |a|
        a + 2
      end
    end

    class Clase
      attr_accessor :varT1, :varT2
      def initialize
        @varT1 = 1
        @varT2 = 4
      end
      uses Trait1 + Trait2
    end

    instancia = Clase.new
    p instancia.varT1
    p instancia.varT2
    expect(instancia.metodo1).to eq(4)

    p instancia.varT1 = 5
    #expect(instancia.metodo1).to eq(5)
    expect(instancia.m2(2)).to eq(4)
  end
end
