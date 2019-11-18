#tag Interface
Private Interface PrivateSurrogate
	#tag Method, Flags = &h0
		Sub AppendMessage(msg As M_REST.RESTMessage_MTC)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RaiseAuthenticationRequired(message As RESTMessage_MTC, realm As String, ByRef name As String, ByRef password As String) As Boolean
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RaiseContinueWaiting(message As RESTMessage_MTC) As Boolean
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RaiseDisconnected(message As RESTMessage_MTC)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RaiseError(message As RESTMessage_MTC, msg As String)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RaiseHeadersReceived(message As RESTMessage_MTC, url As String, httpStatus As Integer)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RaiseReceiveProgress(message As RESTMessage_MTC, bytesReceived As Int64, totalBytes As Int64, newData As String)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RaiseResponseReceived(message As RESTMessage_MTC, url As String, httpStatus As Integer, payload As Variant)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RaiseSendProgress(message As RESTMessage_MTC, bytesSent As Int64, bytesLeft As Int64)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RaiseSent(message As RESTMessage_MTC)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveMessage(msg As M_REST.RESTMessage_MTC)
		  
		End Sub
	#tag EndMethod


End Interface
#tag EndInterface
