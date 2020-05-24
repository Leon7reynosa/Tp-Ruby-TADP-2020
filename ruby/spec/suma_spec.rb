require 'rspec'
require_relative '../src/Trait'
require_relative '../src/Class'

describe 'Suma de traits' do
  it 'Creo una clase usando el uses y agrego los metodos del trait a la clase y sus instancias' do

    Trait.define do
      name :Trait_A
      method :metodo_1 do
        "metodo 1 del trait A"
      end
      method :metodo_2 do |un_numero|
        un_numero * 0 + 42
      end
    end

    Trait.define do
      name :Trait_B
      method :metodo_1 do
        puts "metodo 1 del trait B"
      end
    end

    Trait.define do
      name :Trait_C
      method :metodo_3 do
        "metodo 3"
      end
    end

    class Clase_Prueba
      uses Trait_A + Trait_B + Trait_C

      def metodo_1
        "Clase Prueba"
      end
    end

    instancia_prueba = Clase_Prueba.new

    expect(instancia_prueba.metodo_1).to eq("Clase Prueba")
    expect(instancia_prueba.metodo_2(45)).to eq(42)
    expect(instancia_prueba.metodo_3).to eq("metodo 3")
  end

  it 'Verifico la exepción en caso de Traits con métodos del mismo nombre' do #PASA (ejm del TP)
    Trait.define do
      name :MiTrait
      method :metodo1 do
        "metodo 1 de MiTrait"
      end
      method :metodo2 do |un_numero|
        un_numero + 10
      end
    end

    Trait.define do
      name :MiOtroTrait
      method :metodo1 do
        "metodo 1 de MiOtroTrait"
      end
      method :metodo3 do
        "metodo 3 de MiOtroTrait"
      end
    end

    class Conflicto
      uses MiTrait + MiOtroTrait
    end

    instancia = Conflicto.new

    expect(instancia.metodo2(84)).to eq(94)
    expect(instancia.metodo3).to eq("metodo 3 de MiOtroTrait")
    expect { instancia.metodo1 }.to raise_error(TraitError)
  end
end