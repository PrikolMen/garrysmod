
local AddConsoleCommand = AddConsoleCommand
local string_lower = string.lower
local Msg = Msg

--[[---------------------------------------------------------
   Name: concommand
   Desc: A module to take care of the registration and calling
         of Lua console commands.
-----------------------------------------------------------]]
module( "concommand" )

local CommandList = {}
local CompleteList = {}

--[[---------------------------------------------------------
   Name: concommand.GetTable( )
   Desc: Returns the table of console commands and auto complete
-----------------------------------------------------------]]
function GetTable()
	return CommandList, CompleteList
end

--[[---------------------------------------------------------
   Name: concommand.Exists( name )
   Desc: Returns true if concommand exists
-----------------------------------------------------------]]
function Exists( name )
	return commandList[ string_lower( name ) ] != nil
end

--[[---------------------------------------------------------
   Name: concommand.Add( name, func, completefunc )
   Desc: Register a new console command
-----------------------------------------------------------]]
function Add( name, func, completefunc, help, flags )
	local LowerName = string_lower( name )
	CommandList[ LowerName ] = func
	CompleteList[ LowerName ] = completefunc
	AddConsoleCommand( name, help, flags )
end

--[[---------------------------------------------------------
   Name: concommand.Remove( name )
   Desc: Removes a console command
-----------------------------------------------------------]]
function Remove( name )
	local LowerName = string_lower( name )
	CommandList[ LowerName ] = nil
	CompleteList[ LowerName ] = nil
end

--[[---------------------------------------------------------
   Name: concommand.Run( )
   Desc: Called by the engine when an unknown console command is run
-----------------------------------------------------------]]
function Run( ply, command, arguments, args )

	local LowerCommand = string_lower( command )

	local func = CommandList[ LowerCommand ]
	if ( func != nil ) then
		func( ply, command, arguments, args )
		return true
	end

	Msg( "Unknown command: " .. command .. "\n" )

	return false
end

--[[---------------------------------------------------------
   Name: concommand.AutoComplete( )
   Desc: Returns a table for the autocompletion
-----------------------------------------------------------]]
function AutoComplete( command, arguments )

	local LowerCommand = string_lower( command )

	local func = CompleteList[ LowerCommand ]
	if ( func != nil ) then
		return func( command, arguments )
	end

end
