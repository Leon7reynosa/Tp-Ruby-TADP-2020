require 'rspec'
require_relative '../src/Trait'
require_relative '../src/Class'

describe 'Resta de traits' do
  it 'Creo una clase usando el uses y agrego los metodos del trait a la clase y sus instancias' do
    Trait.define do
      name :MiTrait
      method :metodo1 do
        "metodo1 de MiTrait"
      end
      method :metodo2 do |un_numero|
        un_numero + 1
      end
    end

    Trait.define do
      name :MiOtroTrait
      method :metodo1 do
        "metodo1 de MiOtroTrait"
      end
      method :metodo3 do
        "metodo 3 de MiOtroTrait"
      end
    end

    class TodoBienTodoLegal
      uses MiTrait + (MiOtroTrait - :metodo1)
    end

    instancia = TodoBienTodoLegal.new

    expect(instancia.metodo1).to eq("metodo1 de MiTrait")
    expect(instancia.metodo2(84)).to eq(85)
    expect(instancia.metodo3).to eq("metodo 3 de MiOtroTrait")
  end

  it 'Pruebo la falla si la resta es de un metodo que no posee el Trait' do
    Trait.define do
      name :Trait_prueba_1
      method :metodo_1 do
        "Trait B"
      end
    end

    expect {
      class Prueba_Resta
        uses Trait_prueba_1 - :metodo2
      end
    }.to raise_error(MetodoNoExistente)
  end

end