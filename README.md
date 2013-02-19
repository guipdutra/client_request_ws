client_request_ws
=================

Just a WSDL client to do tests with RSpec for DSMN.

## Usage

```ruby
@response = call("operation")
              .product("blablabla")
              .and(:param1).is("B")
              .and(:param2).is("A")
              .and(:param3).is("C")
              .please!


@response.was_ok?


