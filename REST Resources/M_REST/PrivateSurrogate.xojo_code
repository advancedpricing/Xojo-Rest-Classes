#tag Interface
Private Interface PrivateSurrogate
	#tag Method, Flags = &h0
		Sub AppendMessage(msg As M_REST.RESTMessage_MTC)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RaiseAuthenticationRequired(message As RESTMessage_MTC, realm As Text, ByRef name As Text, ByRef password As Text) As Boolean
		  
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
		Sub RaiseError(message As RESTMessage_MTC, msg As Text)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RaiseHeadersReceived(message As RESTMessage_MTC, url As Text, httpStatus As Integer)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RaiseReceiveProgress(message As RESTMessage_MTC, bytesReceived As Int64, totalBytes As Int64, newData As Xojo.Core.MemoryBlock)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RaiseResponseReceived(message As RESTMessage_MTC, url As Text, httpStatus As Integer, payload As Auto)
		  
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
