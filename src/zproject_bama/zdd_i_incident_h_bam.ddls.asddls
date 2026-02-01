@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface projection historial incidents'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZDD_I_INCIDENT_H_BAM
  as projection on ZDD_INCIDENT_H_BAM

{
  key HisUuid,
  key IncUuid,
      HisId,
      PreviousStatus,
      NewStatus,
      Text,
      @Semantics.user.createdBy: true
      LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      LocalLastChangedBy,
      //Local Etag
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,
      //Total Etag
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      
      /* Associations */
      _Incident : redirected to parent ZDD_I_INCIDENT_BAM,
      _Status1,
      _Status2
}
