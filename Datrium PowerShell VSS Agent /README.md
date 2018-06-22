# Datrium VSS Agent PowerShell
## DaHub (Datrium Git Hub Repository)
DaHub projects are community driven projects, and are not created by Datrium Engineering nor validated by Datrium QA. They are maintained by community members which may or may not be Datrium employees.

## Distributed under MIT license

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Project Notes
**Author:** Clint Wyckoff (@ClintWyckoff) and Cameron Joyce

**Purpose of Script:** This Script will automatically deploy the Datrium VSS Agent to a designated Windows-based computer on the network.

# Required Variables
$vm = What is the FQDN or IP of the VM to deploy Datrium VSS Agent to?
$damgmtfloat = What is the IP address of the Datrium Data Node?
$dapw = What is the Admin password to the Datrium Data Node?

**Requires:** The script was written and tested Windows Server 2016 with SQL 2016 as well as Datrium DVX v.4.0.1