#tag Class
Protected Class Options
Implements PrivateOptions
	#tag Method, Flags = &h0
		Sub Constructor()
		  ExpectedTextEncoding = Xojo.Core.TextEncoding.UTF8
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetParentMessage(msg As M_REST.RESTMessage_MTC)
		  if msg <> ParentMessage then
		    ParentMessage = msg
		    PrivateMessage( msg ).ClearClassMeta
		  end if
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		AdjustDatesForTimeZome As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		DefaultRESTType As RESTMessage_MTC.RESTTypes = RESTMessage_MTC.RESTTypes.Unknown
	#tag EndProperty

	#tag Property, Flags = &h0
		ExpectedTextEncoding As Xojo.Core.TextEncoding
	#tag EndProperty

	#tag Property, Flags = &h0
		SendWithPayloadIfAvailable As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		TimeoutSeconds As Integer = 5
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
