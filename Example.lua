local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local function patchTabForImage(tab)
    if tab.Image then return end

    local Creator = WindUI.Creator
    local New = Creator.New
    
    function tab:Image(options)
        options = options or {}
        local imageId = options.Image
        local desc = options.Description
        local cornerRadius = options.CornerRadius or 12
        local height = options.Height or 150
        local mode = options.Mode or "Crop"

        if not imageId then
            warn("[WindUI.Image] Missing 'Image' property.")
            return
        end

        local container = New("Frame", {
            Size = UDim2.new(1, 0, 0, height),
            BackgroundTransparency = 1,
            Parent = tab.UIElements.ContainerFrame
        })
        
        local scaleType = (mode == "Fill") and Enum.ScaleType.Fit or Enum.ScaleType.Crop
        
        local imageLabel = New("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            Image = "rbxassetid://" .. tostring(imageId),
            ScaleType = scaleType, 
            BackgroundTransparency = 1,
            Parent = container
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0, cornerRadius)
            })
        })

        if desc then
            container.AutomaticSize = "Y"
            
            local descriptionLabel = New("TextLabel", {
                Text = desc,
                TextSize = 14,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutomaticSize = "Y",
                BackgroundTransparency = 1,
                ThemeTag = { TextColor3 = "Text" },
                TextTransparency = 0.4,
                Parent = container,
                Size = UDim2.new(1, 0, 0, 0)
            })

            New("UIListLayout", {
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = container
            })
            
            imageLabel.LayoutOrder = 1
            imageLabel.Size = UDim2.new(1, 0, 0, height)
            descriptionLabel.LayoutOrder = 2
        end

        local imageObject = {
            __type = "Image",
            Container = container,
            ImageLabel = imageLabel,
            DescriptionLabel = descriptionLabel,
            SetScaleType = function(self, newScaleType)
                self.ImageLabel.ScaleType = newScaleType
            end,
            Destroy = function() container:Destroy() end
        }
        
        table.insert(tab.Elements, imageObject)
        return imageObject
    end
end

WindUI:Localization({
    Enabled = true,
    Prefix = "loc:",
    DefaultLanguage = "en",
    Translations = {
        ["ru"] = {
            ["WINDUI_EXAMPLE"] = "WindUI Пример",
            ["WELCOME"] = "Добро пожаловать в WindUI!",
            ["LIB_DESC"] = "Библиотека для создания красивых интерфейсов",
            ["SETTINGS"] = "Настройки",
            ["APPEARANCE"] = "Внешний вид",
            ["FEATURES"] = "Функционал",
            ["UTILITIES"] = "Инструменты",
            ["UI_ELEMENTS"] = "UI Элементы",
            ["CONFIGURATION"] = "Конфигурация",
            ["SAVE_CONFIG"] = "Сохранить конфигурацию",
            ["LOAD_CONFIG"] = "Загрузить конфигурацию",
            ["THEME_SELECT"] = "Выберите тему",
            ["TRANSPARENCY"] = "Прозрачность окна",
            ["IMAGE_GALLERY"] = "Галерея"
        },
        ["en"] = {
            ["WINDUI_EXAMPLE"] = "WindUI Example",
            ["WELCOME"] = "Welcome to WindUI!",
            ["LIB_DESC"] = "Beautiful UI library for Roblox",
            ["SETTINGS"] = "Settings",
            ["APPEARANCE"] = "Appearance",
            ["FEATURES"] = "Features",
            ["UTILITIES"] = "Utilities",
            ["UI_ELEMENTS"] = "UI Elements",
            ["CONFIGURATION"] = "Configuration",
            ["SAVE_CONFIG"] = "Save Configuration",
            ["LOAD_CONFIG"] = "Load Configuration",
            ["THEME_SELECT"] = "Select Theme",
            ["TRANSPARENCY"] = "Window Transparency",
            ["IMAGE_GALLERY"] = "Image Gallery"
        }
    }
})

WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

local function gradient(text, startColor, endColor)
    local result = ""
    for i = 1, #text do
        local t = (i - 1) / (#text - 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', r, g, b, text:sub(i, i))
    end
    return result
end

WindUI:Popup({
    Title = gradient("WindUI Demo", Color3.fromHex("#6A11CB"), Color3.fromHex("#2575FC")),
    Icon = "sparkles",
    Content = "loc:LIB_DESC",
    Buttons = {
        {
            Title = "Get Started",
            Icon = "arrow-right",
            Variant = "Primary",
            Callback = function() end
        }
    }
})

local Window = WindUI:CreateWindow({
    Title = "loc:WINDUI_EXAMPLE",
    Icon = "palette",
    Author = "loc:WELCOME",
    Folder = "WindUI_Example",
    Size = UDim2.fromOffset(580, 490),
    Theme = "Dark",
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
            WindUI:Notify({
                Title = "User Profile",
                Content = "User profile clicked!",
                Duration = 3
            })
        end
    },
    SideBarWidth = 200,
})

Window:Tag({
    Title = "v1.6.4",
    Color = Color3.fromHex("#30ff6a")
})
Window:Tag({
    Title = "Beta",
    Color = Color3.fromHex("#315dff")
})
local TimeTag = Window:Tag({
    Title = "00:00",
    Color = Color3.fromHex("#000000")
})

local hue = 0
task.spawn(function()
	while true do
		local now = os.date("*t")
		local hours = string.format("%02d", now.hour)
		local minutes = string.format("%02d", now.min)
		
		hue = (hue + 0.01) % 1
		local color = Color3.fromHSV(hue, 1, 1)
		
		TimeTag:SetTitle(hours .. ":" .. minutes)
		TimeTag:SetColor(color)

		task.wait(0.06)
	end
end)

Window:CreateTopbarButton("theme-switcher", "moon", function()
    WindUI:SetTheme(WindUI:GetCurrentTheme() == "Dark" and "Light" or "Dark")
    WindUI:Notify({
        Title = "Theme Changed",
        Content = "Current theme: "..WindUI:GetCurrentTheme(),
        Duration = 2
    })
end, 990)

local Tabs = {
    Main = Window:Section({ Title = "loc:FEATURES", Opened = true }),
    Settings = Window:Section({ Title = "loc:SETTINGS", Opened = true }),
    Utilities = Window:Section({ Title = "loc:UTILITIES", Opened = true })
}

local TabHandles = {
    Elements = Tabs.Main:Tab({ Title = "loc:UI_ELEMENTS", Icon = "layout-grid", Desc = "UI Elements Example" }),
    ImageGallery = Tabs.Main:Tab({ Title = "loc:IMAGE_GALLERY", Icon = "image" }),
    Appearance = Tabs.Settings:Tab({ Title = "loc:APPEARANCE", Icon = "brush" }),
    Config = Tabs.Utilities:Tab({ Title = "loc:CONFIGURATION", Icon = "settings" })
}

patchTabForImage(TabHandles.ImageGallery)

TabHandles.Elements:Paragraph({
    Title = "Interactive Components",
    Desc = "Explore WindUI's powerful elements",
    Image = "component",
    ImageSize = 20,
    Color = Color3.fromHex("#30ff6a"),
})

TabHandles.Elements:Divider()

local toggleState = false
local featureToggle = TabHandles.Elements:Toggle({
    Title = "Enable Advanced Features",
    Desc = "Unlocks additional functionality",
    Value = false,
    Callback = function(state) 
        toggleState = state
        WindUI:Notify({
            Title = "Features",
            Content = state and "Features Enabled" or "Features Disabled",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local intensitySlider = TabHandles.Elements:Slider({
    Title = "Effect Intensity",
    Desc = "Adjust the effect strength",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(value)
        print("Intensity set to:", value)
    end
})

local modeDropdown = TabHandles.Elements:Dropdown({
    Title = "Select Mode",
    Values = { "Standard", "Advanced", "Expert" },
    Value = "Standard",
    Callback = function(option)
        WindUI:Notify({
            Title = "Mode Changed",
            Content = "Selected: "..option,
            Duration = 2
        })
    end
})

TabHandles.Elements:Divider()

TabHandles.Elements:Button({
    Title = "Show Notification",
    Icon = "bell",
    Callback = function()
        WindUI:Notify({
            Title = "Hello WindUI!",
            Content = "This is a sample notification",
            Icon = "bell",
            Duration = 3
        })
    end
})

TabHandles.Elements:Colorpicker({
    Title = "Select Color",
    Default = Color3.fromHex("#30ff6a"),
    Transparency = 0,
    Callback = function(color, transparency)
        WindUI:Notify({
            Title = "Color Changed",
            Content = "New color: "..color:ToHex().."\nTransparency: "..transparency,
            Duration = 2
        })
    end
})

TabHandles.ImageGallery:Paragraph({
    Title = "Image Showcase",
    Desc = "非wind官方功能",
    Image = "camera",
    ImageSize = 20,
    Color = "White"
})

local galleryImages = {}

local image1 = TabHandles.ImageGallery:Image({
    Image = "7488932274",
    Description = "完美主义",
    Height = 200,
})
table.insert(galleryImages, image1)

local image2 = TabHandles.ImageGallery:Image({
    Image = "7488932274",
    Description = "可用于展示",
    Height = 200,
})
table.insert(galleryImages, image2)

TabHandles.Appearance:Paragraph({
    Title = "Customize Interface",
    Desc = "Personalize your experience",
    Image = "palette",
    ImageSize = 20,
    Color = "White"
})

local themes = {}
for themeName, _ in pairs(WindUI:GetThemes()) do
    table.insert(themes, themeName)
end
table.sort(themes)

local themeDropdown = TabHandles.Appearance:Dropdown({
    Title = "loc:THEME_SELECT",
    Values = themes,
    Value = "Dark",
    Callback = function(theme)
        WindUI:SetTheme(theme)
        WindUI:Notify({
            Title = "Theme Applied",
            Content = theme,
            Icon = "palette",
            Duration = 2
        })
    end
})

local transparencySlider = TabHandles.Appearance:Slider({
    Title = "loc:TRANSPARENCY",
    Value = { 
        Min = 0,
        Max = 1,
        Default = 0.2,
    },
    Step = 0.1,
    Callback = function(value)
        Window:ToggleTransparency(tonumber(value) > 0)
        WindUI.TransparencyValue = tonumber(value)
    end
})

local canchangetheme = true
local ThemeToggle = TabHandles.Appearance:Toggle({
    Title = "Enable Dark Mode",
    Desc = "Use dark color scheme",
    Value = true,
    Callback = function(state)
        if canchangetheme then
            WindUI:SetTheme(state and "Dark" or "Light")
        end
        themeDropdown:Select(state and "Dark" or "Light")
    end
})

WindUI:OnThemeChange(function(theme)
    canchangetheme = false
    ThemeToggle:Set(theme == "Dark")
    canchangetheme = true
end)

TabHandles.Appearance:Button({
    Title = "Create New Theme",
    Icon = "plus",
    Callback = function()
        Window:Dialog({
            Title = "Create Theme",
            Content = "This feature is coming soon!",
            Buttons = {
                {
                    Title = "OK",
                    Variant = "Primary"
                }
            }
        })
    end
})

TabHandles.Config:Paragraph({
    Title = "Configuration Manager",
    Desc = "Save and load your settings",
    Image = "save",
    ImageSize = 20,
    Color = "White"
})

local configName = "default"
local configFile = nil
local MyPlayerData = {
    name = "Player1",
    level = 1,
    inventory = { "sword", "shield", "potion" }
}

TabHandles.Config:Input({
    Title = "Config Name",
    Value = configName,
    Callback = function(value)
        configName = value or "default"
    end
})

local ConfigManager = Window.ConfigManager
if ConfigManager then
    ConfigManager:Init(Window)
    
    TabHandles.Config:Button({
        Title = "loc:SAVE_CONFIG",
        Icon = "save",
        Variant = "Primary",
        Callback = function()
            configFile = ConfigManager:CreateConfig(configName)
            
            configFile:Register("featureToggle", featureToggle)
            configFile:Register("intensitySlider", intensitySlider)
            configFile:Register("modeDropdown", modeDropdown)
            configFile:Register("themeDropdown", themeDropdown)
            configFile:Register("transparencySlider", transparencySlider)
            
            configFile:Set("playerData", MyPlayerData)
            configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
            
            if configFile:Save() then
                WindUI:Notify({ 
                    Title = "loc:SAVE_CONFIG", 
                    Content = "Saved as: "..configName,
                    Icon = "check",
                    Duration = 3
                })
            else
                WindUI:Notify({ 
                    Title = "Error", 
                    Content = "Failed to save config",
                    Icon = "x",
                    Duration = 3
                })
            end
        end
    })

    TabHandles.Config:Button({
        Title = "loc:LOAD_CONFIG",
        Icon = "folder",
        Callback = function()
            configFile = ConfigManager:CreateConfig(configName)
            local loadedData = configFile:Load()
            
            if loadedData then
                if loadedData.playerData then
                    MyPlayerData = loadedData.playerData
                end
                
                local lastSave = loadedData.lastSave or "Unknown"
                WindUI:Notify({ 
                    Title = "loc:LOAD_CONFIG", 
                    Content = "Loaded: "..configName.."\nLast save: "..lastSave,
                    Icon = "refresh-cw",
                    Duration = 5
                })
                
                TabHandles.Config:Paragraph({
                    Title = "Player Data",
                    Desc = string.format("Name: %s\nLevel: %d\nInventory: %s", 
                        MyPlayerData.name, 
                        MyPlayerData.level, 
                        table.concat(MyPlayerData.inventory, ", "))
                })
            else
                WindUI:Notify({ 
                    Title = "Error", 
                    Content = "Failed to load config",
                    Icon = "x",
                    Duration = 3
                })
            end
        end
    })
else
    TabHandles.Config:Paragraph({
        Title = "Config Manager Not Available",
        Desc = "This feature requires ConfigManager",
        Image = "alert-triangle",
        ImageSize = 20,
        Color = "White"
    })
end

local footerSection = Window:Section({ Title = "WindUI " .. WindUI.Version })
TabHandles.Config:Paragraph({
    Title = "Created with ❤️",
    Desc = "github.com/Footagesus/WindUI",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "Copy Link",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("https://github.com/Footagesus/WindUI")
                WindUI:Notify({
                    Title = "Copied!",
                    Content = "GitHub link copied to clipboard",
                    Duration = 2
                })
            end
        }
    }
})

Window:OnClose(function()
    print("Window closed")
    
    if ConfigManager and configFile then
        configFile:Set("playerData", MyPlayerData)
        configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
        configFile:Save()
        print("Config auto-saved on close")
    end
end)

Window:OnDestroy(function()
    print("Window destroyed")
end)
