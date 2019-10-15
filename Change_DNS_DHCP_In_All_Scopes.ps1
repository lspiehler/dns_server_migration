$scopes = Get-DhcpServerv4Scope

$before = "10.2.10.101"
$after = "10.101.0.73"

$scopes | % {
	$dns = Get-DhcpServerv4OptionValue -ComputerName "dhcp1.smhplus.org" -ScopeId $_.ScopeId -OptionId 6 -ErrorAction "SilentlyContinue"
	$new = @()
	$update = $False
	If ($dns -eq $null) {
		
	} Else {
		"Scope $($_.ScopeId)"
		For($i = 0; $i -le $dns.Value.Count - 1; $i++) {
			If($dns.Value[$i] -eq $before) {
				$update = $True
				"`tchange $($dns.Value[$i])"
				$new += $after
			} Else {
				"`tkeep $($dns.Value[$i])"
				$new += $dns.Value[$i]
			}
		}
		If ($update -eq $True) {
			"Updating $($_.ScopeId)"
			Set-DhcpServerv4OptionValue -ComputerName "dhcp1.smhplus.org" -ScopeId $_.ScopeId -OptionId 6 -Value $new
			Invoke-DhcpServerv4FailoverReplication -ComputerName "dhcp1.smhplus.org" -ScopeId $_.ScopeId -Force
		}
	}
}