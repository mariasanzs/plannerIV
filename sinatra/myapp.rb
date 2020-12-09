# myapp.rb

require 'sinatra'
require 'json'

require_relative '../src/almacen.rb'
require_relative '../src/compra.rb'
class MyApp < Sinatra::Base

  before do
    cliente = 'cliente'
    @almacen = Almacen.new
    obj = Maquillaje.new('prueba',[4, 5, 6, 7],10.0,5.0,[3, 2, 1, 7],TipoProducto::LABIOS,[['maria15','labios30'],[15,30]])
    @almacen.anadirProducto(obj)
    @cesta = Compra.new(cliente)
  end

  get '/' do
    {:status => 'ok'}.to_json
  end

  get '/disponibilidad/:producto' do
    content_type :json
    nombreproducto = params['producto'].to_s
    begin
      res = @almacen.buscarProducto(nombreproducto).consultarUnidadesDisponibles()
      status 200
      res.to_json
    rescue StandardError
      status 400
      {:status => 'Error: no hay disponibilidad de este producto'}.to_json
    end
  end

  get '/caracteristicas/:producto' do
    content_type :json
    nombreproducto = params['producto']
    begin
      res = @almacen.buscarProducto(nombreproducto).listarCaracteristicasProducto()
      status 200
      res.to_json
    rescue StandardError
      status 400
      {:status => 'Error: no se encontró nada de este producto'}.to_json
    end
  end

  get '/producto/:producto/canjearCodigo/:codigo' do
    content_type :json
    n_codigo = params['codigo']
    nombreproducto = params['producto']
    begin
      res = @almacen.buscarProducto(nombreproducto).canjearCodigo(n_codigo)
      status 200
      res.to_json
    rescue StandardError
      status 400
      {:status => 'Error: No se puede canjear el código'}.to_json
    end
  end

  #HU06 - Como usuario, quiero saber el precio total de mi cesta
  get '/preciocesta' do
    @cesta.calcularPrecioTotal().to_json
  end

  error 404 do
    content_type :json
    {:status => 'Error: ruta no encontrada'}.to_json
  end
end
