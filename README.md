# OnkyoKit

OnkyoKit is a Cocoa (and eventually Cocoa Touch) framework to control Onkyo
receivers using the eISCP network protocol. See the [Example](Example/) directory
for a simple OS X example application that uses OnkyoKit. *The public API is not
stable.*

Current development is on the
[develop](https://github.com/jhh/onkyokit/tree/develop) branch with releases
tagged on the [master](https://github.com/jhh/onkyokit/tree/master) branch.

*NOTE: Requires Xcode 6.*

## License

OnkyoKit is released under the MIT license. See [LICENSE](LICENSE).

## See Also

* [ISCP-V1.21_2011.xls][eiscp-protocol]  
  Onkyo protocol documentation, in excel format.

* [https://github.com/miracle2k/onkyo-eiscp][onkyo-eiscp-python]  
  Python implementation and source of YAML file containing commands defined by Onkyo eISCP protocol.

* [https://github.com/janten/onkyo-eiscp-remote-mac][onkyo-eiscp-remote-mac]  
  Command line tool for Mac OS X to interact with Onkyo receivers.


[onkyo-eiscp-python]:https://github.com/miracle2k/onkyo-eiscp "Onkyo eISCP Control"
[onkyo-eiscp-remote-mac]:https://github.com/janten/onkyo-eiscp-remote-mac
[eiscp-protocol]:http://michael.elsdoerfer.name/onkyo/ISCP-V1.21_2011.xls "Integra Serial Communication Protocol for AV Receiver"
[license]:LICENSE
