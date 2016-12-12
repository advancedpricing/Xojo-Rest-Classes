#tag Interface
Protected Interface UnitTestRESTMessage
	#tag Method, Flags = &h0
		Function Deserialize(value As Auto, intoProp As Introspection.PropertyInfo, currentValue As Auto) As Auto
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ExpandURLPattern(urlPattern As Text, ByRef returnPayloadProps() As Introspection.PropertyInfo) As Text
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSendParameters(ByRef action As Text, ByRef url As Text, ByRef mimeType As Text, ByRef payload As Xojo.Core.MemoryBlock) As Boolean
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProcessPayload(payload As Xojo.Core.MemoryBlock) As Auto
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Serialize(value As Auto) As Auto
		  
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
