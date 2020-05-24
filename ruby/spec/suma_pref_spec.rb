require 'rspec'
require_relative '../src/Class'
require_relative '../src/Trait'

describe 'Asociacion de traits' do

  it 'Probamos la suma preferencial' do
    Trait.define do
      name :MiTrait
      method :metodo1 do |pepe|
        @pepe
      end

      method :cosa do
        @cosa
      end

      method :metodo2 do |un_numero|
        un_numero + 10 + otra + cosa + nueva
      end
    end

    Trait.define do
      name :OtroTrait
      method :metodo1 do
        "Chau"
      end
      method :metodo5 do
        "Pepito"
      end
    end

    class Padre
      def nueva
        @nueva
      end
    end

    class MiClase < Padre
      uses MiTrait & OtroTrait
      def initialize
        @cosa = 100
        @nueva = 10000
        @pepe = "Hola"
      end
      def otra
        1000
      end

    end

    o = MiClase.new

    expect(o.metodo1("Hola")).to eq("Hola")
  end

  it 'Probamos la suma preferencial del enunciado' do

    Trait.define do
      name :MiTrait
      method :metodo1 do
        "Hola"
      end
      method :metodo2 do |un_numero|
        un_numero * 0 + 42
      end
    end


    Trait.define do
      name :MiOtroTrait
      method :metodo1 do
        "kawuabonga"
      end
      method :metodo3 do
        "zaraza"
      end

    end


    class MiClase
      uses MiTrait & MiOtroTrait
    end

    o = MiClase.new

    expect(o.metodo1).to eq("Hola")
  end

end
