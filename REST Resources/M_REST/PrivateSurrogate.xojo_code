#tag Interface
Private Interface PrivateSurrogate
	#tag Method, Flags = &h0
		Function RaiseAuthenticationRequired(sender As RESTMessage_MTC, realm As Text, ByRef name As Text, ByRef password As Text) As Boolean
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RaiseContinueWaiting(sender As RESTMessage_MTC) As Boolean
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RaiseDisconnected(sender As RESTMessage_MTC)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RaiseError(sender As RestMessage_MTC, msg As Text)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RaiseHeadersReceived(sender As RESTMessage_MTC, url As Text, httpStatus As Integer)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RaiseReceiveProgress(sender As RESTMessage_MTC, bytesReceived As Int64, totalBytes As Int64, newData As Xojo.Core.MemoryBlock)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RaiseResponseReceived(sender As RESTMessage_MTC, url As Text, httpStatus As Integer, payload As Auto)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RaiseSendProgress(sender As RESTMessage_MTC, bytesSent As Int64, bytesLeft As Int64)
		  
		End Sub
	#tag EndMethod


End Interface
#tag EndInterface
