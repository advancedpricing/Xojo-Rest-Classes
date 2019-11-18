#tag Class
Class RESTMessageSurrogate_MTC
Implements PrivateSurrogate
	#tag Method, Flags = &h21
		Private Sub AppendMessage(msg As M_REST.RESTMessage_MTC)
		  OutstandingMessagesDict.Value( msg ) = nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DisconnectAll()
		  //
		  // We have to do this in two phases so the dictionary isn't changed while we are iterating over it
		  //
		  
		  dim msgs() as M_REST.RESTMessage_MTC
		  for each entry as Xojo.Core.DictionaryEntry in OutstandingMessagesDict
		    dim msg as M_REST.RESTMessage_MTC = M_REST.RESTMessage_MTC( entry.Key )
		    msgs.Append msg
		  next
		  
		  for each msg as M_REST.RESTMessage_MTC in msgs
		    msg.Disconnect
		  next
		  
		  OutstandingMessagesDict.RemoveAll
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DisconnectMessage(msg As M_REST.RESTMessage_MTC)
		  msg.Disconnect
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OutstandingMessages() As M_REST.RESTMessage_MTC()
		  dim msgs() as M_REST.RESTMessage_MTC
		  for each entry as Xojo.Core.DictionaryEntry in OutstandingMessagesDict
		    msgs.Append M_REST.RESTMessage_MTC( entry.Key )
		  next
		  
		  return msgs
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RaiseAuthenticationRequired(message As RESTMessage_MTC, realm As String, ByRef name As String, ByRef password As String) As Boolean
		  return RaiseEvent AuthenticationRequired( message, realm, name, password )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RaiseContinueWaiting(message As RESTMessage_MTC) As Boolean
		  return RaiseEvent ContinueWaiting( message )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseDisconnected(message As RESTMessage_MTC)
		  RaiseEvent Disconnected( message )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseError(message As RESTMessage_MTC, msg As String)
		  RaiseEvent Error( message, msg )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseHeadersReceived(message As RESTMessage_MTC, url As String, httpStatus As Integer)
		  RaiseEvent HeadersReceived( message, url, httpStatus )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseReceiveProgress(message As RESTMessage_MTC, bytesReceived As Int64, totalBytes As Int64, newData As String)
		  RaiseEvent ReceiveProgress( message, bytesReceived, totalBytes, newData )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseResponseReceived(message As RESTMessage_MTC, url As String, httpStatus As Integer, payload As Variant)
		  RaiseEvent ResponseReceived( message, url, httpStatus, payload )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseSendProgress(message As RESTMessage_MTC, bytesSent As Int64, bytesLeft As Int64)
		  RaiseEvent SendProgress( message, bytesSent, bytesLeft )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 546865206D65737361676520686173206265656E2073656E742E
		Private Sub RaiseSent(message As RESTMessage_MTC)
		  RaiseEvent Sent( message )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RemoveMessage(msg As M_REST.RESTMessage_MTC)
		  #pragma BreakOnExceptions false
		  try
		    OutstandingMessagesDict.Remove msg
		  catch err as KeyNotFoundException
		    //
		    // Already gone, so move on
		    //
		  end try
		  #pragma BreakOnExceptions default
		  
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0, Description = 546865206D6573736167652072657175697265732061757468656E7469636174696F6E2E2053657420746865206E616D6520616E642070617373776F72642C207468656E2072657475726E20547275652E
		Event AuthenticationRequired(message As RESTMessage_MTC, realm As String, ByRef name As String, ByRef password As String) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 546865206D6573736167652068617320657863656564207468652074696D652073657420696E204F7074696F6E732E54696D656F75745365636F6E64732E2052657475726E205472756520746F20616C6C6F7720746865206D65737361676520746F206B6565702077616974696E672E
		Event ContinueWaiting(message As RESTMessage_MTC) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 54686520736F636B65742068617320646973636F6E6E65637465642E
		Event Disconnected(message As RESTMessage_MTC)
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 416E206572726F7220686173206F636375727265642E
		Event Error(message As RESTMessage_MTC, msg As String)
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 54686520686561646572732063616D65206261636B2066726F6D20746865207365727665722E
		Event HeadersReceived(message As RESTMessage_MTC, url As String, httpStatus As Integer)
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 546865207374617473206173206120726573706F6E73652069732072656365697665642E
		Event ReceiveProgress(message As RESTMessage_MTC, bytesReceived As Int64, totalBytes As Int64, newData As String)
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 546865205245535466756C20736572766572206861732072657475726E6564206120726573706F6E73652E
		Event ResponseReceived(message As RESTMessage_MTC, url As String, httpStatus As Integer, payload As Variant)
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 546865207374617473206F662061206D657373616765206265696E672073656E742E
		Event SendProgress(message As RESTMessage_MTC, bytesSent As Int64, bytesLeft As Int64)
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 546865206D65737361676520686173206265656E2073656E742E
		Event Sent(message As RESTMessage_MTC)
	#tag EndHook


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return OutstandingMessagesDict.Count <> 0
			End Get
		#tag EndGetter
		IsBusy As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private mOutstandingMessagesDict As Xojo.Core.Dictionary
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  if mOutstandingMessagesDict is nil then
			    mOutstandingMessagesDict = new Xojo.Core.Dictionary
			  end if
			  
			  return mOutstandingMessagesDict
			End Get
		#tag EndGetter
		Private OutstandingMessagesDict As Xojo.Core.Dictionary
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsBusy"
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
