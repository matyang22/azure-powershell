# ----------------------------------------------------------------------------------
#
# Copyright Microsoft Corporation
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------------


<#
.Synopsis
Create a CloudService Resource
.Description
Create a CloudService Resource 
.Link
https://docs.microsoft.com/powershell/module/az.cloudservice/new-azcloudservice
#>

function New-AzCloudService {
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.CloudService.Models.Api20201001Preview.ICloudService])]
    [CmdletBinding(DefaultParameterSetName='CreateExpanded', PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage', Mandatory)]
        [Alias('CloudServiceName')]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Path')]
        [System.String]
        # Name of the cloud service.
        ${Name},

        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Path')]
        [System.String]
        # Name of the resource group.
        ${ResourceGroupName},

        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage')]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
        [System.String]
        # Subscription credentials which uniquely identify Microsoft Azure subscription.
        # The subscription ID forms part of the URI for every service call.
        ${SubscriptionId},

        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Body')]
        [System.String]
        # Resource location.
        ${Location},

        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Body')]
        [System.String]
        # Specifies the XML service configuration (.cscfg) for the cloud service.
        ${ConfigurationFile},
        
        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Body')]  #TODO what should this line be? not in body or path
        [System.String]
        # Specifies the XML service definitions (.csdef) for the cloud service. 
        ${DefinitionFile},

        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Body')]
        [System.String]
        # Specifies a URL that refers to the location of the service package in the Blob service.
        # The service package URL can be Shared Access Signature (SAS) URI from any storage account.This is a write-only property and is not returned in GET calls.
        ${PackageUrl},

        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage')]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Models.Api20201001Preview.ICloudServiceExtensionProfile]
        # Describes a cloud service extension profile.
        # To construct, see NOTES section for EXTENSIONPROFILE properties and create a hash table.
        ${ExtensionProfile},

        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage')]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Body')]
        [System.Management.Automation.SwitchParameter]
        # (Optional) Indicates whether to start the cloud service immediately after it is created.
        # The default value is `true`.If false, the service model is still deployed, but the code is not run immediately.
        # Instead, the service is PoweredOff until you call Start, at which time the service will be started.
        # A deployed service still incurs charges, even if it is poweredoff.
        ${StartCloudService},

        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage')]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Runtime.Info(PossibleTypes=([Microsoft.Azure.PowerShell.Cmdlets.CloudService.Models.Api20201001Preview.ICloudServiceTags]))]
        [System.Collections.Hashtable]
        # Resource tags.
        ${Tag},

        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage')]
        [ArgumentCompleter([Microsoft.Azure.PowerShell.Cmdlets.CloudService.Support.CloudServiceUpgradeMode])]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Support.CloudServiceUpgradeMode]
        # Update mode for the cloud service.
        # Role instances are allocated to update domains when the service is deployed.
        # Updates can be initiated manually in each update domain or initiated automatically in all update domains.Possible Values are <br /><br />**Auto**<br /><br />**Manual** <br /><br />**Simultaneous**<br /><br />If not specified, the default value is Auto.
        # If set to Manual, PUT UpdateDomain must be called to apply the update.
        # If set to Auto, the update is automatically applied to each update domain in sequence.
        ${UpgradeMode},

        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage')]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Body')] #TODO
        [System.String]
        # Name of the KeyVault to be used for the CloudService resource
        ${DnsName},

        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage')]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Body')]  #TODO 
        [System.String]
        # Name of Dns to be used for the CloudService resource
        ${KeyVaultName}
    )

    process {

        # extract csdef/cscfg 

        if (-not (Test-Path $ConfigurationFile))  # TODO
        {
            Write-Error "Cannot find file $JsonTemplatePath. Please make sure it exists!"
            exit 1
        }
        [xml]$csdef = Get-Content -Path $DefinitionFile
        [xml]$cscfg = Get-Content -Path $ConfigurationFile

        # do validation 
        validation $cscfg $csdef

        # if storage is not given, create it 

        
        # network profile
        if ( $null -eq $cscfg.ServiceConfiguration.NetworkConfiguration.AddressAssignments.ReservedIPs.ReservedIPs ){
            $publicIpName = $name + "Ip"
            if ($PSBoundParameters.ContainsKey("ParameterA"))
            {

            }
            # Create a public IP address and (optionally) set the DNS label property of the public IP address. If you are using a static IP, it needs to referenced as a Reserved IP in Service Configuration file.
            $publicIp = New-AzPublicIpAddress -Name “ContosIp” -ResourceGroupName $ResourceGroupName -Location $Location -AllocationMethod Dynamic -IpAddressVersion IPv4 -DomainNameLabel “contosoappdns” -Sku Basic
        }
        else {
            $publicIpName = $cscfg.ServiceConfiguration.NetworkConfiguration.AddressAssignments.ReservedIPs.ReservedIP.Name
        }
        
            # Create Network Profile Object and associate public IP address to the frontend of the platform created load balancer.
        $publicIP = Get-AzPublicIpAddress -ResourceGroupName ContosOrg -Name $publicIpName  
        $feIpConfig = New-AzCloudServiceLoadBalancerFrontendIPConfigurationObject -Name 'ContosoFe' -PublicIPAddressId $publicIP.Id 
        $loadBalancerConfig = New-AzCloudServiceLoadBalancerConfigurationObject -Name 'ContosoLB' -FrontendIPConfiguration $feIpConfig 
        $networkProfile = @{loadBalancerConfiguration = $loadBalancerConfig}

        # Create network profile object
        $publicIp = Get-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Name ContosIp
        $feIpConfig = New-AzCloudServiceLoadBalancerFrontendIPConfigurationObject -Name 'ContosoFe' -PublicIPAddressId $publicIp.Id
        $loadBalancerConfig = New-AzCloudServiceLoadBalancerConfigurationObject -Name 'ContosoLB' -FrontendIPConfiguration $feIpConfig
        $networkProfile = @{loadBalancerConfiguration = $loadBalancerConfig}

        # OS Profile

        # Role Profile 

        $cfg_role1 = $cscfg.ServiceConfiguration.Role[0]
        $def_role1 = $csdef.ServiceDefinition.($cfg_role1.name)
        $role1 = New-AzCloudServiceRoleProfilePropertiesObject -Name $def_role1.Name -SkuName $def_role1.vmsize -SkuTier 'Standard' -SkuCapacity $cfg_role1.Instances.count 
        
        if ( $cscfg.ServiceConfiguration.Role.count -eq 2 )   
        {
            $cfg_role2 = $cscfg.ServiceConfiguration.Role[1]
            $def_role2 = $csdef.ServiceDefinition.($cfg_role2.name)
            $role2 = New-AzCloudServiceRoleProfilePropertiesObject -Name $def_role2.Name -SkuName $def_role2.vmsize -SkuTier 'Standard' -SkuCapacity $cfg_role2.Instances.count 

            $roleProfile = @{role = @($role1, $role2)} 
        }
        else
        {
            $roleProfile = @{role = @($role1)} 
        }
        

        

        # pass it along 


        if ($PSBoundParameters.ContainsKey("ParameterA"))
        {
            # Do something with the -ParameterA parameter

            # If necessary, remove the -ParameterA parameter from the dictionary of bound parameters
            $null = $PSBoundParameters.Remove("ParameterA")
        }

        if ($PSBoundParameters.ContainsKey("ParameterB"))
        {
            # Do something with the -ParameterB parameter

            # If necessary, remove the -ParameterB parameter from the dictionary of bound parameters
            $null = $PSBoundParameters.Remove("ParameterB")
        }

        # Perform action

        # If these variants should call back to the original cmdlet, use splatting to pass the existing set of parameters
        MyModule\Get-Foo @PSBoundParameters
    }

}

function validation
{
    param(
        [Parameter()]
        [object]
        ${cscfg},
        [Parameter()]
        [object]
        ${csdef}
    )

    # Network configuration missing in configuration
    If ( $null -eq $cscfg.ServiceConfiguration.NetworkConfiguration -or $cscfg.ServiceConfiguration.NetworkConfiguration.VirtualNetworkSite.count -eq 0 -or $cscfg.ServiceConfiguration.NetworkConfiguration.AddressAssignments.InstanceAddress.Subnets.count -eq 0)
    {
        Write-Error("The network configuration is missing from the configuration file. Please add the network configuration to the configuration file and re-upload.")
        exit 1
    }






}