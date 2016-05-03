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


	#tag Method, Flags = &h0
		Sub Constructor()
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  TimeoutTimer = new Xojo.Core.Timer
		  TimeoutTimer.Period = TimeoutSeconds \ 1000
		  TimeoutTimer.Mode = Xojo.Core.Timer.Modes.Off
		  
		  AddHandler TimeoutTimer.Action, WeakAddressOf TimeoutTimer_Action
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function RESTTypeToHTTPAction(type As RESTTypes) As Text
		  select case type
		  case RESTTypes.Authenticate, RESTTypes.Read, RESTTypes.GET
		    return "GET"
		    
		  case RESTTypes.Create, RESTTypes.POST
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

	#tag Method, Flags = &h1
		Protected Sub Send(Method as Text, URL as Text)
		  //
		  // Disable external access to this
		  //
		  
		  super.Send( Method, URL )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Send(Method as Text, URL as Text, File as xojo.IO.FolderItem)
		  //
		  // Disable external access to this
		  //
		  
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
		  
		  if not IsConnected then
		    sender.Mode = Xojo.Core.Timer.Modes.Off
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
		Event TimedOut() As Boolean
	#tag EndHook


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
		Private mIsConnected As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRequestSentMicroseconds As Double
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mRequestSentMicroseconds
			End Get
		#tag EndGetter
		RequestSentMicroseconds As Double
	#tag EndComputedProperty

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
			Name="RequestSentMicroseconds"
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
