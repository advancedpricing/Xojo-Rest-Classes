#tag Window
Begin Window WndEddies
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   True
   Compatibility   =   ""
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   FullScreenButton=   False
   HasBackColor    =   False
   Height          =   508
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   508
   MaximizeButton  =   True
   MaxWidth        =   758
   MenuBar         =   0
   MenuBarVisible  =   True
   MinHeight       =   508
   MinimizeButton  =   True
   MinWidth        =   758
   Placement       =   0
   Resizeable      =   True
   Title           =   "Eddies Electronics"
   Visible         =   True
   Width           =   758
   Begin Eddies.GetCustomerList msgGetCustomerList
      DefaultRESTType =   "RESTTypes.Unknown"
      Index           =   -2147483648
      IsConnected     =   False
      LockedInPosition=   False
      MessageSerialNumber=   ""
      RESTType        =   ""
      RoundTripMs     =   0.0
      RoundTripWithProcessingMs=   0.0
      Scope           =   2
      TabPanelIndex   =   0
      ValidateCertificates=   False
   End
   Begin Eddies.GetCustomer msgGetCustomer
      DefaultRESTType =   "RESTTypes.Unknown"
      ID              =   "0"
      Index           =   -2147483648
      IsConnected     =   False
      LockedInPosition=   False
      MessageSerialNumber=   ""
      RESTType        =   ""
      RoundTripMs     =   0.0
      RoundTripWithProcessingMs=   0.0
      Scope           =   2
      TabPanelIndex   =   0
      ValidateCertificates=   False
   End
   Begin Listbox lbCustomers
      AutoDeactivate  =   True
      AutoHideScrollbars=   True
      Bold            =   False
      Border          =   True
      ColumnCount     =   2
      ColumnsResizable=   False
      ColumnWidths    =   "20%"
      DataField       =   ""
      DataSource      =   ""
      DefaultRowHeight=   -1
      Enabled         =   True
      EnableDrag      =   False
      EnableDragReorder=   False
      GridLinesHorizontal=   0
      GridLinesVertical=   0
      HasHeading      =   True
      HeadingIndex    =   -1
      Height          =   468
      HelpTag         =   ""
      Hierarchical    =   False
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   "ID	Name"
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      RequiresSelection=   False
      Scope           =   2
      ScrollbarHorizontal=   False
      ScrollBarVertical=   True
      SelectionType   =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   20
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   298
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
   Begin TextField fldFirstName
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      CueText         =   "First Name"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   False
      Left            =   397
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   2
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   278
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   162
   End
   Begin TextField fldLastName
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      CueText         =   "Last Name"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   False
      Left            =   571
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   2
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   278
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   162
   End
   Begin TextField fldCity
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      CueText         =   "City"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   False
      Left            =   397
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   2
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   312
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   162
   End
   Begin TextField fldState
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      CueText         =   "State"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   False
      Left            =   571
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   2
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   312
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   47
   End
   Begin TextField fldZip
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      CueText         =   "Zip"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   False
      Left            =   630
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   2
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   312
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   103
   End
   Begin TextField fldPhone
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      CueText         =   "Phone"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   False
      Left            =   397
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   2
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   346
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   162
   End
   Begin TextField fldEmail
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      CueText         =   "E-mail"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   False
      Left            =   571
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   2
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   346
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   162
   End
   Begin Canvas cvsPhoto
      AcceptFocus     =   False
      AcceptTabs      =   False
      AutoDeactivate  =   True
      Backdrop        =   0
      DoubleBuffer    =   False
      Enabled         =   True
      EraseBackground =   True
      Height          =   192
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   397
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      TabIndex        =   8
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   20
      Transparent     =   True
      UseFocusRing    =   True
      Visible         =   True
      Width           =   192
   End
   Begin CheckBox cbTaxable
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   "Taxable"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   397
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      State           =   0
      TabIndex        =   9
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   380
      Underline       =   False
      Value           =   False
      Visible         =   True
      Width           =   100
   End
   Begin Timer tmrUpdateControls
      Index           =   -2147483648
      LockedInPosition=   False
      Mode            =   2
      Period          =   250
      Scope           =   2
      TabPanelIndex   =   0
   End
   Begin Label lblRoundtrip
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   True
      Left            =   561
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   10
      TabPanelIndex   =   0
      Text            =   "RoundTrip"
      TextAlign       =   2
      TextColor       =   &c00000000
      TextFont        =   "SmallSystem"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   468
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   177
   End
   Begin CheckBox cbStore
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   "Store Customers"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   601
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      State           =   0
      TabIndex        =   11
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   20
      Underline       =   False
      Value           =   False
      Visible         =   True
      Width           =   129
   End
   Begin M_REST.RESTMessageSurrogate_MTC smsgGetCustomerSurrogate
      Index           =   -2147483648
      IsBusy          =   False
      LockedInPosition=   False
      Scope           =   2
      TabPanelIndex   =   0
   End
   Begin ProgressWheel pwBusy
      AutoDeactivate  =   True
      Enabled         =   True
      Height          =   16
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   344
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      TabIndex        =   12
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   468
      Visible         =   True
      Width           =   16
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  msgGetCustomerList.Send
		  pwBusy.Visible = true
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub ClearFields()
		  fldFirstName.Text = ""
		  fldLastName.Text = ""
		  fldCity.Text = ""
		  fldState.Text = ""
		  fldZip.Text = ""
		  fldEmail.Text = ""
		  fldPhone.Text = ""
		  
		  cvsPhoto.Invalidate
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DisplayCustomer(cust As Eddies.Customer)
		  if cust isa object then
		    fldFirstName.Text = cust.FirstName
		    fldLastName.Text = cust.LastName
		    fldCity.Text = cust.City
		    fldState.Text = cust.State
		    fldZip.Text = cust.Zip
		    fldPhone.Text = cust.Phone
		    fldEmail.Text = cust.Email
		  end if
		  
		  cvsPhoto.Invalidate
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RefreshListbox()
		  lbCustomers.DeleteAllRows
		  
		  dim dict as Xojo.Core.Dictionary = msgGetCustomerList.ReturnGetAllCustomers
		  if dict is nil then
		    return
		  end if
		  
		  for each entry as Xojo.Core.DictionaryEntry in dict
		    dim id as text = entry.Key
		    dim cust as Xojo.Core.Dictionary = entry.Value
		    
		    lbCustomers.AddRow id, cust.Value( "LastName" ) + ", " + cust.Value( "FirstName" )
		    lbCustomers.RowTag( lbCustomers.LastIndex ) = id
		  next
		  
		  lbCustomers.SortedColumn = 0
		  lbCustomers.Sort
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RowOfCustomerID(id As Text) As Integer
		  dim lastListIndex as integer = lbCustomers.ListCount - 1
		  for row as integer = 0 to lastListIndex
		    dim tag as variant = lbCustomers.RowTag( row )
		    if ( tag isa Eddies.Customer and Eddies.Customer( tag ).ID = id ) or _
		      (tag.Type = Variant.TypeText and tag.TextValue = id ) then
		      return row
		    end if
		  next
		  
		  return -1
		  
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  if cbStore.Value then
			    //
			    // Using a surrogate
			    //
			    if lbCustomers.ListIndex <> -1 and lbCustomers.RowTag( lbCustomers.ListIndex ) isa Eddies.Customer then
			      return Eddies.Customer( lbCustomers.RowTag( lbCustomers.ListIndex ) )
			    else
			      return nil
			    end if
			    
			  else
			    //
			    // Using the direct method
			    //
			    if msgGetCustomer.IsConnected then
			      return nil
			    else
			      return msgGetCustomer.ReturnGetCustomer
			    end if
			  end if
			  
			End Get
		#tag EndGetter
		Private CurrentCustomer As Eddies.Customer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private PreviousListIndex As Integer = -1
	#tag EndProperty


#tag EndWindowCode

#tag Events msgGetCustomerList
	#tag Event
		Sub ResponseReceived(url As Text, httpStatus As Integer, payload As Auto)
		  #pragma unused url
		  #pragma unused httpStatus
		  #pragma unused payload
		  
		  RefreshListbox
		  
		  lblRoundtrip.Text = format( me.RoundTripMs / 1000.0, "#,0.0" ) + " ms"
		  pwBusy.Visible = msgGetCustomer.IsConnected or smsgGetCustomerSurrogate.IsBusy
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events msgGetCustomer
	#tag Event
		Sub ResponseReceived(url As Text, httpStatus As Integer, payload As Auto)
		  #pragma unused url
		  #pragma unused httpStatus
		  #pragma unused payload
		  
		  //
		  // If we were only using this one message, we could implment the code
		  // below and be done with it. For this example project, though, since the
		  // surrogate is there to show off handling of multiple, simultaneous
		  // messages, we might as well use it for everything.
		  //
		  
		  'DisplayCustomer me.ReturnGetCustomer
		  'lblRoundtrip.Text = format( me.RoundTripMs / 1000.0, "#,0.0" ) + " s"
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events lbCustomers
	#tag Event
		Sub Change()
		  if me.ListIndex <> PreviousListIndex then
		    ClearFields
		    
		    if me.ListIndex <> -1 then
		      dim tag as variant = me.RowTag( me.ListIndex )
		      dim id as text = if( tag isa Eddies.Customer, Eddies.Customer( tag ).ID, tag.TextValue )
		      
		      //
		      // Use surrogate method?
		      //
		      if cbStore.Value then
		        //
		        // See if we have the customer already
		        //
		        if tag isa Eddies.Customer then
		          DisplayCustomer Eddies.Customer( tag )
		        else
		          dim msg as new Eddies.GetCustomer
		          msg.ID = id
		          msg.Send smsgGetCustomerSurrogate
		        end if
		        
		      else
		        //
		        // Use direct method
		        //
		        msgGetCustomer.Disconnect
		        msgGetCustomer.ID = id
		        msgGetCustomer.Send smsgGetCustomerSurrogate
		      end if
		    end if
		    
		    PreviousListIndex = me.ListIndex
		  end if
		  
		  pwBusy.Visible = msgGetCustomer.IsConnected or smsgGetCustomerSurrogate.IsBusy
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events cvsPhoto
	#tag Event
		Sub Paint(g As Graphics, areas() As REALbasic.Rect)
		  #pragma unused areas
		  
		  dim cust as Eddies.Customer = CurrentCustomer
		  
		  if cust isa object and cust.Photo isa object then
		    g.DrawPicture cust.Photo, 0, 0
		    
		  else
		    g.ClearRect 0, 0, g.Width, g.Height
		  end if
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events tmrUpdateControls
	#tag Event
		Sub Action()
		  dim value as boolean = not( msgGetCustomer.IsConnected or msgGetCustomerList.IsConnected )
		  
		  if fldFirstName.Enabled = value then
		    //
		    // Nothing to do
		    //
		    return
		  end if
		  
		  fldFirstName.Enabled = value
		  fldLastName.Enabled = value
		  fldCity.Enabled = value
		  fldState.Enabled = value
		  fldZip.Enabled = value
		  fldPhone.Enabled = value
		  fldEmail.Enabled = value
		  cbTaxable.Enabled = value
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events cbStore
	#tag Event
		Sub Action()
		  //
		  // This checkbox will control whether the already-retrieved records
		  // will be stored in the Listbox. If not, the existing records will be
		  // cleared.
		  //
		  // This is a simple way to contrast the direct method of downloading information
		  // by dragging a message to the window (msgGetCustomer) vs. using
		  // the RESTMessageSurrogate_MTC class.
		  //
		  
		  if not me.Value then
		    //
		    // Clear any existing records
		    //
		    dim lastListIndex as integer = lbCustomers.ListCount - 1
		    for row as integer = 0 to lastListIndex
		      dim tag as variant = lbCustomers.RowTag( row )
		      if tag isa Eddies.Customer then
		        lbCustomers.RowTag( row ) = Eddies.Customer( tag ).ID
		      end if
		    next
		  end if
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events smsgGetCustomerSurrogate
	#tag Event , Description = 546865205245535466756C20736572766572206861732072657475726E6564206120726573706F6E73652E
		Sub ResponseReceived(message As RESTMessage_MTC, url As Text, httpStatus As Integer, payload As Auto)
		  #pragma unused url
		  #pragma unused httpStatus
		  #pragma unused payload
		  
		  //
		  // Store the customer if the store checkbox is checked
		  //
		  
		  dim response as Eddies.GetCustomer = Eddies.GetCustomer( message )
		  dim cust as Eddies.Customer = response.ReturnGetCustomer
		  
		  dim row as integer = RowOfCustomerID( cust.ID )
		  
		  if cbStore.Value then
		    lbCustomers.RowTag( row ) = cust
		  end if
		  
		  if row = lbCustomers.ListIndex then
		    DisplayCustomer cust
		  end if
		  
		  lblRoundtrip.Text = format( response.RoundTripMs / 1000.0, "#,0.0" ) + " s"
		  pwBusy.Visible = msgGetCustomer.IsConnected or smsgGetCustomerSurrogate.IsBusy
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="BackColor"
		Visible=true
		Group="Background"
		InitialValue="&hFFFFFF"
		Type="Color"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		Type="Picture"
		EditorType="Picture"
	#tag EndViewProperty
	#tag ViewProperty
		Name="CloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Frame"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Integer"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		Type="String"
		EditorType="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="LiveResize"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaxHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaxWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		Type="MenuBar"
		EditorType="MenuBar"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		Type="String"
		EditorType="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Placement"
		Visible=true
		Group="Behavior"
		InitialValue="0"
		Type="Integer"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		Type="String"
		EditorType="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
	#tag EndViewProperty
#tag EndViewBehavior
