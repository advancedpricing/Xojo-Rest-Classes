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
		  
		  dim response as Auto
		  dim jsonText as text
		  dim goodJSON as boolean = true
		  
		  #pragma BreakOnExceptions false
		  try 
		    jsonText = ExpectedTextEncoding.ConvertDataToText( Content )
		  catch err as RuntimeException
		    response = Content
		    goodJSON = false
		  end try
		  #pragma BreakOnExceptions default
		  
		  if goodJSON then
		    try
		      response = Xojo.Data.ParseJSON( jsonText )
		    catch err as Xojo.Data.InvalidJSONException
		      response = jsonText
		      goodJSON = false
		    end try
		  end if
		  
		  RaiseEvent ResponseReceived URL, HTTPStatus, response 
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor()
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  CreateMeta
		  
		  TimeoutTimer = new Xojo.Core.Timer
		  TimeoutTimer.Mode = Xojo.Core.Timer.Modes.Off
		  
		  AddHandler TimeoutTimer.Action, WeakAddressOf TimeoutTimer_Action
		  
		  ExpectedTextEncoding = Xojo.Core.TextEncoding.UTF8
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
		  
		  TimeoutTimer.Period = TimeOutSeconds * 1000
		  TimeoutTimer.Mode = Xojo.Core.Timer.Modes.Multiple
		  
		  CreateMeta
		  
		End Sub
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
		  dim classMeta as M_REST.ClassMeta = ClassMetaDict.Value( ClassName )
		  
		  dim url as text = RaiseEvent GetURLPattern
		  url = url.Trim
		  
		  //
		  // Parse the URL
		  //
		  dim urlPropNames() as text
		  dim payloadPropNames() as text
		  
		  for each entry as Xojo.Core.DictionaryEntry in classMeta.SendPropertiesDict
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
		        
		        #if not TargetiOS then
		      case "String"
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
		        end if
		      end select
		      
		      url = url.ReplaceAll( marker, textValue )
		    end if
		  next
		  
		  #pragma warning "Finish this!!"
		  
		  dim payload as Xojo.Core.Dictionary
		  dim payloadAuto as Auto = payload
		  if RaiseEvent CancelSend( url, action, payloadAuto ) then
		    return
		  end if
		  
		  self.Send httpAction, url
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Send(Method as Text, URL as Text)
		  //
		  // Disable external access to this
		  //
		  
		  PrepareToSend
		  super.Send( Method, URL )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Send(Method as Text, URL as Text, File as xojo.IO.FolderItem)
		  //
		  // Disable external access to this
		  //
		  
		  PrepareToSend
		  super.Send( Method, URL, File )
		End Sub
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
		Event GetRESTType() As RESTTypes
	#tag EndHook

	#tag Hook, Flags = &h0
		Event GetURLPattern() As Text
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ResponseReceived(url As Text, HTTPStatus As Integer, response As Auto)
	#tag EndHook


	#tag Property, Flags = &h21
		Private Shared ClassMetaDict As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ClassName As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		DefaultRESTType As RESTTypes = RESTTypes.Unknown
	#tag EndProperty

	#tag Property, Flags = &h0
		ExpectedTextEncoding As Xojo.Core.TextEncoding
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
		Private RequestSentMicroseconds As Double = -1.0
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

	#tag Property, Flags = &h0
		TimeoutSeconds As Integer = 5
	#tag EndProperty

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

	#tag Using, Name = Xojo.Core
	#tag EndUsing

	#tag Using, Name = Xojo.IO
	#tag EndUsing

	#tag Using, Name = Xojo.Net
	#tag EndUsing


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
