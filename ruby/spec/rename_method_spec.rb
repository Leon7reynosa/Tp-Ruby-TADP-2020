require 'rspec'
require_relative '../src/Trait'
require_relative '../src/Class'
require_relative '../src/Symbol'

describe 'Rename de metodos' do
  it 'Pruebo renombrar uno de los metodos de un Trait' do
    Trait.define do
      name :TraitA
      method :metodo_1 do
        "saludar"
      end
    end

    class Clase_Prueba
      uses TraitA << (:metodo_1 >> :saludar)
    end

    instancia_prueba = Clase_Prueba.new

    expect(instancia_prueba.saludar).to eq("saludar")
  end

  it 'Pruebo renombrar uno de los metodos de un Trait' do
    Trait.define do
      name :Trait_A
      method :metodo_1 do
        "Trait A"
      end
    end

    Trait.define do
      name :Trait_B
      method :metodo_1 do
        "Trait B"
      end
    end

    class Clase_Prueba
      uses Trait_A + ( Trait_B << (:metodo_1 >> :trait_1_metodo_1) )
    end

    instancia_prueba = Clase_Prueba.new

    expect(instancia_prueba.metodo_1).to eq("Trait A")
  end

end