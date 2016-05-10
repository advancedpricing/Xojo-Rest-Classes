#tag Class
Protected Class SQLFormatter
Inherits RESTMessage_MTC
	#tag Event
		Function CancelSend(ByRef url As Text, ByRef httpAction As Text, ByRef payload As Xojo.Core.MemoryBlock, ByRef payloadMIMEType As Text) As Boolean
		  #pragma unused url
		  #pragma unused httpAction
		  
		  payloadMIMEType = "application/x-www-form-urlencoded"
		  
		  dim postText As text = "rqst_input_sql=" + EncodeURLComponent( InputSQL ).ToText + _
		  "&rqst_db_vendor=" + DBVendor.ToText
		  
		  payload = Xojo.Core.TextEncoding.UTF8.ConvertTextToData(postText)
		  
		End Function
	#tag EndEvent

	#tag Event
		Function GetRESTType() As RESTTypes
		  return RESTTypes.POST
		End Function
	#tag EndEvent

	#tag Event
		Function GetURLPattern() As Text
		  return "http://www.gudusoft.com/format.php"
		End Function
	#tag EndEvent

	#tag Event
		Sub Setup()
		  Options.SendWithPayloadIfAvailable = false // We'll handle it ourselves
		  
		End Sub
	#tag EndEvent


	#tag Property, Flags = &h0
		DBVendor As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h0
		InputSQL As Text
	#tag EndProperty


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
			Name="RoundTripMs"
			Group="Behavior"
			Type="Double"
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
			Name="ValidateCertificates"
			Visible=true
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
