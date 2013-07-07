# Onkyo Console

Onkyo Console is a simple application demonstrating the use of OnkyoKit to explore eISCP interaction with an Onkyo AV receiver.

## Usage

Onkyo Console will send the receiver the `PWRQSTN` (power status) command after you select a discovered receiver. You can send commands to the connected receiver by typeing them into the text field below the output window, followed by "return". For example, on a TX-NR616, other commands you can try are:

- `PWRQSTN`: power status
- `PWR01`: set system on
- `PWR00`: set system standby
- `AMTQSTN`: mute status
- `AMT01`: set mute on
- `AMT00`: set mute off
- `MVLQSTN`: master volume status
- `MVL??`: set master volume to ??, ?? is 00-64 in hexadecimal
- `MVLUP`: set master volume up
- `MVLDOWN`: set master volume down

Refer to the [eISCP protocol documentation][eiscp-protocol] for other receivers and commands.

[eiscp-protocol]:http://michael.elsdoerfer.name/onkyo/ISCP-V1.21_2011.xls "Integra Serial Communication Protocol for AV Receiver"
