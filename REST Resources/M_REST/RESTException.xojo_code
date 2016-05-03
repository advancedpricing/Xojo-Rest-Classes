#tag Class
Protected Class RESTException
Inherits RuntimeException
	#tag Method, Flags = &h0
		Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(reason As Text)
		  self.Reason = reason
		End Sub
	#tag EndMethod


End Class
#tag EndClass
