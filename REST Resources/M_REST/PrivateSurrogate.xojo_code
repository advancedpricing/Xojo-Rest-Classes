#tag Interface
Private Interface PrivateSurrogate
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
		Sub RaiseResponseReceived(sender As RESTMessage_MTC, url As Text, httpStatus As Integer, payload As Auto)
		  
		End Sub
	#tag EndMethod


End Interface
#tag EndInterface
