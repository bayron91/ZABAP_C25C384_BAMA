CLASS lhc_Incident DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF incident_status,
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

    METHODS setHistory FOR MODIFY
      IMPORTING keys FOR ACTION Incident~setHistory.

    METHODS validatePriority FOR VALIDATE ON SAVE
      IMPORTING keys FOR Incident~validatePriority.

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
          incidents_update TYPE TABLE FOR UPDATE zdd_r_incident_bam\\Incident.
*          lt_test2 TYPE TABLE FOR UPDATE zdd_r_incident_bam\\History

    READ ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
        ENTITY Incident
        FIELDS ( Status ChangedDate )
        WITH CORRESPONDING #( keys )
        RESULT DATA(incidents).

    LOOP AT incidents ASSIGNING FIELD-SYMBOL(<incident>).
      new_status = keys[ KEY id %tky = <incident>-%tky ]-%param-StatusCode.

      IF new_status IS NOT INITIAL.
        APPEND VALUE #( %tky = <incident>-%tky
                        Status = new_status
                        ChangedDate = cl_abap_context_info=>get_system_date(  ) ) TO incidents_update.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
        ENTITY Incident
        UPDATE
        FIELDS ( Status ChangedDate )
        WITH CORRESPONDING #( incidents_update ).

    READ ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
        ENTITY Incident
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(incidents_with_change_status).

    result = VALUE #( FOR incident IN incidents_with_change_status ( %tky = incident-%tky
                                                                     %param = incident ) ).

  ENDMETHOD.

  METHOD setInitialValues.

    READ ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
        ENTITY Incident
        FIELDS ( IncidentId Status )
        WITH CORRESPONDING #( keys )
        RESULT DATA(incidents).

    IF incidents IS NOT INITIAL.
      "Get last incident id
      SELECT FROM zdt_inct_bam
        FIELDS MAX( incident_id )
        INTO @DATA(lv_incident_id).

      IF sy-subrc EQ 0.
        lv_incident_id += 1.
      ELSE.
        CLEAR lv_incident_id.
      ENDIF.

      MODIFY ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
          ENTITY Incident
          UPDATE
          FIELDS ( IncidentId Status )
          WITH VALUE #( FOR incident IN incidents ( %tky = incident-%tky
                                                    IncidentId = lv_incident_id
                                                    Status = 'OP' ) ).
    ENDIF.

  ENDMETHOD.

  METHOD setInitialHistory.

*    DATA: histories_create TYPE TABLE FOR CREATE zdd_r_incident_bam\_History.
*          history_create   LIKE LINE OF histories_create.

*    READ ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
*        ENTITY Incident
*        ALL FIELDS
*        WITH CORRESPONDING #( keys )
*        RESULT DATA(incidents).

*    LOOP AT incidents INTO DATA(incident).
*      IF incident-IncUuid IS INITIAL.
*        CONTINUE.
*      ENDIF.
*
*      CLEAR history_create.
*
*      history_create-%key = incident-%key.
*
*      APPEND VALUE #( HisId          = 1
*                      NewStatus      = incident-Status "incident_status-open
*                      PreviousStatus = ''
*                      Text           = 'First Incident' ) TO history_create-%target.
*
*      APPEND history_create TO histories_create.
*    ENDLOOP.

*    LOOP AT keys INTO DATA(key).
*
*      APPEND VALUE #( %key    = key-%key
*                      %target = VALUE #( ( HisId          = 1
*                                           NewStatus      = incident_status-open
*                                           PreviousStatus = ''
*                                           Text           = 'First Incident' ) ) ) TO histories_create.
*    ENDLOOP.

*    IF histories_create IS NOT INITIAL.
*      MODIFY ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
*          ENTITY Incident
*          CREATE BY \_History
*          FROM histories_create.
*    ENDIF.

  ENDMETHOD.

  METHOD setHistory.
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
      ELSEIF incident-Priority IS NOT INITIAL AND NOT line_exists( valid_priorities[ priority_code = incident-Priority ] ).
        APPEND VALUE #( %tky = incident-%tky ) TO failed-incident.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
