#tag Class
Protected Class Customer
	#tag Property, Flags = &h0
		City As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		Email As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		FirstName As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		ID As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		LastName As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		Phone As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		Photo As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		State As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		Taxable As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Zip As Text
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="City"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Email"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FirstName"
			Group="Behavior"
			Type="Text"
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
			Name="LastName"
			Group="Behavior"
			Type="Text"
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
			Name="Phone"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Photo"
			Group="Behavior"
			Type="Picture"
		#tag EndViewProperty
		#tag ViewProperty
			Name="State"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Taxable"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Zip"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
