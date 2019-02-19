function Get-ZertoPeerSite {
    [cmdletbinding( defaultParameterSetName = "main" )]
    param (
        [Parameter ( ParameterSetName = "pairingStatuses", Mandatory = $true )]
        [switch]$pairingStatuses,
        [Parameter ( ParameterSetName = "siteIdentifier",
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true )]
        [string[]]$siteIdentifier,
        [Parameter ( ParameterSetName = "filter" )]
        [string]$peerName,
        [Parameter ( ParameterSetName = "filter" )]
        [string]$paringStatus,
        [Parameter ( ParameterSetName = "filter" )]
        [string]$location,
        [Parameter ( ParameterSetName = "filter" )]
        [string]$hostName,
        [Parameter ( ParameterSetName = "filter" )]
        [string]$port
    )

    begin {
        $baseUri = "peersites"
        $returnObject = [System.Collections.ArrayList]@()
    }

    process {
        switch ( $PSCmdlet.ParameterSetName ) {
            "main" {
                $uri = "{0}" -f $baseUri
                $results = Invoke-ZertoRestRequest -uri $uri
                $returnObject.Add($results) | Out-Null
            }

            "siteIdentifier" {
                foreach ( $id in $siteIdentifier ) {
                    $uri = "{0}/{1}" -f $baseUri, $id
                    $results = Invoke-ZertoRestRequest -uri $uri
                    $returnObject.Add($results) | Out-Null
                }
            }

            "filter" {
                $filter = Get-ZertoApiFilter -filterTable $PSBoundParameters
                $uri = "{0}{1}" -f $baseUri, $filter
                $results = Invoke-ZertoRestRequest -uri $uri
                $returnObject.Add($results) | Out-Null
            }

            default {
                $uri = "{0}/{1}" -f $baseUri, $PSCmdlet.ParameterSetName.ToLower()
                $results = Invoke-ZertoRestRequest -uri $uri
                $returnObject.Add($results) | Out-Null
            }
        }
    }

    end {
        return $returnObject
    }
}