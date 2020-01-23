#tag Module
Protected Module M_REST
	#tag Method, Flags = &h1
		Protected Function AssembleURL(baseURL As String, encodedQueries() As String) As String
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
		  
		  dim queries() as string
		  
		  for each query as string in encodedQueries
		    query = query.Trim
		    if query <> "" then
		      queries.Append query
		    end if
		  next
		  
		  dim queryText as string = Join( queries, "&" )
		  
		  //
		  // Append to the base URL
		  //
		  dim result as string = baseURL.Trim
		  
		  if queryText = "" then
		    //
		    // Just return the base URL
		    //
		    
		  elseif result = "" then
		    //
		    // Just return the queryText, whatever that is
		    //
		    result = queryText
		    
		  elseif baseURL.InStr( "?" ) = 0 then
		    result = result + "?" + queryText
		    
		  else
		    result = result + "&" + queryText
		    
		  end if
		  
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function AssembleURL(baseURL As String, encodedQuery As String, ParamArray additionalQueries() As String) As String
		  //
		  // Appends the properly encoded queries to a base URL
		  //
		  // See examples in overloaded method
		  //
		  
		  dim queries() as string
		  
		  queries.Append encodedQuery
		  
		  for each query as string in additionalQueries
		    queries.Append query
		  next
		  
		  //
		  // Will handle trimming and weeding out
		  // blank entries
		  //
		  return AssembleURL( baseURL, queries )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetIOS and (Target64Bit))
		Private Function AutoToText(value As Auto) As Text
		  if value isa Xojo.Core.Date then
		    dim d as Xojo.Core.Date = value
		    return d.ToText
		  end if
		  
		  dim ti as Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType( value )
		  
		  select case ti.FullName
		  case "Text"
		    return value
		    
		  case "String"
		    #if not TargetiOS then
		      dim s as string = value
		      return s.ToText
		    #endif
		    
		  case "Integer", "Int8", "Int16", "Int32", "Int64"
		    dim i as Int64 = value
		    return i.ToText
		    
		  case "UInteger", "UInt8", "UInt16", "UInt32", "UInt64"
		    dim i as UInt64 = value
		    return i.ToText
		    
		  case "Double", "Single"
		    dim d as double = value
		    return d.ToText
		    
		  case "Currency"
		    dim c as currency = value
		    return c.ToText
		    
		  case "Boolean"
		    dim b as boolean = value
		    return if(b, "true", "false")
		    
		  case else
		    dim t as text = value
		    return t // Expect this to raise an exception
		    
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Protected Sub BuildMultipartFileRequest(fileName As String, fileIn As Readable, ByRef payload As String, ByRef mimeType As String)
		  dim boundary as string
		  dim boundaryText as text
		  if true then // Scope
		    boundary = "--" + Right(EncodeHex(MD5(Str(Microseconds))), 24) + "-bOuNdArY"
		    boundary = boundary.DefineEncoding(Encodings.UTF8)
		  end if
		  static doubleDashes as string = "--"
		  
		  static CRLF as string = &u0D + &u0A
		  
		  dim out() as string
		  
		  // Start of file
		  out.Append(doubleDashes)
		  out.Append(boundary)
		  out.Append(CRLF)
		  
		  out.Append("Content-Disposition: form-data; name=""file""; filename=""" + fileName + """" + CRLF)
		  out.Append("Content-Type: application/octet-stream" + CRLF + CRLF) ' replace with actual MIME Type
		  dim chunk as string
		  do until fileIn.EOF
		    chunk = fileIn.Read(1000000)
		    out.Append chunk
		  loop until chunk = ""
		  out.Append(CRLF)
		  
		  out.Append(doubleDashes)
		  out.Append(boundary)
		  out.Append(doubleDashes)
		  out.Append(CRLF)
		  // End of file
		  
		  System.DebugLog CurrentMethodName + " sets the payload"
		  
		  payload = join(out, "")
		  payload = payload.DefineEncoding(nil)
		  mimeType = "multipart/form-data; boundary=" + boundaryText
		  
		  'system.DebugLog "about to send request"
		  'sock.SetRequestContent(data, "multipart/form-data; boundary=" + boundaryText)
		  '
		  'dim url as text = RaiseEvent sock.GetURLPattern
		  'sock.Send(sock.HTTPAction, url)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Protected Sub BuildMultipartRequest(file As FolderItem, formData As Dictionary, ByRef payload As String, ByRef mimeType As String)
		  dim boundary as string
		  if true then // Scope
		    boundary = "--" + Right(EncodeHex(MD5(Str(Microseconds))), 24) + "-bOuNdArY"
		    boundary = boundary.DefineEncoding(Encodings.UTF8)
		  end if
		  static doubleDashes as string = "--"
		  
		  static CRLF as text = &u0D + &u0A
		  
		  dim out() as string
		  
		  if formData isa object then
		    dim formKeys() as variant = formData.Keys
		    dim formValues() as variant = formData.Values
		    for i as integer = 0 to formKeys.Ubound
		      dim key as variant = formKeys( i )
		      dim value as variant = formValues( i )
		      
		      out.Append(doubleDashes)
		      out.Append(boundary)
		      out.Append(CRLF)
		      dim keyText as string = VariantToString( key )
		      dim keyValue as string = VariantToString( value )
		      out.Append("Content-Disposition: form-data; name=""" + keyText + """" + CRLF + CRLF)
		      out.Append(keyValue)
		      out.Append(CRLF)
		    next
		  end if
		  
		  // Start of file
		  out.Append(doubleDashes)
		  out.Append(boundary)
		  out.Append(CRLF)
		  
		  out.Append("Content-Disposition: form-data; name=""file""; filename=""" + file.Name + """" + CRLF)
		  out.Append("Content-Type: application/octet-stream" + CRLF + CRLF) ' replace with actual MIME Type
		  dim bs as BinaryStream = BinaryStream.Open(file, false)
		  out.Append(bs.Read(bs.Length))
		  out.Append(CRLF)
		  bs.Close
		  
		  out.Append(doubleDashes)
		  out.Append(boundary)
		  out.Append(doubleDashes)
		  out.Append(CRLF)
		  // End of file
		  
		  System.DebugLog CurrentMethodName + " sets the payload"
		  
		  payload = join( out, "" )
		  payload = payload.DefineEncoding( nil )
		  mimeType = "multipart/form-data; boundary=" + boundary
		  
		  'system.DebugLog "about to send request"
		  'sock.SetRequestContent(data, "multipart/form-data; boundary=" + boundaryText)
		  '
		  'dim url as text = RaiseEvent sock.GetURLPattern
		  'sock.Send(sock.HTTPAction, url)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1, CompatibilityFlags = (TargetIOS and (Target64Bit))
		Protected Function EncodeURLComponent(src As Text, encoding As Xojo.Core.TextEncoding = Nil) As Text
		  // Emulates the classic framework's EncodeURLComponent
		  //
		  // Where encoding is nil, UTF-8 will be used
		  
		  if src.Empty then
		    return ""
		  end if
		  
		  if encoding is nil then
		    encoding = Xojo.Core.TextEncoding.UTF8
		  end if
		  
		  dim newChars() as Text
		  
		  dim mb as Xojo.Core.MemoryBlock = encoding.ConvertTextToData( src )
		  dim p as ptr = mb.Data
		  
		  dim lastByteIndex as integer = mb.Size - 1
		  for byteIndex as integer = 0 to lastByteIndex
		    dim code as integer = p.Byte( byteIndex )
		    
		    select case code
		    case 45, 46, 48 to 57, 65 to 90, 95, 97 to 122 // [-.0-9A-Z_a-z]
		      newChars.Append Text.FromUnicodeCodepoint( code)
		      
		    case else
		      newChars.Append "%"
		      newChars.Append code.ToHex( 2 )
		      
		    end select
		  next
		  
		  return Text.Join( newChars, "" )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetZeroParamConstructor(ti As Introspection.TypeInfo) As Introspection.ConstructorInfo
		  static constructorCache as new Dictionary
		  
		  dim result as Introspection.ConstructorInfo = constructorCache.Lookup( ti.FullName, nil )
		  if result isa object then
		    return result
		  end if
		  
		  dim constructors() as Introspection.ConstructorInfo
		  #if TargetiOS then
		    constructors = ti.Constructors
		  #else
		    constructors = ti.GetConstructors
		  #endif
		  
		  //
		  // Works backwords in the hope that that subclass Constructor if any, is later in the array
		  //
		  for i as integer = constructors.Ubound downto 0
		    dim c as Introspection.ConstructorInfo = constructors( i )
		    try
		      #pragma BreakOnExceptions false
		      dim params() as Introspection.ParameterInfo
		      #if TargetiOS then
		        params = c.Parameters
		      #else
		        params = c.GetParameters
		      #endif
		      #pragma BreakOnExceptions default 
		      if params.Ubound = -1 then
		        result = c
		        exit for i
		      end if
		      
		    catch err as OutOfBoundsException
		      //
		      // A bug in Xojo as of 2016r11 when there is no
		      // specific Constructor created for the class
		      // If this exception is raised, we've found the only 
		      // Constructor
		      result = c
		      exit for i
		      
		    end try
		  next i
		  
		  if result isa object then
		    constructorCache.Value( ti.FullName ) = result
		    return result
		  else
		    return nil
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private Function Length(Extends s As String) As Integer
		  return s.Len
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private Function VariantToString(value As Variant) As String
		  if value isa Date then
		    dim d as Date = value
		    return d.SQLDateTime
		  end if
		  
		  if value isa Xojo.Core.Date then
		    dim d as Xojo.Core.Date = value
		    return d.ToText
		  end if
		  
		  select case value.Type
		  case Variant.TypeDouble, Variant.TypeSingle 
		    return format( value.DoubleValue, "-0.0###############" )
		    
		  case Variant.TypeCurrency
		    dim d as double = value.CurrencyValue
		    return format( d, "-0.00##" )
		    
		  case Variant.TypeBoolean
		    return if( value.BooleanValue, "true", "false" )
		    
		  case Variant.TypeText
		    dim t as text = value.TextValue
		    return t
		    
		  end select
		  
		  return value.StringValue // Expect this to maybe raise an exception
		  
		  dim ti as Introspection.TypeInfo = Introspection.GetType( value )
		  
		End Function
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
