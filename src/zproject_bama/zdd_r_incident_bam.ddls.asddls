@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root view entity - Incidents'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZDD_R_INCIDENT_BAM
  as select from zdt_inct_bam

  composition [0..*] of ZDD_INCIDENT_H_BAM as _History

  association [1..1] to zdt_status_bam     as _Status   on _Status.status_code = $projection.Status
  association [1..1] to zdt_priority_bam   as _Priority on _Priority.priority_code = $projection.Priority

{
  key inc_uuid              as IncUuid,
      incident_id           as IncidentId,
      title                 as Title,
      description           as Description,
      status                as Status,
      priority              as Priority,
      creation_date         as CreationDate,
      changed_date          as ChangedDate,
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      //Local Etag
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      //Total Etag
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      
      // Make association public
      _History,
      _Priority,
      _Status
}
