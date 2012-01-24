describe "Joosy", ->

  it "should properly initialize", ->
    expect(Joosy.debug).toBeFalsy()
    expect(Joosy.Modules).toBeDefined()
    expect(Joosy.Resource).toBeDefined()
    
  it "should declare namespaces", ->
    Joosy.namespace 'Namespaces.Test1'
    Joosy.namespace 'Namespaces.Test2', ->
      @bingo = 'bongo'
    expect(window.Namespaces.Test1).toBeDefined()
    expect(window.Namespaces.Test2.bingo).toEqual('bongo')
    
  it "should generate proper UUIDs", ->
    uuids = []
    2.times -> 
      uuids.push Joosy.uuid()
    expect(uuids.unique().length).toEqual(2)
    expect(uuids[0]).toMatch /[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[0-9A-F]{4}-[0-9A-F]{12}/
    
  it "should build proper URLs", ->
    expect(Joosy.buildUrl 'http://www.org').toEqual('http://www.org')
    expect(Joosy.buildUrl 'http://www.org#hash').toEqual('http://www.org#hash')
    expect(Joosy.buildUrl 'http://www.org', {foo: 'bar'}).toEqual('http://www.org?foo=bar')
    expect(Joosy.buildUrl 'http://www.org?bar=baz', {foo: 'bar'}).toEqual('http://www.org?bar=baz&foo=bar')
    
  it "should preload images", ->
    path   = "/spec/javascripts/support/images/"
    images = [path+"okay.jpg", path+"okay.jpg"]
    
    callback = sinon.spy()
    
    runs -> Joosy.preloadImages path+"coolface.jpg", callback
    waits(150)
    runs -> expect(callback.callCount).toEqual(1)
    
    runs -> Joosy.preloadImages images, callback
    waits(150)
    runs -> expect(callback.callCount).toEqual(2)