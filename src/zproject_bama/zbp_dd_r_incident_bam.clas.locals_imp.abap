CLASS lhc_Incident DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS: BEGIN OF incident_status,
                 open        TYPE c LENGTH 2 VALUE 'OP', "Open
                 in_progress TYPE c LENGTH 2 VALUE 'IP', "In Progress
                 pending     TYPE c LENGTH 2 VALUE 'PE', "Pending
                 completed   TYPE c LENGTH 2 VALUE 'CO', "Completed
                 closed      TYPE c LENGTH 2 VALUE 'CL', "Closed
                 canceled    TYPE c LENGTH 2 VALUE 'CN', "Canceled
               END OF incident_status.

    CONSTANTS admin_user TYPE string VALUE 'CB9980001799'.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Incident RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Incident RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Incident RESULT result.

    METHODS ChangeStatus FOR MODIFY
      IMPORTING keys FOR ACTION Incident~ChangeStatus RESULT result.

    METHODS setInitialValues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Incident~setInitialValues.

    METHODS setInitialHistory FOR DETERMINE ON SAVE
      IMPORTING keys FOR Incident~setInitialHistory.

    METHODS validatePriority FOR VALIDATE ON SAVE
      IMPORTING keys FOR Incident~validatePriority.

    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Incident~validateDates.

    METHODS setHistory FOR MODIFY
      IMPORTING keys FOR ACTION Incident~setHistory.

ENDCLASS.

CLASS lhc_Incident IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
        ENTITY Incident
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(incidents).

    LOOP AT incidents INTO DATA(incident).
      IF incident-Status IS INITIAL AND incident-%is_draft = if_abap_behv=>mk-on.
        APPEND VALUE #( %tky = incident-%tky
                        %action-changestatus = if_abap_behv=>fc-o-disabled ) TO result.
      ELSEIF incident-Status = incident_status-canceled OR
             incident-Status = incident_status-completed OR
             incident-Status = incident_status-closed.
        APPEND VALUE #( %tky = incident-%tky
                        %action-changestatus = if_abap_behv=>fc-o-disabled ) TO result.
      ELSE.
        APPEND VALUE #( %tky = incident-%tky
                        %action-changestatus = if_abap_behv=>fc-o-enabled ) TO result.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_authorizations.

    DATA delete_incident TYPE abap_bool.

    READ ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
        ENTITY Incident
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
        RESULT DATA(incidents).

    delete_incident = COND #( WHEN requested_authorizations-%delete = if_abap_behv=>mk-on
                                THEN abap_true
                                ELSE abap_false ).

    CHECK delete_incident EQ abap_true.

    DATA(lv_technical_name) = cl_abap_context_info=>get_user_technical_name( ).

    LOOP AT incidents INTO DATA(incident) WHERE Status IS NOT INITIAL.
      IF lv_technical_name = admin_user AND incident-status = incident_status-open.
        APPEND VALUE #( %tky = incident-%tky
                        %delete = if_abap_behv=>auth-allowed ) TO result.
      ELSE.
        APPEND VALUE #( %tky = incident-%tky
                        %delete = if_abap_behv=>auth-unauthorized ) TO result.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_global_authorizations.

    DATA(lv_technical_name) = cl_abap_context_info=>get_user_technical_name( ).

*    lv_technical_name = 'OTHER_USER'. "For testing authorization

    "Create
    IF requested_authorizations-%create = if_abap_behv=>mk-on.
      IF lv_technical_name = admin_user.
        result-%create = if_abap_behv=>auth-allowed.
      ELSE.
        result-%create = if_abap_behv=>auth-unauthorized.
      ENDIF.
    ENDIF.

    "Update/Edit
    IF requested_authorizations-%update      = if_abap_behv=>mk-on OR
       requested_authorizations-%action-Edit = if_abap_behv=>mk-on.
      IF lv_technical_name = admin_user.
        result-%update      = if_abap_behv=>auth-allowed.
        result-%action-Edit = if_abap_behv=>auth-allowed.
      ELSE.
        result-%update      = if_abap_behv=>auth-unauthorized.
        result-%action-Edit = if_abap_behv=>auth-unauthorized.
      ENDIF.
    ENDIF.

    "Delete
    IF requested_authorizations-%delete = if_abap_behv=>mk-on.
      IF lv_technical_name = admin_user.
        result-%delete = if_abap_behv=>auth-allowed.
      ELSE.
        result-%delete = if_abap_behv=>auth-unauthorized.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD ChangeStatus.

    DATA: new_status       TYPE zde_status_bam,
          text_status      TYPE c LENGTH 80,
          flag_status      TYPE abap_bool,
          lv_max_hisid     TYPE n LENGTH 8,
          incidents_update TYPE TABLE FOR UPDATE zdd_r_incident_bam,
          ls_history       TYPE zdt_inct_h_bam,
          lt_history       TYPE TABLE FOR CREATE zdd_r_incident_bam\_History.

    DATA(lv_technical_user) = cl_abap_context_info=>get_user_technical_name(  ).

    READ ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
        ENTITY Incident
        FIELDS ( Status ChangedDate )
        WITH CORRESPONDING #( keys )
        RESULT DATA(incidents)
        FAILED failed.

    LOOP AT incidents ASSIGNING FIELD-SYMBOL(<incident>).
      CLEAR flag_status.

      "Valida authorization user
      IF lv_technical_user NE admin_user.
        flag_status = abap_true.

        APPEND VALUE #( %tky = <incident>-%tky ) TO failed-incident.
        APPEND VALUE #( %tky = <incident>-%tky
                        %msg = NEW zcx_incidents_bam( textid   = zcx_incidents_bam=>user_unauthorized
                                                      attr1    = lv_technical_user
                                                      severity = if_abap_behv_message=>severity-error )
                        %op-%action-changestatus = if_abap_behv=>mk-on ) TO reported-incident.
        EXIT.
      ENDIF.

      new_status = keys[ KEY id %tky = <incident>-%tky ]-%param-StatusCode.

      "Validate is possible change status
      IF ( new_status EQ incident_status-completed OR new_status EQ incident_status-closed ) AND
           <incident>-Status EQ incident_status-pending.
        flag_status = abap_true.

        APPEND VALUE #( %tky = <incident>-%tky ) TO failed-incident.
        APPEND VALUE #( %tky = <incident>-%tky
                        %msg = NEW zcx_incidents_bam( textid   = zcx_incidents_bam=>change_status_pe
                                                      attr1    = CONV string( <incident>-Status )
                                                      attr2    = CONV string( new_status )
                                                      severity = if_abap_behv_message=>severity-error )
                        %op-%action-changestatus = if_abap_behv=>mk-on ) TO reported-incident.
        EXIT.
      ENDIF.

      IF new_status IS NOT INITIAL AND flag_status EQ abap_false.
        APPEND VALUE #( %tky        = <incident>-%tky
                        Status      = new_status
                        ChangedDate = cl_abap_context_info=>get_system_date( ) ) TO incidents_update.
      ENDIF.

      text_status = keys[ KEY id %tky = <incident>-%tky ]-%param-Observation.

      "Get id history
      SELECT FROM zdt_inct_h_bam
          FIELDS MAX( his_id )
          WHERE his_uuid IS NOT INITIAL
            AND inc_uuid = @<incident>-IncUuid
          INTO @lv_max_hisid.

      IF sy-subrc EQ 0.
        lv_max_hisid = lv_max_hisid + 1.
      ELSE.
        lv_max_hisid = 1.
      ENDIF.

      ls_history-his_id = lv_max_hisid.
      ls_history-previous_status = <incident>-Status.
      ls_history-new_status = new_status.
      ls_history-text = text_status.

      TRY.
          ls_history-inc_uuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error INTO DATA(lx_error).
          lx_error->get_text( ).
      ENDTRY.

      APPEND VALUE #( %tky    = <incident>-%tky
                      %target = VALUE #( ( HisUuid        = ls_history-inc_uuid
                                           IncUuid        = <incident>-IncUuid
                                           HisId          = ls_history-his_id
                                           PreviousStatus = ls_history-previous_status
                                           NewStatus      = ls_history-new_status
                                           Text           = ls_history-text ) ) ) TO lt_history.
    ENDLOOP.
    UNASSIGN <incident>.

    CHECK flag_status EQ abap_false.

    IF  incidents_update IS NOT INITIAL.
      MODIFY ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
          ENTITY Incident
          UPDATE
          FIELDS ( Status ChangedDate )
          WITH incidents_update.
    ENDIF.
    FREE incidents.

    IF lt_history IS NOT INITIAL.
      MODIFY ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
          ENTITY Incident
          CREATE BY \_History FIELDS ( HisUuid
                                       IncUuid
                                       HisId
                                       PreviousStatus
                                       NewStatus
                                       Text )
            AUTO FILL CID
            WITH lt_history
          MAPPED mapped
          FAILED failed
          REPORTED reported.
    ENDIF.

*    READ ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
*        ENTITY Incident BY \_History
*        ALL FIELDS
*        WITH CORRESPONDING #( keys )
*        RESULT DATA(incidents_change_history).

    READ ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
        ENTITY Incident
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(incidents_with_change_status).

    result = VALUE #( FOR incident IN incidents_with_change_status ( %tky   = incident-%tky
                                                                     %param = incident ) ).

  ENDMETHOD.

  METHOD setInitialValues.

    READ ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
        ENTITY Incident
        FIELDS ( IncidentId Status CreationDate )
        WITH CORRESPONDING #( keys )
        RESULT DATA(incidents).

    IF incidents IS NOT INITIAL.
      "Get last incident id
      SELECT FROM zdt_inct_bam
        FIELDS MAX( incident_id )
        WHERE incident_id IS NOT INITIAL
        INTO @DATA(lv_incident_id).

      IF lv_incident_id IS INITIAL.
        lv_incident_id = 1.
      ELSE.
        lv_incident_id += 1.
      ENDIF.

      MODIFY ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
          ENTITY Incident
          UPDATE
          FIELDS ( IncidentId Status CreationDate )
          WITH VALUE #( FOR incident IN incidents ( %tky = incident-%tky
                                                    IncidentId = lv_incident_id
                                                    Status = incident_status-open
                                                    CreationDate = cl_abap_context_info=>get_system_date( ) ) ).
    ENDIF.

  ENDMETHOD.

  METHOD setInitialHistory.

    MODIFY ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
        ENTITY Incident
        EXECUTE setHistory
        FROM CORRESPONDING #( keys ).

  ENDMETHOD.

  METHOD validatePriority.

    READ ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
        ENTITY Incident
        FIELDS ( Priority )
        WITH CORRESPONDING #( keys )
        RESULT DATA(incidents).

    DATA priorities TYPE SORTED TABLE OF zdt_priority_bam WITH UNIQUE KEY client priority_code.

    priorities = CORRESPONDING #( incidents DISCARDING DUPLICATES MAPPING priority_code = Priority EXCEPT * ).
    DELETE priorities WHERE priority_code IS INITIAL.

    IF priorities IS NOT INITIAL.
      SELECT FROM zdt_priority_bam AS ddbb
          INNER JOIN @priorities AS http_req ON ddbb~priority_code = http_req~priority_code
          FIELDS ddbb~priority_code
          INTO TABLE @DATA(valid_priorities).
    ENDIF.

    LOOP AT incidents INTO DATA(incident).
      IF incident-Priority IS INITIAL.
        APPEND VALUE #( %tky = incident-%tky ) TO failed-incident.
        APPEND VALUE #( %tky = incident-%tky
                        %msg = NEW zcx_incidents_bam( textid   = zcx_incidents_bam=>enter_priority
                                                      severity = if_abap_behv_message=>severity-error )
                        %element-priority = if_abap_behv=>mk-on ) TO reported-incident.
      ELSEIF incident-Priority IS NOT INITIAL AND NOT line_exists( valid_priorities[ priority_code = incident-Priority ] ).
        APPEND VALUE #( %tky = incident-%tky ) TO failed-incident.
        APPEND VALUE #( %tky = incident-%tky
                        %msg = NEW zcx_incidents_bam( textid   = zcx_incidents_bam=>priority_unknown
                                                      attr1    = CONV string( incident-Priority )
                                                      severity = if_abap_behv_message=>severity-error )
                        %element-priority = if_abap_behv=>mk-on ) TO reported-incident.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateDates.

    READ ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
        ENTITY Incident
        FIELDS ( CreationDate ChangedDate )
        WITH CORRESPONDING #( keys )
        RESULT DATA(incidents).

    LOOP AT incidents INTO DATA(incident).
      IF incident-CreationDate IS INITIAL.
        APPEND VALUE #( %tky = incident-%tky ) TO failed-incident.
        APPEND VALUE #( %tky = incident-%tky
                        %msg = NEW zcx_incidents_bam( textid   = zcx_incidents_bam=>enter_creationdate
                                                      severity = if_abap_behv_message=>severity-error )
                        %element-creationdate = if_abap_behv=>mk-on ) TO reported-incident.
      ENDIF.

      IF incident-CreationDate > cl_abap_context_info=>get_system_date(  ) AND incident-CreationDate IS NOT INITIAL.
        APPEND VALUE #( %tky = incident-%tky ) TO failed-incident.
        APPEND VALUE #( %tky = incident-%tky
                        %msg = NEW zcx_incidents_bam( textid   = zcx_incidents_bam=>creationdate_bef_sydate
                                                      attr1    = CONV string( incident-CreationDate )
                                                      severity = if_abap_behv_message=>severity-error )
                        %element-creationdate = if_abap_behv=>mk-on ) TO reported-incident.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD setHistory.

    DATA: lv_max_hisid TYPE n LENGTH 8,
          ls_history   TYPE zdt_inct_h_bam,
          lt_history   TYPE TABLE FOR CREATE zdd_r_incident_bam\_History.

    READ ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
        ENTITY Incident
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(incidents).

    LOOP AT incidents ASSIGNING FIELD-SYMBOL(<incident>).
      "Get id history
      SELECT FROM zdt_inct_h_bam
          FIELDS MAX( his_id )
          WHERE his_uuid IS NOT INITIAL
            AND inc_uuid = @<incident>-IncUuid
          INTO @lv_max_hisid.

      IF sy-subrc EQ 0.
        ls_history-his_id = lv_max_hisid + 1.
      ELSE.
        ls_history-his_id = 1.
      ENDIF.

      TRY.
          ls_history-inc_uuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error INTO DATA(lx_error).
          lx_error->get_text( ).
      ENDTRY.

      APPEND VALUE #( %tky    = <incident>-%tky
                      %target = VALUE #( ( HisUuid   = ls_history-inc_uuid
                                           IncUuid   = <incident>-IncUuid
                                           HisId     = ls_history-his_id
                                           NewStatus = incident_status-open
                                           Text      = 'First Incident' ) ) ) TO lt_history.
    ENDLOOP.

    UNASSIGN <incident>.
    FREE incidents.

    IF lt_history IS NOT INITIAL.
      MODIFY ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
          ENTITY Incident
          CREATE BY \_History FIELDS ( HisUuid
                                       IncUuid
                                       HisId
                                       NewStatus
                                       Text )
            AUTO FILL CID
            WITH lt_history
          MAPPED mapped
          FAILED failed
          REPORTED reported.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
