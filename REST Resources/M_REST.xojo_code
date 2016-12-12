#tag Module
Protected Module M_REST
	#tag Method, Flags = &h1
		Protected Function AssembleURL(baseURL As Text, encodedQueries() As Text) As Text
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
		  
		  for each query as text in encodedQueries
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

	#tag Method, Flags = &h1
		Protected Function AssembleURL(baseURL As Text, encodedQuery As Text, ParamArray additionalQueries() As Text) As Text
		  //
		  // Appends the properly encoded queries to a base URL
		  //
		  // See examples in overloaded method
		  //
		  
		  dim queries() as text
		  
		  queries.Append encodedQuery
		  
		  for each query as text in additionalQueries
		    queries.Append query
		  next
		  
		  //
		  // Will handle trimming and weeding out
		  // blank entries
		  //
		  return AssembleURL( baseURL, queries )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function AutoToText(value As Auto) As Text
		  #if not TargetiOS then
		    if value isa Date then
		      dim d as Date = value
		      return d.SQLDateTime.ToText
		    end if
		  #endif
		  
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
		Protected Sub BuildMultipartFileRequest(fileName As Text, fileIn As Xojo.IO.BinaryStream, ByRef payload As Xojo.Core.MemoryBlock, ByRef mimeType As Text)
		  dim boundary as xojo.Core.MemoryBlock
		  dim boundaryText as text
		  if true then // Scope
		    dim boundString as string = "--" + Right(EncodeHex(MD5(Str(Microseconds))), 24) + "-bOuNdArY"
		    boundString = boundString.DefineEncoding(Encodings.UTF8)
		    boundaryText = boundString.ToText
		    boundary = Xojo.Core.TextEncoding.UTF8.ConvertTextToData(boundaryText)
		  end if
		  static doubleDashes as xojo.Core.MemoryBlock = Xojo.Core.TextEncoding.UTF8.ConvertTextToData("--")
		  
		  static eol as text = &u0D + &u0A
		  static CRLF as Xojo.Core.MemoryBlock = Xojo.Core.TextEncoding.UTF8.ConvertTextToData(eol)
		  
		  dim enc as Xojo.Core.TextEncoding = Xojo.Core.TextEncoding.UTF8
		  
		  dim data as new Xojo.Core.MutableMemoryBlock(0)
		  dim out as new Xojo.IO.BinaryStream(data)
		  
		  // Start of file
		  out.Write(doubleDashes)
		  out.Write(boundary)
		  out.Write(CRLF)
		  
		  out.WriteText("Content-Disposition: form-data; name=""file""; filename=""" + fileName + """" + eol, enc)
		  out.WriteText("Content-Type: application/octet-stream" + eol + eol, enc) ' replace with actual MIME Type
		  out.Write(fileIn.Read(fileIn.Length))
		  out.Write(CRLF)
		  
		  out.Write(doubleDashes)
		  out.Write(boundary)
		  out.Write(doubleDashes)
		  out.Write(CRLF)
		  // End of file
		  
		  out.Close
		  
		  System.DebugLog CurrentMethodName + " sets the paylod"
		  
		  payload = data
		  mimeType = "multipart/form-data; boundary=" + boundaryText
		  
		  'system.DebugLog "about to send request"
		  'sock.SetRequestContent(data, "multipart/form-data; boundary=" + boundaryText)
		  '
		  'dim url as text = RaiseEvent sock.GetURLPattern
		  'sock.Send(sock.HTTPAction, url)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Protected Sub BuildMultipartRequest(file as Xojo.IO.FolderItem, formData as Xojo.Core.Dictionary, ByRef payload As Xojo.Core.MemoryBlock, ByRef mimeType As Text)
		  dim boundary as xojo.Core.MemoryBlock
		  dim boundaryText as text
		  if true then // Scope
		    dim boundString as string = "--" + Right(EncodeHex(MD5(Str(Microseconds))), 24) + "-bOuNdArY"
		    boundString = boundString.DefineEncoding(Encodings.UTF8)
		    boundaryText = boundString.ToText
		    boundary = Xojo.Core.TextEncoding.UTF8.ConvertTextToData(boundaryText)
		  end if
		  static doubleDashes as xojo.Core.MemoryBlock = Xojo.Core.TextEncoding.UTF8.ConvertTextToData("--")
		  
		  static eol as text = &u0D + &u0A
		  static CRLF as Xojo.Core.MemoryBlock = Xojo.Core.TextEncoding.UTF8.ConvertTextToData(eol)
		  
		  dim enc as Xojo.Core.TextEncoding = Xojo.Core.TextEncoding.UTF8
		  
		  dim data as new Xojo.Core.MutableMemoryBlock(0)
		  dim out as new Xojo.IO.BinaryStream(data)
		  
		  if formData isa object then
		    for each entry as Xojo.Core.DictionaryEntry in formData
		      dim key as auto = entry.Key
		      dim value as auto = entry.Value
		      
		      out.Write(doubleDashes)
		      out.Write(boundary)
		      out.Write(CRLF)
		      dim keyText as text = AutoToText( key )
		      dim keyValue as text = AutoToText( value )
		      out.WriteText("Content-Disposition: form-data; name=""" + keyText + """" + eol + eol, enc)
		      out.WriteText(keyValue, enc)
		      out.Write(CRLF)
		    next
		  end if
		  
		  // Start of file
		  out.Write(doubleDashes)
		  out.Write(boundary)
		  out.Write(CRLF)
		  
		  out.WriteText("Content-Disposition: form-data; name=""file""; filename=""" + file.Name + """" + eol, enc)
		  out.WriteText("Content-Type: application/octet-stream" + eol + eol, enc) ' replace with actual MIME Type
		  dim bs as Xojo.IO.BinaryStream = Xojo.IO.BinaryStream.Open(file, Xojo.IO.BinaryStream.LockModes.Read)
		  out.Write(bs.Read(bs.Length))
		  out.Write(CRLF)
		  bs.Close
		  
		  out.Write(doubleDashes)
		  out.Write(boundary)
		  out.Write(doubleDashes)
		  out.Write(CRLF)
		  // End of file
		  
		  out.Close
		  
		  System.DebugLog CurrentMethodName + " sets the paylod"
		  
		  payload = data
		  mimeType = "multipart/form-data; boundary=" + boundaryText
		  
		  'system.DebugLog "about to send request"
		  'sock.SetRequestContent(data, "multipart/form-data; boundary=" + boundaryText)
		  '
		  'dim url as text = RaiseEvent sock.GetURLPattern
		  'sock.Send(sock.HTTPAction, url)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
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

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private Function Length(Extends s As String) As Integer
		  return s.Len
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
