local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Veristok/bsb/refs/heads/main/lib.lua"))()

local Window = UI:CreateWindow({
    Name = "Celestial UI"
})

local Main = Window:CreateTab("Main")

Main:AddToggle({
    Name = "Fly",
    Flag = "Fly",
    Default = false,
    Callback = function(v)
        print("Fly:", v)
    end
})
