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

    METHODS ChangeStatusHistory FOR MODIFY
      IMPORTING keys FOR ACTION Incident~ChangeStatusHistory.

    METHODS calculateStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Incident~calculateStatus.

    METHODS setStatusToOpen FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Incident~setStatusToOpen.

    METHODS setIncidentID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Incident~setIncidentID.

    METHODS ValidateDateRange FOR VALIDATE ON SAVE
      IMPORTING keys FOR Incident~ValidateDateRange.

    METHODS ValidatePriority FOR VALIDATE ON SAVE
      IMPORTING keys FOR Incident~ValidatePriority.

    METHODS ValidateStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Incident~ValidateStatus.

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

  METHOD ChangeStatusHistory.
  ENDMETHOD.

  METHOD calculateStatus.
  ENDMETHOD.

  METHOD setStatusToOpen.
  ENDMETHOD.

  METHOD setIncidentID.
  ENDMETHOD.

  METHOD ValidateDateRange.
  ENDMETHOD.

  METHOD ValidatePriority.
  ENDMETHOD.

  METHOD ValidateStatus.
  ENDMETHOD.

ENDCLASS.
