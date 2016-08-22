# Xojo REST Classes

A REST client framework for Xojo.

## General Information

There is no standard for RESTful servers. As such, creating classes that work with a variety can be tricky and time-consuming, and tend to make you to work directly with JSON or other raw data. This framework attempts to make the job a bit easier by allowing you to create "messages" by subclassing the main class and implementing various events. 

### Installation

Open the enclosed harness project and copy-and-paste the REST Resources folder into your own project.

**Important**: _Do not drag the REST Resources folder directly from the folder into your project._ Xojo won't like it and  will probably show all sorts of odd errors.

### Basic Use

At its most basic, you need to create a "message" for each type of interaction with your RESTful server by subclassing `RESTMessage_MTC`. You might create one message that will login, another that will get a list of information, another to save some data. Each message must implement the `GetURLPattern` event <a href='#geturlpatterneventsection'>(see below)</a> and _should_ implement <a href='#getresttypeeventsection'>the `GetRESTType` event</a>.

If the REST server communicates with JSON, you can create properties in the message that correspond to the object keys. You can also use the `ExcludeFromOutgoingPayload` event to exclude a property or modify the key or value that will be included. In the `CancelSend` event you can cancel the send or change the URL, payload, or MIME type.

If you expect information back from the server in the form of JSON, you can create properties with the prefix of "Return", e.g., _ReturnSuccess_, _ReturnFirstName_, etc., and the return payload will be parsed into those properties. You can adjust the prefix through the `Options` <a href='#optionssection'>(see below)</a>. You can also use the `IncomingPayloadValueToProperty` event to "massage" a value or store it elsewhere. For example, if you expect an image to be returned as Base64-encoded, you can use that event to decode it, store the resulting image in a _ReturnImage_ property, then return `True` to prevent `RESTMessage_MTC` from processing the value further.

`RESTMessage_MTC` will attempt to deserialize a JSON object into a class. For example, suppose you expect JSON from the server that looks like this:

```json
{
	"user" : {
		"FirstName" : "John",
		"LastName" : "Doe",
		"Age" : 33
	}
}
```

You can create a User class with properties _FirstName As Text_, _LastName As Text_, and _Age As Integer_, then create a property in the message _ReturnUser As User_. The class will automatically create an instance and fill in the properties for you.

The `ResponseReceived` event will let you know when the server has responded and, if you choose, let you deal with the payload directly.

There are times when it is not appropriate to have a single instance of a particular message. For example, if you need to save multiple records in a row. In those cases, you can create a `RESTMessageSurrogate_MTC` <a href='#surrogatesection'>(see below)</a> instead and send the message through it. The surrogate will raise all the events that the message would as if you had used `AddHandler` to map the message's events.

Messages are not sent immediately. Instead, `Send` will add them to a queue that is processed very quickly. The `MaximumConnections` property will determine how many active connections are permitted at one time. For example, with `MaximumConnections` set to `4`, you could send 100 messages without worrying about flooding a server as only four at most will be connected at any given time.

## Details

This is a more detailed description of the `RESTMessage_MTC` class.

### Events  <a name='eventssection'></a>

| Event | Parameters | Return Value | Description |
| ----- | ---------- | :----------: | ----------- |
| BeforeJSONProcessing | ByRef json As Auto |      | The payload was coerced from JSON to an `Auto()` array or `Xojo.Core.Dictionary`. Use this event to make final adjustments before processing begins. |
| CancelSend | ByRef url As Text,<BR />ByRef httpAction As Text,<BR />ByRef payload As Xojo.Core.MemoryBlock,<BR />ByRef payloadMIMEType As Text | Boolean | The last chance to cancel sending the message, or change the URL, HTTP action, payload, or MIME type for the send. Set the payload to nil to avoid any payload. |
| ContinueWaiting |  | Boolean | The message has exceeded the time specified in _MessageOptions.TimeoutSeconds_. Return `True` to let it continue waiting for another period. (See <a href='#optionssection'>_MessageOptions_</a> below.) |
| Disconnected |  |  | The socket has disconnected. |
| Error | msg As Text |  | Some error has occurred during the connection. |
| ExcludeFromOutgoingPayload | prop As Xojo.Introspection.PropertyInfo,<BR />ByRef propName As Text,<BR />ByRef propValue As Auto,<BR />hostObject As Object | Boolean | A message property is about to be included in the outgoing payload. If it shouldn't be, return `True`. You can also change the property name that will be used as the JSON object key or the value. |
| GetNewObjectForClassName | className As Text | Object | Return a new Object for the given _className_. This is called when deserializing the payload into an array of objects. You can also use the shared method `RegisterClassTypeInfo` to register classes ahead of time. |
| GetRESTType |  | RESTTypes | See <a href='#getresttypeeventsection'>The `GetRESTType` Event</a> below. |
| GetURLPattern |  | Text | See <a href='#geturlpatterneventsection'>The `GetURLPattern` Event</a> below. |
| IncomingPayloadValueToProperty | value As Auto,<BR />prop As Xojo.Introspection.PropertyInfo,<BR />hostObject As Object | Boolean | The incoming payload has a value that has been matched to a property of the message or one of the objects in its properties. Return `True` to prevent this value from being processed automatically, i.e., you will process it yourself. |
| ObjectToJSON | o As Object,<BR />typeInfo As Xojo.Introspection.TypeInfo | Auto | An object in one of the message's properties is about to be serialized, but you may prefer to do it yourself. If so, return a `Xojo.Core.Dictionary` or an `Auto()` array. If you do not implement this event or return nil, automatic processing will proceed. |
| ResponseReceived | url As Text,<BR />HTTPStatus As Integer,<BR />payload As Auto |  | The server has responded. The _url_ contains the server's URL, `HTTPStatus` the raw code returned by the server, and `payload` as the best form that RESTMesstage\_MTC could convert it into, i.e., `Xojo.Core.MemoryBlock`, `Auto()`, or `Xojo.Core.Dictionary`. |
| Setup |  |  | The message object has been constructed. This is a good place to set the initial values of properties or <a href='#optionssection'>_MessageOptions_</a>. |
| SkipIncomingPayloadProcessing | url As Text,<BR />httpStatus As Integer,<BR />ByRef payload As Auto | Boolean | The server has responded with a payload. If you prefer the class not try to automatically parse it, return `True`. |

### <a name='geturlpatterneventsection'></a>The `GetURLPattern` Event

This event will let you specify the URL that will be used to connect to the server. It is raised each time you call `Send`.

You must return some value here.

The URL can be complete or may contain placeholders that represent properties within the message. For example, you need to get the weather in the zip code 99911 and the RESTful server requires the URL in the form:

```
http://www.someweathersite.com/api/get/zip/99911
```

You can create a property in your message subclass, _ZipCode_, and return the URL pattern like this:

```
http://www.someweathersite.com/api/get/zip/:ZipCode
```

`RESTMessage_MTC` will do the appropriate substitution and encode the value for you. To send the message, you merely have to fill in the property and call `Send`.

__Note__: Properties that are part of the URL pattern will never be included in the outgoing payload.

### <a name='getresttypeeventsection'></a>The `GetRESTType` Event

`RESTMessage_MTC` defines a _RESTTypes_ enum whose values either include or correspond to HTTP actions. Return the type appropriate for the message. As of v.1.0, these are:

| Type      |
| --------- |
| Unknown |
| Create |
| Read |
| UpdateReplace |
| UpdateModify |
| Authenticate |
| DELETE |
| GET |
| HEAD |
| OPTIONS |
| PATCH |
| POST |
| PUT |

The uppercase types correspond directly to an HTTP action. The lowercase types are for convenience and will choose the proper action. For example, `Read` corresponds to the `GET` action.

### Properties

| Property | Type | Read Only |  Description |
| -------- | ---- | :------: | ------------ |
| DefaultRESTType | RESTTypes | no | The default REST type that will be used of <a href='#getresttypeeventsection'>the `GetRestType` event</a> is not implemented. |
| IsConnected | Boolean | __YES__ | Returns `True` if the socket is currently connected. |
| MaximumConnections | Integer | no | The maximum number of simultaneous connections allowed. Additional messages will be queued automatically until they can be sent. Set to 0 to allow unlimited connections. The default is 4.
| MessageOptions | M\_REST.MessageOptions | no | Set the options for the message. See <a href='#optionssection'>_MessageOptions_</a> below. |
| MessageSerialNumber | Int64 | __YES__ | A unique number (within the session) assigned to each new instance of a message. |
| MessageTag | Auto | no | Anything you wish to attach to a message. Does not get transmitted. |
| QueueState | QueueStates enum | __YES__ | The current state of the message, either `Queued` or `Processed`. |
| RESTType | RESTTypes | __YES__ | The REST type that is ultimately used for the message. |
| RoundTripMs | Double | __YES__ | The round-trip time, in milliseconds, from when the connection was initiated until a response received. |
| RoundTripWithProcessingMs | Double | __YES__ | The round-trip time, in milliseconds, from when `Send` was invoked until response processing was finished. |
| SentPayload | Xojo.Core.MemoryBlock | __YES__ | The payload as it was ultimately sent to the server. |

### Methods

| Method | Parameters | Returns | Description |
| ------ | ---------- | ------- | ----------- |
| Disconnect | | | Disconnect from the server immediately. If not connected, will do nothing. |
| Send | (opt) surrogate As RESTMessageSurrogate\_MTC |  | Fill in the properties first, make sure the <a href='#eventssection'>required events</a> are implemented, then use this to send the message. __Note__: If the socket is already connected to the server, you will get an error. Check the _IsConnected_ property or just call `Disconnect` first.<BR /><BR />If a surrogate is specified, incoming events will be raised for this message in it too <a href='#surrogatesection'>(see below)</a>. |

### Shared Methods

| Method | Parameters | Returns | Description |
| ------ | ---------- | ------- | ----------- |
| RegisterClassTypeInfo | classTypeInfo As Xojo.Introspection.TypeInfo | | Register the TypeInfo for a class that may be used when deserializing an array. Or you implement the `GetNewObjectForClassName` event instead. |
| RESTTypeToHTTPAction | type As RESTTypes | Text | Returns the text that corresponds to the given _type_. |

### <a name='optionssection'></a>MessageOptions

The _MessageOptions_ will let you set certain parameters for the message. For example, if a message is expected to take longer to send or receive or you want to make sure the payload is never sent.

| Property | Type | Default | Description |
| -------- | :--: | :-----: | ----------- |
| AdjustDatesFromTimeZone | Boolean | False | When encoded dates are sent or received, this determines if the time zone should be honored. If so, the date will be adjusted according to the local time zone. |
| ExpectedTextEncoding | Xojo.Core.TextEncoding | Xojo.Core.TextEncoding.UTF8 | When the payload is received, it is usually as UTF-8. If the server expects or delivers something different, specify that here. |
| ReturnPropertyPrefix | Text | "Return" | Any property in your subclass that starts with this prefix will never be included in the outgoing payload and will be cleared and, if possible, populated by the incoming payload. These properties may be a basic type like String, Text, or Integer, a Dictionary, Auto() array, or an object whose public properties correspond to the incoming JSON object. |
| SendWithPayloadIfAvailable | Boolean | True | For any HTTP action _other_ than GET, the class will attempt to construct and attach a payload using the properties of the message that (1) are not "Return" properties and (2) have not been included in the <a href='#geturlpatterneventsection'>URL pattern</a>. Set this to `True` to avoid that processing in all cases. |
| TimeoutSeconds | Integer | 5 | Sets how long a message can wait before the `ContinueWaiting` event is raised. |

### <a name='surrogatesection'></a>RESTMessageSurrogate_MTC

The `RESTMessageSurrogate_MTC` class will act as a stand-in for a message after it is sent. Drag the class to your window and implement its events. When sending a message, use the optional second parameter to specify the surrogate.

__Note__: Events will be raised in the message first and then in the surrogate, except if an event returns a Boolean, returning `True` in the message will prevent the event from being raised in the surrogate.

Generally it doesn't make much sense to implement the same event in both the message and a surrogate. The surrogate is there for situations where dragging a single copy of a message to your window does not make sense, e.g., you need to quickly save multiple records in a row.

The parameters of each event match the parameters of the `RESTMessage_MTC` or `Xojo.Net.HTTPSocket` with the instance of the message as the first parameter in each case. This emulates using `AddHandler` to intercept the message's events.

You can also use the _RESTMessage\_MTC.MessageTag_ property to further identify an instance of a message.

The `RESTMessageSurrogate_MTC` has some additional properties and methods.

#### Methods

| Method | Parameters | Returns | Description |
| ------ | ---------- | ------- | ----------- |
| DisconnectAll | | | Disconnect all of the outstanding messages |
| DisconnectMessage | msg As RESTMessage\_MTC | | Disconnect a single message |
| OutstandingMessages | | RESTMessage\_MTC() | An array of outstanding messages | 

#### Properties

| Property | Type | Default | Description |
| -------- | :--: | :-----: | ----------- |
| IsBusy | Boolean | | Returns `True` if there are still outstanding messages |

## Global Methods in `M_REST` Module

The `M_REST` module has some helper methods that are of use outside of this REST framework. Call them with the `M_REST.` prefix.

| Method | Parameters | Returns | Description |
| ------ | ---------- | ------- | ----------- |
| AssembleURL | baseURL As Text,<BR/ >encodedQuery As Text,<BR />ParamArray additionalQueries() As Text | Text | Assemble a URL from the given base and array of queries. Will properly insert "?" and "&" where needed. Values within the query should be properly URL encoded. |
| AssembleURL | baseURL As Text,<BR />encodedQueries() As Text | Text | Same as above but allows you specify all the queries as an array. |
| BuildMultipartFileRequest | fileName As Text,<BR />fileIn As Xojo.IO.BinaryStream,<BR />ByRef payload As Xojo.Core.MemoryBlock,<BR />ByRef mimeType As Text | | Build a Multipart File request from the given parameters. Primarily intended to send a file from raw data. Returns values in the `ByRef` parameters. |
| BuildMultipartRequest | file as Xojo.IO.FolderItem,<BR />formData as Xojo.Core.Dictionary,<BR />ByRef payload As Xojo.Core.MemoryBlock,<BR />ByRef mimeType As Text | | Build a Multipart File request from the given parameters. Primarily intended to send a file from a FolderItem. Returns values in the `ByRef` parameters. | 
| EncodeURLComponent | src As Text,<BR />encoding As Xojo.Core.TextEncoding = Nil | Text | Emulates the Classic Framework's EncodeURLComponent but for Text. |

## Contributions

Contributions to this project are welcome. Fork it to your own repo, then submit changes. However, be forewarned that only those changes that we deem universally useful will be included.

## Who Did This?

This project was designed and implemented by:

* Kem Tekinay (ktekinay at mactechnologies.com)

With special thanks to [Advanced Medical Pricing Solutions, Inc.](http://www.advancedpricing.com) for making this possible.

## Release Notes

1.3 (___, 2016)

- JSON values that are delivered as `Text` will be coerced into the expected value, if possible.
- Added XojoUnit framework.
- Added `UnitTestRESTMessage` interface to facilitate testing of private methods.
- Added unit tests.
- Added `BeforeJSONProcessing` event.
- Added pragmas to keep from dropping to the debugger for anticipated exceptions.
- Added `M_REST.BuildMultipartRequest` and `M_REST.BuildMultipartFileRequest` functions.
- Added `M_REST.AssembleURL` function.
- Added `M_REST.EncodeURLComponent` function.
- No longer try to process a payload if there isn't one.
- Better handle `Auto()`, `Variant()`,  and `Dictionary` properties.
- After sending, store the last sent payload for reference.
- If a return value is matched to an `Auto` property, just store it directly without processing.
- `ExcludeFromOutgoingPayload` event not includes the `hostObject` of the property.
- `Send` will queue messages instead of sending immediately and will allow no more than `MaximumConnections` simultaneous connections.

1.2 (May 18, 2016)

- Added `RESTMessageSurrogate_MTC.Sent` event.
- Changed where _ResponseReceivedMicroseconds_ is recorded.
- Changed the parameter _sender_ to _message_ in `RESTMessageSurrogate_MTC` events.

1.1 (May 18, 2016)

- Changed _Options_ property to _MessageOptions_ to prevent possible conflicts in subclasses.
- Added _MessageSerialNumber_ property.
- Added _RoundTripWithProcessingMs_ property.
- Added _MessageTag_ property.
- Added `RESTMessageSurrogate_MTC` class.

1.0 (May 12, 2016)

- Initial release.
