#tag Module
Protected Module M_REST
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
		Private Function SerializeObject(o As Object, ti As Xojo.Introspection.TypeInfo) As Xojo.Core.Dictionary
		  if ti isa Xojo.Core.Dictionary then
		    return Xojo.Core.Dictionary( o )
		  end if
		  
		  dim result as new Xojo.Core.Dictionary
		  
		  #if not TargetiOS then
		    if o isa Dictionary then
		      dim d as Dictionary = Dictionary( o )
		      dim keys() as variant = d.Keys
		      dim values() as variant = d.Values
		      for i as integer = 0 to keys.Ubound
		        result.Value( keys( i ) ) = values( i )
		      next
		      return result // *** EARLY EXIT
		    end if
		    
		    if o isa Date then
		      dim d as Date = Date( o )
		      dim tz as Xojo.Core.TimeZone
		      o = new Xojo.Core.Date( d.Year, d.Month, d.Day, d.Hour, d.Minute, d.Second, 0, new Xojo.Core.TimeZone( d.GMTOffset * 60 * 60 ) )
		    end if
		  #endif
		  
		  if o isa Xojo.Core.Date then
		    
		  else
		    
		    for each prop as Xojo.Introspection.PropertyInfo in ti.Properties
		      if prop.IsPublic and prop.CanRead and not prop.IsShared then
		        result.Value( prop.Name ) = Serialize( prop.Value( o ) )
		      end if
		    next
		  end if
		  
		  return result
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
