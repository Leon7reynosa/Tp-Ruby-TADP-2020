require 'rspec'

describe 'Ruby y el monstruo de la no-validacion' do

  class A
    def m
      self
    end
  end

  class B
  end

  module X
    def m
      self
    end
  end

  it 'ruby no re-bindea metodos bindeados' do
    a = A.new
    B.define_method(:m, &a.method(:m))

    b = B.new
    # no quiero que esto sea verdad (pero lo es)
    expect(b.m).to eql(a)
    # quiero que esto sea verdad
    # expect(b.m).to eql(b)
  end

  it 'ruby no me deja asociar metodos unbounded de clases en otra jerarquia de clases' do
    expect {
      # bind argument must be a subclass of A
      B.define_method(:m, A.instance_method(:m))
    }.to raise_error(TypeError)

    expect {
      # wrong argument type UnboundMethod (expected Proc)
      B.define_method(:m, &A.instance_method(:m))
    }.to raise_error(TypeError)
  end

  it 'ruby SI me deja asociar metodos unbounded de modulos en clases' do
    A.define_method(:mX, X.instance_method(:m))
    B.define_method(:mX, X.instance_method(:m))
    a = A.new
    b = B.new
    expect(a.mX).to eql(a)
    expect(b.mX).to eql(b)
  end

  it 'ruby me deja definir los bloques sin bindear' do
    bloque = proc {
      self
    }
    A.define_method(:m2, &bloque)
    B.define_method(:m3, &bloque)
    a = A.new
    b = B.new
    expect(a.m2).to eql(a)
    expect(b.m3).to eql(b)
  end
end