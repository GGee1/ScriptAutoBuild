-- Gui to Lua
-- Version: 3.2

-- Instances:

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Frame_2 = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TextButton = Instance.new("TextButton")
local ScrollingFrame = Instance.new("ScrollingFrame")

--Properties:

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.272653729, 0, 0.191542283, 0)
Frame.Size = UDim2.new(0, 184, 0, 252)

Frame_2.Parent = Frame
Frame_2.BackgroundColor3 = Color3.fromRGB(81, 81, 81)
Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_2.BorderSizePixel = 0
Frame_2.Size = UDim2.new(0, 184, 0, 27)

UICorner.Parent = Frame

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(79, 79, 79)
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.070652172, 0, 0.825396836, 0)
TextButton.Size = UDim2.new(0, 158, 0, 35)
TextButton.Font = Enum.Font.SourceSans
TextButton.Text = "Start"
TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton.TextSize = 14.000

ScrollingFrame.Parent = Frame
ScrollingFrame.Active = true
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(139, 139, 139)
ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Position = UDim2.new(0.0326086953, 0, 0.138888896, 0)
ScrollingFrame.Size = UDim2.new(0, 171, 0, 163)

-- Scripts:

local function FKTL_fake_script() -- Frame_2.UIDragger 
	local script = Instance.new('LocalScript', Frame_2)

	local UserInputService = game:GetService("UserInputService")
	
	local frame = script.Parent
	local dragging = false
	local dragInput, mousePos, framePos
	
	local function update(input)
	    local delta = input.Position - mousePos
	    frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
	end
	
	frame.InputBegan:Connect(function(input)
	    if input.UserInputType == Enum.UserInputType.MouseButton1 then
	        dragging = true
	        mousePos = input.Position
	        framePos = frame.Position
	
	        input.Changed:Connect(function()
	            if input.UserInputState == Enum.UserInputState.End then
	                dragging = false
	            end
	        end)
	    end
	end)
	
	frame.InputChanged:Connect(function(input)
	    if input.UserInputType == Enum.UserInputType.MouseMovement then
	        dragInput = input
	    end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
	    if dragging and input == dragInput then
	        update(input)
	    end
	end)
	
	
end
coroutine.wrap(FKTL_fake_script)()
local function JYKAYJE_fake_script() -- TextButton.AutoBuildScript 
	local script = Instance.new('LocalScript', TextButton)

	-- Função que escolhe o bloco correto
	function getBlockByType(blockType)
	    for _, block in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
	        if block.Name == blockType then
	            return block
	        end
	    end
	    return nil -- Caso o bloco não seja encontrado
	end
	
	-- Função que coloca, escala e pinta o bloco
	function placeBlock(blockData)
	    local character = game.Players.LocalPlayer.Character
	    local humanoid = character:FindFirstChild("Humanoid")
	    
	    if humanoid then
	        local tool = getBlockByType(blockData.blockType)
	        if tool then
	            tool.Parent = character
	            humanoid:EquipTool(tool)
	            
	            -- Colocar o bloco
	            local args = {
	                [1] = CFrame.new(blockData.position) -- Posição do bloco
	            }
	            game:GetService("ReplicatedStorage").PlaceBlock:FireServer(unpack(args))
	            
	            -- Escalar o bloco
	            local argsScale = {
	                [1] = tool, -- Referência ao bloco que foi colocado
	                [2] = blockData.scale -- Escala do bloco
	            }
	            game:GetService("ReplicatedStorage").ResizeBlock:FireServer(unpack(argsScale))
	            
	            -- Pintar o bloco
	            local argsColor = {
	                [1] = tool, -- Referência ao bloco que foi colocado
	                [2] = blockData.color -- Cor do bloco
	            }
	            game:GetService("ReplicatedStorage").PaintBlock:FireServer(unpack(argsColor))
	        end
	    end
	end
	
	-- Função que percorre toda a planta baixa e constroi, escala e pinta os blocos
	function build()
	    for _, blockData in ipairs(_G.blueprint) do
	        placeBlock(blockData)
	        wait(0.5) -- Pequeno delay para cada bloco
	    end
	end
	
	-- Conectar a função de construção ao clique do botão
	script.Parent.MouseButton1Click:Connect(function()
	    build()
	end)
	
	
end
coroutine.wrap(JYKAYJE_fake_script)()
local function APRV_fake_script() -- ScrollingFrame.LoadBuildDataScript 
	local script = Instance.new('Script', ScrollingFrame)

	-- Função para dividir a string de dados em uma tabela
	function split(inputstr, sep)
	    if sep == nil then
	        sep = "%s"
	    end
	    local t = {}
	    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
	        table.insert(t, str)
	    end
	    return t
	end
	
	-- Função para carregar e processar os dados do arquivo .build
	function loadBuildData(data)
	    local blueprint = {}
	    for line in string.gmatch(data, "[^\n]+") do
	        local blockData = split(line, ", ")
	        table.insert(blueprint, {
	            blockType = blockData[1],
	            position = Vector3.new(tonumber(blockData[2]), tonumber(blockData[3]), tonumber(blockData[4])),
	            scale = Vector3.new(tonumber(blockData[5]), tonumber(blockData[6]), tonumber(blockData[7])),
	            color = Color3.fromRGB(tonumber(blockData[8]), tonumber(blockData[9]), tonumber(blockData[10]))
	        })
	    end
	    return blueprint
	end
	
	-- Função para criar um texto para cada bloco no ScrollingFrame
	function createBlockText(block)
	    local textLabel = Instance.new("TextLabel")
	    textLabel.Size = UDim2.new(1, 0, 0, 50)
	    textLabel.Text = string.format("Type: %s, Position: (%d, %d, %d), Scale: (%d, %d, %d), Color: (%d, %d, %d)",
	        block.blockType,
	        block.position.X, block.position.Y, block.position.Z,
	        block.scale.X, block.scale.Y, block.scale.Z,
	        block.color.R * 255, block.color.G * 255, block.color.B * 255)
	    textLabel.Parent = script.Parent
	end
	
	-- Carregar os dados do arquivo
	local blueprint = loadBuildData(buildData)
	
	-- Tornar o blueprint global para que outros scripts possam acessá-lo
	_G.blueprint = blueprint
	
	-- Adicionar os textos ao ScrollingFrame
	for _, block in ipairs(blueprint) do
	    createBlockText(block)
	end
	
	
end
coroutine.wrap(APRV_fake_script)()
