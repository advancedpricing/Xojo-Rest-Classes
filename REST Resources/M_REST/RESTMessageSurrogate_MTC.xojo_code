#tag Class
Class RESTMessageSurrogate_MTC
Implements PrivateSurrogate
	#tag Method, Flags = &h21
		Private Function RaiseAuthenticationRequired(sender As RESTMessage_MTC, realm As Text, ByRef name As Text, ByRef password As Text) As Boolean
		  return RaiseEvent AuthenticationRequired( sender, realm, name, password )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RaiseContinueWaiting(sender As RESTMessage_MTC) As Boolean
		  return RaiseEvent ContinueWaiting( sender )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseDisconnected(sender As RESTMessage_MTC)
		  RaiseEvent Disconnected( sender )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseError(sender As RestMessage_MTC, msg As Text)
		  RaiseEvent Error( sender, msg )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseHeadersReceived(sender As RESTMessage_MTC, url As Text, httpStatus As Integer)
		  RaiseEvent HeadersReceived( sender, url, httpStatus )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseReceiveProgress(sender As RESTMessage_MTC, bytesReceived As Int64, totalBytes As Int64, newData As Xojo.Core.MemoryBlock)
		  RaiseEvent ReceiveProgress( sender, bytesReceived, totalBytes, newData )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseResponseReceived(sender As RESTMessage_MTC, url As Text, httpStatus As Integer, payload As Auto)
		  RaiseEvent ResponseReceived( sender, url, httpStatus, payload )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseSendProgress(sender As RESTMessage_MTC, bytesSent As Int64, bytesLeft As Int64)
		  RaiseEvent SendProgress( sender, bytesSent, bytesLeft )
		  
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event AuthenticationRequired(sender As RESTMessage_MTC, realm As Text, ByRef name As Text, ByRef password As Text) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 546865206D6573736167652068617320657863656564207468652074696D652073657420696E204F7074696F6E732E54696D656F75745365636F6E64732E2052657475726E205472756520746F20616C6C6F7720746865206D65737361676520746F206B6565702077616974696E672E
		Event ContinueWaiting(sender As RESTMessage_MTC) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 54686520736F636B65742068617320646973636F6E6E65637465642E
		Event Disconnected(sender As RESTMessage_MTC)
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 416E206572726F7220686173206F636375727265642E
		Event Error(sender As RESTMessage_MTC, msg As Text)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event HeadersReceived(sender As RESTMessage_MTC, url As Text, httpStatus As Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReceiveProgress(sender As RESTMessage_MTC, bytesReceived As Int64, totalBytes As Int64, newData As Xojo.Core.MemoryBlock)
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 546865205245535466756C20736572766572206861732072657475726E6564206120726573706F6E73652E
		Event ResponseReceived(sender As RESTMessage_MTC, url As Text, httpStatus As Integer, payload As Auto)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event SendProgress(sender As RESTMessage_MTC, bytesSent As Int64, bytesLeft As Int64)
	#tag EndHook


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
