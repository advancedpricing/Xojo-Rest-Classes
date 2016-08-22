#tag Class
Protected Class UnitTestMessage
Inherits RESTMessage_MTC
	#tag Event , Description = 4578636C75646520612070726F70657274792066726F6D20746865206F7574676F696E67207061796C6F6164207468617420776F756C64206F746865727769736520626520696E636C756465642C206F72206368616E6765207468652070726F7065727479206E616D6520616E642F6F722076616C756520746861742077696C6C20626520757365642E
		Function ExcludeFromOutgoingPayload(prop As Xojo.Introspection.PropertyInfo, ByRef propName As Text, ByRef propValue As Auto, hostObject As Object) As Boolean
		  #pragma unused prop
		  #pragma unused propValue
		  #pragma unused hostObject
		  
		  select case propName
		  case "UseURL"
		    return true
		    
		  case else
		    return false
		  end select
		End Function
	#tag EndEvent

	#tag Event , Description = 5468652055524C207061747465726E20746F2075736520666F722074686520636F6E6E656374696F6E2E2043616E20696E636C7564652070726F7065727479206E616D657320746861742077696C6C20626520737562737469747574656420666F722076616C75652C20652E672E2C0A0A687474703A2F2F7777772E6578616D706C652E636F6D2F6765742F3A69643F6E616D653D3A6E616D650A0A3A696420616E64203A6E616D652077696C6C206265207265706C616365642062792070726F70657274696573206F66207468652073616D65206E616D652E
		Function GetURLPattern() As Text
		  return kURLPattern
		End Function
	#tag EndEvent


	#tag Property, Flags = &h0
		IncludeBoolean As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		IncludeString As String
	#tag EndProperty

	#tag Property, Flags = &h0
		IncludeText As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		ReturnBoolean As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ReturnDate As Xojo.Core.Date
	#tag EndProperty

	#tag Property, Flags = &h0
		ReturnDictionary As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		ReturnString As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ReturnText As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		SomeIndex As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		SomeString As String
	#tag EndProperty

	#tag Property, Flags = &h0
		UseURL As Text
	#tag EndProperty


	#tag Constant, Name = kURLPattern, Type = Text, Dynamic = False, Default = \"http://example.com/:SomeString/:someindex", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="DefaultRESTType"
			Visible=true
			Group="Behavior"
			InitialValue="RESTTypes.Unknown"
			Type="RESTTypes"
			EditorType="Enum"
			#tag EnumValues
				"0 - Unknown"
				"1 - Create"
				"2 - Read"
				"3 - UpdateReplace"
				"4 - UpdateModify"
				"5 - Authenticate"
				"6 - DELETE"
				"7 - GET"
				"8 - HEAD"
				"9 - OPTIONS"
				"10 - PATCH"
				"11 - POST"
				"12 - PUT"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeBoolean"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeString"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeText"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsConnected"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MessageSerialNumber"
			Group="Behavior"
			Type="Int64"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RESTType"
			Group="Behavior"
			Type="RESTTypes"
			EditorType="Enum"
			#tag EnumValues
				"0 - Unknown"
				"1 - Create"
				"2 - Read"
				"3 - UpdateReplace"
				"4 - UpdateModify"
				"5 - Authenticate"
				"6 - DELETE"
				"7 - GET"
				"8 - HEAD"
				"9 - OPTIONS"
				"10 - PATCH"
				"11 - POST"
				"12 - PUT"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="ReturnBoolean"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ReturnString"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ReturnText"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RoundTripMs"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RoundTripWithProcessingMs"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SomeIndex"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SomeString"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="State"
			Group="Behavior"
			Type="States"
			EditorType="Enum"
			#tag EnumValues
				"0 - Idle"
				"1 - Queued"
				"2 - Active"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UseURL"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ValidateCertificates"
			Visible=true
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
