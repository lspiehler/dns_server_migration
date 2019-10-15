Option Explicit
'On Error Resume Next

Dim dnsservers, strComputer, objWMIService, colAdapters, objAdapter, i

strComputer = "."

Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

Set colAdapters = objWMIService.ExecQuery _
    ("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = TRUE AND DHCPEnabled = FALSE")
 
For Each objAdapter in colAdapters
	If Not IsNull(objAdapter.DNSServerSearchOrder) Then
		dnsservers = Array()
		For i = 0 To UBound(objAdapter.DNSServerSearchOrder)
			ReDim Preserve dnsservers(UBound(dnsservers)+1)
			'if dns server match, change to new address
			If objAdapter.DNSServerSearchOrder(i) = "10.2.10.101" Then
				dnsservers(i) = "10.101.0.73"
			ElseIf objAdapter.DNSServerSearchOrder(i) = "10.2.11.226" Then
				dnsservers(i) = "10.101.0.74"
			ElseIf objAdapter.DNSServerSearchOrder(i) = "10.2.11.227" Then
				dnsservers(i) = "10.101.0.86"
			Else
				dnsservers(i) = objAdapter.DNSServerSearchOrder(i)
			End If
		Next
		
		objAdapter.SetDNSServerSearchOrder dnsservers
		
	End If
Next