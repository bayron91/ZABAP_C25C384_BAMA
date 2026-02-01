@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface projection for incidents'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZDD_I_INCIDENT_BAM
  provider contract transactional_interface
  as projection on ZDD_R_INCIDENT_BAM

{
  key IncUuid,
      IncidentId,
      Title,
      Description,
      Status,
      Priority,
      CreationDate,
      ChangedDate,
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
      _History : redirected to composition child ZDD_I_INCIDENT_H_BAM,
      _Priority,
      _Status
}
