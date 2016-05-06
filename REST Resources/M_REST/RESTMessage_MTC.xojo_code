#tag Class
Class RESTMessage_MTC
Inherits Xojo.Net.HTTPSocket
	#tag Event
		Sub Error(err as RuntimeException)
		  mIsConnected = false
		  
		  if err isa Xojo.Net.NetException then
		    select case err.ErrorNumber
		    case 102
		      RaiseEvent Disconnected
		      
		    case else
		      RaiseEvent Error( err.Reason )
		      
		    end select
		    
		  else
		    
		    raise err
		    
		  end if
		End Sub
	#tag EndEvent

	#tag Event
		Sub PageReceived(URL as Text, HTTPStatus as Integer, Content as xojo.Core.MemoryBlock)
		  mIsConnected = false
		  ResponseReceivedMicroseconds = Microseconds
		  
		  dim payload as Auto = content
		  
		  if not SkipIncomingPayloadProcessing( URL, HTTPStatus, payload ) then
		    payload = ProcessPayload( payload )
		  end if
		  
		  RaiseEvent ResponseReceived URL, HTTPStatus, payload 
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub ClearReturnProperties()
		  CreateMeta
		  
		  dim meta as M_REST.ClassMeta = MyMeta
		  if meta is nil then
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
		    
		    static prefixLength as integer = kPrefixReturnProperty.Length
		    if propName.Length > prefixLength and propName.Left( prefixLength ) = kPrefixReturnProperty then // Return property 
		      if prop.CanWrite then 
		        classMeta.ReturnPropertiesDict.Value( propName ) = prop
		      end if
		    else // Send property
		      if prop.CanRead then
		        classMeta.SendPropertiesDict.Value( propName ) = prop
		      end if
		    end if
		  next prop
		  
		  classMetaDict.Value( className ) = classMeta
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CreatePayload(props() As Xojo.Introspection.PropertyInfo) As Xojo.Core.MemoryBlock
		  dim result as Xojo.Core.MemoryBlock
		  
		  dim json as new Xojo.Core.Dictionary
		  
		  for each prop as Xojo.Introspection.PropertyInfo in props
		    dim propName as text = prop.Name
		    dim propValue as auto = prop.Value( self )
		    
		    if not RaiseEvent ExcludeFromPayload( prop, propName, propValue ) then
		      dim value as auto = prop.Value( self )
		      json.Value( propName ) = Serialize( propValue )
		    end if
		  next
		  
		  if json.Count <> 0 then
		    dim t as text = Xojo.Data.GenerateJSON( json )
		    result = Xojo.Core.TextEncoding.UTF8.ConvertTextToData( t )
		  end if
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  if TimeoutTimer isa Object then
		    TimeoutTimer.Mode = Xojo.Core.Timer.Modes.Off
		    RemoveHandler TimeoutTimer.Action, WeakAddressOf TimeoutTimer_Action
		    TimeoutTimer = nil
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Disconnect()
		  if IsConnected then
		    mIsConnected = false
		    TimeoutTimer.Mode = Xojo.Core.Timer.Modes.Off
		    super.Disconnect
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PrepareToSend()
		  mIsConnected = true
		  RequestSentMicroseconds = Microseconds
		  ResponseReceivedMicroseconds = -1.0
		  
		  TimeoutTimer.Period = Options.TimeOutSeconds * 1000
		  TimeoutTimer.Mode = Xojo.Core.Timer.Modes.Multiple
		  
		  ClearReturnProperties
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ProcessImagePayload(payload As Xojo.Core.MemoryBlock, subType As Text) As Auto
		  dim result as Auto
		  
		  #if TargetiOS then
		    #pragma error "Finish this!"
		    
		  #else
		    
		    //
		    // Have to use the classic MemoryBlock
		    //
		    dim mbTemp as MemoryBlock = payload.Data
		    dim mb as MemoryBlock = mbTemp.StringValue( 0, payload.Size )
		    
		    dim p as Picture = Picture.FromData( mb )
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
		Private Function ProcessPayload(payload As Xojo.Core.MemoryBlock) As Auto
		  dim result as Auto
		  
		  dim indicatedContentType as text = self.ResponseHeader( "Content-Type" )
		  
		  dim parts() as text = indicatedContentType.Split( "/" )
		  dim indicatedType as text = if( parts.Ubound <> -1, parts( 0 ), "" )
		  dim indicatedSubtype as text = if( parts.Ubound > 0, indicatedContentType.Mid( indicatedContentType.IndexOf( "/" ) + 1 ), "" )
		  
		  if indicatedType = "image" then
		    try
		      result = ProcessImagePayload( payload, indicatedSubtype )
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
		  
		  dim encoding as Xojo.Core.TextEncoding = Options.ExpectedTextEncoding
		  if encoding is nil then
		    encoding = Xojo.Core.TextEncoding.UTF8
		  end if
		  
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
		  if subtype = "" or subtype = "json" then
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
		Sub Send()
		  dim action as text = HTTPAction
		  if action = kActionUnknown then
		    raise new M_REST.RESTException( "REST type was not specified" )
		  end if
		  
		  CreateMeta // Just in case
		  dim meta as M_REST.ClassMeta = MyMeta
		  
		  dim url as text = RaiseEvent GetURLPattern
		  url = url.Trim
		  
		  //
		  // Parse the URL
		  //
		  dim urlPropNames() as text
		  dim payloadPropNames() as text
		  
		  for each entry as Xojo.Core.DictionaryEntry in meta.SendPropertiesDict
		    dim prop as Xojo.Introspection.PropertyInfo = entry.Value
		    dim propName as text = prop.Name
		    
		    dim marker as text = ":" + prop.Name
		    if url.IndexOf( marker ) = -1 then
		      payloadPropNames.Append propName
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
		  
		  dim payload as Xojo.Core.Dictionary
		  if action <> kActionGet and payloadPropNames.Ubound <> -1 and Options.SendWithPayloadIfAvailable then
		    
		  else // No payload
		    'self.SetRequestContent
		  end if
		  
		  dim payloadAuto as Auto = payload
		  if RaiseEvent CancelSend( url, action, payloadAuto ) then
		    return
		  end if
		  
		  Send action, url
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
		    
		  elseif type = "Boolean" or type = "Text" then
		    return value
		    
		  elseif type = "String" then
		    #if not TargetiOS then
		      dim s as string = value
		      dim t as text = s.ToText
		      return t
		    #endif
		    
		  elseif type.Length > 3 and type.BeginsWith( "Int" ) then
		    return value
		    
		  elseif type.Length > 4 and type.BeginsWith( "UInt" ) then
		    return value
		    
		  elseif type = "Double" or type = "Single" or type = "Currency" then
		    return value
		    
		  else
		    return SerializeObject( value, ti )
		    
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SerializeArray(value As Auto, ti As Xojo.Introspection.TypeInfo) As Auto
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SerializeDate(d As Xojo.Core.Date) As Text
		  dim locale as Xojo.Core.Locale = Xojo.Core.Locale.Current
		  
		  dim result as text
		  
		  dim tz as Xojo.Core.TimeZone = d.TimeZone
		  dim interval as new Xojo.Core.DateInterval( 0, 0, 0, 0, 0, tz.SecondsFromGMT )
		  
		  d = d - interval
		  
		  result = d.Year.ToText( locale, "0000" ) + "-" + d.Month.ToText( locale, "00" ) + "-" + d.Day.ToText( locale, "00" )
		  result = result + "T" + d.Hour.ToText( locale, "00" ) + ":" + d.Minute.ToText( locale, "00" ) + ":" + _
		  d.Second.ToText( locale, "00" ) + "Z" 
		  
		  
		  'if d.Hour + d.Minute + d.Second > 0 then
		  'dim minsFromGMT as double = tz.SecondsFromGMT / 60.0
		  'dim hrsFromGMT as double = tz.SecondsFromGMT / 3600.0
		  '
		  'dim offHr as integer = if( hrsFromGMT > 0.0, Xojo.Math.Floor( hrsFromGMT ), Xojo.Math.Ceil( hrsFromGMT ) )
		  'dim offMin as integer = Xojo.Math.Abs( minsFromGMT ) mod 60
		  '
		  'result = result + "T" + d.Hour.ToText( locale, "00" ) + ":" + d.Minute.ToText( locale, "00" ) + ":" + _
		  'd.Second.ToText( locale, "00" ) + "Z" 
		  'if minsFromGMT <> 0.0 then
		  'result = result + offHr.ToText( locale, "+00;" + kMinus + "00" ) + ":" + offMin.ToText( locale, "00" )
		  'end if
		  'end if
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SerializeDictionary(dict As Xojo.Core.Dictionary) As Xojo.Core.Dictionary
		  
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
		      return autoResult
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
		  if IsConnected then
		    if not RaiseEvent ContinueWaiting then
		      self.Disconnect
		      mIsConnected = false
		    end if
		  end if
		  
		  sender.Mode = Xojo.Core.Timer.Modes.Off
		  if IsConnected then
		    sender.Mode = Xojo.Core.Timer.Modes.Multiple
		  end if
		  
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event CancelSend(ByRef url As Text, ByRef httpAction As Text, ByRef payload As Auto) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ContinueWaiting() As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Disconnected()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Error(msg As Text)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ExcludeFromPayload(prop As Xojo.Introspection.PropertyInfo, ByRef propName As Text, ByRef propValue As Auto) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event GetRESTType() As RESTTypes
	#tag EndHook

	#tag Hook, Flags = &h0
		Event GetURLPattern() As Text
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ObjectToJSON(o As Object, typeInfo As Xojo.Introspection.TypeInfo) As Auto
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ResponseReceived(url As Text, HTTPStatus As Integer, payload As Auto)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event SkipIncomingPayloadProcessing(url As Text, httpStatus As Integer, ByRef payload As Auto) As Boolean
	#tag EndHook


	#tag Property, Flags = &h21
		Private Shared ClassMetaDict As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ClassName As Text
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
		Private mIsConnected As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOptions As M_REST.Options
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

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if mOptions is nil then
			    mOptions = new M_REST.Options
			  end if
			  
			  return mOptions
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mOptions = value
			End Set
		#tag EndSetter
		Options As M_REST.Options
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private RequestSentMicroseconds As Double = -1.0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ResponseReceivedMicroseconds As Double = -1.0
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if FlagGetRESTType then
			    return Options.DefaultRESTType
			  end if
			  
			  FlagGetRESTType = true
			  dim type as RESTTypes = RaiseEvent GetRESTType
			  if type = RESTTypes.Unknown then
			    type = Options.DefaultRESTType
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

	#tag Constant, Name = kPrefixReturnProperty, Type = Text, Dynamic = False, Default = \"Return", Scope = Private
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
			InitialValue="RESTTypes.Unspecified"
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
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TimeoutSeconds"
			Visible=true
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
		#tag ViewProperty
			Name="ValidateCertificates"
			Visible=true
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
