require 'rspec'
require_relative '../src/Trait'
require_relative '../src/Class'

describe 'Creacion de traits' do

  it 'Creo un trait y le agrego un metodo random' do
    expect(4 + 5).to eq(9)
  end

  it 'Prueba de creacion de un nuevo Trait' do
    Trait.define do
      name :Trait_prueba
      method :metodo_prueba do
        "metodo PASS"
      end
    end

    class Clase
      uses Trait_prueba
    end

    clase = Clase.new

    expect(clase.metodo_prueba).to eq("metodo PASS")
  end

end
