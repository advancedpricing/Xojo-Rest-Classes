#tag Interface
Protected Interface UnitTestRESTMessage
	#tag Method, Flags = &h0
		Function Deserialize(value As Auto, intoProp As Xojo.Introspection.PropertyInfo, currentValue As Auto) As Auto
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ExpandURLPattern(urlPattern As Text, ByRef returnPayloadProps() As Xojo.Introspection.PropertyInfo) As Text
		  
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


End Interface
#tag EndInterface
