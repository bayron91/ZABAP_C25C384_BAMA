@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Query projection for incidents'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZDD_C_INCIDENT_BAM
  provider contract transactional_query
  as projection on ZDD_R_INCIDENT_BAM

{
  key IncUuid,
      IncidentId,
      Title,
      Description,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #MEDIUM
      @ObjectModel.text.element: [ 'StatusDescription' ]
      Status,
      _Status.status_description     as StatusDescription,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #MEDIUM
      @ObjectModel.text.element: [ 'PriorityDescription' ]
      Priority,
      _Priority.priority_description as PriorityDescription,

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
      _History : redirected to composition child ZDD_C_INCIDENT_H_BAM,
      _Priority,
      _Status
}
