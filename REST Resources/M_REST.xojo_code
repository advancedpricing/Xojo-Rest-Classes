#tag Module
Protected Module M_REST
	#tag Method, Flags = &h1
		Protected Sub BuildMultipartRequest(file as Xojo.IO.FolderItem, additionalData as Dictionary = nil, ByRef payload As Xojo.Core.MemoryBlock, ByRef mimeType As Text)
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
		  dim data as new Xojo.Core.MutableMemoryBlock(0)
		  dim out as new Xojo.IO.BinaryStream(data)
		  
		  if additionalData isa Dictionary then
		    for each key as variant in additionalData.Keys
		      out.Write(doubleDashes)
		      out.Write(boundary)
		      out.Write(CRLF)
		      dim keyText as text = key.StringValue.ToText
		      dim keyValue as text = additionalData.Value(key).StringValue.ToText
		      out.WriteText("Content-Disposition: form-data; name=""" + keyText + """" + eol + eol)
		      out.WriteText(keyValue)
		      out.Write(CRLF)
		    next
		  end if
		  
		  out.WriteText("Content-Disposition: form-data; name=""file""; filename=""" + file.Name + """" + eol)
		  out.WriteText("Content-Type: application/octet-stream" + eol + eol) ' replace with actual MIME Type
		  dim bs as Xojo.IO.BinaryStream = Xojo.IO.BinaryStream.Open(file, Xojo.IO.BinaryStream.LockModes.Read)
		  out.Write(bs.Read(bs.Length))
		  out.Write(CRLF)
		  bs.Close
		  
		  out.Write(doubleDashes)
		  out.Write(boundary)
		  out.Write(doubleDashes)
		  out.Write(CRLF)
		  
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
