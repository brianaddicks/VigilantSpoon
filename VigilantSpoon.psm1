#Build: 55
###############################################################################
## Start Powershell Cmdlets
###############################################################################


###############################################################################
# New-VsCliResult
function New-VsCliResult {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$True,Position=0)]
        [string]$Header,
        
        [Parameter(Mandatory=$False,Position=1)]
        [string]$Content
    )
    
    $NewObject         = "" | Select Header,Content
    $NewObject.Header  = $Header 
    $NewObject.Content = $Content
    
    return $NewObject
}
###############################################################################
# New-VsField
function New-VsField {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory=$True,Position=1)]
        [string]$Name,
        
        [Parameter(Mandatory=$False)]
        [string]$Label,
        
        [Parameter(Mandatory=$False)]
        [switch]$Inline,
        
        # text
        [Parameter(Mandatory=$True,Position=0,ParameterSetName="text")]
        [switch]$Text,
        
        [Parameter(Mandatory=$False,Position=2,ParameterSetName="text")]
        [string]$Placeholder,
        
        [Parameter(Mandatory=$False,ParameterSetName="text")]
        [array]$Validators = @(),

        [Parameter(Mandatory=$False,ParameterSetName="text")]
        [string]$Example,
        
        # select
        [Parameter(Mandatory=$True,Position=0,ParameterSetName="select")]
        [switch]$Select,
        
        [Parameter(Mandatory=$False,Position=2,ParameterSetName="select")]
        [array]$Options,
        
        # checkbox
        [Parameter(Mandatory=$True,Position=0,ParameterSetName="checkbox")]
        [switch]$Checkbox
    )

    if ($Text)     { $Type = "text" }
    if ($Select)   { $Type = "select"}
    if ($Checkbox) { $Type = "checkbox"}

    $NewObject             = "" | Select Name,Type,Placeholder,Validators,Label,Options,Inline,Example
    $NewObject.Name        = $Name
    $NewObject.Type        = $Type
    $NewObject.Label       = $Label
    $NewObject.Placeholder = $Placeholder
    $NewObject.Options     = $Options
    $NewObject.Example     = $Example
    
    if ($Inline) {
        $NewObject.Inline = "true"
    } else {
        $NewObject.Inline = "false"
    }

    return $NewObject
}
###############################################################################
# New-VsFieldset
function New-VsFieldset {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory=$True,Position=0)]
        [string]$Header,
        
        [Parameter(Mandatory=$True,Position=1)]
        [array]$Inputs
    )
    
    $NewObject                = "" | Select Header,Inputs
    $NewObject.Header         = $Header
    $NewObject.Inputs         = @($Inputs)
    
    return $NewObject
}
###############################################################################
# New-VsFieldValidator
function New-VsFieldValidator {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory=$True)]
        [string]$ErrorMessage,
        
        # different
        [Parameter(Mandatory=$True,ParameterSetName="different",Position=0)]
        [switch]$Different,
        
        [Parameter(Mandatory=$True,ParameterSetName="different",Position=1)]
        [string]$CompareToField,

        # ip
        [Parameter(Mandatory=$True,ParameterSetName="ip",Position=0)]
        [switch]$Ip,
        
        [Parameter(Mandatory=$False,ParameterSetName="ip")]
        [switch]$IPv4Only,
        
        [Parameter(Mandatory=$False,ParameterSetName="ip")]
        [switch]$IPv6Only,
        
        # notempty
        [Parameter(Mandatory=$True,ParameterSetName="notempty",Position=0)]
        [switch]$NotEmpty,
        
        # regexp
        [Parameter(Mandatory=$True,ParameterSetName="regexp",Position=0)]
        [switch]$RegularExpression,
        
        [Parameter(Mandatory=$True,ParameterSetName="regexp",Position=1)]
        [string]$Pattern,
        
        # between
        [Parameter(Mandatory=$True,ParameterSetName="between",Position=0)]
        [switch]$Between,
        
        [Parameter(Mandatory=$True,ParameterSetName="between",Position=1)]
        [double]$Min,
        
        [Parameter(Mandatory=$True,ParameterSetName="between",Position=2)]
        [double]$Max,
        
        [Parameter(Mandatory=$False,ParameterSetName="between")]
        [switch]$Inclusive
    )

    if ($Different)         { $Type = "different" }
    if ($Ip)                { $Type = "ip"        }
    if ($NotEmpty)          { $Type = "notempty"  }
    if ($RegularExpression) { $Type = "regexp"    }
    if ($Between)           { $Type = "between"   }
    
    $NewObject = @()
    $NewObject += New-VsHtmlAttribute ("data-fv-$Type").ToLower() "true"
    $NewObject += New-VsHtmlAttribute ("data-fv-$Type-message").ToLower() $ErrorMessage

    switch ($Type) {
        "different" {
            $NewObject += New-VsHtmlAttribute "data-fv-different-field" $CompareToField
            break
        }
        "ip" {
            if ($IPv4Only) { $NewObject += New-VsHtmlAttribute "data-fv-ip-ipv6" 'false' }
            if ($IPv6Only) { $NewObject += New-VsHtmlAttribute "data-fv-ip-ipv4" 'false' }
            break
        }
        "regexp" {
            $NewObject += New-VsHtmlAttribute "data-fv-regexp-regexp" $Pattern
        }
        "between" {
            $NewObject += New-VsHtmlAttribute "data-fv-between-min" $Min
            $NewObject += New-VsHtmlAttribute "data-fv-between-max" $Max
            if ($Inclusive) { $NewObject += New-VsHtmlAttribute "data-fv-between-inclusive" "true" }
        }
    }

    return $NewObject    
}
###############################################################################
# New-VsHtmlAttribute
function New-VsHtmlAttribute {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory=$True,Position=0)]
        [string]$Attribute,
        
        [Parameter(Mandatory=$True,Position=1)]
        [string]$Value
    )
    
    $NewObject           = "" | Select Attribute,Value
    $NewObject.Attribute = $Attribute
    $NewObject.Value     = $Value
    
    return $NewObject
}
###############################################################################
# New-VsPhase
function New-VsPhase {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$True,Position=0)]
        [ValidateSet("clioutput","parser")]
        [string]$AppType,
        
        [Parameter(Mandatory=$False,Position=1)]
        [string]$NextPhase,
        
        [Parameter(Mandatory=$False)]
        [array]$Fieldsets = @(),
        
        [Parameter(Mandatory=$False)]
        [array]$ErrorMessages = @()
    )

    $NewObject               = "" | Select AppType,NextPhase,Fieldsets,ErrorMessages
    $NewObject.AppType       = $AppType
    $NewObject.Fieldsets     = $Fieldsets
    $NewObject.ErrorMessages = $ErrorMessages
 
    return $NewObject
}
###############################################################################
# New-VsResultObject
function New-VsResultObject {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory=$True,Position=0)]
        [ValidateSet("clioutput","parser")]
        [string]$AppType,
        
        [Parameter(Mandatory=$True,Position=1)]
        [array]$Results,

        [Parameter(Mandatory=$False,Position=2)]
        [array]$Troubleshooting
    )
    
    $NewObject                 = "" | Select AppType,Results,Troubleshooting
    $NewObject.AppType         = $AppType
    $NewObject.Results         = $Results
    $NewObject.Troubleshooting = $Troubleshooting 
    
    return $NewObject
}
###############################################################################
# New-VsTroubleshootingItem
function New-VsTroubleshootingItem {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory=$True,Position=0)]
        [string]$Header,
        
        [Parameter(Mandatory=$True,Position=1)]
        [string]$Content
    )
    
    $NewObject         = "" | Select Header,Content
    $NewObject.Header  = $Header
    $NewObject.Content = $Content
    
    return $NewObject
}
