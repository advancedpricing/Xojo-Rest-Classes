#tag Class
Protected Class App
Inherits Application
	#tag MenuHandler
		Function ExamplesCats() As Boolean Handles ExamplesCats.Action
			WndCats.Show
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ExamplesEddies() As Boolean Handles ExamplesEddies.Action
			WndEddies.Show
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ExamplesSQLFormatter() As Boolean Handles ExamplesSQLFormatter.Action
			WndSQLFormatter.Show
			Return True
			
		End Function
	#tag EndMenuHandler


	#tag Constant, Name = kEditClear, Type = String, Dynamic = False, Default = \"&Delete", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"&Delete"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"&Delete"
	#tag EndConstant

	#tag Constant, Name = kFileQuit, Type = String, Dynamic = False, Default = \"&Quit", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"E&xit"
	#tag EndConstant

	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Cmd+Q"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"Ctrl+Q"
	#tag EndConstant


End Class
#tag EndClass
