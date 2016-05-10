#tag Module
Protected Module M_REST
	#tag Method, Flags = &h21
		Private Function GetZeroParamConstructor(ti As Xojo.Introspection.TypeInfo) As Xojo.Introspection.ConstructorInfo
		  dim constructors() as Xojo.Introspection.ConstructorInfo = ti.Constructors
		  
		  //
		  // Works backwords in the hope that that subclass Constructor if any, is later in the array
		  //
		  for i as integer = constructors.Ubound downto 0
		    dim c as Xojo.Introspection.ConstructorInfo = constructors( i )
		    dim params() as Xojo.Introspection.ParameterInfo = c.Parameters
		    if params.Ubound = -1 then
		      return c
		    end if
		  next i
		  
		  return nil
		  
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
End Module
#tag EndModule
