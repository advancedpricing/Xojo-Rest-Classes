#tag Interface
Protected Interface UnitTestRESTMessage
	#tag Method, Flags = &h0
		Function Deserialize(value As Variant, intoProp As Introspection.PropertyInfo, currentValue As Variant) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ExpandURLPattern(urlPattern As String, ByRef returnPayloadProps() As Introspection.PropertyInfo) As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSendParameters(ByRef action As String, ByRef url As String, ByRef mimeType As String, ByRef payload As String) As Boolean
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProcessPayload(payload As String) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Serialize(value As Variant) As Variant
		  
		End Function
	#tag EndMethod


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
End Interface
#tag EndInterface
