@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Query projection for historial incidents'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@Metadata.allowExtensions: true
define view entity ZDD_C_INCIDENT_H_BAM
  as projection on ZDD_INCIDENT_H_BAM

{
  key HisUuid,
      IncUuid,
      HisId,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #MEDIUM
      @ObjectModel.text.element: ['PreviousStatusDescription']
      PreviousStatus,
      _Status1.status_description as PreviousStatusDescription,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #MEDIUM
      @ObjectModel.text.element: ['NewStatusDescription']
      NewStatus,
      _Status2.status_description as NewStatusDescription,
      
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
      _Incident : redirected to parent ZDD_C_INCIDENT_BAM,
      _Status1,
      _Status2
}
