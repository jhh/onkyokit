# OnkyoKit
[![Build Status](https://travis-ci.org/jhh/onkyokit.svg?branch=master)](https://travis-ci.org/jhh/onkyokit)

OnkyoKit is a Cocoa (and eventually Cocoa Touch) framework to control Onkyo
receivers using the eISCP network protocol. See the [Example](Example/) directory
for a simple OS X example application that uses OnkyoKit. *The public API is not
stable.*

Current development is on the
[develop](https://github.com/jhh/onkyokit/tree/develop) branch with releases
tagged on the [master](https://github.com/jhh/onkyokit/tree/master) branch.

*NOTE: Requires Xcode 6.*

## See Also

* [ISCP-V1.21_2011.xls][eiscp-protocol]  
  Onkyo protocol documentation, in excel format.

* [https://github.com/miracle2k/onkyo-eiscp][onkyo-eiscp-python]  
  Python implementation and source of YAML file containing commands defined by
  Onkyo eISCP protocol.

* [https://github.com/janten/onkyo-eiscp-remote-mac][onkyo-eiscp-remote-mac]  
  Command line tool for Mac OS X to interact with Onkyo receivers.


[onkyo-eiscp-python]:https://github.com/miracle2k/onkyo-eiscp "Onkyo eISCP Control"
[onkyo-eiscp-remote-mac]:https://github.com/janten/onkyo-eiscp-remote-mac
[eiscp-protocol]:http://michael.elsdoerfer.name/onkyo/ISCP-V1.21_2011.xls "Integra Serial Communication Protocol for AV Receiver"
[license]:LICENSE

## License

OnkyoKit is released under the MIT license.

```text
Copyright (c) 2013-2015, Jeff Hutchison
All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
