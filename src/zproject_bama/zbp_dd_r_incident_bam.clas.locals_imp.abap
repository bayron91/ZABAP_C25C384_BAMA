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

    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Incident~validateDates.

    METHODS validateMandatory FOR VALIDATE ON SAVE
      IMPORTING keys FOR Incident~validateMandatory.

    METHODS validateStatusChange FOR VALIDATE ON SAVE
      IMPORTING keys FOR Incident~validateStatusChange.

ENDCLASS.

CLASS lhc_Incident IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD ChangeStatus.

    "EJEMPLO EML - Modificación de entidad (create,update and delete data)
    MODIFY ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
        ENTITY Incident
        UPDATE  "EXECUTE para ejecutar internal action
        FIELDS ( Status )
        WITH VALUE #( FOR key IN keys ( %tky   = key-%tky
                                        Status = incident_status-open ) ).

    "EJEMPLO EML - Lectura de entidad
    READ ENTITIES OF zdd_r_incident_bam IN LOCAL MODE
        ENTITY Incident
        ALL FIELDS "FIELDS ( CAMPOS SEPARADO POR ESPACIO)
        WITH CORRESPONDING #( keys )
        RESULT DATA(incidents).

    "ACTION WITH RESULT
    result = VALUE #( FOR incident IN incidents ( %tky   = incident-%tky
                                                  %param = incident ) ).

    "ACTION WITH PARAMETER

  ENDMETHOD.

  METHOD setInitialValues.
  ENDMETHOD.

  METHOD setInitialHistory.
  ENDMETHOD.

  METHOD validateDates.
  ENDMETHOD.

  METHOD validateMandatory.
  ENDMETHOD.

  METHOD validateStatusChange.
  ENDMETHOD.

ENDCLASS.
