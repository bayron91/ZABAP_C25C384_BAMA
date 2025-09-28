CLASS zcl_lab_05_flight_bama DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS get_flight_exists IMPORTING iv_carrier_id    TYPE /dmo/carrier_id
                                        iv_connection_id TYPE /dmo/connection_id
                              RETURNING VALUE(rv_value)  TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_lab_05_flight_bama IMPLEMENTATION.

  METHOD get_flight_exists.

    SELECT SINGLE FROM /dmo/flight
        FIELDS carrier_id, connection_id, flight_date
        WHERE carrier_id = @iv_carrier_id
          AND connection_id = @iv_connection_id
        INTO @DATA(ls_flight).

    IF sy-subrc EQ 0.
      rv_value = abap_true.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
