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
		  
		  try 
		    jsonText = ExpectedTextEncoding.ConvertDataToText( Content )
		  catch err as RuntimeException
		    response = Content
		    goodJSON = false
		  end try
		  
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
		  
		  TimeoutTimer = new Xojo.Core.Timer
		  TimeoutTimer.Mode = Xojo.Core.Timer.Modes.Off
		  
		  AddHandler TimeoutTimer.Action, WeakAddressOf TimeoutTimer_Action
		  
		  ExpectedTextEncoding = Xojo.Core.TextEncoding.UTF8
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
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function RESTTypeToHTTPAction(type As RESTTypes) As Text
		  select case type
		  case RESTTypes.Read, RESTTypes.GET
		    return "GET"
		    
		  case RESTTypes.Create, RESTTypes.Authenticate, RESTTypes.POST
		    return "POST"
		    
		  case RESTTypes.DELETE
		    return "DELETE"
		    
		  case RESTTypes.UpdateReplace, RESTTypes.PUT
		    return "PUT"
		    
		  case RESTTypes.UpdateModify, RESTTypes.PATCH
		    return "PATCH"
		    
		  case RESTTypes.OPTIONS
		    return "OPTIONS"
		    
		  case else
		    return "Unknown"
		    
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Send(type As RESTTypes)
		  dim action as text = HTTPAction
		  if action = RESTTypes.Unknown then
		    raise new M_REST.RESTException( "REST type was not specified" )
		  end if
		  
		  dim url as text = RaiseEvent GetURLPattern
		  url = url.Trim
		  
		  #pragma warning "Finish this!!"
		  
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
		    if not RaiseEvent TimedOut then
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

	#tag Hook, Flags = &h0
		Event TimedOut() As Boolean
	#tag EndHook


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
			  if type <> RESTTypes.Unknown then
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
				"0 - Unspecified"
				"1 - Create"
				"2 - Read"
				"3 - UpdateReplace"
				"4 - UpdateModify"
				"5 - Authenticate"
				"6 - DELETE"
				"7 - GET"
				"8 - OPTIONS"
				"9 - PATCH"
				"10 - POST"
				"11 - PUT"
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
			Name="RequestSentMs"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RESTType"
			Group="Behavior"
			Type="RESTTypes"
			EditorType="Enum"
			#tag EnumValues
				"0 - Unspecified"
				"1 - Create"
				"2 - Read"
				"3 - UpdateReplace"
				"4 - UpdateModify"
				"5 - Authenticate"
				"6 - DELETE"
				"7 - GET"
				"8 - OPTIONS"
				"9 - PATCH"
				"10 - POST"
				"11 - PUT"
			#tag EndEnumValues
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
