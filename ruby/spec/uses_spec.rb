require 'rspec'
require_relative '../src/Class'
require_relative '../src/Trait'

describe 'Asociacion de traits' do

  it 'Creo un trait y una clase, lo asocio y valido que quede agregado los metodos del trait en la clase' do
    Trait.define do
      name :MiTrait
      method :metodo1 do
        "Hola"
      end

      method :cosa do
        @cosa
      end

      method :metodo2 do |un_numero|
        un_numero + 10 + otra + cosa + nueva
      end
    end

    class Padre
      def nueva
        @nueva
      end
    end

    class MiClase < Padre
      uses MiTrait
      def initialize
        @cosa = 100
        @nueva = 10000
      end
      def otra
        1000
      end
      def metodo1
        "mundo"
      end
    end

    o = MiClase.new

    expect(o.metodo1).to eq("mundo")
    expect(o.metodo2(3)).to eq(11113)
  end

  it 'override trait method' do
    Trait.define do
      name :Trait_Self
      method :m do
        self
      end
    end

    class Padre
      uses Trait_Self
    end

    class Hijo < Padre
    end

    padre = Padre.new
    hijo = Hijo.new

    expect(padre.m).to eql(padre)
    expect(hijo.m).to eql(hijo)
  end
end
