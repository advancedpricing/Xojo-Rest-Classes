#tag Class
Protected Class Options
Implements PrivateOptions
	#tag Method, Flags = &h0
		Sub Constructor()
		  ExpectedTextEncoding = Xojo.Core.TextEncoding.UTF8
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetParentMessage(msg As M_REST.RESTMessage_MTC)
		  if msg <> ParentMessage then
		    ParentMessage = msg
		    PrivateMessage( msg ).ClearClassMeta
		  end if
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		AdjustDatesForTimeZone As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  dim result as Xojo.Core.TextEncoding = mExpectedTextEncoding
			  if result is nil then
			    result = Xojo.Core.TextEncoding.UTF8
			  end if
			  
			  return result
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mExpectedTextEncoding = value
			End Set
		#tag EndSetter
		ExpectedTextEncoding As Xojo.Core.TextEncoding
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mExpectedTextEncoding As Xojo.Core.TextEncoding
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mParentMessageWR As WeakRef
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private mReturnPropertyPrefix As Text = "Return"
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  if mParentMessageWR is nil then
			    return nil
			  else
			    return M_REST.RESTMessage_MTC( mParentMessageWR.Value )
			  end if
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if value is nil then
			    mParentMessageWR = nil
			  else
			    mParentMessageWR = new WeakRef( value )
			  end if
			  
			End Set
		#tag EndSetter
		Private ParentMessage As M_REST.RESTMessage_MTC
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mReturnPropertyPrefix
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  value = value.Trim
			  
			  //
			  // If the prefix has changed, the parent has to regenerate its
			  // meta
			  //
			  
			  if value <> mReturnPropertyPrefix then
			    mReturnPropertyPrefix = value
			    dim parent as RESTMessage_MTC = ParentMessage
			    if parent isa object then
			      PrivateMessage( parent ).ClearClassMeta
			    end if
			  end if
			  
			End Set
		#tag EndSetter
		ReturnPropertyPrefix As Text
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		SendWithPayloadIfAvailable As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		TimeoutSeconds As Integer = 5
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="AdjustDatesForTimeZone"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
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
			Name="ReturnPropertyPrefix"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SendWithPayloadIfAvailable"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TimeoutSeconds"
			Group="Behavior"
			InitialValue="5"
			Type="Integer"
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
