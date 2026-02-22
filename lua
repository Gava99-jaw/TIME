-- Simple Clock GUI for Roblox
-- Активируется в эксплойтах типа Delta, Fluxus, etc.

-- Проверка на запуск в эксплойте
if not isfolder or not makefolder then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Ошибка",
        Text = "Скрипт должен запускаться в эксплойте!",
        Duration = 3
    })
    return
end

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ClockGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

-- Главное окно
local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.Size = UDim2.new(0, 200, 0, 80)
Frame.Position = UDim2.new(0.5, -100, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Закругленные углы
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame

-- Тень
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 0, 0)
Stroke.Thickness = 2
Stroke.Transparency = 0.5
Stroke.Parent = Frame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⏰ Текущее время"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

-- Отображение времени
local TimeLabel = Instance.new("TextLabel")
TimeLabel.Name = "TimeLabel"
TimeLabel.Size = UDim2.new(1, 0, 0, 40)
TimeLabel.Position = UDim2.new(0, 0, 0, 25)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "00:00:00"
TimeLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
TimeLabel.TextSize = 30
TimeLabel.Font = Enum.Font.GothamBlack
TimeLabel.Parent = Frame

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BackgroundTransparency = 0.3
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Frame

-- Закругления для кнопки
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseButton

-- Функция обновления времени
local function updateTime()
    while ScreenGui and ScreenGui.Parent do
        local currentTime = os.date("*t")
        -- Форматируем часы (24-часовой формат)
        local timeString = string.format("%02d:%02d:%02d", 
            currentTime.hour, 
            currentTime.min, 
            currentTime.sec
        )
        
        TimeLabel.Text = timeString
        
        -- Меняем цвет в зависимости от времени суток
        if currentTime.hour >= 6 and currentTime.hour < 12 then
            TimeLabel.TextColor3 = Color3.fromRGB(255, 200, 100) -- Утро (золотой)
        elseif currentTime.hour >= 12 and currentTime.hour < 18 then
            TimeLabel.TextColor3 = Color3.fromRGB(100, 200, 255) -- День (голубой)
        elseif currentTime.hour >= 18 and currentTime.hour < 22 then
            TimeLabel.TextColor3 = Color3.fromRGB(255, 150, 100) -- Вечер (оранжевый)
        else
            TimeLabel.TextColor3 = Color3.fromRGB(150, 100, 255) -- Ночь (фиолетовый)
        end
        
        wait(0.5) -- Обновление каждые полсекунды
    end
end

-- Кнопка закрытия
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Перетаскивание окна
local dragging = false
local dragInput
local dragStart
local startPos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Запускаем обновление времени
spawn(updateTime)

-- Уведомление о загрузке
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Часы",
    Text = "Скрипт загружен! Время показывается в левом верхнем углу",
    Duration = 3
})

-- Информация в консоль
print("✅ Clock GUI loaded successfully!")
print("🕒 Текущее время: " .. os.date("%H:%M:%S"))
print("📌 Перемещай окно мышкой")
