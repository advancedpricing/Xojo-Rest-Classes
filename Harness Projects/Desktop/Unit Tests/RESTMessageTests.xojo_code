#tag Class
Protected Class RESTMessageTests
Inherits TestGroup
	#tag Method, Flags = &h21
		Private Function ArrayAuto(ParamArray values() As Auto) As Auto()
		  return values
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SerializeDeserializeTest()
		  dim msg as new UnitTestMessage
		  msg.SomeString = "something"
		  msg.SomeIndex = 4
		  msg.DefaultRESTType = RESTMessage_MTC.RESTTypes.GET
		  msg.UseURL = "http://example.com/:SomeString/:someindex"
		  
		  dim expectURL as text = "http://example.com/something/4"
		  dim expectMIMEType as text = "application/json"
		  
		  dim action as text
		  dim url as text
		  dim mimeType as text
		  dim payload as Xojo.Core.MemoryBlock
		  
		  dim test as M_REST.UnitTestRESTMessage = msg
		  Assert.IsTrue test.GetSendParameters( action, url, mimeType, payload )
		  Assert.AreEqual action, "GET", "Action does not match"
		  Assert.AreEqual expectURL, url, "URL does not match"
		  Assert.IsNil payload, "Payload should be nil"
		  
		  msg.DefaultRESTType = RESTMessage_MTC.RESTTypes.POST
		  msg.IncludeBoolean = true
		  msg.IncludeString = "a string"
		  msg.IncludeText = "some text"
		  
		  Assert.IsTrue test.GetSendParameters( action, url, mimeType, payload )
		  Assert.AreEqual "POST", action
		  Assert.AreEqual expectMIMEType, mimeType
		  Assert.IsNotNil payload, "Payload should not be nil"
		  
		  dim json as Xojo.Core.Dictionary
		  try
		    json = Xojo.Data.ParseJSON( Xojo.Core.TextEncoding.UTF8.ConvertDataToText( payload ) )
		    Assert.Pass "Payload was properly converted"
		  catch err as RuntimeException
		    if err isa EndException or err isa ThreadEndException then
		      raise err
		    end if
		    Assert.Fail "Could not convert payload to JSON"
		    return
		  end try
		  
		  dim expectedKeys() as text = array( "IncludeBoolean", "IncludeString", "IncludeText" )
		  dim expectedValues() as auto = ArrayAuto( msg.IncludeBoolean, msg.IncludeString, msg.IncludeText )
		  
		  for i as integer = 0 to expectedKeys.Ubound
		    dim k as text = expectedKeys( i )
		    dim v as auto = expectedValues( i )
		    if json.HasKey( k ) then
		      Assert.Pass "Has the key " + k
		      Assert.IsTrue v = json.Value( k ), "Values for key " + k + " do not match"
		      json.Remove k
		    else
		      Assert.Fail "Could not find key " + k
		    end if
		  next
		  
		  Assert.AreEqual 0, json.Count, "JSON has unexpected additional keys"
		  
		  dim exampleDict as new Xojo.Core.Dictionary
		  exampleDict.Value( "hey" ) = "ho"
		  exampleDict.Value( "blah" ) = 34
		  
		  dim returnJSON as new Xojo.Core.Dictionary
		  returnJSON.Value( "Boolean" ) = true
		  returnJSON.Value( "String" ) = "another string"
		  returnJSON.Value( "Text" ) = "111 text"
		  returnJSON.Value( "Dictionary" ) = exampleDict
		  returnJSON.Value( "Date" ) = "2016-03-12T14:05:06Z"
		  dim expectDate as new Xojo.Core.Date( 2016, 03, 12, 14, 5, 6, 0, Xojo.Core.TimeZone.Current )
		  dim returnPayload as Xojo.Core.MemoryBlock = _
		  Xojo.Core.TextEncoding.UTF8.ConvertTextToData( Xojo.Data.GenerateJSON( returnJSON ) )
		  
		  #pragma BreakOnExceptions false
		  dim dict as Xojo.Core.Dictionary = test.ProcessPayload( returnPayload )
		  #pragma unused dict
		  #pragma BreakOnExceptions default 
		  
		  Assert.IsTrue msg.ReturnBoolean
		  Assert.AreEqual msg.ReturnString, "another string"
		  Assert.AreEqual msg.ReturnText, "111 text"
		  Assert.IsNotNil msg.ReturnDate
		  Assert.AreEqual expectDate.ToText, msg.ReturnDate.ToText
		  Assert.IsNotNil msg.ReturnDictionary
		  
		  for each entry as Xojo.Core.DictionaryEntry in exampleDict
		    Assert.IsTrue msg.ReturnDictionary.HasKey( entry.Key ), "ReturnDictionary missing key " + entry.Key
		    Assert.IsTrue entry.Value = _
		    msg.ReturnDictionary.Value( entry.Key ), "ReturnDictionary values for " + entry.Key + " do not match"
		  next
		  
		  return
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
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
			Name="NotImplementedCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
