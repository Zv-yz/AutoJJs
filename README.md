# AutoJJs
### Um script de AutoJJs que pode ser usado na maioria do Exércitos Brasileiros.
> 
## Script
```lua
local Options = {
    Keybind = 'Home', --> Keybind para mostrar/esconder a UI, mais informações sobre KeyCode: https://create.roblox.com/docs/reference/engine/enums/KeyCode
    Tempo = 2.5, --> Tempo para enviar mensagem.
    Rainbow = false, --> Deixar a UI mais colorida (true/false)

	Language = {
		UI = 'pt-br', --> Alterar a linguagem da UI, disponívels: pt-br, en-us
		Words = 'pt-br' --> Alterar a linguagem dos número em extenso, disponívels: pt-br, en-us
	},
};
loadstring(game:HttpGet('https://raw.githubusercontent.com/Zv-yz/AutoJJs/main/Main.lua'))(Options);
```
