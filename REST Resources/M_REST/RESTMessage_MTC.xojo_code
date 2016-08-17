#tag Class
Class RESTMessage_MTC
Inherits Xojo.Net.HTTPSocket
Implements PrivateMessage,UnitTestRESTMessage
	#tag Event
		Function AuthenticationRequired(Realm as Text, ByRef Name as Text, ByRef Password as Text) As Boolean
		  dim surrogate as M_REST.PrivateSurrogate = MessageSurrogate
		  
		  if RaiseEvent AuthenticationRequired( realm, name, password ) or _
		    ( surrogate isa object and surrogate.RaiseAuthenticationRequired( self, realm, name, password ) ) then
		    return true
		  else
		    return false
		  end if
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub Error(err as RuntimeException)
		  mIsConnected = false
		  
		  dim surrogate as M_REST.PrivateSurrogate = MessageSurrogate
		  
		  if surrogate isa object then
		    surrogate.RemoveMessage self
		  end if
		  
		  if err isa Xojo.Net.NetException then
		    select case err.ErrorNumber
		    case 102
		      RaiseEvent Disconnected
		      
		      if surrogate isa object then
		        surrogate.RaiseDisconnected( self )
		      end if
		      
		    case else
		      RaiseEvent Error( err.Reason )
		      
		      if surrogate isa object then
		        surrogate.RaiseError( self, err.Reason )
		      end if
		      
		    end select
		    
		    MessageSurrogate = nil
		    
		  else
		    
		    MessageSurrogate = nil
		    raise err
		    
		  end if
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub FileReceived(URL as Text, HTTPStatus as Integer, File as xojo.IO.FolderItem)
		  #pragma unused url
		  #pragma unused httpStatus
		  #pragma unused file
		  
		  // Do nothing for now
		End Sub
	#tag EndEvent

	#tag Event
		Sub HeadersReceived(URL as Text, HTTPStatus as Integer)
		  RaiseEvent HeadersReceived( url, httpStatus )
		  
		  dim surrogate as M_REST.PrivateSurrogate = MessageSurrogate
		  if surrogate isa object then
		    surrogate.RaiseHeadersReceived( self, url, httpStatus )
		  end if
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub PageReceived(URL as Text, HTTPStatus as Integer, Content as xojo.Core.MemoryBlock)
		  ResponseReceivedMicroseconds = Microseconds
		  
		  mIsConnected = false
		  dim surrogate as M_REST.PrivateSurrogate = MessageSurrogate
		  
		  if surrogate isa object then
		    surrogate.RemoveMessage self
		  end if
		  
		  ClearReturnProperties
		  
		  dim payload as Auto = content
		  
		  if not SkipIncomingPayloadProcessing( url, httpStatus, payload ) then
		    //
		    // The subclass may have changed the payload into 
		    // a dictionary. If so, process it
		    // as JSON
		    //
		    if payload isa Xojo.Core.Dictionary then
		      ProcessJSONPayload( payload )
		    else
		      payload = ProcessPayload( payload )
		    end if
		  end if
		  
		  ReceiveFinishedMicroseconds = microseconds
		  RaiseEvent ResponseReceived url, httpStatus, payload 
		  
		  //
		  // NOTE: If the caller no longer exists, you will get a NilObjectException here
		  //
		  
		  if surrogate isa object then
		    surrogate.RaiseResponseReceived( self, url, httpStatus, payload )
		    MessageSurrogate = nil
		  end if
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub ReceiveProgress(BytesReceived as Int64, TotalBytes as Int64, NewData as xojo.Core.MemoryBlock)
		  RaiseEvent ReceiveProgress( bytesReceived, totalBytes, newData )
		  
		  dim surrogate as M_REST.PrivateSurrogate = MessageSurrogate
		  if surrogate isa object then
		    surrogate.RaiseReceiveProgress( self, bytesReceived, totalBytes, newData )
		  end if
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub SendProgress(BytesSent as Int64, BytesLeft as Int64)
		  RaiseEvent SendProgress( bytesSent, bytesLeft )
		  
		  dim surrogate as M_REST.PrivateSurrogate = MessageSurrogate
		  if surrogate isa object then
		    surrogate.RaiseSendProgress( self, bytesSent, bytesLeft )
		  end if
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub ClearClassMeta()
		  if ClassName <> "" and ClassMetaDict isa object and ClassMetaDict.HasKey( ClassName ) then
		    ClassMetaDict.Remove ClassName
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ClearReturnProperties()
		  CreateMeta
		  
		  dim meta as M_REST.ClassMeta = MyMeta
		  if meta is nil or MessageOptions.ReturnPropertyPrefix = "" then
		    return
		  end if
		  
		  for each entry as Xojo.Core.DictionaryEntry in meta.ReturnPropertiesDict
		    dim prop as Xojo.Introspection.PropertyInfo = entry.Value
		    dim propType as text = prop.PropertyType.Name
		    
		    if propType = "String()" then
		      #if not TargetiOS then
		        dim arr() as string = prop.Value( self )
		        redim arr( -1 )
		      #endif
		      
		    elseif propType = "Text()" then
		      dim arr() as text = prop.Value( self )
		      redim arr( -1 )
		      
		    elseif propType = "Double()" then
		      dim arr() as double = prop.Value( self )
		      redim arr( -1 )
		      
		    elseif propType = "Single()" then
		      dim arr() as single = prop.Value( self )
		      redim arr( -1 )
		      
		    elseif propType = "Currency()" then
		      dim arr() as currency
		      redim arr( -1 )
		      
		    elseif propType = "Boolean()" then
		      dim arr() as boolean = prop.Value( self )
		      redim arr( -1 )
		      
		    elseif propType = "Int8()" then
		      dim arr() as Int8 = prop.Value( self )
		      redim arr( -1 )
		      
		    elseif propType = "Int16()" then
		      dim arr() as Int16 = prop.Value( self )
		      redim arr( -1 )
		      
		    elseif propType = "Int32()" then
		      dim arr() as Int32 = prop.Value( self )
		      redim arr( -1 )
		      
		    elseif propType = "Int64()" then
		      dim arr() as Int64 = prop.Value( self )
		      redim arr( -1 )
		      
		    elseif propType = "UInt8()" then
		      dim arr() as UInt8 = prop.Value( self )
		      redim arr( -1 )
		      
		    elseif propType = "UInt16()" then
		      dim arr() as UInt16 = prop.Value( self )
		      redim arr( -1 )
		      
		    elseif propType = "UInt32()" then
		      dim arr() as UInt32 = prop.Value( self )
		      redim arr( -1 )
		      
		    elseif propType = "UInt64()" then
		      dim arr() as UInt64 = prop.Value( self )
		      redim arr( -1 )
		      
		    elseif propType.EndsWith( "()" ) then
		      //
		      // Object array
		      //
		      dim arr() as object = prop.Value( self )
		      redim arr( -1 )
		      
		    elseif propType = "Text" or propType = "String" then
		      prop.Value( self ) = ""
		      
		    elseif propType.Length > 4 and ( propType.BeginsWith( "Int" ) or propType.BeginsWith( "UInt" ) ) then
		      prop.Value( self ) = 0
		      
		    elseif propType = "Double" or propType = "Single" or propType = "Currency" then
		      prop.Value( self ) = 0.0
		      
		    elseif propType = "Boolean" then
		      prop.Value( self ) = false
		      
		    else
		      //
		      // Must be an object
		      //
		      prop.Value( self ) = nil
		      
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  CreateMeta
		  
		  TimeoutTimer = new Xojo.Core.Timer
		  TimeoutTimer.Mode = Xojo.Core.Timer.Modes.Off
		  
		  AddHandler TimeoutTimer.Action, WeakAddressOf TimeoutTimer_Action
		  
		  RaiseEvent Setup
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CreateMeta()
		  if ClassMetaDict is nil then
		    ClassMetaDict = new Xojo.Core.Dictionary
		  end if
		  
		  dim tiSelf as Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType( self )
		  ClassName = tiSelf.FullName
		  dim classMeta as M_REST.ClassMeta = ClassMetaDict.Lookup( className, nil )
		  if classMeta isa object then
		    //
		    // Already done
		    //
		    return
		  end if
		  classMeta = new M_REST.ClassMeta
		  
		  dim tiBase as Xojo.Introspection.TypeInfo = tiSelf.BaseType
		  while tiBase.BaseType isa Object and tiBase.BaseType.FullName <> "Xojo.Net.HTTPSocket"
		    tiBase = tiBase.BaseType
		  wend
		  
		  //
		  // Get or create the meta for the base class
		  //
		  dim baseName as text = tiBase.FullName
		  dim baseMeta as M_REST.ClassMeta = ClassMetaDict.Lookup( baseName, nil )
		  if baseMeta is nil then
		    baseMeta = new M_REST.ClassMeta
		    dim dict as Xojo.Core.Dictionary = baseMeta.SendPropertiesDict
		    
		    dim props() as Xojo.Introspection.PropertyInfo = tiBase.Properties
		    for each prop as Xojo.Introspection.PropertyInfo in props
		      dim propName as text = prop.Name
		      if prop.CanRead and prop.IsPublic and not prop.IsShared then
		        dict.Value( propName ) = prop
		      end if
		    next
		  end if
		  
		  //
		  // Fill out the class meta
		  //
		  for each prop as Xojo.Introspection.PropertyInfo in tiSelf.Properties
		    dim propName as text = prop.Name
		    
		    if prop.IsShared or not prop.IsPublic then
		      //
		      // Doesn't qualify
		      //
		      continue for prop
		    end if
		    
		    if baseMeta.SendPropertiesDict.HasKey( propName ) or baseMeta.ReturnPropertiesDict.HasKey( propName ) then
		      //
		      // Part of the base so we ignore it
		      //
		      continue for prop
		    end if
		    
		    if propName = "Index" then
		      //
		      // Something that comes up in a window, so ignore it
		      //
		      continue for prop
		    end if
		    
		    dim isReturnProp as boolean
		    
		    dim returnPropPrefix as text = MessageOptions.ReturnPropertyPrefix
		    dim prefixLength as integer = returnPropPrefix.Length
		    if returnPropPrefix = "" or _ // Can be empty
		      ( propName.Length > prefixLength and propName.Left( prefixLength ) = returnPropPrefix ) then // Return property 
		      if prop.CanWrite then 
		        classMeta.ReturnPropertiesDict.Value( propName ) = prop
		        isReturnProp = true
		      end if
		    end if
		    
		    if not isReturnProp or returnPropPrefix = "" then // Send property
		      if prop.CanRead then
		        classMeta.SendPropertiesDict.Value( propName ) = prop
		      end if
		    end if
		  next prop
		  
		  classMetaDict.Value( className ) = classMeta
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CreateOutgoingPayload(props() As Xojo.Introspection.PropertyInfo) As Xojo.Core.MemoryBlock
		  dim result as Xojo.Core.MemoryBlock
		  
		  dim json as new Xojo.Core.Dictionary
		  
		  for each prop as Xojo.Introspection.PropertyInfo in props
		    dim propName as text = prop.Name
		    dim propValue as auto = prop.Value( self )
		    
		    if not RaiseEvent ExcludeFromOutgoingPayload( prop, propName, propValue ) then
		      json.Value( propName ) = Serialize( propValue )
		    end if
		  next
		  
		  if json.Count <> 0 then
		    dim t as text = Xojo.Data.GenerateJSON( json )
		    dim encoding as Xojo.Core.TextEncoding = MessageOptions.ExpectedTextEncoding
		    result = encoding.ConvertTextToData( t )
		  end if
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Deserialize(value As Auto, intoProp As Xojo.Introspection.PropertyInfo, currentValue As Auto) As Auto
		  dim tiDestination as Xojo.Introspection.TypeInfo = intoProp.PropertyType
		  dim typeName as text = tiDestination.Name
		  
		  if typeName.Length > 2 and typeName.EndsWith( "()" ) then
		    return DeserializeArray( value, intoProp, currentValue )
		    
		  elseif typeName = "Auto" then
		    return value
		    
		  elseif typeName = "Xojo.Core.Dictionary" and value isa Xojo.Core.Dictionary then
		    return value
		    
		  elseif IsIntrinsicType( typeName ) then
		    //
		    // See if we have to coerce the value from text
		    //
		    value = MaybeCoerceValue( value, tiDestination )
		    return value
		    
		  else 
		    return DeserializeObject( value, intoProp )
		    
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DeserializeArray(value As Auto, intoProp As Xojo.Introspection.PropertyInfo, existingArray As Auto) As Auto
		  dim tiDestination as Xojo.Introspection.TypeInfo = intoProp.PropertyType
		  dim typeName as text = tiDestination.Name
		  
		  dim sourceArr() as auto = value
		  
		  select case typeName
		  case "Text()"
		    dim arr() as text
		    try
		      redim arr( sourceArr.Ubound )
		      for i as integer = 0 to sourceArr.Ubound
		        arr( i ) = sourceArr( i )
		      next
		    catch err as TypeMismatchException
		      redim arr( -1 )
		    end try
		    return arr
		    
		  case "String()"
		    #if not TargetiOS then
		      dim arr() as string
		      try
		        redim arr( sourceArr.Ubound )
		        for i as integer = 0 to sourceArr.Ubound
		          arr( i ) = MaybeCoerceValue( sourceArr( i ), tiDestination )
		        next
		      catch err as TypeMismatchException
		        redim arr( -1 )
		      end try
		      return arr
		    #endif
		    
		  case "Boolean()"
		    dim arr() as boolean
		    try
		      redim arr( sourceArr.Ubound )
		      for i as integer = 0 to sourceArr.Ubound
		        arr( i ) = MaybeCoerceValue( sourceArr( i ), tiDestination )
		      next
		    catch err as TypeMismatchException
		      redim arr( -1 )
		    end try
		    return arr
		    
		  case "Currency()"
		    dim arr() as currency
		    try
		      redim arr( sourceArr.Ubound )
		      for i as integer = 0 to sourceArr.Ubound
		        arr( i ) = MaybeCoerceValue( sourceArr( i ), tiDestination )
		      next
		    catch err as TypeMismatchException
		      redim arr( -1 )
		    end try
		    return arr
		    
		  case "Double()"
		    dim arr() as double
		    try
		      redim arr( sourceArr.Ubound )
		      for i as integer = 0 to sourceArr.Ubound
		        arr( i ) = MaybeCoerceValue( sourceArr( i ), tiDestination )
		      next
		    catch err as TypeMismatchException
		      redim arr( -1 )
		    end try
		    return arr
		    
		  case "Single()"
		    dim arr() as single
		    try
		      redim arr( sourceArr.Ubound )
		      for i as integer = 0 to sourceArr.Ubound
		        arr( i ) = MaybeCoerceValue( sourceArr( i ), tiDestination )
		      next
		    catch err as TypeMismatchException
		      redim arr( -1 )
		    end try
		    return arr
		    
		  case "Int8()"
		    dim arr() as Int8
		    try
		      redim arr( sourceArr.Ubound )
		      for i as integer = 0 to sourceArr.Ubound
		        arr( i ) = MaybeCoerceValue( sourceArr( i ), tiDestination )
		      next
		    catch err as TypeMismatchException
		      redim arr( -1 )
		    end try
		    return arr
		    
		  case "Int16()"
		    dim arr() as Int16
		    try
		      redim arr( sourceArr.Ubound )
		      for i as integer = 0 to sourceArr.Ubound
		        arr( i ) = MaybeCoerceValue( sourceArr( i ), tiDestination )
		      next
		    catch err as TypeMismatchException
		      redim arr( -1 )
		    end try
		    return arr
		    
		  case "Int32()"
		    dim arr() as Int32
		    try
		      redim arr( sourceArr.Ubound )
		      for i as integer = 0 to sourceArr.Ubound
		        arr( i ) = MaybeCoerceValue( sourceArr( i ), tiDestination )
		      next
		    catch err as TypeMismatchException
		      redim arr( -1 )
		    end try
		    return arr
		    
		  case "Int64()"
		    dim arr() as Int64
		    try
		      redim arr( sourceArr.Ubound )
		      for i as integer = 0 to sourceArr.Ubound
		        arr( i ) = MaybeCoerceValue( sourceArr( i ), tiDestination )
		      next
		    catch err as TypeMismatchException
		      redim arr( -1 )
		    end try
		    return arr
		    
		  case "Byte()"
		    dim arr() as byte
		    try
		      redim arr( sourceArr.Ubound )
		      for i as integer = 0 to sourceArr.Ubound
		        arr( i ) = MaybeCoerceValue( sourceArr( i ), tiDestination )
		      next
		    catch err as TypeMismatchException
		      redim arr( -1 )
		    end try
		    return arr
		    
		  case "UInt8()"
		    dim arr() as UInt8
		    try
		      redim arr( sourceArr.Ubound )
		      for i as integer = 0 to sourceArr.Ubound
		        arr( i ) = MaybeCoerceValue( sourceArr( i ), tiDestination )
		      next
		    catch err as TypeMismatchException
		      redim arr( -1 )
		    end try
		    return arr
		    
		  case "UInt16()"
		    dim arr() as UInt16
		    try
		      redim arr( sourceArr.Ubound )
		      for i as integer = 0 to sourceArr.Ubound
		        arr( i ) = MaybeCoerceValue( sourceArr( i ), tiDestination )
		      next
		    catch err as TypeMismatchException
		      redim arr( -1 )
		    end try
		    return arr
		    
		  case "UInt32()"
		    dim arr() as UInt32
		    try
		      redim arr( sourceArr.Ubound )
		      for i as integer = 0 to sourceArr.Ubound
		        arr( i ) = MaybeCoerceValue( sourceArr( i ), tiDestination )
		      next
		    catch err as TypeMismatchException
		      redim arr( -1 )
		    end try
		    return arr
		    
		  case "UInt64()"
		    dim arr() as UInt64
		    try
		      redim arr( sourceArr.Ubound )
		      for i as integer = 0 to sourceArr.Ubound
		        arr( i ) = MaybeCoerceValue( sourceArr( i ), tiDestination )
		      next
		    catch err as TypeMismatchException
		      redim arr( -1 )
		    end try
		    return arr
		    
		  case "Integer()"
		    dim arr() as integer
		    try
		      redim arr( sourceArr.Ubound )
		      for i as integer = 0 to sourceArr.Ubound
		        arr( i ) = MaybeCoerceValue( sourceArr( i ), tiDestination )
		      next
		    catch err as TypeMismatchException
		      redim arr( -1 )
		    end try
		    return arr
		    
		  case "Auto()"
		    dim arr() as auto
		    redim arr( sourceArr.Ubound )
		    for i as integer = 0 to sourceArr.Ubound
		      arr( i ) = sourceArr( i )
		    next
		    return arr
		    
		  case "Variant()"
		    #if not TargetiOS then
		      dim arr() as variant 
		      redim arr( sourceArr.Ubound )
		      for i as integer = 0 to sourceArr.Ubound
		        arr( i ) = sourceArr( i )
		      next
		      return arr
		    #endif
		    
		  case else
		    //
		    // Must be an object array
		    //
		    
		    dim arr() as object
		    
		    //
		    // Lets get a TypeInfo for the array elements
		    //
		    dim objectClassName as text = tiDestination.FullName.Replace( "()", "" )
		    dim tiObject as Xojo.Introspection.TypeInfo = TypeInfoForClassName( objectClassName )
		    
		    try
		      arr = existingArray
		      
		      if tiObject isa object then
		        redim arr( sourceArr.Ubound )
		        for i as integer = 0 to sourceArr.Ubound
		          arr( i ) = DeserializeObject( sourceArr( i ), intoProp, tiObject )
		        next
		      else
		        redim arr( -1 )
		      end if
		      return existingArray
		      
		    catch err as TypeMismatchException
		      redim arr( -1 )
		      return existingArray
		    end try
		    return arr
		    
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DeserializeDate(value As Text, intoProp As Xojo.Introspection.PropertyInfo) As Auto
		  //
		  // We are expecting the ISO 8601 format
		  // as a date or date and time.
		  //
		  // https://en.wikipedia.org/wiki/ISO_8601
		  //
		  
		  dim parts() as text = value.Split( "T" )
		  if parts.Ubound = -1 or parts.Ubound > 1 then
		    //
		    // We don't recognize this format
		    //
		    return nil
		  end if
		  
		  dim datePart as text = parts( 0 )
		  dim dateParts() as text = datePart.Split( "-" )
		  if dateParts.Ubound <> 2 then
		    return nil
		  end if
		  
		  dim year as integer = Integer.FromText( dateParts( 0 ) )
		  dim month as integer = Integer.FromText( dateParts( 1 ) )
		  dim day as integer = Integer.FromText( dateParts( 2 ) )
		  
		  //
		  // See if there is a time
		  //
		  dim hour as integer
		  dim minute as integer
		  dim second as integer
		  
		  dim tz as Xojo.Core.TimeZone = Xojo.Core.TimeZone.Current
		  dim tzHours as double = tz.SecondsFromGMT / 3600.0
		  
		  if parts.Ubound = 1 then
		    dim timePart as text = parts( 1 )
		    dim timeParts() as text 
		    dim tzPart as text
		    
		    select case true
		    case timePart.IndexOf( "Z" ) <> -1
		      timeParts = timePart.Split( "Z" )
		      timePart = timeParts( 0 )
		      tzPart = "0"
		      
		    case timePart.IndexOf( "-" ) <> -1 
		      timeParts = timePart.Split( "-" )
		      timePart = timeParts( 0 )
		      tzPart = "-" + timeParts( 1 )
		      
		    case timePart.IndexOf( "+" ) <> -1 
		      timeParts = timePart.Split( "+" )
		      timePart = timeParts( 0 )
		      tzPart = timeParts( 1 )
		      
		    end select
		    
		    //
		    // The time will either be in HH:MM:SS format or HHMMSS format
		    //
		    timePart = timePart.ReplaceAll( ":", "" )
		    if timePart.Length = 6 then
		      hour = Integer.FromText( timePart.Left( 2 ) )
		      minute = Integer.FromText( timePart.Mid( 2, 2 ) )
		      second = Integer.FromText( timePart.Right( 2 ) )
		      
		      //
		      // Process the timezone, maybe
		      //
		      if MessageOptions.AdjustDatesForTimeZone then
		        dim tzParts() as text = tzPart.Split( ":" )
		        if tzParts.Ubound = 1 then
		          tzHours = Integer.FromText( tzParts( 0 ) ) + ( Integer.FromText( tzParts( 1 ) ) / 60.0 )
		          tz = new Xojo.Core.TimeZone( tzHours * 3600.0 )
		        end if
		      end if
		      
		    end if
		  end if
		  
		  //
		  // Create the object
		  //
		  select case intoProp.PropertyType.FullName.Replace( "()", "")
		  case "Xojo.Core.Date"
		    dim d as new Xojo.Core.Date( year, month, day, hour, minute, second, 0, tz )
		    return d
		    
		  case else
		    #if not TargetiOS then
		      dim d as new Date( year, month, day, hour, minute, second, tzHours )
		      return d
		    #endif
		    
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DeserializeDictionary(value As Xojo.Core.Dictionary, intoProp As Xojo.Introspection.PropertyInfo) As Auto
		  select case intoProp.PropertyType.FullName.Replace( "()", "" )
		  case "Xojo.Core.Dictionary"
		    dim dict as new Xojo.Core.Dictionary
		    for each entry as Xojo.Core.DictionaryEntry in value
		      dict.Value( entry.Key ) = entry.Value
		    next
		    return dict
		    
		  case "Dictionary"
		    #if not TargetiOS then
		      dim dict as new Dictionary
		      for each entry as Xojo.Core.DictionaryEntry in value
		        dict.Value( entry.Key ) = entry.Value
		      next
		      return dict
		    #endif
		    
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DeserializeObject(value As Auto, intoProp As Xojo.Introspection.PropertyInfo, objectTypeInfo As Xojo.Introspection.TypeInfo = Nil) As Object
		  if value = nil then
		    return nil
		  end if
		  
		  dim tiObject as Xojo.Introspection.TypeInfo = if( objectTypeInfo is nil, intoProp.PropertyType, objectTypeInfo )
		  dim typeName as text = tiObject.Name
		  
		  select case typeName.Replace( "()", "" )
		  case "Dictionary", "Xojo.Core.Dictionary"
		    return DeserializeDictionary( value, intoProp )
		    
		  case "Date", "Xojo.Core.Date"
		    return DeserializeDate( value, intoProp )
		    
		  case else
		    //
		    // Have to create a new object to return
		    //
		    dim c as Xojo.Introspection.ConstructorInfo = GetZeroParamConstructor( tiObject )
		    if c isa object then
		      dim o as object = c.Invoke
		      
		      //
		      // Create a dictionary of the object's properties
		      //
		      dim propsDict as new Xojo.Core.Dictionary
		      for each prop as Xojo.Introspection.PropertyInfo in tiObject.Properties
		        if prop.CanWrite and prop.IsPublic and not prop.IsShared then
		          propsDict.Value( prop.Name ) = prop
		        end if
		      next prop
		      
		      if propsDict.Count <> 0 then
		        JSONObjectToProps( value, propsDict, "", o )
		      end if
		      
		      return o
		    end if
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  if TimeoutTimer isa Object then
		    TimeoutTimer.Mode = Xojo.Core.Timer.Modes.Off
		    RemoveHandler TimeoutTimer.Action, WeakAddressOf TimeoutTimer_Action
		    TimeoutTimer = nil
		  end if
		  
		  //
		  // We don't bother removing the message from the MessageSurrogate here.
		  // Why? Well, if the surrogate still has the message, this
		  // Destructor will never fire anyway.
		  //
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Disconnect()
		  if IsConnected then
		    mIsConnected = false
		    TimeoutTimer.Mode = Xojo.Core.Timer.Modes.Off
		    super.Disconnect
		  end if
		  
		  dim surrogate as M_REST.PrivateSurrogate = MessageSurrogate
		  if surrogate isa object then
		    surrogate.RemoveMessage self
		    MessageSurrogate = nil
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ExpandURLPattern(urlPattern As Text, ByRef returnPayloadProps() As Xojo.Introspection.PropertyInfo) As Text
		  //
		  // Expand the given url pattern using the properties
		  // of the class. The properties must be public and readable.
		  //
		  // Returns the payload props as it expands since properties found in the url
		  // will not be included in the payload. To force it to be included, create a
		  // second property and use one in the URL. Use the ExcludeFromOutgoingPayload
		  // event to control when and how a property should be included in the payload.
		  //
		  
		  CreateMeta // Just in case
		  dim meta as M_REST.ClassMeta = MyMeta
		  
		  dim url as text = urlPattern.Trim
		  
		  //
		  // Expand the URL
		  //
		  dim urlPropNames() as text
		  dim payloadProps() as Xojo.Introspection.PropertyInfo
		  
		  for each entry as Xojo.Core.DictionaryEntry in meta.SendPropertiesDict
		    dim prop as Xojo.Introspection.PropertyInfo = entry.Value
		    dim propName as text = prop.Name
		    
		    dim marker as text = ":" + prop.Name
		    if url.IndexOf( marker ) = -1 then
		      payloadProps.Append prop
		    else
		      
		      urlPropNames.Append propName
		      dim value as auto = prop.Value( self )
		      
		      //
		      // Get the text version of the value
		      //
		      dim tiValue as Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType( value )
		      dim textValue as text
		      
		      select case tiValue.Name
		      case "Text"
		        //
		        // Already good
		        //
		        textValue = value
		        
		      case "Integer", "Int8", "Int16", "Int32", "Int64"
		        dim i as Int64 = value
		        textValue = i.ToText
		        
		      case "UInt8", "UInt16", "UInt32", "UInt64", "Byte"
		        dim i as UInt64 = value
		        textValue = i.ToText
		        
		      case "Double", "Single", "Currency"
		        dim d as double = value
		        textValue = d.ToText
		        
		      case "String"
		        #if not TargetiOS then
		          dim s as string = value
		          textValue = s.ToText
		        #endif
		        
		      case "Boolean"
		        const kTrueValue as text = "true"
		        const kFalseValue as text = "false"
		        
		        dim b as boolean = value
		        textValue = if( b, kTrueValue, kFalseValue )
		        
		      case else
		        if value isa M_REST.TextProvider then
		          textValue = M_REST.TextProvider( value ).ConvertToText
		        else
		          raise new M_REST.RESTException( "The property " + propName + " cannot be converted to Text" )
		        end if
		      end select
		      
		      url = url.ReplaceAll( marker, textValue )
		    end if
		  next
		  
		  returnPayloadProps = payloadProps
		  return url
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetSendParameters(ByRef action As Text, ByRef url As Text, ByRef mimeType As Text, ByRef payload As Xojo.Core.MemoryBlock) As Boolean
		  action = HTTPAction
		  if action = kActionUnknown then
		    raise new M_REST.RESTException( "REST type was not specified" )
		  end if
		  
		  url = RaiseEvent GetURLPattern
		  dim payloadProps() as Xojo.Introspection.PropertyInfo
		  url = ExpandURLPattern( url, payloadProps )
		  
		  if action <> kActionGet and payloadProps.Ubound <> -1 and MessageOptions.SendWithPayloadIfAvailable then
		    payload = CreateOutgoingPayload( payloadProps )
		  end if
		  
		  mimeType = "application/json"
		  if RaiseEvent CancelSend( url, action, payload, mimeType ) then
		    return false
		  end if
		  
		  return true
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function IsIntrinsicType(propType As Text) As Boolean
		  static types() as text
		  
		  if types.Ubound = -1 then
		    types = array( _
		    "Int8", "Int16", "Int32", "Int64", _
		    "Byte", "UInt8", "UInt16", "UInt32", "UInt64", _
		    "Single", "Double", "Currency", _
		    "String", "Text", _
		    "Boolean" _
		    )
		    
		    //
		    // Add the array versions
		    //
		    dim lastIndex as integer = types.Ubound
		    for i as integer = 0 to lastIndex
		      types.Append types( i ) + "()"
		    next
		  end if
		  
		  return types.IndexOf( propType ) <> -1
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub JSONObjectToProps(json As Xojo.Core.Dictionary, propsDict As Xojo.Core.Dictionary, propPrefix As Text, hostObject As Object)
		  for each entry as Xojo.Core.DictionaryEntry in json
		    dim returnPropName as text = propPrefix + entry.Key
		    if not propsDict.HasKey( returnPropName ) then
		      continue for entry
		    end if
		    
		    dim prop as Xojo.Introspection.PropertyInfo = propsDict.Value( returnPropName )
		    
		    dim value as Auto = entry.Value
		    
		    if not RaiseEvent IncomingPayloadValueToProperty( value, prop, hostObject ) then
		      try
		        value = Deserialize( value, prop, prop.Value( hostObject ) )
		        
		        //
		        // If the value now holds an Object(), it was already populated by
		        // DeserializeArray, so we can skip the TypeMismatchException
		        //
		        if value = nil or Xojo.Introspection.GetType( value ).Name <> "Object()" then
		          #pragma BreakOnExceptions false
		          prop.Value( hostObject ) = value
		          #pragma BreakOnExceptions default
		        end if
		        
		      catch err as TypeMismatchException
		        //
		        // Didn't work, move on
		        //
		      end try
		      
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MaybeCoerceValue(value As Auto, targetTypeInfo As Xojo.Introspection.TypeInfo) As Auto
		  //
		  // Some JSON will return text for certain types of values (doubles or big ints, usually).
		  // If the value is given as text but we are expecting something else,
		  // we are going to do our best to coerce it.
		  //
		  // In some cases, it won't be enough so the IncomingPayloadValueToProperty event
		  // should be used to store the value manually.
		  //
		  
		  if value = nil then
		    return value
		  end if
		  
		  dim targetName as text = targetTypeInfo.Name.Replace( "()", "" )
		  
		  dim valueTypeInfo as Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType( value )
		  dim valueName as text = valueTypeInfo.Name
		  
		  if valueName <> "Text" or valueName = targetName then
		    return value
		  end if
		  
		  //
		  // If we get here, we are dealing with a Text value so we will try to coerce it
		  // into the expected type
		  //
		  
		  dim textValue as text = value
		  select case targetName
		  case "String"
		    #if not TargetiOS then
		      dim s as string = textValue
		      return s
		    #endif
		    
		  case "Boolean"
		    select case textValue
		    case "true", "t", "yes", "y", "1"
		      return true
		      
		    case "false", "f", "no", "n", "0"
		      return false
		      
		    case else
		      return value
		      
		    end select
		    
		  case "Integer", "Int8", "Int16", "Int32", "Int64"
		    try
		      dim i as Int64 = Int64.FromText( textValue )
		      return i
		    catch err as Xojo.Core.BadDataException
		      return value
		    end try
		    
		  case "UInteger", "UInt8", "Byte", "UInt16", "UInt32", "UInt64"
		    try
		      dim i as UInt64 = UInt64.FromText( textValue )
		      return i
		    catch err as Xojo.Core.BadDataException
		      return value
		    end try
		    
		  case "Currency"
		    try
		      dim c as currency = Currency.FromText( textValue )
		      return c
		    catch err as Xojo.Core.BadDataException
		      return value
		    end try
		    
		  case "Double", "Single"
		    //
		    // Won't get an exception with a double, so let's see if it's valid
		    //
		    #if not TargetiOS then
		      if not IsNumeric( textValue ) then
		        return value
		      end if
		    #endif
		    
		    try
		      dim d as double = Double.FromText( textValue )
		      return d
		    catch err as Xojo.Core.BadDataException
		      return value
		    end try
		    
		  end select
		  
		  //
		  // If we get here, just return the original value
		  //
		  return value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PrepareToSend()
		  mIsConnected = true
		  RequestSentMicroseconds = Microseconds
		  ResponseReceivedMicroseconds = -1.0
		  
		  TimeoutTimer.Period = MessageOptions.TimeOutSeconds * 1000
		  TimeoutTimer.Mode = Xojo.Core.Timer.Modes.Multiple
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ProcessImagePayload(payload As Xojo.Core.MemoryBlock) As Auto
		  dim result as Auto
		  
		  #if TargetiOS then
		    
		    dim image as iOSImage = iOSImage.FromData( payload )
		    result = image
		    
		  #else
		    
		    //
		    // Have to use the classic MemoryBlock
		    //
		    dim mbTemp as MemoryBlock = payload.Data
		    dim p as Picture = Picture.FromData( mbTemp.StringValue( 0, payload.Size ) )
		    result = p
		    
		  #endif
		  
		  if result <> nil then
		    //
		    // It's got something, so let's try to store it
		    //
		    
		    dim meta as M_REST.ClassMeta = MyMeta
		    dim tiResult as Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType( result )
		    dim matchType as text = tiResult.Name
		    
		    dim picProps() as Xojo.Introspection.PropertyInfo
		    
		    for each entry as Xojo.Core.DictionaryEntry in meta.ReturnPropertiesDict
		      dim prop as Xojo.Introspection.PropertyInfo = entry.Value
		      if prop.PropertyType.Name = matchType then
		        picProps.Append prop
		      end if
		    next
		    
		    if picProps.Ubound = 0 then
		      picProps( 0 ).Value( self ) = result
		    end if
		  end if
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessJSONPayload(payload As Auto)
		  CreateMeta // REALLY shouldn't be needed, but let's make sure
		  
		  dim returnProps as Xojo.Core.Dictionary = MyMeta.ReturnPropertiesDict
		  
		  //
		  // Let the subclass modify as needed
		  //
		  RaiseEvent BeforeJSONProcessing( payload )
		  
		  //
		  // If the JSON is just an array, see if there is only one return property
		  // and it's an array. If so, copy the items into that.
		  //
		  
		  dim tiPayload as Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType( payload )
		  if tiPayload.Name.Length > 2 and tiPayload.Name.EndsWith( "()" ) then
		    
		    if returnProps.Count = 1 then
		      dim prop as Xojo.Introspection.PropertyInfo
		      for each entry as Xojo.Core.DictionaryEntry in returnProps
		        prop = entry.Value
		      next
		      
		      try
		        prop.Value( self ) = DeserializeArray( payload, prop, prop.Value( self ) )
		      catch err as TypeMismatchException
		        //
		        // Oh well, we tried
		        //
		      end try
		    end if
		    
		  elseif payload isa Xojo.Core.Dictionary then // Make sure since the subclass may have changed it
		    //
		    // It's an object, so it will be case-sensitive.
		    // Cycle through the object and match it against the returnProps
		    // dictionary that is not case-sensitive
		    //
		    
		    dim json as Xojo.Core.Dictionary = payload
		    dim returnPropPrefix as text = MessageOptions.ReturnPropertyPrefix
		    JSONObjectToProps( json, returnProps, returnPropPrefix, self )
		    
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ProcessPayload(payload As Xojo.Core.MemoryBlock) As Auto
		  dim result as Auto
		  
		  dim indicatedContentType as text 
		  try
		    indicatedContentType = self.ResponseHeader( "Content-Type" )
		  catch err as Xojo.Core.UnsupportedOperationException
		    //
		    // Really shouldn't happen, so we're going to guess and hope we're right
		    //
		    indicatedContentType = "text/json"
		  end try
		  
		  dim parts() as text = indicatedContentType.Split( "/" )
		  dim indicatedType as text = if( parts.Ubound <> -1, parts( 0 ), "" )
		  dim indicatedSubtype as text = if( parts.Ubound > 0, indicatedContentType.Mid( indicatedContentType.IndexOf( "/" ) + 1 ), "" )
		  
		  if indicatedType = "image" then
		    try
		      result = ProcessImagePayload( payload )
		    catch err as RuntimeException
		      if err isa EndException or err isa ThreadEndException then
		        raise err
		      end if
		      indicatedType = ""
		      indicatedSubtype = ""
		    end try
		  end if
		  
		  if indicatedType = "text" or _
		    ( indicatedSubtype.Length >= 4 and indicatedSubtype.BeginsWith( "json" ) ) or _
		    ( indicatedSubtype.Length >= 3 and indicatedSubtype.BeginsWith( "xml" ) ) or _
		    indicatedType = "" then
		    try
		      result = ProcessTextPayload( payload, indicatedSubtype )
		    catch err as RuntimeException
		      if err isa EndException or err isa ThreadEndException then
		        raise err
		      end if
		      indicatedType = ""
		      indicatedSubtype = ""
		    end try
		  end if
		  
		  if result = nil then
		    //
		    // The indicated type was wrong or couldn't be handled properly.
		    // In either case, just pass it on.
		    //
		    result = payload
		  end if
		  
		  return result
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ProcessTextPayload(payload As Xojo.Core.MemoryBlock, subtype As Text) As Auto
		  dim result as Auto
		  
		  dim encoding as Xojo.Core.TextEncoding = MessageOptions.ExpectedTextEncoding
		  
		  //
		  // See if an encoding is indicated
		  //
		  if subtype <> "" then
		    dim parts() as text = subtype.Split( ";" )
		    if parts.Ubound > 0 then
		      
		      dim pairs as new Xojo.Core.Dictionary
		      for each part as text in parts
		        dim subparts() as text = part.Split( "=" )
		        if subparts.Ubound = 1 then
		          pairs.Value( subparts( 0 ).Trim ) = subparts( 1 ).Trim
		        end if
		      next
		      
		      if pairs.HasKey( "charset" ) then
		        try
		          encoding = Xojo.Core.TextEncoding.FromIANAName( pairs.Value( "charset" ) )
		        catch err as RuntimeException
		          if err isa EndException or err isa ThreadEndException then
		            raise err
		          end if
		        end try
		      end if
		      
		    end if
		  end if
		  
		  dim textValue as text = encoding.ConvertDataToText( payload )
		  //
		  // If that crashes, the caller will handle it
		  //
		  
		  //
		  // Try to figure it out
		  //
		  
		  //
		  // JSON?
		  //
		  dim json as Xojo.Core.Dictionary
		  if subtype <> "xml" then
		    //
		    // We are going to try anything since the header could be wrong
		    //
		    try
		      json = Xojo.Data.ParseJSON( textValue )
		      subtype = "json"
		      result = json
		    catch err as RuntimeException
		      if err isa EndException or err isa ThreadEndException then
		        raise err
		      end if
		    end try
		  end if
		  
		  #if not TargetiOS then
		    //
		    // XML?
		    //
		    dim xml as XMLDocument
		    if subtype = "" or subtype = "xml" then
		      try
		        xml = new XmlDocument( textValue )
		        result = xml
		        subtype = "xml"
		      catch err as XmlException
		        //
		        // Do nothing
		        //
		      end try
		    end if
		  #endif
		  
		  if result = nil then
		    result = textValue
		  elseif json isa Xojo.Core.Dictionary then
		    //
		    // It's JSON, so let's try to parse it into the return
		    // properties
		    //
		    ProcessJSONPayload( json )
		  end if
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function PublicPropertiesToDictionary(ti As Xojo.Introspection.TypeInfo) As Xojo.Core.Dictionary
		  dim dict as new Xojo.Core.Dictionary
		  
		  dim props() as Xojo.Introspection.PropertyInfo = ti.Properties
		  for each prop as Xojo.Introspection.PropertyInfo in props
		    if prop.CanRead and prop.IsPublic and not prop.IsShared then
		      dict.Value( prop.Name ) = prop
		    end if
		  next
		  
		  return dict
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub RegisterClassTypeInfo(classTypeInfo As Xojo.Introspection.TypeInfo)
		  //
		  // Will raise a NilObjectException if there is not TypeInfo given
		  //
		  
		  dim className as text = classTypeInfo.FullName.Replace( "()", "" )
		  ClassTypeInfoRegistry.Value( className ) = classTypeInfo
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function RESTTypeToHTTPAction(type As RESTTypes) As Text
		  select case type
		  case RESTTypes.Read, RESTTypes.GET
		    return kActionGet
		    
		  case RESTTypes.Create, RESTTypes.Authenticate, RESTTypes.POST
		    return kActionPost
		    
		  case RESTTypes.DELETE
		    return kActionDelete
		    
		  case RESTTypes.UpdateReplace, RESTTypes.PUT
		    return kActionPut
		    
		  case RESTTypes.UpdateModify, RESTTypes.PATCH
		    return kActionPatch
		    
		  case RESTTypes.OPTIONS
		    return kActionOptions
		    
		  case else
		    return kActionUnknown
		    
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Send(surrogate As RESTMessageSurrogate_MTC = Nil)
		  RequestStartedMicroseconds = microseconds
		  ReceiveFinishedMicroseconds = -1.0
		  
		  dim action as text
		  dim url as text
		  dim mimeType as text
		  dim payload as Xojo.Core.MemoryBlock
		  
		  if not GetSendParameters( action, url, mimeType, payload ) then
		    //
		    // The user chose to cancel
		    //
		    return
		  end if
		  
		  if payload isa object then
		    if mimeType = "" then
		      Raise new M_REST.RESTException( "No MIME type specified" )
		    end if
		    
		    SetRequestContent payload, mimeType
		  end if
		  
		  MessageSurrogate = surrogate
		  Send action, url
		  
		  if surrogate isa object then
		    PrivateSurrogate(surrogate).RaiseSent self
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Send(method as Text, url as Text)
		  //
		  // Disable external access to this
		  //
		  
		  PrepareToSend
		  super.Send( method, url )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Send(method as Text, url as Text, file as Xojo.IO.FolderItem)
		  //
		  // Disable external access to this
		  //
		  
		  PrepareToSend
		  super.Send( method, url, file )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Serialize(value As Auto) As Auto
		  dim ti as Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType( value )
		  if ti is nil then
		    return nil
		  end if
		  
		  dim type as text = ti.Name
		  if type.Length > 2 and type.EndsWith( "()" ) then
		    return SerializeArray( value, ti )
		    
		  elseif type = "String" then
		    #if not TargetiOS then
		      dim s as string = value
		      dim t as text = s.ToText
		      return t
		    #endif
		    
		  elseif type = "Currency" then
		    dim c as currency = value 
		    dim d as double = c
		    return d
		    
		  elseif IsIntrinsicType( type ) then
		    return value
		    
		  else
		    return SerializeObject( value, ti )
		    
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SerializeArray(value As Auto, ti As Xojo.Introspection.TypeInfo) As Auto
		  if ti.Name = "String()" then
		    //
		    // Convert the string to text to make sure JSON can handle it
		    //
		    #if not TargetiOS then
		      dim arr() as string = value
		      dim result() as text
		      redim result( arr.Ubound )
		      for i as integer = 0 to arr.Ubound
		        result( i ) = arr( i ).ToText
		      next i
		      return result
		    #endif
		    
		  elseif ti.Name = "Currency()" then
		    //
		    // JSON can't handle currency so convert to a double
		    //
		    dim arr() as currency = value
		    dim result() as double
		    redim result( arr.Ubound )
		    for i as integer = 0 to arr.Ubound
		      result( i ) = arr( i )
		    next
		    return result
		    
		  elseif IsIntrinsicType( ti.Name ) then
		    //
		    // It's another basic type so just return it
		    //
		    return value
		    
		  else // It's some object array
		    dim arr() as object = value
		    dim result() as auto
		    redim result( arr.Ubound )
		    for i as integer = 0 to arr.Ubound
		      result( i ) = Serialize( arr( i ) )
		    next
		    return result
		    
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SerializeDate(d As Xojo.Core.Date) As Text
		  //
		  // Returns ISO 8601 format
		  //
		  // https://en.wikipedia.org/wiki/ISO_8601
		  //
		  
		  
		  dim result as text
		  
		  if MessageOptions.AdjustDatesForTimeZone then
		    dim tz as Xojo.Core.TimeZone = d.TimeZone
		    dim interval as new Xojo.Core.DateInterval( 0, 0, 0, 0, 0, tz.SecondsFromGMT )
		    d = d - interval
		  end if
		  
		  dim locale as Xojo.Core.Locale = Xojo.Core.Locale.Current
		  
		  result = d.Year.ToText( locale, "0000" ) + "-" + d.Month.ToText( locale, "00" ) + "-" + d.Day.ToText( locale, "00" )
		  result = result + "T" + d.Hour.ToText( locale, "00" ) + ":" + d.Minute.ToText( locale, "00" ) + ":" + _
		  d.Second.ToText( locale, "00" ) + "Z" 
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SerializeDictionary(dict As Xojo.Core.Dictionary) As Xojo.Core.Dictionary
		  dim result as new Xojo.Core.Dictionary
		  
		  for each entry as Xojo.Core.DictionaryEntry in dict
		    result.Value( entry.Key ) = Serialize( entry.Value )
		  next
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SerializeObject(o As Object, ti As Xojo.Introspection.TypeInfo) As Auto
		  //
		  // See if the subclass wants to tackle this
		  //
		  if true then // Scope
		    dim autoResult as Auto = RaiseEvent ObjectToJSON( o, ti )
		    if autoResult <> nil then
		      return autoResult // *** EARLY EXIT
		    end if
		  end if
		  
		  
		  #if not TargetiOS then
		    if o isa Dictionary then
		      //
		      // We are going to do this here
		      //
		      dim result as new Xojo.Core.Dictionary
		      
		      dim d as Dictionary = Dictionary( o )
		      dim keys() as variant = d.Keys
		      dim values() as variant = d.Values
		      for i as integer = 0 to keys.Ubound
		        result.Value( keys( i ) ) = Serialize( values( i ) )
		      next
		      return result // *** EARLY EXIT
		    end if
		    
		    if o isa Date then
		      //
		      // Convert it to a new Date
		      //
		      dim d as Date = Date( o )
		      dim tz as new Xojo.Core.TimeZone( d.GMTOffset * 60 * 60 )
		      o = new Xojo.Core.Date( d.Year, d.Month, d.Day, d.Hour, d.Minute, d.Second, 0, tz )
		    end if
		  #endif
		  
		  if o isa Xojo.Core.Date then
		    return SerializeDate( Xojo.Core.Date( o ) ) // *** EARLY EXIT
		  else
		    dim result as new Xojo.Core.Dictionary
		    
		    for each prop as Xojo.Introspection.PropertyInfo in ti.Properties
		      if prop.IsPublic and prop.CanRead and not prop.IsShared then
		        result.Value( prop.Name ) = Serialize( prop.Value( o ) )
		      end if
		    next
		    
		    return result
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TimeoutTimer_Action(sender As Xojo.Core.Timer)
		  dim surrogate as M_REST.PrivateSurrogate = MessageSurrogate
		  
		  if IsConnected then
		    if RaiseEvent ContinueWaiting or (surrogate isa object and surrogate.RaiseContinueWaiting( self ) ) then
		      //
		      // One of these wanted to continue waiting
		      //
		    else
		      self.Disconnect
		    end if
		  end if
		  
		  sender.Mode = Xojo.Core.Timer.Modes.Off
		  if IsConnected then
		    sender.Mode = Xojo.Core.Timer.Modes.Multiple
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TypeInfoForClassName(className As Text) As Xojo.Introspection.TypeInfo
		  className = className.Replace( "()", "" ) // In case it's an array
		  
		  dim tiObject as Xojo.Introspection.TypeInfo = ClassTypeInfoRegistry.Lookup( className, nil )
		  
		  if tiObject is nil then
		    
		    dim o as object
		    select case className
		    case "Dictionary"
		      #if TargetiOS then
		        o = new Xojo.Core.Dictionary
		      #else
		        o = new Dictionary
		      #endif
		      
		    case "Date"
		      #if TargetiOS then
		        o = Xojo.Core.Date.Now
		      #else
		        o = new Date
		      #endif
		      
		    case "Xojo.Core.Dictionary"
		      o = new Xojo.Core.Dictionary
		      
		    case "Xojo.Core.Date"
		      o = Xojo.Core.Date.Now
		      
		    case else
		      o = RaiseEvent GetNewObjectForClassName( className )
		      
		    end select
		    
		    if o isa object then
		      tiObject = Xojo.Introspection.GetType( o )
		      ClassTypeInfoRegistry.Value( className ) = tiObject
		    end if
		    
		  end if
		  
		  return tiObject
		  
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event AuthenticationRequired(realm As Text, ByRef username As Text, ByRef password As Text) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 54686520696E636F6D696E67207061796C6F61642077617320636F6E76657274656420746F204A534F4E20616E642069732061626F757420746F2062652070726F6365737365642E20596F75206D6179206D6F6469667920746865206B65797320616E642076616C756573206173206E656564656420686572652E
		Event BeforeJSONProcessing(ByRef json As Auto)
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 4C617374206368616E636520746F2063616E63656C20612073656E64206F72206D6F64696679207468652076616C7565732069742077696C6C207573652E
		Event CancelSend(ByRef url As Text, ByRef httpAction As Text, ByRef payload As Xojo.Core.MemoryBlock, ByRef payloadMIMEType As Text) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 546865206D6573736167652068617320657863656564207468652074696D652073657420696E204F7074696F6E732E54696D656F75745365636F6E64732E2052657475726E205472756520746F20616C6C6F7720746865206D65737361676520746F206B6565702077616974696E672E
		Event ContinueWaiting() As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 54686520736F636B65742068617320646973636F6E6E65637465642E
		Event Disconnected()
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 416E206572726F7220686173206F636375727265642E
		Event Error(msg As Text)
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 4578636C75646520612070726F70657274792066726F6D20746865206F7574676F696E67207061796C6F6164207468617420776F756C64206F746865727769736520626520696E636C756465642C206F72206368616E6765207468652070726F7065727479206E616D6520616E642F6F722076616C756520746861742077696C6C20626520757365642E
		Event ExcludeFromOutgoingPayload(prop As Xojo.Introspection.PropertyInfo, ByRef propName As Text, ByRef propValue As Auto) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event GetNewObjectForClassName(className As Text) As Object
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 5468652052455354207479706520746F2075736520666F72207468697320636F6E6E656374696F6E2E204966206E6F7420696D706C656D656E7465642C2044656661756C7452455354547970652077696C6C206265207573656420696E73746561642E
		Event GetRESTType() As RESTTypes
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 5468652055524C207061747465726E20746F2075736520666F722074686520636F6E6E656374696F6E2E2043616E20696E636C7564652070726F7065727479206E616D657320746861742077696C6C20626520737562737469747574656420666F722076616C75652C20652E672E2C0A0A687474703A2F2F7777772E6578616D706C652E636F6D2F6765742F3A69643F6E616D653D3A6E616D650A0A3A696420616E64203A6E616D652077696C6C206265207265706C616365642062792070726F70657274696573206F66207468652073616D65206E616D652E
		Event GetURLPattern() As Text
	#tag EndHook

	#tag Hook, Flags = &h0
		Event HeadersReceived(url As Text, httpStatus As Integer)
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 4D616E75616C6C792073746F72652074686520696E636F6D696E67207061796C6F61642076616C756520617320646573697265642E2052657475726E205472756520746F2070726576656E7420667572746865722070726F63657373696E67206F6E20746861742076616C75652E
		Event IncomingPayloadValueToProperty(value As Auto, prop As Xojo.Introspection.PropertyInfo, hostObject As Object) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 4D616E75616C6C7920636F6E7665727420616E206F626A65637420746F204A534F4E20666F7220696E636C7573696F6E20696E20746865206F7574676F696E67207061796C6F61642E
		Event ObjectToJSON(o As Object, typeInfo As Xojo.Introspection.TypeInfo) As Auto
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReceiveProgress(bytesReceived As Int64, totalBytes As Int64, newData As Xojo.Core.MemoryBlock)
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 546865205245535466756C20736572766572206861732072657475726E6564206120726573706F6E73652E
		Event ResponseReceived(url As Text, httpStatus As Integer, payload As Auto)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event SendProgress(bytesSent As Int64, bytesLeft As Int64)
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 5365742075702070726F70657274696573206F722074616B65206F7468657220616374696F6E732061667465722074686520696E7374616E636520697320666972737420636F6E73747275637465642E
		Event Setup()
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 52657475726E205472756520746F2070726576656E74206175746F6D617469632070726F63657373696E67206F662074686520696E636F6D696E67207061796C6F61642C206F72206368616E676520746865207061796C6F6164206265666F7265206175746F6D617469632070726F63657373696E672E
		Event SkipIncomingPayloadProcessing(url As Text, httpStatus As Integer, ByRef payload As Auto) As Boolean
	#tag EndHook


	#tag Property, Flags = &h21
		Private Shared ClassMetaDict As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ClassName As Text
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  if mClassTypeInfoRegistry is nil then
			    mClassTypeInfoRegistry = new Xojo.Core.Dictionary
			  end if
			  
			  return mClassTypeInfoRegistry
			End Get
		#tag EndGetter
		Private Shared ClassTypeInfoRegistry As Xojo.Core.Dictionary
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		DefaultRESTType As RESTTypes = RESTTypes.Unknown
	#tag EndProperty

	#tag Property, Flags = &h21
		Private FlagGetRESTType As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  return RESTTypeToHTTPAction( RESTType )
			End Get
		#tag EndGetter
		Protected HTTPAction As Text
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mIsConnected
			End Get
		#tag EndGetter
		IsConnected As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private Shared mClassTypeInfoRegistry As Xojo.Core.Dictionary
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if mMessageOptions is nil then
			    MessageOptions = new M_REST.Options
			  end if
			  
			  return mMessageOptions
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if value = mMessageOptions then
			    //
			    // Nothing to do
			    //
			    return
			  end if
			  
			  if mMessageOptions isa Object then
			    //
			    // Clear the parent
			    //
			    PrivateOptions( mMessageOptions ).SetParentMessage nil
			  end if
			  
			  mMessageOptions = value
			  if mMessageOptions isa Object then
			    PrivateOptions( mMessageOptions ).SetParentMessage self
			  end if
			  
			End Set
		#tag EndSetter
		MessageOptions As M_REST.Options
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  static nextSN as Int64
			  static accessFlag as new Semaphore( 1 )
			  
			  if mMessageSerialNumber <= 0 then
			    accessFlag.Signal
			    
			    const kOne as Int64 = 1
			    nextSN = nextSN + kOne
			    mMessageSerialNumber = nextSN
			    
			    accessFlag.Release
			  end if
			  
			  return mMessageSerialNumber
			  
			End Get
		#tag EndGetter
		MessageSerialNumber As Int64
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  if mMessageSurrogateWeakRef is nil then
			    return nil
			  else
			    return PrivateSurrogate( mMessageSurrogateWeakRef.Value )
			  end if
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if value is nil then
			    mMessageSurrogateWeakRef = nil
			  else
			    mMessageSurrogateWeakRef = Xojo.Core.WeakRef.Create( value )
			    value.AppendMessage self
			  end if
			  
			End Set
		#tag EndSetter
		Private MessageSurrogate As PrivateSurrogate
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		MessageTag As Auto
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private mIsConnected As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private mMessageOptions As M_REST.Options
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private mMessageSerialNumber As Int64
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMessageSurrogateWeakRef As Xojo.Core.WeakRef
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  if ClassMetaDict is nil then
			    return nil
			  end if
			  
			  if ClassName = "" then
			    return nil
			  end if
			  
			  return ClassMetaDict.Value( ClassName )
			End Get
		#tag EndGetter
		Private MyMeta As M_REST.ClassMeta
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private ReceiveFinishedMicroseconds As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private RequestSentMicroseconds As Double = -1.0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private RequestStartedMicroseconds As Double = -1.0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ResponseReceivedMicroseconds As Double = -1.0
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if FlagGetRESTType then
			    return DefaultRESTType
			  end if
			  
			  FlagGetRESTType = true
			  dim type as RESTTypes = RaiseEvent GetRESTType
			  if type = RESTTypes.Unknown then
			    type = DefaultRESTType
			  end if
			  FlagGetRESTType = false
			  
			  return type
			End Get
		#tag EndGetter
		RESTType As RESTTypes
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  dim roundTrip as double
			  
			  if ResponseReceivedMicroseconds < 0.0 or RequestSentMicroseconds < 0.0 then
			    roundTrip = -1.0
			  else
			    roundTrip = ( ResponseReceivedMicroseconds - RequestSentMicroseconds ) / 1000.0
			  end if
			  
			  if roundTrip < 0.0 then
			    roundTrip = -1.0
			  end if
			  
			  return roundTrip
			End Get
		#tag EndGetter
		RoundTripMs As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  dim roundTrip as double
			  
			  if ReceiveFinishedMicroseconds < 0.0 or RequestStartedMicroseconds < 0.0 then
			    roundTrip = -1.0
			  else
			    roundTrip = ( ReceiveFinishedMicroseconds - RequestStartedMicroseconds ) / 1000.0
			  end if
			  
			  if roundTrip < 0.0 then
			    roundTrip = -1.0
			  end if
			  
			  return roundTrip
			End Get
		#tag EndGetter
		RoundTripWithProcessingMs As Double
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private TimeoutTimer As Xojo.Core.Timer
	#tag EndProperty


	#tag Constant, Name = kActionDelete, Type = Text, Dynamic = False, Default = \"DELETE", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kActionGet, Type = Text, Dynamic = False, Default = \"GET", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kActionOptions, Type = Text, Dynamic = False, Default = \"OPTIONS", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kActionPatch, Type = Text, Dynamic = False, Default = \"PATCH", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kActionPost, Type = Text, Dynamic = False, Default = \"POST", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kActionPut, Type = Text, Dynamic = False, Default = \"PUT", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kActionUnknown, Type = Text, Dynamic = False, Default = \"Unknown", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kContentType, Type = Text, Dynamic = False, Default = \"application/json", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = Text, Dynamic = False, Default = \"1.2", Scope = Public
	#tag EndConstant


	#tag Enum, Name = RESTTypes, Type = Integer, Flags = &h0
		Unknown
		  Create
		  Read
		  UpdateReplace
		  UpdateModify
		  Authenticate
		  DELETE
		  GET
		  HEAD
		  OPTIONS
		  PATCH
		  POST
		PUT
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="DefaultRESTType"
			Visible=true
			Group="Behavior"
			InitialValue="RESTTypes.Unknown"
			Type="RESTTypes"
			EditorType="Enum"
			#tag EnumValues
				"0 - Unknown"
				"1 - Create"
				"2 - Read"
				"3 - UpdateReplace"
				"4 - UpdateModify"
				"5 - Authenticate"
				"6 - DELETE"
				"7 - GET"
				"8 - HEAD"
				"9 - OPTIONS"
				"10 - PATCH"
				"11 - POST"
				"12 - PUT"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsConnected"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MessageSerialNumber"
			Group="Behavior"
			Type="Int64"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RESTType"
			Group="Behavior"
			Type="RESTTypes"
			EditorType="Enum"
			#tag EnumValues
				"0 - Unknown"
				"1 - Create"
				"2 - Read"
				"3 - UpdateReplace"
				"4 - UpdateModify"
				"5 - Authenticate"
				"6 - DELETE"
				"7 - GET"
				"8 - HEAD"
				"9 - OPTIONS"
				"10 - PATCH"
				"11 - POST"
				"12 - PUT"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="RoundTripMs"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RoundTripWithProcessingMs"
			Group="Behavior"
			Type="Double"
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
		#tag ViewProperty
			Name="ValidateCertificates"
			Visible=true
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
