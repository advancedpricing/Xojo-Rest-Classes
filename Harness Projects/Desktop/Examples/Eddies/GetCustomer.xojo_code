#tag Class
Protected Class GetCustomer
Inherits RESTMessage_MTC
	#tag Event , Description = 5468652052455354207479706520746F2075736520666F72207468697320636F6E6E656374696F6E2E204966206E6F7420696D706C656D656E7465642C2044656661756C7452455354547970652077696C6C206265207573656420696E73746561642E
		Function GetRESTType() As RESTTypes
		  return RESTTypes.POST
		End Function
	#tag EndEvent

	#tag Event , Description = 5468652055524C207061747465726E20746F2075736520666F722074686520636F6E6E656374696F6E2E2043616E20696E636C7564652070726F7065727479206E616D657320746861742077696C6C20626520737562737469747574656420666F722076616C75652C20652E672E2C0A0A687474703A2F2F7777772E6578616D706C652E636F6D2F6765742F3A69643F6E616D653D3A6E616D650A0A3A696420616E64203A6E616D652077696C6C206265207265706C616365642062792070726F70657274696573206F66207468652073616D65206E616D652E
		Function GetURLPattern() As String
		  return kBaseURL + "GetCustomer"
		End Function
	#tag EndEvent

	#tag Event , Description = 4D616E75616C6C792073746F72652074686520696E636F6D696E67207061796C6F61642076616C756520617320646573697265642E2052657475726E205472756520746F2070726576656E7420667572746865722070726F63657373696E67206F6E20746861742076616C75652E
		Function IncomingPayloadValueToProperty(value As Variant, prop As Introspection.PropertyInfo, hostObject As Object) As Boolean
		  if hostObject isa Customer then
		    
		    if prop.Name = "Photo" then
		      dim textData as string = value
		      dim binaryData as MemoryBlock = DecodeBase64( textData )
		      dim p as Picture = Picture.FromData( binaryData )
		      prop.Value( hostObject ) = p
		      return true
		      
		    elseif prop.Name = "Taxable" then
		      dim b as boolean = value = "1"
		      prop.Value( hostObject ) = b
		      return true
		      
		    end if
		    
		  end if
		End Function
	#tag EndEvent


	#tag Property, Flags = &h0
		ID As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ReturnGetCustomer As Customer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="SentPayload"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowCertificateValidation"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HTTPStatusCode"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsActive"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="QueueState"
			Group="Behavior"
			Type="QueueStates"
			EditorType="Enum"
			#tag EnumValues
				"0 - Unused"
				"1 - Queued"
				"2 - Processed"
			#tag EndEnumValues
		#tag EndViewProperty
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
			Name="ID"
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
	#tag EndViewBehavior
End Class
#tag EndClass
