#tag Module
Protected Module M_REST
	#tag Method, Flags = &h1
		Protected Function AssembleURL(baseURL As Text, encodedQuery As Text, ParamArray additionalQueries() As Text) As Text
		  //
		  // Appends the properly encoded queries to a base URL
		  //
		  // Examples:
		  //   AssembleURL( "www.something.com", "switch=value") ->
		  //     "www.something.com?switch=value
		  //
		  //   AssembleURL( "www.something.com?switch=value", "anotherswitch=encoded%20value" ) ->
		  //     "www.something.comd?switch=value&anotherswitch=encoded%20value"
		  //
		  //   AssembleURL( "www.something.com", "switch=value", "anotherswitch=anothervalue" ) ->
		  //     "www.something.com?switch=value&anotherswitch=anothervalue"
		  //
		  //   AssembleURL( "www.something.com?a=1&c=2", "d=3", "e=4" ) ->
		  //     "www.something.com?a=1&c=2&d=3&e=4"
		  //
		  // Notes:
		  //   - Order of the given queries is not guaranteed.
		  //   - Queries will be trimmed and blank queries will be skipped
		  //
		  
		  dim queries() as text
		  
		  encodedQuery = encodedQuery.Trim
		  if encodedQuery <> "" then
		    queries.Append encodedQuery
		  end if
		  
		  for each query as text in additionalQueries
		    query = query.Trim
		    if query <> "" then
		      queries.Append query
		    end if
		  next
		  
		  dim queryText as text = Text.Join( queries, "&" )
		  
		  //
		  // Append to the base URL
		  //
		  dim result as text = baseURL.Trim
		  
		  if queryText = "" then
		    //
		    // Just return the base URL
		    //
		    
		  elseif result = "" then
		    //
		    // Just return the queryText, whatever that is
		    //
		    result = queryText
		    
		  elseif baseURL.IndexOf( "?" ) = -1 then
		    result = result + "?" + queryText
		    
		  else
		    result = result + "&" + queryText
		    
		  end if
		  
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetZeroParamConstructor(ti As Xojo.Introspection.TypeInfo) As Xojo.Introspection.ConstructorInfo
		  dim constructors() as Xojo.Introspection.ConstructorInfo = ti.Constructors
		  
		  //
		  // Works backwords in the hope that that subclass Constructor if any, is later in the array
		  //
		  for i as integer = constructors.Ubound downto 0
		    dim c as Xojo.Introspection.ConstructorInfo = constructors( i )
		    try
		      #pragma BreakOnExceptions false
		      dim params() as Xojo.Introspection.ParameterInfo = c.Parameters
		      #pragma BreakOnExceptions default 
		      if params.Ubound = -1 then
		        return c
		      end if
		      
		    catch err as OutOfBoundsException
		      //
		      // A bug in Xojo as of 2016r11 when there is no
		      // specific Constructor created for the class
		      // If this exception is raised, we've found the only 
		      // Constructor
		      return c
		      
		    end try
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
