local event = import("libs/event")
local lust = import("libs/lust")
local describe, it, expect = lust.describe, lust.it, lust.expect

describe("event", function()
    it("observe", function()
        local test = nil
        local cb = function()
            test = true
        end
        local spy = lust.spy(cb)
        local destroy = event.Observe("TestEvent"):subscribe(cb)
        expect(detroy).to.be.a("function")
        event.Call("TestEvent")
        destroy()
        expect(#spy).to.be(1)
        expect(test).to.be.truthy()
    end)
end)