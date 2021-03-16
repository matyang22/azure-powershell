namespace Microsoft.Azure.PowerShell.Cmdlets.DnsResolver.Models.Api20200401Preview
{
    using static Microsoft.Azure.PowerShell.Cmdlets.DnsResolver.Runtime.Extensions;

    /// <summary>Metadata attached to the inbound endpoint.</summary>
    public partial class InboundEndpointPatchPropertiesMetadata :
        Microsoft.Azure.PowerShell.Cmdlets.DnsResolver.Models.Api20200401Preview.IInboundEndpointPatchPropertiesMetadata,
        Microsoft.Azure.PowerShell.Cmdlets.DnsResolver.Models.Api20200401Preview.IInboundEndpointPatchPropertiesMetadataInternal
    {

        /// <summary>Creates an new <see cref="InboundEndpointPatchPropertiesMetadata" /> instance.</summary>
        public InboundEndpointPatchPropertiesMetadata()
        {

        }
    }
    /// Metadata attached to the inbound endpoint.
    public partial interface IInboundEndpointPatchPropertiesMetadata :
        Microsoft.Azure.PowerShell.Cmdlets.DnsResolver.Runtime.IJsonSerializable,
        Microsoft.Azure.PowerShell.Cmdlets.DnsResolver.Runtime.IAssociativeArray<string>
    {

    }
    /// Metadata attached to the inbound endpoint.
    internal partial interface IInboundEndpointPatchPropertiesMetadataInternal

    {

    }
}