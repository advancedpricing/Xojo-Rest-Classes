#tag Class
Protected Class GetCustomer
Inherits RESTMessage_MTC
	#tag Event
		Function GetRESTType() As RESTTypes
		  return RESTTypes.POST
		End Function
	#tag EndEvent

	#tag Event
		Function GetURLPattern() As Text
		  return kBaseURL + "GetCustomer"
		End Function
	#tag EndEvent

	#tag Event
		Function IncomingPayloadValueToProperty(value As Auto, prop As Xojo.Introspection.PropertyInfo, hostObject As Object) As Boolean
		  if hostObject isa Customer then
		    
		    if prop.Name = "Photo" then
		      dim textData as text = value
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
		ID As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		ReturnGetCustomer As Customer
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
			Name="ID"
			Group="Behavior"
			Type="Integer"
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
