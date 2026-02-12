CLASS lhc_Incident DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

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
