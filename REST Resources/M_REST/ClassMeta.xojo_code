#tag Class
Private Class ClassMeta
	#tag Method, Flags = &h0
		Sub Constructor()
		  ReturnPropertiesDict = new Dictionary
		  SendPropertiesDict = new Dictionary
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		ReturnPropertiesDict As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		SendPropertiesDict As Dictionary
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
